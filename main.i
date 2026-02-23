# 0 "main.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "main.c"
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
# 2 "main.c" 2
# 1 "game.h" 1
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
# 3 "main.c" 2

u16 buttons;
u16 oldButtons;

static void initialize(void);

int main(void) {
    initialize();
    initGame();

    while (1) {
        oldButtons = buttons;
        buttons = (*(volatile unsigned short *)0x04000130);


        updateGame();


        waitForVBlank();
        drawGame();
    }
}

static void initialize(void) {
    (*(volatile unsigned short *)0x4000000) = ((3) & 7) | (1 << (8 + ((2) % 4)));

    oldButtons = 0;
    buttons = (*(volatile unsigned short *)0x04000130);


    waitForVBlank();
    fillScreen((((0) & 31) | ((0) & 31) << 5 | ((0) & 31) << 10));
}
