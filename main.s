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
	.file	"main.c"
	.text
	.section	.text.startup,"ax",%progbits
	.align	2
	.global	main
	.syntax unified
	.arm
	.type	main, %function
main:
	@ Function supports interworking.
	@ Volatile: function does not return.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r7, lr}
	mov	r3, #67108864
	mov	r7, #0
	ldr	r2, .L5
	ldr	r4, .L5+4
	strh	r2, [r3]	@ movhi
	ldr	r6, .L5+8
	strh	r7, [r4]	@ movhi
	ldrh	r3, [r6, #48]
	ldr	r5, .L5+12
	strh	r3, [r4, #2]	@ movhi
	mov	lr, pc
	bx	r5
	mov	r0, r7
	ldr	r3, .L5+16
	mov	lr, pc
	bx	r3
	ldr	r3, .L5+20
	mov	lr, pc
	bx	r3
	ldr	r8, .L5+24
	ldr	r7, .L5+28
.L2:
	ldrh	r3, [r4, #2]
	strh	r3, [r4]	@ movhi
	ldrh	r3, [r6, #48]
	strh	r3, [r4, #2]	@ movhi
	mov	lr, pc
	bx	r8
	mov	lr, pc
	bx	r5
	mov	lr, pc
	bx	r7
	b	.L2
.L6:
	.align	2
.L5:
	.word	1027
	.word	.LANCHOR0
	.word	67109120
	.word	waitForVBlank
	.word	fillScreen
	.word	initGame
	.word	updateGame
	.word	drawGame
	.size	main, .-main
	.global	oldButtons
	.global	buttons
	.bss
	.align	1
	.set	.LANCHOR0,. + 0
	.type	oldButtons, %object
	.size	oldButtons, 2
oldButtons:
	.space	2
	.type	buttons, %object
	.size	buttons, 2
buttons:
	.space	2
	.ident	"GCC: (devkitARM) 15.2.0"
