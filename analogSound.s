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
	.file	"analogSound.c"
	.text
	.align	2
	.global	initSound
	.syntax unified
	.arm
	.type	initSound, %function
initSound:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mov	r3, #67108864
	mov	r0, #128
	mvn	r1, #170
	mov	r2, #2
	strh	r0, [r3, #132]	@ movhi
	strh	r1, [r3, #128]	@ movhi
	strh	r2, [r3, #130]	@ movhi
	bx	lr
	.size	initSound, .-initSound
	.align	2
	.global	playNoteWithDuration
	.syntax unified
	.arm
	.type	playNoteWithDuration, %function
playNoteWithDuration:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldrh	r3, [r0]
	cmp	r3, #0
	beq	.L4
	ldrb	r2, [r0, #2]	@ zero_extendqisi2
	ldr	r3, .L6
	lsl	r2, r2, #8
	smull	ip, r2, r3, r2
	lsl	r1, r1, #6
	asr	r3, r2, #6
	and	r1, r1, #255
	rsb	r3, r3, #64
	orr	r3, r3, r1
	mvn	r3, r3, lsl #20
	mvn	r3, r3, lsr #20
	mov	ip, #67108864
	lsl	r3, r3, #16
	lsr	r3, r3, #16
	strh	r3, [ip, #104]	@ movhi
	ldrh	r3, [r0]
	orr	r3, r3, #49152
	strh	r3, [ip, #108]	@ movhi
	bx	lr
.L4:
	mov	r2, #67108864
	strh	r3, [r2, #104]	@ movhi
	strh	r3, [r2, #108]	@ movhi
	bx	lr
.L7:
	.align	2
.L6:
	.word	274877907
	.size	playNoteWithDuration, .-playNoteWithDuration
	.align	2
	.global	playChannel1
	.syntax unified
	.arm
	.type	playChannel1, %function
playChannel1:
	@ Function supports interworking.
	@ args = 16, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	mov	r5, r2
	mov	r6, r0
	ldrb	r0, [sp, #24]	@ zero_extendqisi2
	ldr	r2, .L12
	cmp	r0, #0
	ldr	ip, .L12+4
	lsl	r0, r3, #4
	movne	ip, r2
	ldrb	r4, [sp, #16]	@ zero_extendqisi2
	and	r0, r0, #112
	and	r3, r5, #7
	orr	r3, r3, r0
	mov	r2, #67108864
	cmp	r4, #0
	moveq	r0, r3
	orrne	r0, r3, #1
	ldrb	lr, [sp, #28]	@ zero_extendqisi2
	ldrb	r3, [sp, #20]	@ zero_extendqisi2
	lsl	lr, lr, #6
	and	lr, lr, #255
	and	r1, r1, #63
	lsl	r3, r3, #8
	orr	r1, r1, lr
	and	r3, r3, #1792
	orr	r1, r1, r3
	orr	ip, ip, r1
	lsl	ip, ip, #16
	orr	lr, r6, #49152
	lsr	ip, ip, #16
	strh	r0, [r2, #96]	@ movhi
	strh	ip, [r2, #98]	@ movhi
	strh	lr, [r2, #100]	@ movhi
	pop	{r4, r5, r6, lr}
	bx	lr
.L13:
	.align	2
.L12:
	.word	-4095
	.word	-4096
	.size	playChannel1, .-playChannel1
	.align	2
	.global	playChannel2
	.syntax unified
	.arm
	.type	playChannel2, %function
playChannel2:
	@ Function supports interworking.
	@ args = 4, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	subs	r3, r3, #0
	movne	r3, #1
	str	lr, [sp, #-4]!
	mov	lr, #67108864
	ldrb	ip, [sp, #4]	@ zero_extendqisi2
	lsl	ip, ip, #6
	and	ip, ip, #255
	lsl	r2, r2, #8
	and	r2, r2, #1792
	orr	ip, ip, r3, lsl #11
	and	r1, r1, #63
	orr	ip, ip, r2
	orr	r1, r1, ip
	orr	r0, r0, #49152
	orr	r1, r1, #53248
	strh	r1, [lr, #104]	@ movhi
	strh	r0, [lr, #108]	@ movhi
	ldr	lr, [sp], #4
	bx	lr
	.size	playChannel2, .-playChannel2
	.align	2
	.global	playSfxPreset
	.syntax unified
	.arm
	.type	playSfxPreset, %function
playSfxPreset:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L28
	str	lr, [sp, #-4]!
	cmp	r0, #5
	bhi	.L16
	ldrb	r0, [r3, r0]
	add	pc, pc, r0, lsl #2
.Lrtx19:
	nop
	.section	.rodata
.L19:
	.byte	(.L24-.Lrtx19-4)/4
	.byte	(.L23-.Lrtx19-4)/4
	.byte	(.L22-.Lrtx19-4)/4
	.byte	(.L21-.Lrtx19-4)/4
	.byte	(.L20-.Lrtx19-4)/4
	.byte	(.L18-.Lrtx19-4)/4
	.text
	.p2align 2
.L18:
	mov	r3, #67108864
	mov	r0, #0
	ldr	lr, .L28+4
	ldr	ip, .L28+8
	ldr	r1, .L28+12
	ldr	r2, .L28+16
.L27:
	strh	lr, [r3, #104]	@ movhi
	strh	ip, [r3, #108]	@ movhi
	strh	r0, [r3, #96]	@ movhi
	strh	r1, [r3, #98]	@ movhi
	strh	r2, [r3, #100]	@ movhi
.L16:
	ldr	lr, [sp], #4
	bx	lr
.L24:
	mov	r3, #67108864
	ldr	r1, .L28+20
	ldr	r2, .L28+24
	strh	r1, [r3, #104]	@ movhi
	ldr	lr, [sp], #4
	strh	r2, [r3, #108]	@ movhi
	bx	lr
.L23:
	mov	r3, #67108864
	ldr	ip, .L28+28
	ldr	r0, .L28+32
	ldr	r1, .L28+36
	ldr	r2, .L28+40
	strh	ip, [r3, #104]	@ movhi
	ldr	lr, [sp], #4
	strh	r0, [r3, #108]	@ movhi
	strh	r1, [r3, #120]	@ movhi
	strh	r2, [r3, #124]	@ movhi
	bx	lr
.L22:
	mov	r3, #67108864
	mov	lr, #67
	ldr	ip, .L28+44
	ldr	r0, .L28+48
	ldr	r1, .L28+52
	ldr	r2, .L28+56
	strh	lr, [r3, #96]	@ movhi
	strh	ip, [r3, #98]	@ movhi
	ldr	lr, [sp], #4
	strh	r0, [r3, #100]	@ movhi
	strh	r1, [r3, #120]	@ movhi
	strh	r2, [r3, #124]	@ movhi
	bx	lr
.L21:
	mov	r3, #67108864
	mov	r0, #0
	ldr	lr, .L28+60
	ldr	ip, .L28+64
	ldr	r1, .L28+68
	ldr	r2, .L28+24
	b	.L27
.L20:
	mov	r3, #67108864
	mov	r0, #0
	ldr	lr, .L28+72
	ldr	ip, .L28+64
	ldr	r1, .L28+76
	ldr	r2, .L28+24
	b	.L27
.L29:
	.align	2
.L28:
	.word	.L19
	.word	-11370
	.word	-15131
	.word	-3178
	.word	-15338
	.word	-11894
	.word	-14435
	.word	-11634
	.word	-14670
	.word	-3574
	.word	-16271
	.word	-3428
	.word	-14586
	.word	-3554
	.word	-16309
	.word	-11958
	.word	-14461
	.word	-3766
	.word	-11888
	.word	-3696
	.size	playSfxPreset, .-playSfxPreset
	.align	2
	.global	playDrumSound
	.syntax unified
	.arm
	.type	playDrumSound, %function
playDrumSound:
	@ Function supports interworking.
	@ args = 4, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	subs	r2, r2, #0
	movne	r2, #1
	str	lr, [sp, #-4]!
	mov	lr, #67108864
	ldrb	ip, [sp, #4]	@ zero_extendqisi2
	lsl	r1, r1, #4
	lsl	ip, ip, #8
	and	r1, r1, #255
	and	r0, r0, #7
	and	ip, ip, #1792
	orr	r0, r0, r1
	and	r3, r3, #63
	orr	r3, r3, ip
	orr	r0, r0, r2, lsl #3
	orr	r3, r3, #61440
	orr	r0, r0, #49152
	strh	r3, [lr, #120]	@ movhi
	strh	r0, [lr, #124]	@ movhi
	ldr	lr, [sp], #4
	bx	lr
	.size	playDrumSound, .-playDrumSound
	.align	2
	.global	playAnalogSound
	.syntax unified
	.arm
	.type	playAnalogSound, %function
playAnalogSound:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L54
	cmp	r0, #17
	bhi	.L32
	ldrb	r0, [r3, r0]
	add	pc, pc, r0, lsl #2
.Lrtx35:
	nop
	.section	.rodata
.L35:
	.byte	(.L52-.Lrtx35-4)/4
	.byte	(.L51-.Lrtx35-4)/4
	.byte	(.L50-.Lrtx35-4)/4
	.byte	(.L49-.Lrtx35-4)/4
	.byte	(.L48-.Lrtx35-4)/4
	.byte	(.L47-.Lrtx35-4)/4
	.byte	(.L46-.Lrtx35-4)/4
	.byte	(.L45-.Lrtx35-4)/4
	.byte	(.L44-.Lrtx35-4)/4
	.byte	(.L43-.Lrtx35-4)/4
	.byte	(.L42-.Lrtx35-4)/4
	.byte	(.L41-.Lrtx35-4)/4
	.byte	(.L40-.Lrtx35-4)/4
	.byte	(.L39-.Lrtx35-4)/4
	.byte	(.L38-.Lrtx35-4)/4
	.byte	(.L37-.Lrtx35-4)/4
	.byte	(.L36-.Lrtx35-4)/4
	.byte	(.L34-.Lrtx35-4)/4
	.text
	.p2align 2
.L34:
	mov	r3, #67108864
	mov	r0, #117
	ldr	r1, .L54+4
	ldr	r2, .L54+8
	strh	r0, [r3, #96]	@ movhi
	strh	r1, [r3, #98]	@ movhi
	strh	r2, [r3, #100]	@ movhi
.L32:
	bx	lr
.L52:
	mov	r3, #67108864
	mov	r2, #49152
	ldr	r1, .L54+12
	strh	r1, [r3, #120]	@ movhi
	strh	r2, [r3, #124]	@ movhi
	bx	lr
.L51:
	mov	r3, #67108864
	ldr	r1, .L54+16
	ldr	r2, .L54+20
	strh	r1, [r3, #120]	@ movhi
	strh	r2, [r3, #124]	@ movhi
	bx	lr
.L50:
	mov	r3, #67108864
	ldr	r1, .L54+24
	ldr	r2, .L54+28
	strh	r1, [r3, #120]	@ movhi
	strh	r2, [r3, #124]	@ movhi
	bx	lr
.L49:
	mov	r3, #67108864
	ldr	r1, .L54+24
	ldr	r2, .L54+32
	strh	r1, [r3, #120]	@ movhi
	strh	r2, [r3, #124]	@ movhi
	bx	lr
.L48:
	mov	r3, #67108864
	mov	r1, #61696
	ldr	r2, .L54+36
	strh	r1, [r3, #120]	@ movhi
	strh	r2, [r3, #124]	@ movhi
	bx	lr
.L47:
	mov	r3, #67108864
	ldr	r1, .L54+40
	ldr	r2, .L54+44
	strh	r1, [r3, #120]	@ movhi
	strh	r2, [r3, #124]	@ movhi
	bx	lr
.L46:
	mov	r3, #67108864
	ldr	r1, .L54+48
	ldr	r2, .L54+52
	strh	r1, [r3, #120]	@ movhi
	strh	r2, [r3, #124]	@ movhi
	bx	lr
.L45:
	mov	r3, #67108864
	ldr	r1, .L54+56
	ldr	r2, .L54+60
	strh	r1, [r3, #120]	@ movhi
	strh	r2, [r3, #124]	@ movhi
	bx	lr
.L44:
	mov	r3, #67108864
	mov	r0, #55
	mov	r1, #61696
	ldr	r2, .L54+64
	strh	r0, [r3, #96]	@ movhi
	strh	r1, [r3, #98]	@ movhi
	strh	r2, [r3, #100]	@ movhi
	bx	lr
.L43:
	mov	r3, #67108864
	mov	r0, #53
	mov	r1, #61696
	ldr	r2, .L54+8
	strh	r0, [r3, #96]	@ movhi
	strh	r1, [r3, #98]	@ movhi
	strh	r2, [r3, #100]	@ movhi
	bx	lr
.L42:
	mov	r3, #67108864
	mov	r0, #53
	ldr	r1, .L54+68
	ldr	r2, .L54+72
	strh	r0, [r3, #96]	@ movhi
	strh	r1, [r3, #98]	@ movhi
	strh	r2, [r3, #100]	@ movhi
	bx	lr
.L41:
	mov	r3, #67108864
	mov	r0, #23
	ldr	r1, .L54+76
	ldr	r2, .L54+64
	strh	r0, [r3, #96]	@ movhi
	strh	r1, [r3, #98]	@ movhi
	strh	r2, [r3, #100]	@ movhi
	bx	lr
.L40:
	mov	r3, #67108864
	mov	r0, #23
	ldr	r1, .L54+80
	ldr	r2, .L54+84
	strh	r0, [r3, #96]	@ movhi
	strh	r1, [r3, #98]	@ movhi
	strh	r2, [r3, #100]	@ movhi
	bx	lr
.L39:
	mov	r3, #67108864
	mov	r0, #39
	ldr	r1, .L54+80
	ldr	r2, .L54+64
	strh	r0, [r3, #96]	@ movhi
	strh	r1, [r3, #98]	@ movhi
	strh	r2, [r3, #100]	@ movhi
	bx	lr
.L38:
	mov	r3, #67108864
	mov	r0, #36
	ldr	r1, .L54+88
	ldr	r2, .L54+84
	strh	r0, [r3, #96]	@ movhi
	strh	r1, [r3, #98]	@ movhi
	strh	r2, [r3, #100]	@ movhi
	bx	lr
.L37:
	mov	r3, #67108864
	mov	r0, #36
	ldr	r1, .L54+92
	ldr	r2, .L54+96
	strh	r0, [r3, #96]	@ movhi
	strh	r1, [r3, #98]	@ movhi
	strh	r2, [r3, #100]	@ movhi
	bx	lr
.L36:
	mov	r3, #67108864
	mov	r0, #117
	ldr	r1, .L54+88
	ldr	r2, .L54+64
	strh	r0, [r3, #96]	@ movhi
	strh	r1, [r3, #98]	@ movhi
	strh	r2, [r3, #100]	@ movhi
	bx	lr
.L55:
	.align	2
.L54:
	.word	.L35
	.word	-2879
	.word	-14634
	.word	-3820
	.word	-3552
	.word	-16327
	.word	-2786
	.word	-16272
	.word	-16264
	.word	-16232
	.word	-3810
	.word	-16325
	.word	-4064
	.word	-16353
	.word	-3296
	.word	-16240
	.word	-14670
	.word	-3712
	.word	-14782
	.word	-3445
	.word	-2943
	.word	-14734
	.word	-3455
	.word	-3451
	.word	-14757
	.size	playAnalogSound, .-playAnalogSound
	.ident	"GCC: (devkitARM) 15.2.0"
