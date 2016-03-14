	.EQU	SIM_SCGC5, 0x40048038
	.EQU	Port_Clock_Gate_Control, 0b1010000000000

	.EQU	MUX_GPIO_Mask_SET, 0b00000000000000000000000100000000
	.EQU	MUX_GPIO_Mask_CLR, 0b11111111111111111111100111111111
	
	.EQU	PORTB_PCR18, 0x4004A048		@Red
	.EQU	PORTB_PCR19, 0x4004A04C		@Green
	.EQU	PORTD_PCR01, 0x4004C004		@Blue
	
	.EQU	GPIOB_PDDR, 0x400FF054
	.EQU	GPIOB_PDOR, 0x400FF040
	.EQU	GPIOB_PSOR, 0x400FF044
	.EQU	GPIOB_PCOR, 0x400FF048
	.EQU	GPIOB_PTOR, 0x400FF04C
	
	.EQU	GPIOD_PDDR, 0x400FF0D4
	.EQU	GPIOD_PDOR, 0x400FF0C0
	.EQU	GPIOD_PSOR, 0x400FF0C4
	.EQU	GPIOD_PCOR, 0x400FF0C8
	.EQU	GPIOD_PTOR, 0x400FF0CC
	
	.EQU	red, 0b1000000000000000000
	.EQU	green, 0b10000000000000000000
	.EQU	blue, 0b10
	
	.text
	.global main
	
	main:
		@Set the pins as GPIO in MUX settings
		LDR r0, =SIM_SCGC5
		LDR r1, [r0]
		LDR r2, =Port_Clock_Gate_Control
		ORR r1, r1, r2
		STR r1, [r0]
		
		@Set output pins
		LDR r0, =PORTB_PCR18
		LDR r1, [r0]
		LDR r2, =MUX_GPIO_Mask_SET
		ORR r1, r1, r2
		LDR r2, =MUX_GPIO_Mask_CLR
		AND r1, r1, r2
		STR r1, [r0]
		
		LDR r0, =PORTB_PCR19
		LDR r1, [r0]
		LDR r2, =MUX_GPIO_Mask_SET
		ORR r1, r1, r2
		LDR r2, =MUX_GPIO_Mask_CLR
		AND r1, r1, r2
		STR r1, [r0]
		
		LDR r0, =PORTD_PCR01
		LDR r1, [r0]
		LDR r2, =MUX_GPIO_Mask_SET
		ORR r1, r1, r2
		LDR r2, =MUX_GPIO_Mask_CLR
		AND r1, r1, r2
		STR r1, [r0]
		
		@Turn on
		LDR r0, =GPIOB_PDDR
		LDR r1, [r0]
		LDR r2, =red
		ORR r1, r1, r2
		STR r1, [r0]
		
		LDR r2, =green
		ORR r1, r1, r2
		STR r1, [r0]
		
		LDR r0, =GPIOD_PDDR
		LDR r1, [r0]
		LDR r2, =blue
		ORR r1, r1, r2
		STR r1, [r0]
		
		@Turn off
		@LDR r0, =red
		@LDR r1, =GPIOB_PSOR
		@STR r0, [r1]
		
		@Toggle
		LDR r0, =red
		LDR r1, =GPIOB_PTOR
		STR r0, [r1]
		
		LDR r0, =green
		LDR r1, =GPIOB_PTOR
		STR r0, [r1]
		
		LDR r0, =blue
		LDR r1, =GPIOD_PTOR
		STR r0, [r1]
		
		@Off with PDOR
		@LDR r0, =red
		@LDR r1, =GPIOB_PDOR
		@LDR r2, [r1]
		@EOR r0, r2, r0
		@STR r0, [r1]
		
	loop:
		BL wait_500_ms
		@RGB on
		@None off
		LDR r0, =red
		LDR r1, =GPIOB_PTOR
		STR r0, [r1]
		
		LDR r0, =green
		LDR r1, =GPIOB_PTOR
		STR r0, [r1]
		
		LDR r0, =blue
		LDR r1, =GPIOD_PTOR
		STR r0, [r1]
		
		BL wait_500_ms
		@GB on
		@R off
		LDR r0, =red
		LDR r1, =GPIOB_PTOR
		STR r0, [r1]
		
		BL wait_500_ms
		@RB on
		@G off
		LDR r0, =red
		LDR r1, =GPIOB_PTOR
		STR r0, [r1]
		
		LDR r0, =green
		LDR r1, =GPIOB_PTOR
		STR r0, [r1]
		
		BL wait_500_ms
		@B on
		@RG off
		LDR r0, =red
		LDR r1, =GPIOB_PTOR
		STR r0, [r1]
		
		bal loop
	wait_500_ms:
		push {LR}
		push {r0-r7}
		LDR r0, =4200000
	wait_loop:
		sub r0, #1
		BPL wait_loop
		POP {r0-r7}
		POP {PC}
