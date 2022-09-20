;
; AssemblerApplication1.asm
;
; Created: 4/24/2022 1:58:53 PM
; Author : Hamidreza
.ORG 0
	RJMP START
.ORG 0x02
	RJMP EX0_INT_ISR


START:
	LDI R16,LOW(RAMEND)
	OUT SPL,R16
	LDI R16,HIGH(RAMEND)
	OUT SPH,R16
	SBI PORTD,2
	SBI PORTD,2		;PULL-UP
	SER R16
	OUT DDRA,R16
	OUT DDRB,R16
	LDI R16,1<<ISC01
	OUT MCUCR,R16
	LDI R20,1<<INT0
	OUT GICR,R20	;ENABLE INT0
	SEI
	CLR R30
	CLR R31
HERE:
	RJMP HERE

EX0_INT_ISR:			;3us  3 Cycle to call routine
	ADIW ZH:ZL,1		;1us  1 Cycle
	OUT PORTA,ZL		;1us  1 Cycle
	OUT PORTB,ZH		;1us  1 Cycle
	RETI				;4us  4 Cycles
						;Overall: 10us takes to execute Interrupt routine so: 10000 KHz