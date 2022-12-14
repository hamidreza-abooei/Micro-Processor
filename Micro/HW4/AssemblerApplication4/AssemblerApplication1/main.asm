;
; AssemblerApplication1.asm
;
; Created: 4/24/2022 1:58:53 PM
; Author : Hamidreza
.ORG 0
	RJMP INIT

.ORG 0X100
INIT:
	LDI R16,LOW(RAMEND)
	OUT SPL,R16
	LDI R16,HIGH(RAMEND)
	OUT SPH,R16

	LDI R20,1<<INT1
	OUT GICR,R20	;ENABLE INT1
	SBI PORTD,3		;PULL-UP
	SER R16
	OUT DDRA,R16
	LDI R16,1<<ISC01
	OUT MCUCR,R16
	CLR R18
	;SEI
	

START:
	;LDI R16,GIFR>>INTF1
	IN R16,GIFR
	BST R16,INTF1
	BRTS ADDPORTA
	;CPI R16,1
	;BREQ ADDPORTA
	RJMP START

ADDPORTA:
	INC R18
	OUT PORTA,R18
	LDI R20,1<<INTF1
	OUT GIFR,R20
	RJMP START

