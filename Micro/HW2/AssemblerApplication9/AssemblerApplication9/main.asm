;
; AssemblerApplication9.asm
;
; Created: 3/10/2022 8:06:55 PM
; Author : Hamidreza
;


; Replace with your application code
LDI R16,0X00
OUT DDRB,R16
OUT DDRC,R16
COM R16
OUT PORTB,R16	;PULLUP
OUT PORTC,R16	;PULLUP 
start:
    IN R16,PINC
	COM R16
	LDI R17,5
	ADD R16,R17
	IN R18,PINB
	CLR ZL
	ADD ZL,R18
	ST Z,R16
    rjmp start
