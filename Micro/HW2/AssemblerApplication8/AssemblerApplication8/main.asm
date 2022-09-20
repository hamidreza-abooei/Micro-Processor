;
; AssemblerApplication8.asm
;
; Created: 3/10/2022 7:41:54 PM
; Author : Hamidreza
;


; Replace with your application code
LDI R16,0B10111111
OUT DDRA,R16
COM R16
OUT PORTA,R16
LDI R16,0B00001000
start:
	CLR R17
	IN R16,PINA
	BST R16,6
	BLD R17,3
	OUT PORTB,R17
    rjmp start
