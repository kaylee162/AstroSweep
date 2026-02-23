#include "gba.h"
#include "game.h"

u16 buttons;
u16 oldButtons;

static void initialize(void);

int main(void) {
    initialize();
    initGame();

    while (1) {
        oldButtons = buttons;
        buttons = REG_BUTTONS;

        // Game logic update stays the same
        updateGame();

        // Draw during VBlank to reduce flicker/tearing
        waitForVBlank();
        drawGame();
    }
}

static void initialize(void) {
    REG_DISPCTL = MODE(3) | BG_ENABLE(2);

    oldButtons = 0;
    buttons = REG_BUTTONS;

    // Clear once at startup (best done during VBlank)
    waitForVBlank();
    fillScreen(BLACK);
}