;
; AssemblerApplication1.asm
;
; Created: 3/29/2022 12:24:55 AM
; Author : Hamidreza
;


; Replace with your application code
LDI R16,HIGH(RAMEND)
OUT SPH,R16
LDI R16,LOW(RAMEND)
OUT SPL,R16
LDI R16,0x00
LDI R17,0xff	
OUT DDRA,R17
OUT PORTA,R17
LDI R18,50		;count up to 50


start:
    INC R16
	COM R17
	OUT PORTA,R17
		;LDI R19,123
	CALL delay_one
	COM R17
	OUT PORTA,R17
	CALL delay_half
	CP R16,R18
	BREQ END
    rjmp start

delay_half: 
	LDI R19,123
	L1:
		DEC R19
		NOP
		BRNE L1
	RET
	
delay_one:
	LDI R19,248
	L2:
		DEC R19
		NOP
		BRNE L2
	RET

END: 
	RJMP END