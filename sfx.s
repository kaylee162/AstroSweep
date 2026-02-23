	.cpu arm7tdmi
	.arch armv4t
	.fpu softvfp
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 1
	.eabi_attribute 30, 2
	.eabi_attribute 34, 0
	.eabi_attribute 18, 4
	.file	"sfx.c"
	.text
	.align	2
	.global	sfxInit
	.syntax unified
	.arm
	.type	sfxInit, %function
sfxInit:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	ldr	r3, .L4
	mov	lr, pc
	bx	r3
	pop	{r4, lr}
	bx	lr
.L5:
	.align	2
.L4:
	.word	initSound
	.size	sfxInit, .-sfxInit
	.align	2
	.global	sfxShoot
	.syntax unified
	.arm
	.type	sfxShoot, %function
sfxShoot:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	mov	r0, #0
	ldr	r3, .L8
	mov	lr, pc
	bx	r3
	pop	{r4, lr}
	bx	lr
.L9:
	.align	2
.L8:
	.word	playSfxPreset
	.size	sfxShoot, .-sfxShoot
	.align	2
	.global	sfxHit
	.syntax unified
	.arm
	.type	sfxHit, %function
sfxHit:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	mov	r0, #1
	ldr	r3, .L12
	mov	lr, pc
	bx	r3
	pop	{r4, lr}
	bx	lr
.L13:
	.align	2
.L12:
	.word	playSfxPreset
	.size	sfxHit, .-sfxHit
	.align	2
	.global	sfxBomb
	.syntax unified
	.arm
	.type	sfxBomb, %function
sfxBomb:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	mov	r0, #2
	ldr	r3, .L16
	mov	lr, pc
	bx	r3
	pop	{r4, lr}
	bx	lr
.L17:
	.align	2
.L16:
	.word	playSfxPreset
	.size	sfxBomb, .-sfxBomb
	.align	2
	.global	sfxPowerup
	.syntax unified
	.arm
	.type	sfxPowerup, %function
sfxPowerup:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	mov	r0, #3
	ldr	r3, .L20
	mov	lr, pc
	bx	r3
	pop	{r4, lr}
	bx	lr
.L21:
	.align	2
.L20:
	.word	playSfxPreset
	.size	sfxPowerup, .-sfxPowerup
	.align	2
	.global	sfxWin
	.syntax unified
	.arm
	.type	sfxWin, %function
sfxWin:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	mov	r0, #4
	ldr	r3, .L24
	mov	lr, pc
	bx	r3
	pop	{r4, lr}
	bx	lr
.L25:
	.align	2
.L24:
	.word	playSfxPreset
	.size	sfxWin, .-sfxWin
	.align	2
	.global	sfxLose
	.syntax unified
	.arm
	.type	sfxLose, %function
sfxLose:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	mov	r0, #5
	ldr	r3, .L28
	mov	lr, pc
	bx	r3
	pop	{r4, lr}
	bx	lr
.L29:
	.align	2
.L28:
	.word	playSfxPreset
	.size	sfxLose, .-sfxLose
	.ident	"GCC: (devkitARM) 15.2.0"
