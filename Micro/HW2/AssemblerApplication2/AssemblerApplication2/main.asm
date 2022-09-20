;
; AssemblerApplication2.asm
;
; Created: 3/9/2022 9:46:22 PM
; Author : Hamidreza
;


; Replace with your application code
start:

    LDI R16,$39
	LDI R17,$02
	MOV R18,R17
	ADD R18,R16
	LDI R19,6
	ADD R18,R19

    rjmp start
