#include "gba.h"
#include "game.h"

// Buttons
u16 buttons;
u16 oldButtons;

static void initialize(void);

// Main
int main(void) {
    // Initialize and Initialize Game
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
    // Set mode and background
    REG_DISPCTL = MODE(3) | BG_ENABLE(2);

    // Set buttons
    oldButtons = 0;
    buttons = REG_BUTTONS;

    // Clear once at startup
    waitForVBlank();
    fillScreen(BLACK);
}