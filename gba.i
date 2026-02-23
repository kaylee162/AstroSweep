# 0 "gba.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "gba.c"
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
# 2 "gba.c" 2
# 1 "font.h" 1

extern const unsigned char fontdata[12288];
# 3 "gba.c" 2
# 18 "gba.c"
u16* videoBuffer = (u16*)0x6000000;


void drawRectangle(int x, int y, int width, int height, volatile unsigned short color) {
    if (width <= 0 || height <= 0) return;


    if (x < 0 || y < 0 || x + width > 240 || y + height > 160) return;

    for (int row = 0; row < height; row++) {
        volatile unsigned short* dest =
            (volatile unsigned short*)&videoBuffer[((y + row) * (240) + (x))];

        DMANow(3,
               (volatile void*)&color,
               (volatile void*)dest,
               width | (2 << 23) | (0 << 21) | (0 << 26));
    }
}


void fillScreen(volatile u16 color) {
    DMANow(3,
           (volatile void*)&color,
           (volatile void*)videoBuffer,
           (240 * 160) | (2 << 23) | (0 << 21) | (0 << 26));
}


void drawChar(int x, int y, char ch, u16 color) {
    unsigned char code = (unsigned char)ch;
    if (code > 127) return;

    int glyphIndex = code * 48;

    for (int r = 0; r < 8; r++) {
        for (int c = 0; c < 6; c++) {
            unsigned char pixel = fontdata[glyphIndex + r * 6 + c];
            if (pixel) {
                (videoBuffer[((y + r) * (240) + (x + c))] = color);
            }
        }
    }
}


void drawString(int x, int y, const char* str, u16 color) {
    int cx = x;
    while (*str) {
        if (*str == '\n') {
            y += 10;
            cx = x;
        } else {
            drawChar(cx, y, *str, color);
            cx += 6;
        }
        str++;
    }
}


void waitForVBlank() {
    while ((*(volatile unsigned short *)0x4000006) >= 160);
    while ((*(volatile unsigned short *)0x4000006) < 160);
}



void flipBuffer(void) {

}


int collision(int xA, int yA, int widthA, int heightA,
              int xB, int yB, int widthB, int heightB) {
    return yA <= yB + heightB - 1
        && yA + heightA - 1 >= yB
        && xA <= xB + widthB - 1
        && xA + widthA - 1 >= xB;
}


void DMANow(int channel, volatile void* src, volatile void* dest, unsigned int ctrl) {
    ((DMAChannel*)0x040000B0)[channel].ctrl = 0;
    ((DMAChannel*)0x040000B0)[channel].src = src;
    ((DMAChannel*)0x040000B0)[channel].dest = dest;
    ((DMAChannel*)0x040000B0)[channel].ctrl = ctrl | (1 << 31);
}
