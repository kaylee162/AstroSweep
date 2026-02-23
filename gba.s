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
	.file	"gba.c"
	.text
	.align	2
	.global	drawRectangle
	.syntax unified
	.arm
	.type	drawRectangle, %function
drawRectangle:
	@ Function supports interworking.
	@ args = 4, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	cmp	r3, #0
	cmpgt	r2, #0
	movle	ip, #1
	movgt	ip, #0
	bxle	lr
	push	{r4, lr}
	orrs	lr, r0, r1
	bmi	.L1
	add	lr, r2, r0
	cmp	lr, #240
	bgt	.L1
	add	lr, r3, r1
	cmp	lr, #160
	bgt	.L1
	rsb	r1, r1, r1, lsl #4
	add	r1, r0, r1, lsl #4
	ldr	r0, .L11
	ldr	r0, [r0]
	mov	lr, ip
	add	r0, r0, r1, lsl #1
	mov	r1, #67108864
	orr	r2, r2, #-2130706432
.L4:
	add	ip, ip, #1
	add	r4, sp, #8
	cmp	r3, ip
	str	lr, [r1, #220]
	str	r4, [r1, #212]
	str	r0, [r1, #216]
	str	r2, [r1, #220]
	add	r0, r0, #480
	bgt	.L4
.L1:
	pop	{r4, lr}
	bx	lr
.L12:
	.align	2
.L11:
	.word	.LANCHOR0
	.size	drawRectangle, .-drawRectangle
	.align	2
	.global	fillScreen
	.syntax unified
	.arm
	.type	fillScreen, %function
fillScreen:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	str	lr, [sp, #-4]!
	mov	r3, #67108864
	mov	lr, #0
	ldr	r1, .L15
	sub	sp, sp, #12
	ldr	r1, [r1]
	ldr	r2, .L15+4
	add	ip, sp, #6
	strh	r0, [sp, #6]	@ movhi
	str	lr, [r3, #220]
	str	ip, [r3, #212]
	str	r1, [r3, #216]
	str	r2, [r3, #220]
	add	sp, sp, #12
	@ sp needed
	ldr	lr, [sp], #4
	bx	lr
.L16:
	.align	2
.L15:
	.word	.LANCHOR0
	.word	-2130668032
	.size	fillScreen, .-fillScreen
	.align	2
	.global	drawChar
	.syntax unified
	.arm
	.type	drawChar, %function
drawChar:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	tst	r2, #128
	bxne	lr
	push	{r4, r5, lr}
	ldr	ip, .L30
	mov	r4, r3
	ldr	r3, .L30+4
	add	r2, r2, r2, lsl #1
	rsb	r1, r1, r1, lsl #4
	add	ip, ip, r2, lsl #4
	ldr	r2, [r3]
	add	r0, r0, r1, lsl #4
	lsl	lr, r1, #4
	add	r3, r2, r0, lsl #1
	add	r5, lr, #1920
.L19:
	mov	r1, r3
	sub	r2, ip, #6
.L21:
	ldrb	r0, [r2], #1	@ zero_extendqisi2
	cmp	r0, #0
	strhne	r4, [r1]	@ movhi
	cmp	r2, ip
	add	r1, r1, #2
	bne	.L21
	add	lr, lr, #240
	cmp	lr, r5
	add	ip, ip, #6
	add	r3, r3, #480
	bne	.L19
	pop	{r4, r5, lr}
	bx	lr
.L31:
	.align	2
.L30:
	.word	fontdata+6
	.word	.LANCHOR0
	.size	drawChar, .-drawChar
	.align	2
	.global	drawString
	.syntax unified
	.arm
	.type	drawString, %function
drawString:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, lr}
	mov	r4, r2
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, #0
	beq	.L32
	mov	r6, r1
	mov	r8, r3
	mov	r7, r0
	mov	r5, r0
.L36:
	cmp	r2, #10
	moveq	r5, r7
	addeq	r6, r6, #10
	beq	.L35
	mov	r0, r5
	mov	r3, r8
	mov	r1, r6
	bl	drawChar
	add	r5, r5, #6
.L35:
	ldrb	r2, [r4, #1]!	@ zero_extendqisi2
	cmp	r2, #0
	bne	.L36
.L32:
	pop	{r4, r5, r6, r7, r8, lr}
	bx	lr
	.size	drawString, .-drawString
	.align	2
	.global	waitForVBlank
	.syntax unified
	.arm
	.type	waitForVBlank, %function
waitForVBlank:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mov	r2, #67108864
.L43:
	ldrh	r3, [r2, #6]
	cmp	r3, #159
	bhi	.L43
	mov	r2, #67108864
.L44:
	ldrh	r3, [r2, #6]
	cmp	r3, #159
	bls	.L44
	bx	lr
	.size	waitForVBlank, .-waitForVBlank
	.align	2
	.global	flipBuffer
	.syntax unified
	.arm
	.type	flipBuffer, %function
flipBuffer:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	bx	lr
	.size	flipBuffer, .-flipBuffer
	.align	2
	.global	collision
	.syntax unified
	.arm
	.type	collision, %function
collision:
	@ Function supports interworking.
	@ args = 16, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	str	lr, [sp, #-4]!
	ldr	lr, [sp, #8]
	ldr	ip, [sp, #16]
	add	ip, lr, ip
	cmp	ip, r1
	ble	.L53
	add	r1, r1, r3
	cmp	r1, lr
	bgt	.L55
.L53:
	mov	r0, #0
	ldr	lr, [sp], #4
	bx	lr
.L55:
	ldr	r3, [sp, #4]
	ldr	r1, [sp, #12]
	add	r3, r3, r1
	cmp	r3, r0
	ble	.L53
	ldr	r3, [sp, #4]
	add	r0, r0, r2
	cmp	r0, r3
	movle	r0, #0
	movgt	r0, #1
	ldr	lr, [sp], #4
	bx	lr
	.size	collision, .-collision
	.align	2
	.global	DMANow
	.syntax unified
	.arm
	.type	DMANow, %function
DMANow:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mov	ip, #0
	add	r0, r0, r0, lsl #1
	lsl	r0, r0, #2
	add	r0, r0, #67108864
	orr	r3, r3, #-2147483648
	str	ip, [r0, #184]
	str	r1, [r0, #176]
	str	r2, [r0, #180]
	str	r3, [r0, #184]
	bx	lr
	.size	DMANow, .-DMANow
	.global	videoBuffer
	.data
	.align	2
	.set	.LANCHOR0,. + 0
	.type	videoBuffer, %object
	.size	videoBuffer, 4
videoBuffer:
	.word	100663296
	.ident	"GCC: (devkitARM) 15.2.0"
