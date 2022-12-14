;
; AssemblerApplication7.asm
;
; Created: 3/10/2022 6:26:17 PM
; Author : Hamidreza
;


; Replace with your application code
start:
	LDI R16,HIGH(RAMEND)
	OUT SPH,R16
	LDI R16,LOW(RAMEND)
	OUT SPL,R16
	LDI ZH,0X00
	LDI ZL,0X60
	LDI R16,10
	ST Z+,R16
	LDI R16,11
	ST Z+,R16
	LDI R16,13
	ST Z+,R16
	LDI R16,15
	ST Z+,R16
	LDI R16,20
	ST Z+,R16
	LDI R16,72
	ST Z+,R16
	LDI R16,134
	ST Z+,R16
	LDI R16,135
	ST Z+,R16
	LDI R16,200
	ST Z+,R16
	LDI R16,255
	ST Z+,R16
	LDI ZL,0X60
	CLR ZH
	LDI R17,10
	CLR R18
	LDI YL,0X00		;EVEN
	LDI YH,0X01
	LDI XL,0X20		;ODD
	LDI XH,0X01	
LOOP:
	INC R18
	LD R16,Z+
	MOV R19,R16
	LSR R19
	BRCS ODD
	BRCC EVEN


EVEN:
	NEG R16
	ST Y+,R16
	CP R18,R17
	BRNE LOOP
	rjmp start

ODD:
	DEC R16
	ST X+,R16
    CP R18,R17
	BRNE LOOP
	rjmp start
