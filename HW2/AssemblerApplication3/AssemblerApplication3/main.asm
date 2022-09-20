;
; AssemblerApplication3.asm
;
; Created: 3/9/2022 11:27:52 PM
; Author : Hamidreza
;


; Replace with your application code
start:
	LDI R16,0X10
	LDI R17,250
	CLR R18
;	LDI R18,0xF8
	CLR R19
	CLR R2
LOOP:
	INC R18
	BRNE ifs
	INC R19
ifs:
	INC R17
	BRNE LOOP
	DEC R16
	BRNE LOOP
    JMP start
