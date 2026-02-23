#ifndef SFX_H
#define SFX_H

#include "analogSound.h"

// Call once at program start
void sfxInit(void);

// Two+ sound effects (shoot + hit + optional win/lose stingers)
void sfxShoot(void);
void sfxHit(void);
void sfxBomb(void);
void sfxWin(void);
void sfxLose(void);
void sfxPowerUp(void);

#endif