#ifndef GAME_H
#define GAME_H

#include "gba.h"

// Game tuning
#define MAX_BULLETS   16   // object pool
#define MAX_ASTEROIDS 12   // object pool
#define MAX_STARS     24

#define PLAYER_W 8
#define PLAYER_H 8

// Gamestates
typedef enum {
    STATE_START,
    STATE_GAME,
    STATE_PAUSE,
    STATE_WIN,
    STATE_LOSE
} GameState;

// Player struct
typedef struct {
    int x, y;
    int oldx, oldy;
    int w, h;
    int speed;

    int lives;
    int invulnTimer;   // brief invulnerability after getting hit
    int dashCooldown;  // B dash cooldown

    int bombs;         // L shoulder: “Nova Bomb” (extra mechanic)
} Player;

// Bullet Struct
typedef struct {
    int x, y;
    int oldx, oldy;
    int w, h;

    int dx, dy;
    int active;
} Bullet;

// Asteroid Struct
typedef struct {
    int x, y;
    int oldx, oldy;
    int size;

    int dx, dy;
    int active;

    int hp;           // larger asteroids can take more hits
    int isBomb;        // 1 if this is the rare "bomb" asteroid (power-up)
} Asteroid;

// Star Struct
typedef struct {
    int x, y;
    int oldx, oldy;

    int speed;
} Star;

// Public game API (main.c calls these)
void initGame(void);
void updateGame(void);
void drawGame(void);

// State transitions
void goToStart(void);
void goToGame(void);
void goToPause(void);
void goToWin(void);
void goToLose(void);

// State getter (so main can switch)
GameState getState(void);

#endif