;
; AssemblerApplication6.asm
;
; Created: 3/10/2022 6:06:10 PM
; Author : Hamidreza
;


; Replace with your application code
start:
	CLR R16
	LDI ZL,0X00
	LDI ZH,0X02
	LDI R17,100
LOOP:
    INC R16
	ST Z+,R16
	CP R16,R17
	BRNE LOOP
	LDI YH,0X02
	CLR YL
	LDI ZH,0X04
	CLR ZL
LOOP2:
	LD R16,Y+
	ST Z+,R16
	CP R16,R17
	BRNE LOOP2
    rjmp start
