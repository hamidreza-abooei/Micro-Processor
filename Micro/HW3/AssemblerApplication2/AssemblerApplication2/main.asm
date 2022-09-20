;
; AssemblerApplication2.asm
;
; Created: 3/31/2022 8:11:27 PM
; Author : Hamidreza
;


; Replace with your application code

LDI R16,0x00
LDI R17,0XFF
OUT DDRA,R16
OUT PORTA,R17
OUT DDRB,R16
OUT PORTB, R17

COM R16
OUT DDRC,R16
OUT DDRD,R16
LDI R19,0X00


start:
    IN R16,PINA
	IN R17,PINB ; This cannot be 0 
	LDI R18,0X00
	LOOP:
		INC R18
		SUB R16,R17
		;CP R16,R19
		BRPL LOOP
	ADD R16,R17
	DEC R18
	OUT PORTC,R18
	OUT PORTD,R17

    rjmp start
