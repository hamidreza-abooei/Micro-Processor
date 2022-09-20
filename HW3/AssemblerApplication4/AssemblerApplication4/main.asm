;
; AssemblerApplication4.asm
;
; Created: 3/31/2022 10:46:47 PM
; Author : Hamidreza
;


LDI R16,HIGH(RAMEND)
OUT SPH,R16
LDI R16,LOW(RAMEND)
OUT SPL,R16
LDI R16,0x00
LDI R17,0b1000
OUT	DDRB,R17
OUT PORTB,R17
LDI R18,0XFF


start:		
	COM R18
	AND R18,R17
	OUT PORTB,R18
		;LDI R19,123
	CALL delay
    rjmp start

delay:				;This sub routine delays exactly 500 clock 
	LDI R19,123
	L1:
		DEC R19
		NOP
		BRNE L1
	RET


