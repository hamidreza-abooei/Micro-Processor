;
; AssemblerApplication4-2.asm
;
; Created: 4/25/2022 1:27:20 PM
; Author : Hamidreza
;


.ORG 0X0000
JMP START
.ORG 0X030
;RJMP HERE

START:
;LDI R18,0
;LDI R16,HIGH(RAMEND)
;OUT SPH,R16
;LDI R16,LOW(RAMEND)
;OUT SPL,R16
SER R16
OUT DDRA,R16
CLR R16
OUT DDRD,R16
SBI PORTD,3           ;PULL_UP
LDI R16,1<<ISC11
OUT MCUCR,R16        ;FALLING EDGE
LDI R16,1<<INT1
OUT GICR,R16          ;INT1
;LDI R16,1<<INTF1
;OUT GIFR,R16
;SEI

HERE: 
IN R17,GIFR
;OUT PORTA,R17
SBRS R17,INTF1
RJMP HERE
INC R18
OUT PORTA,R18
LDI R16,1<<INTF1
OUT GIFR,R16
RJMP HERE