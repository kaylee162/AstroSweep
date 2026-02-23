# 0 "sfx.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "sfx.c"
# 1 "sfx.h" 1



# 1 "analogSound.h" 1



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
# 5 "analogSound.h" 2
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
# 2 "sfx.c" 2


void sfxInit(void) { initSound(); }

void sfxShoot(void) { playSfxPreset(SFXP_SHOOT); }
void sfxHit(void) { playSfxPreset(SFXP_HIT); }
void sfxBomb(void) { playSfxPreset(SFXP_BOMB); }
void sfxPowerup(void) { playSfxPreset(SFXP_POWERUP); }
void sfxWin(void) { playSfxPreset(SFXP_WIN); }
void sfxLose(void) { playSfxPreset(SFXP_LOSE); }
