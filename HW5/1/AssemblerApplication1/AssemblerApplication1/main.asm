;
; AssemblerApplication1.asm
;
; Created: 5/5/2022 1:55:06 PM
; Author : Hamidreza
;


; Replace with your application code

.ORG 0x000
	RJMP INITIALIZATION
.ORG 0X016
	RJMP OVF_INT


INITIALIZATION:
	LDI R16,LOW(RAMEND)
	OUT SPL,R16
	LDI R16,HIGH(RAMEND)
	OUT SPH,R16
	LDI R16,0X0
	OUT DDRC,R16
	SBI DDRA,0


	;debug
	;LDI R16,0XFF
	;OUT DDRA,R16
	;debug
	LDI R16,0X01
	OUT TIMSK,R16

	LDI R16,0X00
	OUT PORTA,R16
	LDI R21,0X06	;TIMER INIT TCNT0 TO COUNT 250 INSTEAD OF 256
	LDI R22,0X00	;FLAG
	SEI


MAIN:
	IN R18,PINC
	;debug
	;LDI R19,0X55
	;OUT PORTA,R18
	;debug

	SBRC R18,0
	CALL INITIALIZING_TIMER
	JMP MAIN


INITIALIZING_TIMER:
	SBRC R22,0
	RET
	LDI R19,0X01
	OUT PORTA,R19
	LDI R22,0X01			;FLAG ON
	LDI R24,0X00			;COUNTER
	LDI R20,0XFA
	OUT OCR0,R20
	OUT TCNT0,R21
	LDI R20,0B00000011
	OUT TCCR0,R20
	RET

OVF_INT:
	;debug
	;LDI R19,0X55
	;OUT PORTA,R18
	;debug
	OUT TCNT0,R21
	INC R24					;INC COUNTER
	CPI R24,0XFA			;=250
	BREQ END_TIMER
	RETI


END_TIMER:
	LDI R20,0B00000000
	OUT TCCR0,R20
	LDI R22,0X00		;FLAG OFF
	LDI R19,0X00
	OUT PORTA,R19
	RETI