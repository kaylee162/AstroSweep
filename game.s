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
	.file	"game.c"
	.text
	.align	2
	.syntax unified
	.arm
	.type	drawRectPlayfield, %function
drawRectPlayfield:
	@ Function supports interworking.
	@ args = 4, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	cmp	r3, #0
	cmpgt	r2, #0
	movle	ip, #1
	movgt	ip, #0
	cmp	r1, #11
	orrle	ip, ip, #1
	orrs	ip, ip, r0, lsr #31
	bxne	lr
	push	{r4, r5, r6, lr}
	add	lr, r2, r0
	cmp	lr, #240
	sub	sp, sp, #8
	bgt	.L1
	add	r4, r3, r1
	cmp	r4, #160
	ldrhle	ip, [sp, #24]
	ldrle	r4, .L8
	strle	ip, [sp]
	movle	lr, pc
	bxle	r4
.L1:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, lr}
	bx	lr
.L9:
	.align	2
.L8:
	.word	drawRectangle
	.size	drawRectPlayfield, .-drawRectPlayfield
	.align	2
	.global	getState
	.syntax unified
	.arm
	.type	getState, %function
getState:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L11
	ldrb	r0, [r3]	@ zero_extendqisi2
	bx	lr
.L12:
	.align	2
.L11:
	.word	.LANCHOR0
	.size	getState, .-getState
	.align	2
	.global	initGame
	.syntax unified
	.arm
	.type	initGame, %function
initGame:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	ldr	r3, .L15
	mov	lr, pc
	bx	r3
	mov	r2, #0
	mov	r1, #25
	ldr	r3, .L15+4
	strb	r2, [r3]
	str	r1, [r3, #4]
	pop	{r4, lr}
	bx	lr
.L16:
	.align	2
.L15:
	.word	sfxInit
	.word	.LANCHOR0
	.size	initGame, .-initGame
	.section	.rodata.str1.4,"aMS",%progbits,1
	.align	2
.LC0:
	.ascii	"ASTRO SWEEP\000"
	.align	2
.LC1:
	.ascii	"Press START to begin\000"
	.align	2
.LC2:
	.ascii	"A: Shoot  B: Dash  L: Bomb\000"
	.align	2
.LC3:
	.ascii	"Shoot MAGENTA asteroid to earn bomb\000"
	.align	2
.LC4:
	.ascii	"YOU WIN!\000"
	.align	2
.LC5:
	.ascii	"Press START for menu\000"
	.align	2
.LC6:
	.ascii	"YOU LOSE!\000"
	.align	2
.LC7:
	.ascii	"PAUSED\000"
	.align	2
.LC8:
	.ascii	"START: Resume  SELECT: Menu\000"
	.text
	.align	2
	.global	drawGame
	.syntax unified
	.arm
	.type	drawGame, %function
drawGame:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r9, r10, lr}
	ldr	r5, .L68
	ldrb	ip, [r5]	@ zero_extendqisi2
	sub	r1, ip, #3
	cmp	ip, #0
	cmpne	r1, #1
	ldr	r6, .L68+4
	movls	r1, #1
	movhi	r1, #0
	ldrb	r3, [r6]	@ zero_extendqisi2
	sub	sp, sp, #32
	bhi	.L18
	cmp	ip, r3
	bne	.L62
.L17:
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r9, r10, lr}
	bx	lr
.L62:
	ldr	r3, .L68+8
	mov	r0, #0
	strb	ip, [r6]
	mov	lr, pc
	bx	r3
	ldrb	r3, [r5]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L63
	cmp	r3, #3
	beq	.L64
	cmp	r3, #4
	bne	.L17
	mov	r3, #31
	mov	r1, #70
	mov	r0, #80
	ldr	r2, .L68+12
	b	.L61
.L18:
	cmp	ip, #2
	beq	.L65
	cmp	ip, r3
	beq	.L25
	mov	r3, #1
	strb	ip, [r6]
	str	r3, [r6, #4]
	str	r3, [r6, #8]
.L26:
	ldr	r3, .L68+8
	mov	r0, #0
	mov	lr, pc
	bx	r3
	mov	r2, #0
	mov	r3, #1
	stmib	r6, {r2, r3}
.L27:
	mov	r8, #0
	ldr	r4, .L68+16
	ldr	r3, .L68+20
	ldr	ip, [r4]
	ldr	lr, .L68+24
	add	r0, r3, #480
.L30:
	ldr	r2, [r3, #8]
	cmp	r2, #239
	bhi	.L28
	ldr	r1, [r3, #12]
	sub	r7, r1, #12
	cmp	r7, #147
	rsbls	r1, r1, r1, lsl #4
	addls	r2, r2, r1, lsl #4
	lslls	r2, r2, #1
	strhls	r8, [ip, r2]	@ movhi
.L28:
	ldr	r2, [r3, #4]
	sub	r1, r2, #12
	cmp	r1, #147
	ldrls	r1, [r3]
	rsbls	r2, r2, r2, lsl #4
	addls	r2, r1, r2, lsl #4
	lslls	r2, r2, #1
	add	r3, r3, #20
	strhls	lr, [ip, r2]	@ movhi
	cmp	r3, r0
	bne	.L30
	mov	ip, #0
	add	r0, r5, #496
	ldm	r0, {r0, r1, r2, r3}
	ldr	r7, .L68+28
	str	ip, [sp]
	mov	lr, pc
	bx	r7
	ldr	r3, [r5, #520]
	cmp	r3, #0
	ble	.L31
	tst	r3, #4
	beq	.L32
.L31:
	ldr	r3, .L68+32
	str	r3, [sp]
	add	r2, r5, #504
	add	r0, r5, #488
	ldm	r2, {r2, r3}
	ldm	r0, {r0, r1}
	mov	lr, pc
	bx	r7
	ldr	r3, [r5, #488]
	ldr	r2, [r5, #492]
	add	r3, r3, #3
	add	r2, r2, #2
	cmp	r2, #159
	cmpls	r3, #239
	bls	.L66
.L32:
	mov	r10, #0
	ldr	r4, .L68+36
	ldr	r9, .L68+40
	add	r8, r4, #576
.L35:
	ldr	r3, [r4, #32]
	cmp	r3, #0
	beq	.L34
	str	r10, [sp]
	add	r0, r4, #8
	ldm	r0, {r0, r1, r2, r3}
	bl	drawRectPlayfield
	str	r9, [sp]
	add	r2, r4, #16
	ldm	r2, {r2, r3}
	ldm	r4, {r0, r1}
	bl	drawRectPlayfield
.L34:
	add	r4, r4, #36
	cmp	r8, r4
	bne	.L35
	ldr	r4, .L68+44
	ldr	r10, .L68+48
	ldr	r9, .L68+52
	add	r8, r4, #480
.L38:
	ldr	r3, [r4, #28]
	cmp	r3, #0
	beq	.L36
	mov	ip, #0
	add	r1, r4, #12
	ldm	r1, {r1, r3}
	ldr	r0, [r4, #8]
	mov	r2, r3
	str	ip, [sp]
	bl	drawRectPlayfield
	ldr	r3, [r4, #36]
	cmp	r3, #0
	movne	r3, r10
	bne	.L37
	ldr	r2, [r4, #32]
	cmp	r2, #2
	ldr	r3, .L68+24
	moveq	r3, r9
.L37:
	str	r3, [sp]
	ldr	r3, [r4, #16]
	ldm	r4, {r0, r1}
	mov	r2, r3
	bl	drawRectPlayfield
.L36:
	add	r4, r4, #40
	cmp	r8, r4
	bne	.L38
	ldr	r8, [r5, #516]
	ldr	r4, [r5, #1588]
	cmp	r8, #9
	ldr	r5, [r5, #528]
	movge	r8, #9
	cmp	r4, #99
	movge	r4, #99
	cmp	r5, #1
	movge	r5, #1
	ldr	r3, [r6, #8]
	cmp	r3, #0
	bic	r8, r8, r8, asr #31
	bic	r4, r4, r4, asr #31
	bic	r5, r5, r5, asr #31
	bne	.L39
	ldr	r3, [r6, #12]
	cmp	r8, r3
	beq	.L67
.L39:
	mov	r9, #0
	str	r8, [r6, #12]
	str	r4, [r6, #16]
	str	r5, [r6, #20]
	mov	r1, r9
	mov	r0, r9
	str	r9, [r6, #8]
	mov	r3, #12
	mov	r2, #150
	str	r9, [sp]
	mov	lr, pc
	bx	r7
	mov	r1, #2
	mov	r3, #32
	mov	ip, #58
	ldr	r2, .L68+56
	ldr	r0, .L68+60
	strh	r2, [sp, #8]	@ movhi
	ldr	r2, .L68+64
	strh	r0, [sp, #12]	@ movhi
	umull	r0, r2, r4, r2
	lsr	r2, r2, #3
	add	r0, r2, r2, lsl r1
	sub	r4, r4, r0, lsl #1
	ldr	lr, .L68+68
	add	r2, r2, #48
	add	r4, r4, #48
	strb	r3, [sp, #11]
	strb	r2, [sp, #14]
	strb	r4, [sp, #15]
	mov	r0, r1
	ldr	r3, .L68+72
	ldr	r4, .L68+76
	add	r8, r8, #48
	add	r5, r5, #48
	add	r2, sp, #8
	strb	r9, [sp, #20]
	strb	r5, [sp, #19]
	strb	r8, [sp, #10]
	strh	lr, [sp, #16]	@ movhi
	strb	ip, [sp, #18]
	mov	lr, pc
	bx	r4
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r9, r10, lr}
	bx	lr
.L25:
	ldr	r3, [r6, #4]
	cmp	r3, #0
	beq	.L27
	b	.L26
.L63:
	ldr	r4, .L68+76
	mov	r1, #70
	mov	r0, #60
	ldr	r3, .L68+32
	ldr	r2, .L68+80
	mov	lr, pc
	bx	r4
	mov	r1, #92
	mov	r0, #28
	ldr	r3, .L68+72
	ldr	r2, .L68+84
	mov	lr, pc
	bx	r4
	mov	r1, #110
	mov	r0, #22
	ldr	r3, .L68+24
	ldr	r2, .L68+88
	mov	lr, pc
	bx	r4
	mov	r1, #122
	mov	r0, #14
	ldr	r3, .L68+24
	ldr	r2, .L68+92
	mov	lr, pc
	bx	r4
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r9, r10, lr}
	bx	lr
.L65:
	cmp	r3, #2
	beq	.L17
	str	r1, [sp]
	mov	r0, r1
	strb	ip, [r6]
	mov	r3, #160
	mov	r2, #240
	ldr	r4, .L68+28
	mov	lr, pc
	bx	r4
	mov	r1, #70
	mov	r0, #96
	ldr	r3, .L68+40
	ldr	r2, .L68+96
	ldr	r4, .L68+76
	mov	lr, pc
	bx	r4
	mov	r1, #92
	mov	r0, #26
	ldr	r3, .L68+72
	ldr	r2, .L68+100
	mov	lr, pc
	bx	r4
	b	.L17
.L67:
	ldr	r3, [r6, #16]
	cmp	r4, r3
	bne	.L39
	ldr	r3, [r6, #20]
	cmp	r5, r3
	bne	.L39
	b	.L17
.L64:
	mov	r3, #992
	mov	r1, #70
	mov	r0, #80
	ldr	r2, .L68+104
.L61:
	ldr	r4, .L68+76
	mov	lr, pc
	bx	r4
	mov	r1, #92
	mov	r0, #34
	ldr	r3, .L68+72
	ldr	r2, .L68+108
	mov	lr, pc
	bx	r4
	b	.L17
.L66:
	mvn	r1, #32768
	rsb	r2, r2, r2, lsl #4
	add	r3, r3, r2, lsl #4
	ldr	r2, [r4]
	lsl	r3, r3, #1
	strh	r1, [r2, r3]	@ movhi
	b	.L32
.L69:
	.align	2
.L68:
	.word	.LANCHOR0
	.word	.LANCHOR1
	.word	fillScreen
	.word	.LC6
	.word	videoBuffer
	.word	.LANCHOR0+8
	.word	15855
	.word	drawRectangle
	.word	32736
	.word	.LANCHOR0+532
	.word	1023
	.word	.LANCHOR0+1108
	.word	31775
	.word	5460
	.word	14924
	.word	14928
	.word	-858993459
	.word	16928
	.word	32767
	.word	drawString
	.word	.LC0
	.word	.LC1
	.word	.LC2
	.word	.LC3
	.word	.LC7
	.word	.LC8
	.word	.LC4
	.word	.LC5
	.size	drawGame, .-drawGame
	.align	2
	.global	goToStart
	.syntax unified
	.arm
	.type	goToStart, %function
goToStart:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mov	r2, #0
	ldr	r3, .L71
	strb	r2, [r3]
	bx	lr
.L72:
	.align	2
.L71:
	.word	.LANCHOR0
	.size	goToStart, .-goToStart
	.align	2
	.global	goToGame
	.syntax unified
	.arm
	.type	goToGame, %function
goToGame:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}
	ldr	r4, .L87
	ldrb	r3, [r4]	@ zero_extendqisi2
	sub	r2, r3, #3
	cmp	r3, #0
	cmpne	r2, #1
	bhi	.L74
	mov	r3, #0
	mov	r2, #45
	mov	ip, r3
	mov	r0, r3
	ldr	r5, .L87+4
	ldr	lr, .L87+8
	str	r3, [r4, #1588]
	str	r3, [r4, #1592]
	str	r2, [r4, #1596]
	str	r3, [r4, #1600]
	str	r3, [r4, #1604]
	add	r1, r4, #8
.L75:
	rsb	r6, r0, r0, lsl #3
	lsr	r2, r6, #2
	umull	r3, r2, lr, r2
	umull	r7, r3, r5, ip
	and	r7, r0, #1
	add	r7, r7, #1
	lsr	r2, r2, #2
	str	r7, [r1, #16]
	add	r7, r2, r2, lsl #3
	lsr	r3, r3, #7
	add	r2, r2, r7, lsl #2
	add	r0, r0, #1
	rsb	r3, r3, r3, lsl #4
	sub	r2, r6, r2, lsl #2
	add	r1, r1, #20
	sub	r3, ip, r3, lsl #4
	add	r2, r2, #12
	cmp	r0, #24
	str	r3, [r1, #-20]
	str	r2, [r1, #-16]
	str	r3, [r1, #-12]
	str	r2, [r1, #-8]
	add	ip, ip, #13
	bne	.L75
	mov	ip, #8
	mov	r3, #116
	mov	r2, #0
	mov	r1, #2
	mov	lr, #3
	mov	r0, #140
	str	ip, [r4, #504]
	str	ip, [r4, #508]
	mvn	ip, #3
	str	r3, [r4, #488]
	str	r3, [r4, #496]
	ldr	r3, .L87+12
	str	lr, [r4, #516]
	str	r1, [r4, #512]
	str	r2, [r4, #520]
	str	r2, [r4, #524]
	str	r2, [r4, #528]
	str	r0, [r4, #492]
	str	r0, [r4, #500]
	add	r0, r3, #576
.L76:
	str	r2, [r3, #32]
	str	r1, [r3, #16]
	str	r1, [r3, #20]
	str	r2, [r3, #4]
	str	r2, [r3]
	str	r2, [r3, #12]
	str	r2, [r3, #8]
	str	r2, [r3, #24]
	str	ip, [r3, #28]
	add	r3, r3, #36
	cmp	r3, r0
	bne	.L76
	mov	r2, #0
	mov	ip, #8
	mov	r1, #1
	ldr	r3, .L87+16
	add	r0, r3, #480
.L77:
	str	r2, [r3, #28]
	str	ip, [r3, #16]
	str	r2, [r3, #4]
	str	r2, [r3]
	str	r2, [r3, #12]
	str	r2, [r3, #8]
	str	r2, [r3, #20]
	str	r1, [r3, #24]
	str	r1, [r3, #32]
	str	r2, [r3, #36]
	add	r3, r3, #40
	cmp	r3, r0
	bne	.L77
.L79:
	mov	r2, #1
	ldr	r3, .L87+20
	str	r2, [r3, #4]
	str	r2, [r3, #8]
	mov	r3, #1
	strb	r3, [r4]
	pop	{r4, r5, r6, r7, lr}
	bx	lr
.L74:
	cmp	r3, #2
	beq	.L79
	mov	r3, #1
	strb	r3, [r4]
	pop	{r4, r5, r6, r7, lr}
	bx	lr
.L88:
	.align	2
.L87:
	.word	.LANCHOR0
	.word	-2004318071
	.word	464320789
	.word	.LANCHOR0+532
	.word	.LANCHOR0+1108
	.word	.LANCHOR1
	.size	goToGame, .-goToGame
	.align	2
	.global	updateGame
	.syntax unified
	.arm
	.type	updateGame, %function
updateGame:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r9, r10, lr}
	ldr	r7, .L267
	ldr	r2, .L267+4
	ldrb	r3, [r7]	@ zero_extendqisi2
	sub	sp, sp, #24
	cmp	r3, #4
	bhi	.L89
	ldrb	r3, [r2, r3]
	add	pc, pc, r3, lsl #2
.Lrtx92:
	nop
	.section	.rodata
.L92:
	.byte	(.L95-.Lrtx92-4)/4
	.byte	(.L94-.Lrtx92-4)/4
	.byte	(.L93-.Lrtx92-4)/4
	.byte	(.L91-.Lrtx92-4)/4
	.byte	(.L91-.Lrtx92-4)/4
	.text
	.p2align 2
.L95:
	ldr	r3, .L267+8
	ldrh	r3, [r3]
	tst	r3, #8
	bne	.L250
.L89:
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r9, r10, lr}
	bx	lr
.L91:
	ldr	r3, .L267+8
	ldrh	r3, [r3]
	tst	r3, #8
	beq	.L89
	ldr	r3, .L267+12
	ldrh	r3, [r3]
	tst	r3, #8
	bne	.L89
.L165:
	mov	r3, #0
	strb	r3, [r7]
	b	.L89
.L93:
	ldr	r3, .L267+8
	ldrh	r3, [r3]
	tst	r3, #8
	bne	.L251
.L163:
	tst	r3, #4
	beq	.L89
	ldr	r3, .L267+12
	ldrh	r3, [r3]
	tst	r3, #4
	bne	.L89
	b	.L165
.L94:
	ldr	r4, .L267+12
	ldrh	r0, [r4]
	ands	r6, r0, #4
	bne	.L98
	mvn	r0, r0
	ldr	r5, .L267+16
	ldrh	r3, [r5, #8]
	and	r0, r0, #123
	bic	r3, r0, r3
	ands	r4, r3, #8
	strh	r0, [r5, #8]	@ movhi
	bne	.L252
	ands	r6, r3, #32
	bne	.L253
	ands	r2, r3, #2
	beq	.L101
	sub	r4, r5, #492
	sub	r5, r5, #12
	b	.L103
.L102:
	add	r4, r4, #40
	cmp	r4, r5
	beq	.L89
.L103:
	ldr	r3, [r4, #28]
	cmp	r3, #0
	beq	.L102
	str	r6, [sp]
	ldr	r3, [r4, #16]
	add	r0, r4, #8
	mov	r2, r3
	ldm	r0, {r0, r1}
	bl	drawRectPlayfield
	str	r6, [sp]
	ldr	r3, [r4, #16]
	ldm	r4, {r0, r1}
	mov	r2, r3
	bl	drawRectPlayfield
	str	r6, [r4, #28]
	b	.L102
.L251:
	ldr	r2, .L267+12
	ldrh	r2, [r2]
	tst	r2, #8
	bne	.L163
.L164:
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r9, r10, lr}
	b	goToGame
.L98:
	mov	r2, #0
	ldr	r5, .L267+8
	ldrh	r9, [r5]
	ldr	r3, .L267+16
	tst	r9, #8
	strh	r2, [r3, #8]	@ movhi
	beq	.L106
	tst	r0, #8
	beq	.L254
.L106:
	mov	r6, #12
	ldr	r3, [r7, #1592]
	add	r3, r3, #1
	str	r3, [r7, #1592]
	ldr	r3, .L267+20
	ldr	lr, .L267+24
	add	ip, r3, #480
.L109:
	ldr	r1, [r3, #4]
	ldr	r2, [r3, #16]
	ldr	r8, [r3]
	add	r2, r1, r2
	cmp	r2, #159
	addgt	r2, r8, #53
	str	r1, [r3, #12]
	str	r8, [r3, #8]
	smullgt	r1, r8, lr, r2
	asrgt	r1, r2, #31
	addgt	r8, r8, r2
	rsbgt	r1, r1, r8, asr #7
	rsbgt	r1, r1, r1, lsl #4
	subgt	r2, r2, r1, lsl #4
	strle	r2, [r3, #4]
	strgt	r6, [r3, #4]
	strgt	r2, [r3]
	add	r3, r3, #20
	cmp	r3, ip
	bne	.L109
	ldr	r1, [r7, #520]
	cmp	r1, #0
	subgt	r1, r1, #1
	strgt	r1, [r7, #520]
	ldr	r1, [r7, #524]
	cmp	r1, #0
	subgt	r1, r1, #1
	ldr	r2, [r7, #488]
	strgt	r1, [r7, #524]
	ldr	r1, [r7, #512]
	tst	r0, #32
	ldr	r3, [r7, #492]
	str	r2, [r7, #496]
	subeq	r2, r2, r1
	tst	r0, #16
	addeq	r2, r2, r1
	tst	r0, #64
	str	r3, [r7, #500]
	subeq	r3, r3, r1
	tst	r0, #128
	addeq	r3, r3, r1
	cmp	r2, #0
	movlt	ip, #0
	ldr	r1, [r7, #504]
	blt	.L116
	rsb	ip, r1, #240
	cmp	ip, r2
	movge	ip, r2
.L116:
	cmp	r3, #11
	movle	r2, #12
	str	ip, [r7, #488]
	ble	.L117
	ldr	r2, [r7, #508]
	rsb	r2, r2, #160
	cmp	r2, r3
	movge	r2, r3
.L117:
	tst	r9, #1
	ldr	r8, .L267+28
	str	r2, [r7, #492]
	beq	.L118
	ands	r0, r0, #1
	bne	.L118
	mov	r3, r8
.L120:
	ldr	lr, [r3, #32]
	cmp	lr, #0
	add	r3, r3, #36
	beq	.L255
	add	r0, r0, #1
	cmp	r0, #16
	bne	.L120
.L118:
	tst	r9, #2
	beq	.L121
	ldrh	r3, [r4]
	tst	r3, #2
	bne	.L121
	ldr	ip, [r7, #524]
	cmp	ip, #0
	bne	.L121
	and	r2, r3, #32
	cmp	r2, #0
	and	r0, r3, #16
	moveq	r2, #0
	mvneq	r1, #0
	mvnne	r2, #0
	movne	r1, #0
	cmp	r0, #0
	mov	r0, #30
	str	r0, [r7, #524]
	and	r0, r3, #128
	moveq	r2, #0
	moveq	r1, #1
	cmp	r0, #0
	moveq	r1, #0
	moveq	r2, #1
	tst	r3, #64
	moveq	r2, ip
	addne	r1, r1, r1, lsl #3
	ldr	r0, [r7, #488]
	addne	r3, r2, r2, lsl #3
	lslne	r2, r1, #1
	mvneq	r3, #17
	lslne	r3, r3, #1
	adds	r2, r2, r0
	bmi	.L126
	ldr	r1, [r7, #504]
	rsb	r1, r1, #240
	cmp	r1, r2
	movlt	ip, r1
	movge	ip, r2
.L126:
	ldr	r2, [r7, #492]
	add	r3, r3, r2
	cmp	r3, #11
	movle	r3, #12
	str	ip, [r7, #488]
	ble	.L127
	ldr	r2, [r7, #508]
	rsb	r2, r2, #160
	cmp	r2, r3
	movlt	r3, r2
.L127:
	str	r3, [r7, #492]
.L121:
	tst	r9, #512
	beq	.L249
	ldrh	r3, [r4]
	ands	r3, r3, #512
	bne	.L249
	ldr	r2, [r7, #528]
	cmp	r2, #0
	ble	.L249
	ldr	r5, .L267+32
	sub	r2, r2, #1
	mov	r6, r3
	mov	r9, r3
	str	r2, [r7, #528]
	add	r4, r5, #4
	add	r10, r5, #484
	b	.L130
.L129:
	add	r4, r4, #40
	cmp	r10, r4
	beq	.L256
.L130:
	ldr	r3, [r4, #28]
	cmp	r3, #0
	beq	.L129
	str	r9, [sp]
	ldr	r3, [r4, #16]
	add	r0, r4, #8
	mov	r2, r3
	ldm	r0, {r0, r1}
	bl	drawRectPlayfield
	str	r9, [sp]
	ldr	r3, [r4, #16]
	ldm	r4, {r0, r1}
	mov	r2, r3
	bl	drawRectPlayfield
	add	r6, r6, #1
	str	r9, [r4, #28]
	b	.L129
.L250:
	ldr	r3, .L267+12
	ldrh	r3, [r3]
	tst	r3, #8
	bne	.L89
	b	.L164
.L249:
	ldr	r5, .L267+32
.L128:
	ldr	r6, .L267+28
	mov	r9, #0
	mov	r4, r6
	add	r8, r8, #576
	b	.L135
.L133:
	add	r4, r4, #36
	cmp	r8, r4
	beq	.L257
.L135:
	ldr	r3, [r4, #32]
	cmp	r3, #0
	beq	.L133
	ldr	r1, [r4, #4]
	ldr	r3, [r4, #28]
	ldr	r0, [r4]
	add	r3, r1, r3
	cmp	r3, #11
	str	r0, [r4, #8]
	str	r1, [r4, #12]
	str	r3, [r4, #4]
	bgt	.L133
	str	r9, [sp]
	str	r9, [r4, #32]
	ldr	r3, [r4, #20]
	ldr	r2, [r4, #16]
	bl	drawRectPlayfield
	b	.L133
.L257:
	ldr	r3, [r7, #1596]
	sub	r3, r3, #1
	cmp	r3, #0
	str	r3, [r7, #1596]
	ble	.L258
.L136:
	add	r10, r5, #4
	mov	r4, r10
	mov	r9, #0
	add	r5, r5, #484
	b	.L149
.L261:
	ldr	r3, [r4, #16]
	rsb	r3, r3, #240
	cmp	ip, r3
	rsbge	lr, lr, #0
	strge	lr, [r4, #20]
	blt	.L145
.L146:
	cmp	r3, ip
	movge	r3, ip
.L147:
	str	r3, [r4]
.L145:
	cmp	r1, #159
	movle	r3, #1
	movgt	r3, #0
	cmp	r2, #159
	movle	r3, #0
	cmp	r3, #0
	bne	.L259
.L143:
	add	r4, r4, #40
	cmp	r4, r5
	beq	.L260
.L149:
	ldr	r3, [r4, #28]
	cmp	r3, #0
	beq	.L143
	ldr	r0, [r4]
	ldr	lr, [r4, #20]
	ldr	r1, [r4, #4]
	ldr	r2, [r4, #24]
	add	ip, r0, lr
	add	r2, r1, r2
	cmp	ip, #0
	str	r0, [r4, #8]
	str	r1, [r4, #12]
	str	r2, [r4, #4]
	str	ip, [r4]
	bgt	.L261
	rsb	lr, lr, #0
	movne	r3, #0
	str	lr, [r4, #20]
	bne	.L147
	ldr	r3, [r4, #16]
	rsb	r3, r3, #240
	b	.L146
.L259:
	str	r9, [sp]
	ldr	r3, [r4, #16]
	mov	r2, r3
	bl	drawRectPlayfield
	str	r9, [r4, #28]
	b	.L143
.L260:
	ldr	r9, .L267+36
	b	.L156
.L151:
	add	r6, r6, #36
	cmp	r8, r6
	beq	.L262
.L156:
	ldr	r3, [r6, #32]
	cmp	r3, #0
	beq	.L151
	mov	r4, r10
	mov	r5, #0
	b	.L150
.L152:
	add	r5, r5, #1
	cmp	r5, #12
	add	r4, r4, #40
	beq	.L151
.L150:
	ldr	r3, [r4, #28]
	cmp	r3, #0
	beq	.L152
	ldr	r3, [r4, #16]
	ldr	r1, [r4, #4]
	ldr	r2, [r4]
	stmib	sp, {r1, r3}
	str	r2, [sp]
	str	r3, [sp, #12]
	add	r2, r6, #16
	ldm	r2, {r2, r3}
	ldm	r6, {r0, r1}
	mov	lr, pc
	bx	r9
	cmp	r0, #0
	beq	.L152
	mov	r3, #0
	str	r3, [sp]
	str	r3, [r6, #32]
	add	r0, r6, #8
	add	r5, r5, r5, lsl #2
	ldm	r0, {r0, r1, r2, r3}
	add	r5, r7, r5, lsl #3
	bl	drawRectPlayfield
	ldr	r3, [r5, #1140]
	sub	r3, r3, #1
	cmp	r3, #0
	str	r3, [r5, #1140]
	bgt	.L151
	mov	r4, #0
	add	r1, r5, #1120
	ldm	r1, {r1, r3}
	ldr	r0, [r5, #1116]
	mov	r2, r3
	str	r4, [sp]
	bl	drawRectPlayfield
	ldr	r3, [r5, #1124]
	ldr	r1, [r5, #1112]
	mov	r2, r3
	ldr	r0, [r5, #1108]
	str	r4, [sp]
	bl	drawRectPlayfield
	ldr	r3, [r5, #1144]
	cmp	r3, r4
	str	r4, [r5, #1136]
	beq	.L154
	mov	r3, #1
	mov	r0, #3
	str	r3, [r7, #528]
	ldr	r3, .L267+40
	mov	lr, pc
	bx	r3
.L155:
	mov	r2, #1
	ldr	r3, .L267+44
	str	r2, [r3, #8]
	b	.L151
.L262:
	ldr	r4, [r7, #520]
	cmp	r4, #0
	bne	.L158
	ldr	r5, .L267+36
.L157:
	ldr	r3, [r10, #28]
	cmp	r3, #0
	beq	.L159
	ldr	r3, [r10, #16]
	ldr	r2, [r10, #4]
	stmib	sp, {r2, r3}
	str	r3, [sp, #12]
	ldr	r2, [r10]
	ldr	r3, [r7, #508]
	str	r2, [sp]
	add	r0, r7, #488
	ldr	r2, [r7, #504]
	ldm	r0, {r0, r1}
	mov	lr, pc
	bx	r5
	cmp	r0, #0
	bne	.L263
.L159:
	add	r4, r4, #1
	cmp	r4, #12
	add	r10, r10, #40
	bne	.L157
.L158:
	ldr	r2, [r7, #1588]
	ldr	r3, [r7, #4]
	cmp	r2, r3
	bge	.L264
.L161:
	ldr	r3, [r7, #516]
	cmp	r3, #0
	ble	.L265
.L162:
	ldr	r3, [r7, #1604]
	cmp	r3, #0
	subgt	r3, r3, #1
	strgt	r3, [r7, #1604]
	b	.L89
.L254:
	mov	r1, #2
	mov	r2, #1
	ldr	r3, .L267+44
	strb	r1, [r7]
	str	r2, [r3, #8]
	b	.L89
.L253:
	mov	r2, #4
	ldr	r3, .L267+48
	strb	r2, [r7]
	mov	lr, pc
	bx	r3
	strh	r4, [r5, #8]	@ movhi
	b	.L89
.L264:
	mov	r2, #3
	ldr	r3, .L267+52
	strb	r2, [r7]
	mov	lr, pc
	bx	r3
	b	.L161
.L265:
	mov	r2, #4
	ldr	r3, .L267+48
	strb	r2, [r7]
	mov	lr, pc
	bx	r3
	b	.L162
.L258:
	mov	r4, #0
	add	r3, r5, #4
.L141:
	ldr	r2, [r3, #28]
	cmp	r2, #0
	add	r3, r3, #40
	beq	.L266
	add	r4, r4, #1
	cmp	r4, #12
	bne	.L141
	ldr	r10, [r7, #1592]
	asr	r9, r10, #31
.L140:
	ldr	r3, .L267+24
	smull	r2, r3, r10, r3
	add	r3, r3, r10
	sub	r3, r9, r3, asr #7
	add	r3, r3, #60
	cmp	r3, #60
	movge	r3, #60
	cmp	r3, #18
	movlt	r3, #18
	str	r3, [r7, #1596]
	b	.L136
.L252:
	mov	r2, #3
	ldr	r3, .L267+52
	strb	r2, [r7]
	mov	lr, pc
	bx	r3
	strh	r6, [r5, #8]	@ movhi
	b	.L89
.L101:
	ands	r1, r3, #1
	beq	.L104
	mov	r0, #3
	mov	r1, #1
	ldr	r3, .L267+44
	str	r2, [r7, #1588]
	str	r2, [r7, #520]
	str	r2, [r7, #528]
	str	r0, [r7, #516]
	str	r1, [r3, #8]
	b	.L89
.L154:
	ldr	r3, [r7, #1588]
	add	r3, r3, #1
	str	r3, [r7, #1588]
	ldr	r3, .L267+56
	mov	lr, pc
	bx	r3
	b	.L155
.L104:
	tst	r3, #64
	beq	.L105
	mov	r0, #3
	mov	r2, #1
	ldr	r3, .L267+44
	str	r1, [r7, #520]
	str	r0, [r7, #516]
	str	r2, [r3, #8]
	b	.L89
.L263:
	mov	ip, #1
	mov	r5, #0
	mov	r0, #45
	ldr	r2, [r7, #516]
	add	r4, r4, r4, lsl #2
	add	r4, r7, r4, lsl #3
	sub	r2, r2, #1
	ldr	r3, [r4, #1124]
	str	r2, [r7, #516]
	ldr	r2, .L267+44
	ldr	r1, [r4, #1120]
	str	r0, [r7, #520]
	ldr	r0, [r4, #1116]
	str	r5, [sp]
	str	ip, [r2, #8]
	mov	r2, r3
	bl	drawRectPlayfield
	ldr	r3, [r4, #1124]
	ldr	r1, [r4, #1112]
	mov	r2, r3
	ldr	r0, [r4, #1108]
	str	r5, [sp]
	bl	drawRectPlayfield
	ldr	r3, .L267+56
	str	r5, [r4, #1136]
	mov	lr, pc
	bx	r3
	b	.L158
.L256:
	cmp	r6, #3
	movlt	r1, #1
	movge	r1, #2
	mov	r2, #1
	mov	r0, #10
	ldr	r3, [r7, #1588]
	add	r3, r3, r1
	str	r3, [r7, #1588]
	ldr	r3, .L267+44
	str	r2, [r3, #8]
	ldr	r3, .L267+60
	str	r0, [r7, #1604]
	mov	lr, pc
	bx	r3
	b	.L128
.L266:
	mov	r0, #1
	ldr	r2, [r7, #1600]
	ldr	r1, .L267+24
	add	r2, r2, #1
	smull	r3, r1, r2, r1
	asr	r3, r2, #31
	add	r1, r1, r2
	rsb	r3, r3, r1, asr #3
	rsb	r3, r3, r3, lsl #4
	sub	r3, r2, r3
	cmp	r3, #0
	str	r2, [r7, #1600]
	moveq	r2, r0
	movne	r2, #0
	ldr	r10, [r7, #1592]
	add	r3, r4, r4, lsl #2
	add	r3, r7, r3, lsl #3
	str	r2, [r3, #1144]
	str	r0, [r3, #1136]
	lsl	r1, r4, #2
	moveq	r3, #8
	asreq	r9, r10, #31
	beq	.L138
	ldr	r3, .L267+64
	smull	r2, r3, r10, r3
	ldr	r0, .L267+68
	add	r3, r3, r10
	asr	r9, r10, #31
	rsb	r3, r9, r3, asr #7
	smull	r2, r0, r3, r0
	asr	r2, r3, #31
	add	r0, r0, r3
	rsb	r2, r2, r0, asr #2
	rsb	r2, r2, r2, lsl #3
	sub	r3, r3, r2
	add	r3, r3, #6
	cmp	r3, #10
	movlt	r0, #1
	movge	r0, #2
.L138:
	add	r2, r1, r4
	add	r2, r7, r2, lsl #3
	rsb	r1, r4, r4, lsl #3
	str	r0, [r2, #1140]
	add	r1, r4, r1, lsl #2
	add	r0, r10, r10, lsl #1
	str	r3, [r2, #1124]
	str	r2, [sp, #20]
	str	r3, [sp, #16]
	add	r0, r1, r0
	rsb	r1, r3, #240
	ldr	r3, .L267+72
	mov	lr, pc
	bx	r3
	ldr	r0, .L267+76
	smull	lr, r0, r10, r0
	ldr	r2, [sp, #20]
	str	r1, [r2, #1108]
	str	r1, [r2, #1116]
	rsb	r1, r9, r0, asr #6
	add	r1, r1, #1
	cmp	r1, #3
	movge	r1, #3
	cmp	r1, #1
	movlt	r1, #1
	ldr	ip, .L267+80
	umull	lr, ip, r4, ip
	ldr	r3, [sp, #16]
	rsb	r3, r3, #12
	str	r3, [r2, #1112]
	str	r3, [r2, #1120]
	bic	r3, ip, #1
	add	r3, r3, ip, lsr #1
	sub	r3, r4, r3
	sub	r3, r3, #1
	str	r3, [r2, #1128]
	str	r1, [r2, #1132]
	b	.L140
.L105:
	cmp	r3, #0
	movne	r3, #1
	ldrne	r2, .L267+44
	strne	r3, [r7, #528]
	strne	r3, [r2, #8]
	b	.L89
.L255:
	add	r0, r0, r0, lsl #3
	add	r3, r7, r0, lsl #2
	str	r2, [r3, #536]
	str	r2, [r3, #544]
	mov	r2, #1
	add	r1, r1, r1, lsr #31
	add	ip, ip, r1, asr #1
	str	ip, [r3, #532]
	str	ip, [r3, #540]
	str	r2, [r3, #564]
	ldr	r3, .L267+84
	mov	lr, pc
	bx	r3
	ldrh	r9, [r5]
	b	.L118
.L268:
	.align	2
.L267:
	.word	.LANCHOR0
	.word	.L92
	.word	oldButtons
	.word	buttons
	.word	.LANCHOR0+1600
	.word	.LANCHOR0+8
	.word	-2004318071
	.word	.LANCHOR0+532
	.word	.LANCHOR0+1104
	.word	collision
	.word	playSfxPreset
	.word	.LANCHOR1
	.word	sfxLose
	.word	sfxWin
	.word	sfxHit
	.word	sfxBomb
	.word	-1240768329
	.word	-1840700269
	.word	__aeabi_idivmod
	.word	458129845
	.word	-1431655765
	.word	sfxShoot
	.size	updateGame, .-updateGame
	.align	2
	.global	goToPause
	.syntax unified
	.arm
	.type	goToPause, %function
goToPause:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mov	r0, #2
	mov	r2, #1
	ldr	r1, .L270
	ldr	r3, .L270+4
	strb	r0, [r1]
	str	r2, [r3, #8]
	bx	lr
.L271:
	.align	2
.L270:
	.word	.LANCHOR0
	.word	.LANCHOR1
	.size	goToPause, .-goToPause
	.align	2
	.global	goToWin
	.syntax unified
	.arm
	.type	goToWin, %function
goToWin:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	mov	r1, #3
	push	{r4, lr}
	ldr	r2, .L274
	ldr	r3, .L274+4
	strb	r1, [r2]
	mov	lr, pc
	bx	r3
	pop	{r4, lr}
	bx	lr
.L275:
	.align	2
.L274:
	.word	.LANCHOR0
	.word	sfxWin
	.size	goToWin, .-goToWin
	.align	2
	.global	goToLose
	.syntax unified
	.arm
	.type	goToLose, %function
goToLose:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	mov	r1, #4
	push	{r4, lr}
	ldr	r2, .L278
	ldr	r3, .L278+4
	strb	r1, [r2]
	mov	lr, pc
	bx	r3
	pop	{r4, lr}
	bx	lr
.L279:
	.align	2
.L278:
	.word	.LANCHOR0
	.word	sfxLose
	.size	goToLose, .-goToLose
	.data
	.align	2
	.set	.LANCHOR1,. + 0
	.type	lastRenderedState, %object
	.size	lastRenderedState, 1
lastRenderedState:
	.byte	-1
	.space	3
	.type	fullRedrawRequested, %object
	.size	fullRedrawRequested, 4
fullRedrawRequested:
	.word	1
	.type	hudDirty, %object
	.size	hudDirty, 4
hudDirty:
	.word	1
	.type	lastLives.2, %object
	.size	lastLives.2, 4
lastLives.2:
	.word	-1
	.type	lastScore.1, %object
	.size	lastScore.1, 4
lastScore.1:
	.word	-1
	.type	lastBombs.0, %object
	.size	lastBombs.0, 4
lastBombs.0:
	.word	-1
	.bss
	.align	2
	.set	.LANCHOR0,. + 0
	.type	state, %object
	.size	state, 1
state:
	.space	1
	.space	3
	.type	targetScore, %object
	.size	targetScore, 4
targetScore:
	.space	4
	.type	stars, %object
	.size	stars, 480
stars:
	.space	480
	.type	player, %object
	.size	player, 44
player:
	.space	44
	.type	bullets, %object
	.size	bullets, 576
bullets:
	.space	576
	.type	asteroids, %object
	.size	asteroids, 480
asteroids:
	.space	480
	.type	score, %object
	.size	score, 4
score:
	.space	4
	.type	frameCount, %object
	.size	frameCount, 4
frameCount:
	.space	4
	.type	spawnTimer, %object
	.size	spawnTimer, 4
spawnTimer:
	.space	4
	.type	asteroidSpawnCount, %object
	.size	asteroidSpawnCount, 4
asteroidSpawnCount:
	.space	4
	.type	screenShakeTimer, %object
	.size	screenShakeTimer, 4
screenShakeTimer:
	.space	4
	.type	cheatLatch, %object
	.size	cheatLatch, 2
cheatLatch:
	.space	2
	.global	__aeabi_idivmod
	.ident	"GCC: (devkitARM) 15.2.0"
