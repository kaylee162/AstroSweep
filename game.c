#include "game.h"
#include "sfx.h"

// Module-level game state
static GameState state;

static Player player;

static Bullet bullets[MAX_BULLETS];       // object pool (meaningful pooling requirement)
static Asteroid asteroids[MAX_ASTEROIDS]; // object pool
static Star stars[MAX_STARS];             // just for background motion (array + extra polish)

// Game counters
static int score;
static int targetScore;
static int frameCount;
static int spawnTimer;
static int asteroidSpawnCount; // counts asteroid spawns for rare bomb-asteroid logic

// Controls a small “slow motion” feel during bomb use (extra polish)
static int screenShakeTimer;

// Forward declarations
static void initStars(void);
static void updateStars(void);
static void drawStars(void);

static void initPlayer(void);
static void updatePlayer(void);
static void drawPlayer(void);

static void initPools(void);
static void fireBullet(void);
static void updateBullets(void);
static void drawBullets(void);

static void spawnAsteroid(void);
static void updateAsteroids(void);
static void drawAsteroids(void);

static void handleCollisions(void);
static void useBomb(void);

// --- Debug cheat latch (makes combos reliable even with weird timing) ---
static u16 cheatLatch = 0;
static int cheatFlashTimer = 0; // quick visual confirmation

// Tracks which state screen we last fully rendered.
// Prevents re-drawing heavy text screens every frame (reduces flicker).
static GameState lastRenderedState = -1;
static int fullRedrawRequested = 1;   // full redraw once when entering gameplay
static int hudDirty = 1;              // force HUD redraw when needed

static void safeSetPixel(int x, int y, u16 color);

static int clamp(int v, int lo, int hi) {
    if (v < lo) return lo;
    if (v > hi) return hi;
    return v;
}
// Small helper for debugging
static void cheatFlash(void) {
    cheatFlashTimer = 10; // 10 frames
}

// Draw a rectangle only if it is fully within the gameplay area (below HUD) and on-screen.
// This prevents bullets/asteroids from erasing HUD pixels.
static void drawRectPlayfield(int x, int y, int w, int h, volatile unsigned short color) {
    if (w <= 0 || h <= 0) return;

    // Disallow drawing into the HUD strip at the top of the screen
    if (y < HUD_HEIGHT) return;

    // Match drawRectangle's bounds contract (must be fully on-screen)
    if (x < 0 || y < 0 || x + w > SCREENWIDTH || y + h > SCREENHEIGHT) return;

    drawRectangle(x, y, w, h, color);
}

// Public API
GameState getState(void) {
    return state;
}

void initGame(void) {
    // Baseline setup
    sfxInit();
    targetScore = 25;

    goToStart();
}

// Update Game function
void updateGame(void) {
    // Start / Pausing
    switch (state) {
        case STATE_START:
            // START: begin game
            if (BUTTON_PRESSED(BUTTON_START)) {
                goToGame();
            }
            break;

        case STATE_GAME: {
            // -----------------------------
            // Debug cheats (hold SELECT)
            // Reliable + prevents gameplay input from stealing A/B/etc
            // -----------------------------
            if (BUTTON_HELD(BUTTON_SELECT)) {
                // Convert to "pressed = 1" bitmask (since buttons are active-low)
                u16 pressedNow = (u16)(~buttons);

                // Use these keys for cheats (choose any you want)
                u16 cheatKeys = (BUTTON_START | BUTTON_A | BUTTON_B | BUTTON_LEFT | BUTTON_RIGHT | BUTTON_UP);

                // Current held cheat keys while SELECT is held
                u16 comboNow = pressedNow & cheatKeys;

                // Newly pressed keys since last frame (one-shot)
                u16 newlyPressed = (u16)(comboNow & (u16)(~cheatLatch));
                cheatLatch = comboNow;

                // SELECT + START -> WIN
                if (newlyPressed & BUTTON_START) {
                    goToWin();
                    cheatLatch = 0;
                    break;
                }

                // SELECT + L -> LOSE
                if (newlyPressed & BUTTON_LEFT) {
                    goToLose();
                    cheatLatch = 0;
                    break;
                }

                // SELECT + B -> clear asteroids
                if (newlyPressed & BUTTON_B) {
                    for (int i = 0; i < MAX_ASTEROIDS; i++) {
                        if (asteroids[i].active) {
                            drawRectPlayfield(asteroids[i].oldx, asteroids[i].oldy,
                                            asteroids[i].size, asteroids[i].size, BLACK);
                            drawRectPlayfield(asteroids[i].x, asteroids[i].y,
                                            asteroids[i].size, asteroids[i].size, BLACK);
                            asteroids[i].active = 0;
                        }
                    }
                    cheatFlash();
                    break; // stop frame so player input doesn't also run
                }

                // SELECT + A -> reset score + restore lives
                if (newlyPressed & BUTTON_A) {
                    score = 0;
                    player.lives = 3;
                    player.invulnTimer = 0;
                    player.bombs = 0;
                    hudDirty = 1;
                    cheatFlash();
                    break; // stop frame so updatePlayer() doesn't shoot and mask the test
                }

                // SELECT + UP -> restore lives only
                if (newlyPressed & BUTTON_UP) {
                    player.lives = 3;
                    player.invulnTimer = 0;   
                    hudDirty = 1;
                    cheatFlash();
                    break;
                }

                // SELECT + R -> give bomb
                if (newlyPressed & BUTTON_RIGHT) {
                    player.bombs = 1;
                    hudDirty = 1;
                    cheatFlash();
                    break;
                }

                // If SELECT is held but no cheat fired, do nothing else this frame.
                // (Prevents normal gameplay controls while debugging.)
                break;
            } else {
                cheatLatch = 0;
            }

            // Pause (START) only when not using SELECT-cheats
            if (BUTTON_PRESSED(BUTTON_START)) {
                goToPause();
                break;
            }

            // Update world
            frameCount++;
            updateStars();
            updatePlayer();
            updateBullets();

            // Spawn asteroids over time
            spawnTimer--;
            if (spawnTimer <= 0) {
                spawnAsteroid();
                // Spawn rate ramps up slowly over time
                spawnTimer = clamp(60 - (frameCount / 240), 18, 60);
            }

            updateAsteroids();
            handleCollisions();

            // Win/lose checks
            if (score >= targetScore) {
                goToWin();
            }
            if (player.lives <= 0) {
                goToLose();
            }

            if (screenShakeTimer > 0) screenShakeTimer--;
            break;
        }
        case STATE_PAUSE:
            // START: resume, SELECT: restart
            if (BUTTON_PRESSED(BUTTON_START)) {
                goToGame();
            } else if (BUTTON_PRESSED(BUTTON_SELECT)) {
                goToStart();
            }
            break;

        case STATE_WIN:
        case STATE_LOSE:
            // START: back to start (or restart)
            if (BUTTON_PRESSED(BUTTON_START)) {
                goToStart();
            }
            break;
    }
}

// Draw HUD in top-left. Call this LAST so it can't be overwritten.
static void drawHUD(void) {
    static int lastLives = -1;
    static int lastScore = -1;
    static int lastBombs = -1;

    int livesShown  = clamp(player.lives, 0, 9);
    int pointsShown = clamp(score, 0, 99);
    int bombsShown  = clamp(player.bombs, 0, 1);

    // If nothing changed and we are not forcing a refresh, skip redraw this frame
    if (!hudDirty && livesShown == lastLives && pointsShown == lastScore && bombsShown == lastBombs) {
        return;
    }

    lastLives = livesShown;
    lastScore = pointsShown;
    lastBombs = bombsShown;
    hudDirty = 0;

    drawRectangle(0, 0, 150, 12, BLACK);

    char hud[24];
    int idx = 0;

    // L: lives
    hud[idx++] = 'L';
    hud[idx++] = ':';
    hud[idx++] = (char)('0' + livesShown);
    hud[idx++] = ' ';

    // P: points (00-99)
    hud[idx++] = 'P';
    hud[idx++] = ':';
    hud[idx++] = (char)('0' + (pointsShown / 10));
    hud[idx++] = (char)('0' + (pointsShown % 10));
    hud[idx++] = ' ';

    // B: bomb available (0/1)
    hud[idx++] = 'B';
    hud[idx++] = ':';
    hud[idx++] = (char)('0' + bombsShown);
    hud[idx] = '\0';

    drawString(2, 2, hud, WHITE);
}

void drawGame(void) {

    // ------------------------------------------------------------
    // 1) START / WIN / LOSE: draw once on state change (no HUD)
    // ------------------------------------------------------------
    if (state == STATE_START || state == STATE_WIN || state == STATE_LOSE) {
        if (state == lastRenderedState) {
            return;
        }
        lastRenderedState = state;

        fillScreen(BLACK);

        if (state == STATE_START) {
            drawString(60, 70, "ASTRO SWEEP", CYAN);
            drawString(28, 92, "Press START to begin", WHITE);
            drawString(22, 110, "A: Shoot  B: Dash  L: Bomb", GRAY);
            drawString(14, 122, "Shoot MAGENTA asteroid to earn bomb", GRAY);
        } else if (state == STATE_WIN) {
            drawString(80, 70, "YOU WIN!", GREEN);
            drawString(34, 92, "Press START for menu", WHITE);
        } else if (state == STATE_LOSE) {
            drawString(80, 70, "YOU LOSE!", RED);
            drawString(34, 92, "Press START for menu", WHITE);
        }
        return;
    }

    // ------------------------------------------------------------
    // 2) PAUSE: draw once on entry, then wait
    // ------------------------------------------------------------
    if (state == STATE_PAUSE) {
        if (state != lastRenderedState) {
            lastRenderedState = state;
            // Dark overlay, then pause text
            drawRectangle(0, 0, SCREENWIDTH, SCREENHEIGHT, BLACK);
            drawString(96, 70, "PAUSED", YELLOW);
            drawString(26, 92, "START: Resume  SELECT: Menu", WHITE);
        }
        return;
    }

    // ------------------------------------------------------------
    // 3) GAME: normal rendering (HUD always last)
    // ------------------------------------------------------------
    if (state != lastRenderedState) {
        lastRenderedState = state;
        fullRedrawRequested = 1;
        hudDirty = 1;
    }

    if (fullRedrawRequested) {
        fillScreen(BLACK);

        // If we cleared the screen, the HUD must be redrawn too.
        hudDirty = 1;

        fullRedrawRequested = 0;
    }

    drawStars();
    drawPlayer();
    drawBullets();
    drawAsteroids();

    // HUD LAST so nothing overwrites it
    drawHUD();
}

// State transitions
void goToStart(void) {
    state = STATE_START;
}

// Go To Game
void goToGame(void) {
    // If coming from START/WIN/LOSE, fully reset.
    if (state == STATE_START || state == STATE_WIN || state == STATE_LOSE) {
        score = 0;
        frameCount = 0;
        spawnTimer = 45;
        asteroidSpawnCount = 0;
        screenShakeTimer = 0;

        initStars();
        initPlayer();
        initPools();

        // Force a clean full redraw on first gameplay frame
        fullRedrawRequested = 1;
        hudDirty = 1;
    }

    // If resuming from PAUSE, remove the pause overlay with a one-time redraw
    if (state == STATE_PAUSE) {
        fullRedrawRequested = 1;
        hudDirty = 1;
    }

    state = STATE_GAME;
}

// Go To Pause
void goToPause(void) {
    state = STATE_PAUSE;
    hudDirty = 1;
}

void goToWin(void) {
    state = STATE_WIN;
    sfxWin();
}

void goToLose(void) {
    state = STATE_LOSE;
    sfxLose();
}

// Stars (background polish)
static void initStars(void) {
    for (int i = 0; i < MAX_STARS; i++) {
        stars[i].x = (i * 13) % SCREENWIDTH;
        stars[i].y = HUD_HEIGHT + (i * 7) % (SCREENHEIGHT - HUD_HEIGHT);
        stars[i].oldx = stars[i].x;
        stars[i].oldy = stars[i].y;
        stars[i].speed = 1 + (i % 2);
    }
}

static void updateStars(void) {
    for (int i = 0; i < MAX_STARS; i++) {
        stars[i].oldx = stars[i].x;
        stars[i].oldy = stars[i].y;

        // Drift downward
        stars[i].y += stars[i].speed;

        // If star moves off bottom, respawn BELOW HUD strip
        if (stars[i].y >= SCREENHEIGHT) {
            stars[i].y = HUD_HEIGHT;   // never 0 anymore
            stars[i].x = (stars[i].x + 53) % SCREENWIDTH;
        }
    }
}

static void drawStars(void) {
    for (int i = 0; i < MAX_STARS; i++) {

        // Erase old star (only if it wasn't in HUD strip)
        if (stars[i].oldx >= 0 && stars[i].oldx < SCREENWIDTH &&
            stars[i].oldy >= HUD_HEIGHT && stars[i].oldy < SCREENHEIGHT) {

            setPixel(stars[i].oldx, stars[i].oldy, BLACK);
        }

        // Draw new star (only if below HUD strip)
        if (stars[i].y >= HUD_HEIGHT && stars[i].y < SCREENHEIGHT) {
            setPixel(stars[i].x, stars[i].y, GRAY);
        }
    }
}

// Player
static void initPlayer(void) {
    player.w = PLAYER_W;
    player.h = PLAYER_H;

    player.x = (SCREENWIDTH / 2) - (player.w / 2);
    player.y = (SCREENHEIGHT - 20);

    player.oldx = player.x;
    player.oldy = player.y;

    player.speed = 2;
    player.lives = 3;
    player.invulnTimer = 0;
    player.dashCooldown = 0;
    player.bombs = 0;
}

static void updatePlayer(void) {
    player.oldx = player.x;
    player.oldy = player.y;

    if (player.invulnTimer > 0) player.invulnTimer--;
    if (player.dashCooldown > 0) player.dashCooldown--;

    int spd = player.speed;

    // Movement (D-pad)
    if (BUTTON_HELD(BUTTON_LEFT))  player.x -= spd;
    if (BUTTON_HELD(BUTTON_RIGHT)) player.x += spd;
    if (BUTTON_HELD(BUTTON_UP))    player.y -= spd;
    if (BUTTON_HELD(BUTTON_DOWN))  player.y += spd;

    // Clamp to screen (keep player out of HUD strip)
    player.x = clamp(player.x, 0, SCREENWIDTH - player.w);
    player.y = clamp(player.y, HUD_HEIGHT, SCREENHEIGHT - player.h);

    // Shoot (A)
    if (BUTTON_PRESSED(BUTTON_A)) {
        fireBullet();
    }

    // Dash (B): quick burst movement, cooldown so it’s not spammable
    if (BUTTON_PRESSED(BUTTON_B) && player.dashCooldown == 0) {
        player.dashCooldown = 30;

        // Dash in the direction held, default upward if nothing held
        int dx = 0, dy = -1;
        if (BUTTON_HELD(BUTTON_LEFT))  dx = -1, dy = 0;
        if (BUTTON_HELD(BUTTON_RIGHT)) dx =  1, dy = 0;
        if (BUTTON_HELD(BUTTON_DOWN))  dx =  0, dy = 1;
        if (BUTTON_HELD(BUTTON_UP))    dx =  0, dy = -1;

        player.x = clamp(player.x + dx * 18, 0, SCREENWIDTH - player.w);
        player.y = clamp(player.y + dy * 18, HUD_HEIGHT, SCREENHEIGHT - player.h);
    }

    // Extra mechanic: Nova Bomb (L shoulder) clears asteroids and gives small score.
    if (BUTTON_PRESSED(BUTTON_LSHOULDER)) {
        useBomb();
    }
}

static void drawPlayer(void) {
    // Erase old player rectangle
    drawRectangle(player.oldx, player.oldy, player.w, player.h, BLACK);

    // Blink if invulnerable (visual feedback)
    if (player.invulnTimer > 0 && (player.invulnTimer / 4) % 2 == 0) {
        // don't draw (blink)
        return;
    }

    // Draw new player rectangle
    drawRectangle(player.x, player.y, player.w, player.h, CYAN);

    // Tiny “cockpit” pixel to make it look like more than a box
    safeSetPixel(player.x + 3, player.y + 2, WHITE);
}

// Bullets (object pool)
static void initPools(void) {
    for (int i = 0; i < MAX_BULLETS; i++) {
        bullets[i].active = 0;
        bullets[i].w = 2;
        bullets[i].h = 2;
        bullets[i].x = bullets[i].y = 0;
        bullets[i].oldx = bullets[i].oldy = 0;
        bullets[i].dx = 0;
        bullets[i].dy = -4;
    }

    for (int i = 0; i < MAX_ASTEROIDS; i++) {
        asteroids[i].active = 0;
        asteroids[i].size = 8;
        asteroids[i].x = asteroids[i].y = 0;
        asteroids[i].oldx = asteroids[i].oldy = 0;
        asteroids[i].dx = 0;
        asteroids[i].dy = 1;
        asteroids[i].hp = 1;
        asteroids[i].isBomb = 0;
    }
}

static void fireBullet(void) {
    // Find first inactive bullet in pool
    for (int i = 0; i < MAX_BULLETS; i++) {
        if (!bullets[i].active) {
            bullets[i].active = 1;

            bullets[i].x = player.x + player.w / 2;
            bullets[i].y = player.y;
            bullets[i].oldx = bullets[i].x;
            bullets[i].oldy = bullets[i].y;

            sfxShoot();
            return;
        }
    }
    // If pool is full, do nothing (meaningful pooling)
}

static void updateBullets(void) {
    for (int i = 0; i < MAX_BULLETS; i++) {
        if (!bullets[i].active) continue;

        bullets[i].oldx = bullets[i].x;
        bullets[i].oldy = bullets[i].y;

        bullets[i].y += bullets[i].dy;

        // Reached HUD strip -> deactivate (prevents HUD damage)
        if (bullets[i].y < HUD_HEIGHT) {
            bullets[i].active = 0;
            // erase bullet so it doesn't leave a trail (only if in playfield)
            drawRectPlayfield(bullets[i].oldx, bullets[i].oldy, bullets[i].w, bullets[i].h, BLACK);
            continue;
        }

        // Offscreen -> deactivate (returns to pool)
        if (bullets[i].y < 0) {
            bullets[i].active = 0;
            // erase bullet so it doesn't leave a trail (only if in playfield)
            drawRectPlayfield(bullets[i].oldx, bullets[i].oldy, bullets[i].w, bullets[i].h, BLACK);
        }
    }
}

static void drawBullets(void) {
    for (int i = 0; i < MAX_BULLETS; i++) {
        if (!bullets[i].active) continue;

        // erase old (only in playfield)
        drawRectPlayfield(bullets[i].oldx, bullets[i].oldy, bullets[i].w, bullets[i].h, BLACK);

        // draw new (only in playfield)
        drawRectPlayfield(bullets[i].x, bullets[i].y, bullets[i].w, bullets[i].h, YELLOW);
    }
}

// Asteroids (object pool)
static void spawnAsteroid(void) {
    for (int i = 0; i < MAX_ASTEROIDS; i++) {
        if (!asteroids[i].active) {
            asteroids[i].active = 1;

            // Count spawns so we can make a rare "bomb asteroid".
            asteroidSpawnCount++;

            // Roughly 1 in 15 spawns is a bomb-asteroid (power-up).
            // (Deterministic on purpose: avoids needing rand() setup.)
            asteroids[i].isBomb = (asteroidSpawnCount % 15 == 0);

            // Spawn across the top
            if (asteroids[i].isBomb) {
                // Bomb asteroid: smaller + distinct look, always 1 HP
                asteroids[i].size = 8;
                asteroids[i].hp = 1;
            } else {
                asteroids[i].size = 6 + ((frameCount / 180) % 7); // size grows slowly over time
                asteroids[i].hp = (asteroids[i].size >= 10) ? 2 : 1;
            }

            asteroids[i].x = (i * 29 + frameCount * 3) % (SCREENWIDTH - asteroids[i].size);
            asteroids[i].y = HUD_HEIGHT - asteroids[i].size; // never spawn through HUD

            asteroids[i].oldx = asteroids[i].x;
            asteroids[i].oldy = asteroids[i].y;

            // Slight horizontal drift
            asteroids[i].dx = ((i % 3) - 1);  // -1,0,1
            asteroids[i].dy = 1 + (frameCount / 600); // speeds up a bit later
            asteroids[i].dy = clamp(asteroids[i].dy, 1, 3);

            return;
        }
    }
    // Pool full: no spawn (again, intentional)
}

static void updateAsteroids(void) {
    for (int i = 0; i < MAX_ASTEROIDS; i++) {
        if (!asteroids[i].active) continue;

        // Save last drawn location for clean erasing
        asteroids[i].oldx = asteroids[i].x;
        asteroids[i].oldy = asteroids[i].y;

        // Movement
        asteroids[i].x += asteroids[i].dx;
        asteroids[i].y += asteroids[i].dy;

        // Bounce slightly on side walls
        if (asteroids[i].x <= 0 || asteroids[i].x >= SCREENWIDTH - asteroids[i].size) {
            asteroids[i].dx = -asteroids[i].dx;
            asteroids[i].x = clamp(asteroids[i].x, 0, SCREENWIDTH - asteroids[i].size);
        }

        // If it moved fully past the bottom, erase the LAST drawn rect and recycle
        if (asteroids[i].oldy < SCREENHEIGHT && asteroids[i].y >= SCREENHEIGHT) {
            // Clear where it was last frame (this is the one that matters)
            drawRectPlayfield(asteroids[i].oldx, asteroids[i].oldy,
                              asteroids[i].size, asteroids[i].size, BLACK);
            asteroids[i].active = 0;
        }
    }
}

static void safeSetPixel(int x, int y, u16 color) {
    if (x >= 0 && x < SCREENWIDTH && y >= 0 && y < SCREENHEIGHT) {
        setPixel(x, y, color);
    }
}

static void drawAsteroids(void) {
    for (int i = 0; i < MAX_ASTEROIDS; i++) {
        if (!asteroids[i].active) continue;

        // Erase last drawn location (only in playfield)
        drawRectPlayfield(asteroids[i].oldx, asteroids[i].oldy,
                          asteroids[i].size, asteroids[i].size, BLACK);

        // Draw new location (only in playfield)
        u16 c = asteroids[i].isBomb ? MAGENTA : ((asteroids[i].hp == 2) ? BROWN : GRAY);
        drawRectPlayfield(asteroids[i].x, asteroids[i].y,
                          asteroids[i].size, asteroids[i].size, c);
    }
}

// Collisions + bomb
static void handleCollisions(void) {
    // Bullet vs Asteroid
    for (int b = 0; b < MAX_BULLETS; b++) {
        if (!bullets[b].active) continue;

        for (int a = 0; a < MAX_ASTEROIDS; a++) {
            if (!asteroids[a].active) continue;

            if (collision(bullets[b].x, bullets[b].y, bullets[b].w, bullets[b].h,
                          asteroids[a].x, asteroids[a].y, asteroids[a].size, asteroids[a].size)) {

                // Bullet returns to pool
                bullets[b].active = 0;
                drawRectPlayfield(bullets[b].oldx, bullets[b].oldy, bullets[b].w, bullets[b].h, BLACK);

                // Asteroid takes damage
                asteroids[a].hp--;
                if (asteroids[a].hp <= 0) {

                    // Clear BOTH old and current positions (only in playfield)
                    drawRectPlayfield(asteroids[a].oldx, asteroids[a].oldy,
                                      asteroids[a].size, asteroids[a].size, BLACK);

                    drawRectPlayfield(asteroids[a].x, asteroids[a].y,
                                      asteroids[a].size, asteroids[a].size, BLACK);

                    asteroids[a].active = 0;

                    // Bomb asteroid grants a one-time Nova Bomb (L) instead of just points.
                    if (asteroids[a].isBomb) {
                        player.bombs = 1;   // only 0/1 allowed (keeps it balanced)
                        playSfxPreset(SFXP_POWERUP); 
                    } else {
                        score++;
                        sfxHit();
                    }

                    // Score/bomb changed -> redraw HUD
                    hudDirty = 1;
                }

                break; // bullet is gone; stop checking this bullet
            }
        }
    }

    // Player vs Asteroid
    if (player.invulnTimer == 0) {
        for (int a = 0; a < MAX_ASTEROIDS; a++) {
            if (!asteroids[a].active) continue;

            if (collision(player.x, player.y, player.w, player.h,
                          asteroids[a].x, asteroids[a].y, asteroids[a].size, asteroids[a].size)) {

                // Lose a life
                player.lives--;
                player.invulnTimer = 45;

                // Ensure HUD redraws (lives changed)
                hudDirty = 1;

                // Remove asteroid on hit (makes collision “matter”)
                drawRectPlayfield(asteroids[a].oldx, asteroids[a].oldy,
                                  asteroids[a].size, asteroids[a].size, BLACK);

                drawRectPlayfield(asteroids[a].x, asteroids[a].y,
                                  asteroids[a].size, asteroids[a].size, BLACK);

                asteroids[a].active = 0;
                sfxHit();
                break;
            }
        }
    }
}

/**
 * Extra mechanic: Nova Bomb (L).
 * Earned by shooting a rare MAGENTA "bomb asteroid".
 * Clears all asteroids currently active.
 * This is "above and beyond" because the core game works without it,
 * but it adds a strategic resource + panic button.
 */
static void useBomb(void) {
    if (player.bombs <= 0) return;
    player.bombs--;

    // Clear all asteroids and award a small bonus for using it well
    int cleared = 0;
    for (int i = 0; i < MAX_ASTEROIDS; i++) {
        if (asteroids[i].active) {
            // Erase both old + current to avoid leftovers
            drawRectPlayfield(asteroids[i].oldx, asteroids[i].oldy,
                              asteroids[i].size, asteroids[i].size, BLACK);
            drawRectPlayfield(asteroids[i].x, asteroids[i].y,
                              asteroids[i].size, asteroids[i].size, BLACK);
            asteroids[i].active = 0;
            cleared++;
        }
    }

    // Reward for smart use, but not too strong
    score += (cleared >= 3) ? 2 : 1;

    // Score changed, force HUD redraw
    hudDirty = 1;

    screenShakeTimer = 10;
    sfxBomb();
}