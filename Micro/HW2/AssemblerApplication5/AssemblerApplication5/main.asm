;
; AssemblerApplication5.asm
;
; Created: 3/10/2022 4:00:01 PM
; Author : Hamidreza
;


; Replace with your application code




start:
	CLR R5
	LDI ZL,0X60
	CLR ZH
	LPM R0,Z+
	LPM R1,Z+
	LPM R2,Z+
	LPM R3,Z+
	ADC R1,R3
	ADC R0,R2
	ADC R4,R5
	LDI ZH,0X01
	LDI ZL,0X00
	ST Z+,R1
	ST Z+,R0
	ST Z+,R4
    rjmp start

.ORG 0x0030
.DB $CA,$30
.DB $FA,$DA
