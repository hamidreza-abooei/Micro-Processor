;
; AssemblerApplication4.asm
;
; Created: 3/10/2022 11:41:22 AM
; Author : Hamidreza
;


; Replace with your application code
start:
	LDI R16,0XFF
	LDI R17,-1
	LDI R18,0X10
	LDI R19,0X70
	LDI R20,0xff
	LDI R21,0x00
	NEG R20
	ADD R21,R20
	COM R16
	NEG R16
	SUB R16,R17
	ADD R16,R17
	ADD R19,R18
    jmp start
