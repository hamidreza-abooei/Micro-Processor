;
; AssemblerApplication1.asm
;
; Created: 4/24/2022 1:58:53 PM
; Author : Hamidreza
.ORG 0
	RJMP START
.ORG 0x06
	RJMP EX2_INT_ISR


START:
	LDI R16,LOW(RAMEND)
	OUT SPL,R16
	LDI R16,HIGH(RAMEND)
	OUT SPH,R16
	SBI PORTD,2
	LDI R20,1<<INT2
	OUT GICR,R20	;ENABLE INT0
	SBI PORTB,2		;PULL-UP
	LDI R20,0<<ISC2
	OUT MCUCSR,R20
	SER R16 
	OUT DDRC,R16
	SEI
	LDI ZH,HIGH(TABLE*2) 
	LDI ZL,LOW(TABLE*2) 
	LPM R0,Z+ 
	OUT PORTC,R0
HERE:
	RJMP HERE

EX2_INT_ISR:
	LPM R0,Z+ 
	MOV R22,R0 
	CPI R22,$FF 
	BREQ INIT 
	OUT PORTC,R0 
	RETI
	INIT: 
	LDI ZH,HIGH(TABLE*2) 
	LDI ZL,LOW(TABLE*2) 
	LPM R0,Z+ 
	OUT PORTC,R0 
	RETI

TABLE: 
	.DB $C0,$F9,$A4,$B0,$99,$92,$82,$F8,$80,$90