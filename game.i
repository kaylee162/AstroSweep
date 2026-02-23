# 0 "game.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "game.c"
# 1 "game.h" 1



# 1 "gba.h" 1




typedef signed char s8;
typedef unsigned char u8;
typedef signed short s16;
typedef unsigned short u16;
typedef signed int s32;
typedef unsigned int u32;
typedef signed long long s64;
typedef unsigned long long u64;
# 25 "gba.h"
extern u16* videoBuffer;
# 35 "gba.h"
int collision(int x1, int y1, int width1, int height1, int x2, int y2, int width2, int height2);


void waitForVBlank();

void flipBuffer(void);






extern int hudClipEnabled;
# 64 "gba.h"
void drawRectangle(int x, int y, int width, int height, volatile unsigned short color);
void fillScreen(volatile unsigned short color);


void drawChar(int x, int y, char ch, u16 color);
void drawString(int x, int y, const char* str, u16 color);
# 85 "gba.h"
extern u16 oldButtons;
extern u16 buttons;





typedef volatile struct {
    volatile void* src;
    volatile void* dest;
    unsigned int ctrl;
} DMAChannel;
# 126 "gba.h"
void DMANow(int channel, volatile void* src, volatile void* dest, unsigned int ctrl);
# 5 "game.h" 2
# 14 "game.h"
typedef enum {
    STATE_START,
    STATE_GAME,
    STATE_PAUSE,
    STATE_WIN,
    STATE_LOSE
} GameState;


typedef struct {
    int x, y;
    int oldx, oldy;
    int w, h;
    int speed;

    int lives;
    int invulnTimer;
    int dashCooldown;

    int bombs;
} Player;


typedef struct {
    int x, y;
    int oldx, oldy;
    int w, h;

    int dx, dy;
    int active;
} Bullet;


typedef struct {
    int x, y;
    int oldx, oldy;
    int size;

    int dx, dy;
    int active;

    int hp;
    int isBomb;
} Asteroid;


typedef struct {
    int x, y;
    int oldx, oldy;

    int speed;
} Star;


void initGame(void);
void updateGame(void);
void drawGame(void);


void goToStart(void);
void goToGame(void);
void goToPause(void);
void goToWin(void);
void goToLose(void);


GameState getState(void);
# 2 "game.c" 2
# 1 "sfx.h" 1



# 1 "analogSound.h" 1
# 259 "analogSound.h"
typedef enum note {

  REST = 0,
  NOTE_C2 =44,
  NOTE_CS2 =157,
  NOTE_D2 =263,
  NOTE_DS2 =363,
  NOTE_E2 =457,
  NOTE_F2 =547,
  NOTE_FS2 =631,
  NOTE_G2 =711,
  NOTE_GS2 =786,
  NOTE_A2 =856,
  NOTE_AS2 =923,
  NOTE_B2 =986,
  NOTE_C3 =1046,
  NOTE_CS3 =1102,
  NOTE_D3 =1155,
  NOTE_DS3 =1205,
  NOTE_E3 =1253,
  NOTE_F3 =1297,
  NOTE_FS3 =1339,
  NOTE_G3 =1379,
  NOTE_GS3 =1417,
  NOTE_A3 =1452,
  NOTE_AS3 =1486,
  NOTE_B3 =1517,
  NOTE_C4 =1547,
  NOTE_CS4 =1575,
  NOTE_D4 =1602,
  NOTE_DS4 =1627,
  NOTE_E4 =1650,
  NOTE_F4 =1673,
  NOTE_FS4 =1694,
  NOTE_G4 =1714,
  NOTE_GS4 =1732,
  NOTE_A4 =1750,
  NOTE_AS4 =1767,
  NOTE_B4 =1783,
  NOTE_C5 =1798,
  NOTE_CS5 =1812,
  NOTE_D5 =1825,
  NOTE_DS5 =1837,
  NOTE_E5 =1849,
  NOTE_F5 =1860,
  NOTE_FS5 =1871,
  NOTE_G5 =1881,
  NOTE_GS5 =1890,
  NOTE_A5 =1899,
  NOTE_AS5 =1907,
  NOTE_B5 =1915,
  NOTE_C6 =1923,
  NOTE_CS6 =1930,
  NOTE_D6 =1936,
  NOTE_DS6 =1943,
  NOTE_E6 =1949,
  NOTE_F6 =1954,
  NOTE_FS6 =1959,
  NOTE_G6 =1964,
  NOTE_GS6 =1969,
  NOTE_A6 =1974,
  NOTE_AS6 =1978,
  NOTE_B6 =1982,
  NOTE_C7 =1985,
  NOTE_CS7 =1989,
  NOTE_D7 =1992,
  NOTE_DS7 =1995,
  NOTE_E7 =1998,
  NOTE_F7 =2001,
  NOTE_FS7 =2004,
  NOTE_G7 =2006,
  NOTE_GS7 =2009,
  NOTE_A7 =2011,
  NOTE_AS7 =2013,
  NOTE_B7 =2015,
  NOTE_C8 =2017
} Note;

typedef struct noteWithDuration {
  Note note;
  unsigned char duration;
} NoteWithDuration;

void initSound();
void playDrumSound(u8 r, u8 s, u8 b, u8 length, u8 steptime);
void playNoteWithDuration(NoteWithDuration *n, u8 duty);
void playChannel1(u16 note, u8 length, u8 sweepShift, u8 sweepTime, u8 sweepDir, u8 envStepTime, u8 envDir, u8 duty);
void playAnalogSound(u16 sound);


void playChannel2(u16 note, u8 length, u8 envStepTime, u8 envDir, u8 duty);


typedef enum {
    SFXP_SHOOT = 0,
    SFXP_HIT,
    SFXP_BOMB,
    SFXP_POWERUP,
    SFXP_WIN,
    SFXP_LOSE
} SfxPreset;

void playSfxPreset(SfxPreset p);
# 5 "sfx.h" 2


void sfxInit(void);


void sfxShoot(void);
void sfxHit(void);
void sfxBomb(void);
void sfxWin(void);
void sfxLose(void);
void sfxPowerUp(void);
# 3 "game.c" 2


static GameState state;

static Player player;

static Bullet bullets[16];
static Asteroid asteroids[12];
static Star stars[24];


static int score;
static int targetScore;
static int frameCount;
static int spawnTimer;
static int asteroidSpawnCount;


static int screenShakeTimer;


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


static u16 cheatLatch = 0;
static int cheatFlashTimer = 0;



static GameState lastRenderedState = -1;
static int fullRedrawRequested = 1;
static int hudDirty = 1;

static void safeSetPixel(int x, int y, u16 color);

static int clamp(int v, int lo, int hi) {
    if (v < lo) return lo;
    if (v > hi) return hi;
    return v;
}

static void cheatFlash(void) {
    cheatFlashTimer = 10;
}



static void drawRectPlayfield(int x, int y, int w, int h, volatile unsigned short color) {
    if (w <= 0 || h <= 0) return;


    if (y < 12) return;


    if (x < 0 || y < 0 || x + w > 240 || y + h > 160) return;

    drawRectangle(x, y, w, h, color);
}


GameState getState(void) {
    return state;
}

void initGame(void) {

    sfxInit();
    targetScore = 25;

    goToStart();
}


void updateGame(void) {

    switch (state) {
        case STATE_START:

            if ((!(~(oldButtons) & ((1<<3))) && (~(buttons) & ((1<<3))))) {
                goToGame();
            }
            break;

        case STATE_GAME: {




            if ((~(buttons) & ((1<<2)))) {

                u16 pressedNow = (u16)(~buttons);


                u16 cheatKeys = ((1<<3) | (1<<0) | (1<<1) | (1<<5) | (1<<4) | (1<<6));


                u16 comboNow = pressedNow & cheatKeys;


                u16 newlyPressed = (u16)(comboNow & (u16)(~cheatLatch));
                cheatLatch = comboNow;


                if (newlyPressed & (1<<3)) {
                    goToWin();
                    cheatLatch = 0;
                    break;
                }


                if (newlyPressed & (1<<5)) {
                    goToLose();
                    cheatLatch = 0;
                    break;
                }


                if (newlyPressed & (1<<1)) {
                    for (int i = 0; i < 12; i++) {
                        if (asteroids[i].active) {
                            drawRectPlayfield(asteroids[i].oldx, asteroids[i].oldy,
                                            asteroids[i].size, asteroids[i].size, (((0) & 31) | ((0) & 31) << 5 | ((0) & 31) << 10));
                            drawRectPlayfield(asteroids[i].x, asteroids[i].y,
                                            asteroids[i].size, asteroids[i].size, (((0) & 31) | ((0) & 31) << 5 | ((0) & 31) << 10));
                            asteroids[i].active = 0;
                        }
                    }
                    cheatFlash();
                    break;
                }


                if (newlyPressed & (1<<0)) {
                    score = 0;
                    player.lives = 3;
                    player.invulnTimer = 0;
                    player.bombs = 0;
                    hudDirty = 1;
                    cheatFlash();
                    break;
                }


                if (newlyPressed & (1<<6)) {
                    player.lives = 3;
                    player.invulnTimer = 0;
                    hudDirty = 1;
                    cheatFlash();
                    break;
                }


                if (newlyPressed & (1<<4)) {
                    player.bombs = 1;
                    hudDirty = 1;
                    cheatFlash();
                    break;
                }



                break;
            } else {
                cheatLatch = 0;
            }


            if ((!(~(oldButtons) & ((1<<3))) && (~(buttons) & ((1<<3))))) {
                goToPause();
                break;
            }


            frameCount++;
            updateStars();
            updatePlayer();
            updateBullets();


            spawnTimer--;
            if (spawnTimer <= 0) {
                spawnAsteroid();

                spawnTimer = clamp(60 - (frameCount / 240), 18, 60);
            }

            updateAsteroids();
            handleCollisions();


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

            if ((!(~(oldButtons) & ((1<<3))) && (~(buttons) & ((1<<3))))) {
                goToGame();
            } else if ((!(~(oldButtons) & ((1<<2))) && (~(buttons) & ((1<<2))))) {
                goToStart();
            }
            break;

        case STATE_WIN:
        case STATE_LOSE:

            if ((!(~(oldButtons) & ((1<<3))) && (~(buttons) & ((1<<3))))) {
                goToStart();
            }
            break;
    }
}


static void drawHUD(void) {
    static int lastLives = -1;
    static int lastScore = -1;
    static int lastBombs = -1;

    int livesShown = clamp(player.lives, 0, 9);
    int pointsShown = clamp(score, 0, 99);
    int bombsShown = clamp(player.bombs, 0, 1);


    if (!hudDirty && livesShown == lastLives && pointsShown == lastScore && bombsShown == lastBombs) {
        return;
    }

    lastLives = livesShown;
    lastScore = pointsShown;
    lastBombs = bombsShown;
    hudDirty = 0;

    drawRectangle(0, 0, 150, 12, (((0) & 31) | ((0) & 31) << 5 | ((0) & 31) << 10));

    char hud[24];
    int idx = 0;


    hud[idx++] = 'L';
    hud[idx++] = ':';
    hud[idx++] = (char)('0' + livesShown);
    hud[idx++] = ' ';


    hud[idx++] = 'P';
    hud[idx++] = ':';
    hud[idx++] = (char)('0' + (pointsShown / 10));
    hud[idx++] = (char)('0' + (pointsShown % 10));
    hud[idx++] = ' ';


    hud[idx++] = 'B';
    hud[idx++] = ':';
    hud[idx++] = (char)('0' + bombsShown);
    hud[idx] = '\0';

    drawString(2, 2, hud, (((31) & 31) | ((31) & 31) << 5 | ((31) & 31) << 10));
}

void drawGame(void) {




    if (state == STATE_START || state == STATE_WIN || state == STATE_LOSE) {
        if (state == lastRenderedState) {
            return;
        }
        lastRenderedState = state;

        fillScreen((((0) & 31) | ((0) & 31) << 5 | ((0) & 31) << 10));

        if (state == STATE_START) {
            drawString(60, 70, "ASTRO SWEEP", (((0) & 31) | ((31) & 31) << 5 | ((31) & 31) << 10));
            drawString(28, 92, "Press START to begin", (((31) & 31) | ((31) & 31) << 5 | ((31) & 31) << 10));
            drawString(22, 110, "A: Shoot  B: Dash  L: Bomb", (((15) & 31) | ((15) & 31) << 5 | ((15) & 31) << 10));
            drawString(14, 122, "Shoot MAGENTA asteroid to earn bomb", (((15) & 31) | ((15) & 31) << 5 | ((15) & 31) << 10));
        } else if (state == STATE_WIN) {
            drawString(80, 70, "YOU WIN!", (((0) & 31) | ((31) & 31) << 5 | ((0) & 31) << 10));
            drawString(34, 92, "Press START for menu", (((31) & 31) | ((31) & 31) << 5 | ((31) & 31) << 10));
        } else if (state == STATE_LOSE) {
            drawString(80, 70, "YOU LOSE!", (((31) & 31) | ((0) & 31) << 5 | ((0) & 31) << 10));
            drawString(34, 92, "Press START for menu", (((31) & 31) | ((31) & 31) << 5 | ((31) & 31) << 10));
        }
        return;
    }




    if (state == STATE_PAUSE) {
        if (state != lastRenderedState) {
            lastRenderedState = state;

            drawRectangle(0, 0, 240, 160, (((0) & 31) | ((0) & 31) << 5 | ((0) & 31) << 10));
            drawString(96, 70, "PAUSED", (((31) & 31) | ((31) & 31) << 5 | ((0) & 31) << 10));
            drawString(26, 92, "START: Resume  SELECT: Menu", (((31) & 31) | ((31) & 31) << 5 | ((31) & 31) << 10));
        }
        return;
    }




    if (state != lastRenderedState) {
        lastRenderedState = state;
        fullRedrawRequested = 1;
        hudDirty = 1;
    }

    if (fullRedrawRequested) {
        fillScreen((((0) & 31) | ((0) & 31) << 5 | ((0) & 31) << 10));


        hudDirty = 1;

        fullRedrawRequested = 0;
    }

    drawStars();
    drawPlayer();
    drawBullets();
    drawAsteroids();


    drawHUD();
}


void goToStart(void) {
    state = STATE_START;
}


void goToGame(void) {

    if (state == STATE_START || state == STATE_WIN || state == STATE_LOSE) {
        score = 0;
        frameCount = 0;
        spawnTimer = 45;
        asteroidSpawnCount = 0;
        screenShakeTimer = 0;

        initStars();
        initPlayer();
        initPools();


        fullRedrawRequested = 1;
        hudDirty = 1;
    }


    if (state == STATE_PAUSE) {
        fullRedrawRequested = 1;
        hudDirty = 1;
    }

    state = STATE_GAME;
}


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


static void initStars(void) {
    for (int i = 0; i < 24; i++) {
        stars[i].x = (i * 13) % 240;
        stars[i].y = 12 + (i * 7) % (160 - 12);
        stars[i].oldx = stars[i].x;
        stars[i].oldy = stars[i].y;
        stars[i].speed = 1 + (i % 2);
    }
}

static void updateStars(void) {
    for (int i = 0; i < 24; i++) {
        stars[i].oldx = stars[i].x;
        stars[i].oldy = stars[i].y;


        stars[i].y += stars[i].speed;


        if (stars[i].y >= 160) {
            stars[i].y = 12;
            stars[i].x = (stars[i].x + 53) % 240;
        }
    }
}

static void drawStars(void) {
    for (int i = 0; i < 24; i++) {


        if (stars[i].oldx >= 0 && stars[i].oldx < 240 &&
            stars[i].oldy >= 12 && stars[i].oldy < 160) {

            (videoBuffer[((stars[i].oldy) * (240) + (stars[i].oldx))] = (((0) & 31) | ((0) & 31) << 5 | ((0) & 31) << 10));
        }


        if (stars[i].y >= 12 && stars[i].y < 160) {
            (videoBuffer[((stars[i].y) * (240) + (stars[i].x))] = (((15) & 31) | ((15) & 31) << 5 | ((15) & 31) << 10));
        }
    }
}


static void initPlayer(void) {
    player.w = 8;
    player.h = 8;

    player.x = (240 / 2) - (player.w / 2);
    player.y = (160 - 20);

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


    if ((~(buttons) & ((1<<5)))) player.x -= spd;
    if ((~(buttons) & ((1<<4)))) player.x += spd;
    if ((~(buttons) & ((1<<6)))) player.y -= spd;
    if ((~(buttons) & ((1<<7)))) player.y += spd;


    player.x = clamp(player.x, 0, 240 - player.w);
    player.y = clamp(player.y, 12, 160 - player.h);


    if ((!(~(oldButtons) & ((1<<0))) && (~(buttons) & ((1<<0))))) {
        fireBullet();
    }


    if ((!(~(oldButtons) & ((1<<1))) && (~(buttons) & ((1<<1)))) && player.dashCooldown == 0) {
        player.dashCooldown = 30;


        int dx = 0, dy = -1;
        if ((~(buttons) & ((1<<5)))) dx = -1, dy = 0;
        if ((~(buttons) & ((1<<4)))) dx = 1, dy = 0;
        if ((~(buttons) & ((1<<7)))) dx = 0, dy = 1;
        if ((~(buttons) & ((1<<6)))) dx = 0, dy = -1;

        player.x = clamp(player.x + dx * 18, 0, 240 - player.w);
        player.y = clamp(player.y + dy * 18, 12, 160 - player.h);
    }


    if ((!(~(oldButtons) & ((1<<9))) && (~(buttons) & ((1<<9))))) {
        useBomb();
    }
}

static void drawPlayer(void) {

    drawRectangle(player.oldx, player.oldy, player.w, player.h, (((0) & 31) | ((0) & 31) << 5 | ((0) & 31) << 10));


    if (player.invulnTimer > 0 && (player.invulnTimer / 4) % 2 == 0) {

        return;
    }


    drawRectangle(player.x, player.y, player.w, player.h, (((0) & 31) | ((31) & 31) << 5 | ((31) & 31) << 10));


    safeSetPixel(player.x + 3, player.y + 2, (((31) & 31) | ((31) & 31) << 5 | ((31) & 31) << 10));
}


static void initPools(void) {
    for (int i = 0; i < 16; i++) {
        bullets[i].active = 0;
        bullets[i].w = 2;
        bullets[i].h = 2;
        bullets[i].x = bullets[i].y = 0;
        bullets[i].oldx = bullets[i].oldy = 0;
        bullets[i].dx = 0;
        bullets[i].dy = -4;
    }

    for (int i = 0; i < 12; i++) {
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

    for (int i = 0; i < 16; i++) {
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

}

static void updateBullets(void) {
    for (int i = 0; i < 16; i++) {
        if (!bullets[i].active) continue;

        bullets[i].oldx = bullets[i].x;
        bullets[i].oldy = bullets[i].y;

        bullets[i].y += bullets[i].dy;


        if (bullets[i].y < 12) {
            bullets[i].active = 0;

            drawRectPlayfield(bullets[i].oldx, bullets[i].oldy, bullets[i].w, bullets[i].h, (((0) & 31) | ((0) & 31) << 5 | ((0) & 31) << 10));
            continue;
        }


        if (bullets[i].y < 0) {
            bullets[i].active = 0;

            drawRectPlayfield(bullets[i].oldx, bullets[i].oldy, bullets[i].w, bullets[i].h, (((0) & 31) | ((0) & 31) << 5 | ((0) & 31) << 10));
        }
    }
}

static void drawBullets(void) {
    for (int i = 0; i < 16; i++) {
        if (!bullets[i].active) continue;


        drawRectPlayfield(bullets[i].oldx, bullets[i].oldy, bullets[i].w, bullets[i].h, (((0) & 31) | ((0) & 31) << 5 | ((0) & 31) << 10));


        drawRectPlayfield(bullets[i].x, bullets[i].y, bullets[i].w, bullets[i].h, (((31) & 31) | ((31) & 31) << 5 | ((0) & 31) << 10));
    }
}


static void spawnAsteroid(void) {
    for (int i = 0; i < 12; i++) {
        if (!asteroids[i].active) {
            asteroids[i].active = 1;


            asteroidSpawnCount++;



            asteroids[i].isBomb = (asteroidSpawnCount % 15 == 0);


            if (asteroids[i].isBomb) {

                asteroids[i].size = 8;
                asteroids[i].hp = 1;
            } else {
                asteroids[i].size = 6 + ((frameCount / 180) % 7);
                asteroids[i].hp = (asteroids[i].size >= 10) ? 2 : 1;
            }

            asteroids[i].x = (i * 29 + frameCount * 3) % (240 - asteroids[i].size);
            asteroids[i].y = 12 - asteroids[i].size;

            asteroids[i].oldx = asteroids[i].x;
            asteroids[i].oldy = asteroids[i].y;


            asteroids[i].dx = ((i % 3) - 1);
            asteroids[i].dy = 1 + (frameCount / 600);
            asteroids[i].dy = clamp(asteroids[i].dy, 1, 3);

            return;
        }
    }

}

static void updateAsteroids(void) {
    for (int i = 0; i < 12; i++) {
        if (!asteroids[i].active) continue;


        asteroids[i].oldx = asteroids[i].x;
        asteroids[i].oldy = asteroids[i].y;


        asteroids[i].x += asteroids[i].dx;
        asteroids[i].y += asteroids[i].dy;


        if (asteroids[i].x <= 0 || asteroids[i].x >= 240 - asteroids[i].size) {
            asteroids[i].dx = -asteroids[i].dx;
            asteroids[i].x = clamp(asteroids[i].x, 0, 240 - asteroids[i].size);
        }


        if (asteroids[i].oldy < 160 && asteroids[i].y >= 160) {

            drawRectPlayfield(asteroids[i].oldx, asteroids[i].oldy,
                              asteroids[i].size, asteroids[i].size, (((0) & 31) | ((0) & 31) << 5 | ((0) & 31) << 10));
            asteroids[i].active = 0;
        }
    }
}

static void safeSetPixel(int x, int y, u16 color) {
    if (x >= 0 && x < 240 && y >= 0 && y < 160) {
        (videoBuffer[((y) * (240) + (x))] = color);
    }
}

static void drawAsteroids(void) {
    for (int i = 0; i < 12; i++) {
        if (!asteroids[i].active) continue;


        drawRectPlayfield(asteroids[i].oldx, asteroids[i].oldy,
                          asteroids[i].size, asteroids[i].size, (((0) & 31) | ((0) & 31) << 5 | ((0) & 31) << 10));


        u16 c = asteroids[i].isBomb ? (((31) & 31) | ((0) & 31) << 5 | ((31) & 31) << 10) : ((asteroids[i].hp == 2) ? (((20) & 31) | ((10) & 31) << 5 | ((5) & 31) << 10) : (((15) & 31) | ((15) & 31) << 5 | ((15) & 31) << 10));
        drawRectPlayfield(asteroids[i].x, asteroids[i].y,
                          asteroids[i].size, asteroids[i].size, c);
    }
}


static void handleCollisions(void) {

    for (int b = 0; b < 16; b++) {
        if (!bullets[b].active) continue;

        for (int a = 0; a < 12; a++) {
            if (!asteroids[a].active) continue;

            if (collision(bullets[b].x, bullets[b].y, bullets[b].w, bullets[b].h,
                          asteroids[a].x, asteroids[a].y, asteroids[a].size, asteroids[a].size)) {


                bullets[b].active = 0;
                drawRectPlayfield(bullets[b].oldx, bullets[b].oldy, bullets[b].w, bullets[b].h, (((0) & 31) | ((0) & 31) << 5 | ((0) & 31) << 10));


                asteroids[a].hp--;
                if (asteroids[a].hp <= 0) {


                    drawRectPlayfield(asteroids[a].oldx, asteroids[a].oldy,
                                      asteroids[a].size, asteroids[a].size, (((0) & 31) | ((0) & 31) << 5 | ((0) & 31) << 10));

                    drawRectPlayfield(asteroids[a].x, asteroids[a].y,
                                      asteroids[a].size, asteroids[a].size, (((0) & 31) | ((0) & 31) << 5 | ((0) & 31) << 10));

                    asteroids[a].active = 0;


                    if (asteroids[a].isBomb) {
                        player.bombs = 1;
                        playSfxPreset(SFXP_POWERUP);
                    } else {
                        score++;
                        sfxHit();
                    }


                    hudDirty = 1;
                }

                break;
            }
        }
    }


    if (player.invulnTimer == 0) {
        for (int a = 0; a < 12; a++) {
            if (!asteroids[a].active) continue;

            if (collision(player.x, player.y, player.w, player.h,
                          asteroids[a].x, asteroids[a].y, asteroids[a].size, asteroids[a].size)) {


                player.lives--;
                player.invulnTimer = 45;


                hudDirty = 1;


                drawRectPlayfield(asteroids[a].oldx, asteroids[a].oldy,
                                  asteroids[a].size, asteroids[a].size, (((0) & 31) | ((0) & 31) << 5 | ((0) & 31) << 10));

                drawRectPlayfield(asteroids[a].x, asteroids[a].y,
                                  asteroids[a].size, asteroids[a].size, (((0) & 31) | ((0) & 31) << 5 | ((0) & 31) << 10));

                asteroids[a].active = 0;
                sfxHit();
                break;
            }
        }
    }
}
# 782 "game.c"
static void useBomb(void) {
    if (player.bombs <= 0) return;
    player.bombs--;


    int cleared = 0;
    for (int i = 0; i < 12; i++) {
        if (asteroids[i].active) {

            drawRectPlayfield(asteroids[i].oldx, asteroids[i].oldy,
                              asteroids[i].size, asteroids[i].size, (((0) & 31) | ((0) & 31) << 5 | ((0) & 31) << 10));
            drawRectPlayfield(asteroids[i].x, asteroids[i].y,
                              asteroids[i].size, asteroids[i].size, (((0) & 31) | ((0) & 31) << 5 | ((0) & 31) << 10));
            asteroids[i].active = 0;
            cleared++;
        }
    }


    score += (cleared >= 3) ? 2 : 1;


    hudDirty = 1;

    screenShakeTimer = 10;
    sfxBomb();
}
