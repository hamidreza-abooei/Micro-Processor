
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _key_pressed=R5
	.DEF _value1=R6
	.DEF _value1_msb=R7
	.DEF _value2=R8
	.DEF _value2_msb=R9
	.DEF _command_pressed=R4
	.DEF _command=R11
	.DEF _i=R10
	.DEF _counter=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0


__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 6/28/2022
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega32
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*******************************************************/
;
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#define EN PORTC.2
;#define RW PORTC.1
;#define RS PORTC.0
;#define lcd PORTD
;
;
;unsigned char key_pressed;
;int value1;
;int value2;
;//unsigned int value3;
;unsigned char command_pressed = 0;
;unsigned char command = 0;
;unsigned char i;
;unsigned char temp[16];
;unsigned char counter = 0;
;
;
;
;void lcd_command(unsigned char data){
; 0000 002C void lcd_command(unsigned char data){

	.CSEG
_lcd_command:
; .FSTART _lcd_command
; 0000 002D     lcd = data;
	ST   -Y,R26
;	data -> Y+0
	LD   R30,Y
	OUT  0x12,R30
; 0000 002E     RS = 0;
	CBI  0x15,0
; 0000 002F     RW = 0;
	RCALL SUBOPT_0x0
; 0000 0030     EN = 0;
; 0000 0031     delay_ms(2);
; 0000 0032     EN = 1;
; 0000 0033     RS = 0;
; 0000 0034     RW = 0;
; 0000 0035 
; 0000 0036 }
	RJMP _0x2000001
; .FEND
;
;void lcd_data(unsigned char data){
; 0000 0038 void lcd_data(unsigned char data){
_lcd_data:
; .FSTART _lcd_data
; 0000 0039     lcd = data;
	ST   -Y,R26
;	data -> Y+0
	LD   R30,Y
	OUT  0x12,R30
; 0000 003A     RS = 1;
	SBI  0x15,0
; 0000 003B     RW = 0;
	RCALL SUBOPT_0x0
; 0000 003C     EN = 0;
; 0000 003D     delay_ms(2);
; 0000 003E     EN = 1;
; 0000 003F     RS = 0;
; 0000 0040     RW = 0;
; 0000 0041 }
	RJMP _0x2000001
; .FEND
;
;void lcd_init(void){
; 0000 0043 void lcd_init(void){
_lcd_init:
; .FSTART _lcd_init
; 0000 0044     lcd_command(0x38);//function set
	LDI  R26,LOW(56)
	RCALL _lcd_command
; 0000 0045     lcd_command(0b1100);//on/off display
	LDI  R26,LOW(12)
	RCALL _lcd_command
; 0000 0046     lcd_command(0b110);//inc
	LDI  R26,LOW(6)
	RCALL _lcd_command
; 0000 0047     lcd_command(0x01);//clear
; 0000 0048 }
; .FEND
;
;void lcd_clear(void){
; 0000 004A void lcd_clear(void){
_lcd_clear:
; .FSTART _lcd_clear
; 0000 004B    lcd_command(0x01);
_0x2000002:
	LDI  R26,LOW(1)
	RCALL _lcd_command
; 0000 004C 
; 0000 004D }
	RET
; .FEND
;
;void lcd_write_number(int number){
; 0000 004F void lcd_write_number(int number){
_lcd_write_number:
; .FSTART _lcd_write_number
; 0000 0050     lcd_clear();
	ST   -Y,R27
	ST   -Y,R26
;	number -> Y+0
	RCALL _lcd_clear
; 0000 0051     if (number<0){
	LDD  R26,Y+1
	TST  R26
	BRPL _0x1B
; 0000 0052         lcd_data('-');
	LDI  R26,LOW(45)
	RCALL _lcd_data
; 0000 0053     }
; 0000 0054     counter = 0;
_0x1B:
	CLR  R13
; 0000 0055     while(number!=0 ){
_0x1C:
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	BREQ _0x1E
; 0000 0056         temp[counter] = number%10;
	MOV  R30,R13
	LDI  R31,0
	SUBI R30,LOW(-_temp)
	SBCI R31,HIGH(-_temp)
	MOVW R22,R30
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	MOVW R26,R22
	ST   X,R30
; 0000 0057         number = number/10;
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	ST   Y,R30
	STD  Y+1,R31
; 0000 0058         counter++;
	INC  R13
; 0000 0059     }
	RJMP _0x1C
_0x1E:
; 0000 005A     for (i = 0;i<counter;i++){
	CLR  R10
_0x20:
	CP   R10,R13
	BRSH _0x21
; 0000 005B         lcd_data('0'+temp[counter-i-1]);
	MOV  R26,R13
	CLR  R27
	MOV  R30,R10
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	SUBI R30,LOW(-_temp)
	SBCI R31,HIGH(-_temp)
	LD   R30,Z
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RCALL _lcd_data
; 0000 005C     }
	INC  R10
	RJMP _0x20
_0x21:
; 0000 005D 
; 0000 005E }
	ADIW R28,2
	RET
; .FEND
;
;void calculator (unsigned char key){
; 0000 0060 void calculator (unsigned char key){
_calculator:
; .FSTART _calculator
; 0000 0061     if (key >=20){          // command sent
	ST   -Y,R26
;	key -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0x14)
	BRLO _0x22
; 0000 0062         command_pressed = 1;
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 0063         command = key;
	LDD  R11,Y+0
; 0000 0064         if (command == 20){    //       /
	LDI  R30,LOW(20)
	CP   R30,R11
	BRNE _0x23
; 0000 0065           lcd_clear();
	RCALL _lcd_clear
; 0000 0066           lcd_data(253);
	LDI  R26,LOW(253)
	RCALL _lcd_data
; 0000 0067         }
; 0000 0068         if (command == 21){    //       *
_0x23:
	LDI  R30,LOW(21)
	CP   R30,R11
	BRNE _0x24
; 0000 0069           lcd_clear();
	RCALL _lcd_clear
; 0000 006A           lcd_data('*');
	LDI  R26,LOW(42)
	RCALL _lcd_data
; 0000 006B         }
; 0000 006C         if (command == 22){    //       -
_0x24:
	LDI  R30,LOW(22)
	CP   R30,R11
	BRNE _0x25
; 0000 006D           lcd_clear();
	RCALL _lcd_clear
; 0000 006E           lcd_data('-');
	LDI  R26,LOW(45)
	RCALL _lcd_data
; 0000 006F         }
; 0000 0070         if (command == 23){    //       +
_0x25:
	LDI  R30,LOW(23)
	CP   R30,R11
	BRNE _0x26
; 0000 0071           lcd_clear();
	RCALL _lcd_clear
; 0000 0072           lcd_data('+');
	LDI  R26,LOW(43)
	RCALL _lcd_data
; 0000 0073         }
; 0000 0074 
; 0000 0075 
; 0000 0076     }else if (key == 19){         // on/c
_0x26:
	RJMP _0x27
_0x22:
	LD   R26,Y
	CPI  R26,LOW(0x13)
	BRNE _0x28
; 0000 0077          lcd_clear ();
	RCALL _lcd_clear
; 0000 0078          value1 = 0;
	CLR  R6
	CLR  R7
; 0000 0079          value2 = 0;
	CLR  R8
	CLR  R9
; 0000 007A          command_pressed = 0;
	CLR  R4
; 0000 007B          command = 0;
	CLR  R11
; 0000 007C 
; 0000 007D 
; 0000 007E     }else if (key == 18){          // =
	RJMP _0x29
_0x28:
	LD   R26,Y
	CPI  R26,LOW(0x12)
	BRNE _0x2A
; 0000 007F          //if (command==0){
; 0000 0080 
; 0000 0081          //}
; 0000 0082          if (command == 20){           //   /
	LDI  R30,LOW(20)
	CP   R30,R11
	BRNE _0x2B
; 0000 0083            value1 = value1/value2;
	MOVW R30,R8
	MOVW R26,R6
	CALL __DIVW21
	MOVW R6,R30
; 0000 0084            value2 = 0;
	CLR  R8
	CLR  R9
; 0000 0085          }
; 0000 0086 
; 0000 0087          if (command == 21){           //   *
_0x2B:
	LDI  R30,LOW(21)
	CP   R30,R11
	BRNE _0x2C
; 0000 0088             value1 = value1* value2;
	MOVW R30,R8
	MOVW R26,R6
	CALL __MULW12
	MOVW R6,R30
; 0000 0089             value2 = 0;
	CLR  R8
	CLR  R9
; 0000 008A          }
; 0000 008B 
; 0000 008C          if (command == 22){          //    -
_0x2C:
	LDI  R30,LOW(22)
	CP   R30,R11
	BRNE _0x2D
; 0000 008D             value1 = value1 - value2;
	__SUBWRR 6,7,8,9
; 0000 008E             value2 = 0;
	CLR  R8
	CLR  R9
; 0000 008F          }
; 0000 0090 
; 0000 0091          if (command == 23){           //   +
_0x2D:
	LDI  R30,LOW(23)
	CP   R30,R11
	BRNE _0x2E
; 0000 0092             value1 = value1 + value2;
	__ADDWRR 6,7,8,9
; 0000 0093             value2 = 0;
	CLR  R8
	CLR  R9
; 0000 0094 
; 0000 0095          }
; 0000 0096          lcd_write_number(value1);
_0x2E:
	MOVW R26,R6
	RCALL _lcd_write_number
; 0000 0097          command_pressed = 0;
	CLR  R4
; 0000 0098          command = 0;
	CLR  R11
; 0000 0099     }else if (key < 10 ) {                        // numbers
	RJMP _0x2F
_0x2A:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRSH _0x30
; 0000 009A         if (command_pressed == 0){   // value 1
	TST  R4
	BRNE _0x31
; 0000 009B             value1 = value1*10+key;
	MOVW R30,R6
	RCALL SUBOPT_0x1
	MOVW R6,R30
; 0000 009C             lcd_write_number(value1);
	MOVW R26,R6
	RJMP _0x58
; 0000 009D         }else{                       //value2
_0x31:
; 0000 009E             value2 = value2*10+key;
	MOVW R30,R8
	RCALL SUBOPT_0x1
	MOVW R8,R30
; 0000 009F             lcd_write_number(value2);
	MOVW R26,R8
_0x58:
	RCALL _lcd_write_number
; 0000 00A0         }
; 0000 00A1 
; 0000 00A2     }
; 0000 00A3 
; 0000 00A4 }
_0x30:
_0x2F:
_0x29:
_0x27:
_0x2000001:
	ADIW R28,1
	RET
; .FEND
;
;
;
;
;void GET_KEY (void){
; 0000 00A9 void GET_KEY (void){
_GET_KEY:
; .FSTART _GET_KEY
; 0000 00AA     key_pressed = 50;   //
	LDI  R30,LOW(50)
	MOV  R5,R30
; 0000 00AB     PORTA=0XFE;
	LDI  R30,LOW(254)
	OUT  0x1B,R30
; 0000 00AC     if(PINB.0==0)
	SBIC 0x16,0
	RJMP _0x33
; 0000 00AD             {
; 0000 00AE             delay_ms(100);
	RCALL SUBOPT_0x2
; 0000 00AF             if(PINB.0==0)
	SBIC 0x16,0
	RJMP _0x34
; 0000 00B0                 {
; 0000 00B1                     //while (PINB.0==0){}
; 0000 00B2                     key_pressed=7;
	LDI  R30,LOW(7)
	MOV  R5,R30
; 0000 00B3                 }
; 0000 00B4             }
_0x34:
; 0000 00B5      if(PINB.1==0)
_0x33:
	SBIC 0x16,1
	RJMP _0x35
; 0000 00B6             {
; 0000 00B7             delay_ms(100);
	RCALL SUBOPT_0x2
; 0000 00B8             if(PINB.1==0)
	SBIC 0x16,1
	RJMP _0x36
; 0000 00B9                 {
; 0000 00BA                     //while (PINB.1==0){}
; 0000 00BB                     key_pressed=8;
	LDI  R30,LOW(8)
	MOV  R5,R30
; 0000 00BC                 }
; 0000 00BD             }
_0x36:
; 0000 00BE 
; 0000 00BF      if(PINB.2==0)
_0x35:
	SBIC 0x16,2
	RJMP _0x37
; 0000 00C0             {
; 0000 00C1             delay_ms(100);
	RCALL SUBOPT_0x2
; 0000 00C2             if(PINB.2==0)
	SBIC 0x16,2
	RJMP _0x38
; 0000 00C3                 {
; 0000 00C4                     //while (PINB.2==0){}
; 0000 00C5                     key_pressed=9;
	LDI  R30,LOW(9)
	MOV  R5,R30
; 0000 00C6                 }
; 0000 00C7             }
_0x38:
; 0000 00C8 
; 0000 00C9      if(PINB.3==0)
_0x37:
	SBIC 0x16,3
	RJMP _0x39
; 0000 00CA             {
; 0000 00CB             delay_ms(100);
	RCALL SUBOPT_0x2
; 0000 00CC             if(PINB.3==0)
	SBIC 0x16,3
	RJMP _0x3A
; 0000 00CD                 {
; 0000 00CE                     //while (PINB.3==0){}
; 0000 00CF                     key_pressed=20;  //      /
	LDI  R30,LOW(20)
	MOV  R5,R30
; 0000 00D0                 }
; 0000 00D1             }
_0x3A:
; 0000 00D2 
; 0000 00D3 
; 0000 00D4 
; 0000 00D5       PORTA=0XFD;
_0x39:
	LDI  R30,LOW(253)
	OUT  0x1B,R30
; 0000 00D6       if(PINB.0==0)
	SBIC 0x16,0
	RJMP _0x3B
; 0000 00D7             {
; 0000 00D8             delay_ms(100);
	RCALL SUBOPT_0x2
; 0000 00D9             if(PINB.0==0)
	SBIC 0x16,0
	RJMP _0x3C
; 0000 00DA                 {
; 0000 00DB                     //while (PINB.0==0){}
; 0000 00DC                     key_pressed=4;
	LDI  R30,LOW(4)
	MOV  R5,R30
; 0000 00DD                 }
; 0000 00DE             }
_0x3C:
; 0000 00DF      if(PINB.1==0)
_0x3B:
	SBIC 0x16,1
	RJMP _0x3D
; 0000 00E0             {
; 0000 00E1             delay_ms(100);
	RCALL SUBOPT_0x2
; 0000 00E2             if(PINB.1==0)
	SBIC 0x16,1
	RJMP _0x3E
; 0000 00E3                 {
; 0000 00E4                     //while (PINB.1==0){}
; 0000 00E5                     key_pressed=5;
	LDI  R30,LOW(5)
	MOV  R5,R30
; 0000 00E6                 }
; 0000 00E7             }
_0x3E:
; 0000 00E8 
; 0000 00E9      if(PINB.2==0)
_0x3D:
	SBIC 0x16,2
	RJMP _0x3F
; 0000 00EA             {
; 0000 00EB             delay_ms(100);
	RCALL SUBOPT_0x2
; 0000 00EC             if(PINB.2==0)
	SBIC 0x16,2
	RJMP _0x40
; 0000 00ED                 {
; 0000 00EE                     //while (PINB.2==0){}
; 0000 00EF                     key_pressed=6;
	LDI  R30,LOW(6)
	MOV  R5,R30
; 0000 00F0                 }
; 0000 00F1             }
_0x40:
; 0000 00F2 
; 0000 00F3      if(PINB.3==0)
_0x3F:
	SBIC 0x16,3
	RJMP _0x41
; 0000 00F4             {
; 0000 00F5             delay_ms(100);
	RCALL SUBOPT_0x2
; 0000 00F6             if(PINB.3==0)
	SBIC 0x16,3
	RJMP _0x42
; 0000 00F7                 {
; 0000 00F8                     //while (PINB.2==0){}
; 0000 00F9                     key_pressed=21;     //   *
	LDI  R30,LOW(21)
	MOV  R5,R30
; 0000 00FA                 }
; 0000 00FB             }
_0x42:
; 0000 00FC 
; 0000 00FD       PORTA=0XFB;
_0x41:
	LDI  R30,LOW(251)
	OUT  0x1B,R30
; 0000 00FE       if(PINB.0==0)
	SBIC 0x16,0
	RJMP _0x43
; 0000 00FF             {
; 0000 0100             delay_ms(100);
	RCALL SUBOPT_0x2
; 0000 0101             if(PINB.0==0)
	SBIC 0x16,0
	RJMP _0x44
; 0000 0102                 {
; 0000 0103                     //while (PINB.0==0){}
; 0000 0104                     key_pressed=1;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 0105                 }
; 0000 0106             }
_0x44:
; 0000 0107      if(PINB.1==0)
_0x43:
	SBIC 0x16,1
	RJMP _0x45
; 0000 0108             {
; 0000 0109             delay_ms(100);
	RCALL SUBOPT_0x2
; 0000 010A             if(PINB.1==0)
	SBIC 0x16,1
	RJMP _0x46
; 0000 010B                 {
; 0000 010C                     //while (PINB.1==0){}
; 0000 010D                     key_pressed=2;
	LDI  R30,LOW(2)
	MOV  R5,R30
; 0000 010E                 }
; 0000 010F             }
_0x46:
; 0000 0110 
; 0000 0111      if(PINB.2==0)
_0x45:
	SBIC 0x16,2
	RJMP _0x47
; 0000 0112             {
; 0000 0113             delay_ms(100);
	RCALL SUBOPT_0x2
; 0000 0114             if(PINB.2==0)
	SBIC 0x16,2
	RJMP _0x48
; 0000 0115                 {
; 0000 0116                     //while (PINB.2==0){}
; 0000 0117                     key_pressed=3;
	LDI  R30,LOW(3)
	MOV  R5,R30
; 0000 0118                 }
; 0000 0119             }
_0x48:
; 0000 011A 
; 0000 011B      if(PINB.3==0)
_0x47:
	SBIC 0x16,3
	RJMP _0x49
; 0000 011C             {
; 0000 011D             delay_ms(100);
	RCALL SUBOPT_0x2
; 0000 011E             if(PINB.3==0)
	SBIC 0x16,3
	RJMP _0x4A
; 0000 011F                 {
; 0000 0120                    // while (PINB.3==0){}
; 0000 0121                     key_pressed=22;   //     -
	LDI  R30,LOW(22)
	MOV  R5,R30
; 0000 0122                 }
; 0000 0123             }
_0x4A:
; 0000 0124 
; 0000 0125 
; 0000 0126      PORTA=0XF7;
_0x49:
	LDI  R30,LOW(247)
	OUT  0x1B,R30
; 0000 0127      if(PINB.0==0)
	SBIC 0x16,0
	RJMP _0x4B
; 0000 0128             {
; 0000 0129             delay_ms(100);
	RCALL SUBOPT_0x2
; 0000 012A             if(PINB.0==0)
	SBIC 0x16,0
	RJMP _0x4C
; 0000 012B                 {
; 0000 012C                     //while (PINB.0==0){}
; 0000 012D                     key_pressed=19;  //      on/c
	LDI  R30,LOW(19)
	MOV  R5,R30
; 0000 012E                 }
; 0000 012F             }
_0x4C:
; 0000 0130      if(PINB.1==0)
_0x4B:
	SBIC 0x16,1
	RJMP _0x4D
; 0000 0131             {
; 0000 0132             delay_ms(100);
	RCALL SUBOPT_0x2
; 0000 0133             if(PINB.1==0)
	SBIS 0x16,1
; 0000 0134                 {
; 0000 0135                     //while (PINB.1==0){}
; 0000 0136                     key_pressed=0;
	CLR  R5
; 0000 0137                 }
; 0000 0138             }
; 0000 0139 
; 0000 013A      if(PINB.2==0)
_0x4D:
	SBIC 0x16,2
	RJMP _0x4F
; 0000 013B             {
; 0000 013C             delay_ms(100);
	RCALL SUBOPT_0x2
; 0000 013D             if(PINB.2==0)
	SBIC 0x16,2
	RJMP _0x50
; 0000 013E                 {
; 0000 013F                     //while (PINB.2==0){}
; 0000 0140                     key_pressed=18;    //    =
	LDI  R30,LOW(18)
	MOV  R5,R30
; 0000 0141                 }
; 0000 0142             }
_0x50:
; 0000 0143 
; 0000 0144      if(PINB.3==0)
_0x4F:
	SBIC 0x16,3
	RJMP _0x51
; 0000 0145             {
; 0000 0146             delay_ms(100);
	RCALL SUBOPT_0x2
; 0000 0147             if(PINB.3==0)
	SBIC 0x16,3
	RJMP _0x52
; 0000 0148                 {
; 0000 0149                     //while (PINB.3==0){}
; 0000 014A                     key_pressed=23;     //     +
	LDI  R30,LOW(23)
	MOV  R5,R30
; 0000 014B                 }
; 0000 014C             }
_0x52:
; 0000 014D        calculator(key_pressed);
_0x51:
	MOV  R26,R5
	RCALL _calculator
; 0000 014E        PORTA=0XF0;
	LDI  R30,LOW(240)
	OUT  0x1B,R30
; 0000 014F 
; 0000 0150 
; 0000 0151 
; 0000 0152 }
	RET
; .FEND
;
;
;
;void main(void)
; 0000 0157 {
_main:
; .FSTART _main
; 0000 0158 // Declare your local variables here
; 0000 0159 
; 0000 015A // Input/Output Ports initialization
; 0000 015B // Port A initialization
; 0000 015C // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 015D DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
	LDI  R30,LOW(15)
	OUT  0x1A,R30
; 0000 015E // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 015F PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0160 
; 0000 0161 // Port B initialization
; 0000 0162 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0163 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 0164 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=P Bit2=P Bit1=P Bit0=P
; 0000 0165 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (1<<PORTB3) | (1<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);
	LDI  R30,LOW(15)
	OUT  0x18,R30
; 0000 0166 
; 0000 0167 // Port C initialization
; 0000 0168 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=Out Bit0=Out
; 0000 0169 DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(7)
	OUT  0x14,R30
; 0000 016A // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=1 Bit1=0 Bit0=0
; 0000 016B PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (1<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(4)
	OUT  0x15,R30
; 0000 016C 
; 0000 016D // Port D initialization
; 0000 016E // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 016F DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0170 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0171 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0172 lcd_init();
	RCALL _lcd_init
; 0000 0173 while (1)
_0x53:
; 0000 0174       {
; 0000 0175         if ((PINB&0x0F) != 0x0F){
	IN   R30,0x16
	ANDI R30,LOW(0xF)
	CPI  R30,LOW(0xF)
	BREQ _0x56
; 0000 0176             GET_KEY();
	RCALL _GET_KEY
; 0000 0177             //PORTA.4 = ~PORTA.4;
; 0000 0178             delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0000 0179         }
; 0000 017A 
; 0000 017B       }
_0x56:
	RJMP _0x53
; 0000 017C }
_0x57:
	RJMP _0x57
; .FEND

	.DSEG
_temp:
	.BYTE 0x10

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	CBI  0x15,1
	CBI  0x15,2
	LDI  R26,LOW(2)
	LDI  R27,0
	CALL _delay_ms
	SBI  0x15,2
	CBI  0x15,0
	CBI  0x15,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	MOVW R26,R30
	LD   R30,Y
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _delay_ms


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

;END OF CODE MARKER
__END_OF_CODE:
