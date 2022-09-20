;
; AssemblerApplication1.asm
;
; Created: 3/8/2022 9:15:45 PM
; Author : Hamidreza
;std num : 9733002
;


; Replace with your application code
start:
    CLR R2
	LDI R20,$68
	LDI R21,$09
	LDI R22,$90
	LDI R23,$0B
	FMULS R23,R21
	MOVW R19:R18,R1:R0
	FMUL R22,R20
	ADC R18,R2
	MOVW R17:R16,R1:R0
	FMULS R23,R20
	SBC R19,R2
	ADD R17,R0
	ADC R18,R1
	ADC R19,R2
	FMULS R21,R22
	SBC R19,R2
	ADD R17,R0
	ADC R18,R1
	ADC R19,R2


    rjmp start
