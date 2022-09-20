
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
	.DEF _pass=R6
	.DEF _pass_msb=R7
	.DEF _password=R8
	.DEF _password_msb=R9
	.DEF _passtemp=R10
	.DEF _passtemp_msb=R11
	.DEF _fail_counter=R4
	.DEF _i=R13
	.DEF _alpha=R12

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
	JMP  _timer1_ovf_isr
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x06
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

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
;Date    : 6/29/2022
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
;
;// Declare your global variables here
;
;// Standard Input/Output functions
;#include <stdio.h>
;#include <stdlib.h>
;#include <delay.h>
;#define ADC_INIT ((1<<REFS0) | (0<<ADLAR))
;
;unsigned char key_pressed;
;unsigned int pass = 0;
;unsigned int password = 0,passtemp;
;unsigned char fail_counter = 0,i;
;unsigned char temp[4];
;unsigned char alpha;
;//Init and seed.
;unsigned int u_seed_rand_val = 0;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 002C {

	.CSEG
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
; 0000 002D // Place your code here
; 0000 002E 
; 0000 002F PORTC.0 = ~PORTC.0;
	SBIS 0x15,0
	RJMP _0x3
	CBI  0x15,0
	RJMP _0x4
_0x3:
	SBI  0x15,0
_0x4:
; 0000 0030 }
	RETI
; .FEND
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0034 {
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0035     TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 0036     TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 0037     TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0038     SREG.7=0;
	BCLR 7
; 0000 0039 
; 0000 003A }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
; .FEND
;
;void send_number(unsigned char number){
; 0000 003C void send_number(unsigned char number){
_send_number:
; .FSTART _send_number
; 0000 003D     if(number == 10){     //Enter
	ST   -Y,R26
;	number -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ PC+2
	RJMP _0x5
; 0000 003E           if(pass == password){
	__CPWRR 8,9,6,7
	BRNE _0x6
; 0000 003F                UDR = 'H';
	LDI  R30,LOW(72)
	OUT  0xC,R30
; 0000 0040                while(!(UCSRA & (1<<UDRE)));
_0x7:
	SBIS 0xB,5
	RJMP _0x7
; 0000 0041                UDR = 'a';
	LDI  R30,LOW(97)
	OUT  0xC,R30
; 0000 0042                while(!(UCSRA & (1<<UDRE)));
_0xA:
	SBIS 0xB,5
	RJMP _0xA
; 0000 0043                UDR = 'm';
	LDI  R30,LOW(109)
	OUT  0xC,R30
; 0000 0044                while(!(UCSRA & (1<<UDRE)));
_0xD:
	SBIS 0xB,5
	RJMP _0xD
; 0000 0045                UDR = 'i';
	LDI  R30,LOW(105)
	OUT  0xC,R30
; 0000 0046                while(!(UCSRA & (1<<UDRE)));
_0x10:
	SBIS 0xB,5
	RJMP _0x10
; 0000 0047                UDR = 'd';
	LDI  R30,LOW(100)
	OUT  0xC,R30
; 0000 0048                while(!(UCSRA & (1<<UDRE)));
_0x13:
	SBIS 0xB,5
	RJMP _0x13
; 0000 0049                UDR = 'R';
	LDI  R30,LOW(82)
	OUT  0xC,R30
; 0000 004A                while(!(UCSRA & (1<<UDRE)));
_0x16:
	SBIS 0xB,5
	RJMP _0x16
; 0000 004B                UDR = 'e';
	LDI  R30,LOW(101)
	OUT  0xC,R30
; 0000 004C                while(!(UCSRA & (1<<UDRE)));
_0x19:
	SBIS 0xB,5
	RJMP _0x19
; 0000 004D                UDR = 'z';
	LDI  R30,LOW(122)
	OUT  0xC,R30
; 0000 004E                while(!(UCSRA & (1<<UDRE)));
_0x1C:
	SBIS 0xB,5
	RJMP _0x1C
; 0000 004F                UDR = 'a';
	LDI  R30,LOW(97)
	OUT  0xC,R30
; 0000 0050                while(!(UCSRA & (1<<UDRE)));
_0x1F:
	SBIS 0xB,5
	RJMP _0x1F
; 0000 0051           }else{
	RJMP _0x22
_0x6:
; 0000 0052 
; 0000 0053                if (fail_counter == 2){
	LDI  R30,LOW(2)
	CP   R30,R4
	BRNE _0x23
; 0000 0054                     UDR = 'L';
	LDI  R30,LOW(76)
	OUT  0xC,R30
; 0000 0055                     while(!(UCSRA & (1<<UDRE)));
_0x24:
	SBIS 0xB,5
	RJMP _0x24
; 0000 0056                     UDR = 'O';
	LDI  R30,LOW(79)
	OUT  0xC,R30
; 0000 0057                     while(!(UCSRA & (1<<UDRE)));
_0x27:
	SBIS 0xB,5
	RJMP _0x27
; 0000 0058                     UDR = 'C';
	LDI  R30,LOW(67)
	OUT  0xC,R30
; 0000 0059                     while(!(UCSRA & (1<<UDRE)));
_0x2A:
	SBIS 0xB,5
	RJMP _0x2A
; 0000 005A                     UDR = 'K';
	LDI  R30,LOW(75)
	OUT  0xC,R30
; 0000 005B                     while(!(UCSRA & (1<<UDRE)));
_0x2D:
	SBIS 0xB,5
	RJMP _0x2D
; 0000 005C                     // Timer/Counter 0 initialization
; 0000 005D                     // Clock source: System Clock
; 0000 005E                     // Clock value: 1000.000 kHz
; 0000 005F                     // Mode: Normal top=0xFF
; 0000 0060                     // OC0 output: Disconnected
; 0000 0061                     // Timer Period: 0.256 ms
; 0000 0062                     TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (1<<CS01) | (0<<CS00);
	LDI  R30,LOW(2)
	OUT  0x33,R30
; 0000 0063                     TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0064                     OCR0=0x00;
	OUT  0x3C,R30
; 0000 0065 
; 0000 0066                     // Timer/Counter 1 initialization
; 0000 0067                     // Clock source: System Clock
; 0000 0068                     // Clock value: 7.813 kHz
; 0000 0069                     // Mode: Normal top=0xFFFF
; 0000 006A                     // OC1A output: Disconnected
; 0000 006B                     // OC1B output: Disconnected
; 0000 006C                     // Noise Canceler: Off
; 0000 006D                     // Input Capture on Falling Edge
; 0000 006E                     // Timer Period: 2.9999 s
; 0000 006F                     // Timer1 Overflow Interrupt: On
; 0000 0070                     // Input Capture Interrupt: Off
; 0000 0071                     // Compare A Match Interrupt: Off
; 0000 0072                     // Compare B Match Interrupt: Off
; 0000 0073                     TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0074                     TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (1<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(5)
	OUT  0x2E,R30
; 0000 0075                     TCNT1H=0xA4;
	LDI  R30,LOW(164)
	OUT  0x2D,R30
; 0000 0076                     TCNT1L=0x73;
	LDI  R30,LOW(115)
	OUT  0x2C,R30
; 0000 0077                     ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 0078                     ICR1L=0x00;
	OUT  0x26,R30
; 0000 0079                     OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 007A                     OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 007B                     OCR1BH=0x00;
	OUT  0x29,R30
; 0000 007C                     OCR1BL=0x00;
	OUT  0x28,R30
; 0000 007D 
; 0000 007E                     // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 007F                     TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<OCIE0) |  ...
	LDI  R30,LOW(5)
	OUT  0x39,R30
; 0000 0080 
; 0000 0081                }else{
	RJMP _0x30
_0x23:
; 0000 0082                     UDR = 'F';
	LDI  R30,LOW(70)
	OUT  0xC,R30
; 0000 0083                     while(!(UCSRA & (1<<UDRE)));
_0x31:
	SBIS 0xB,5
	RJMP _0x31
; 0000 0084                     UDR = 'A';
	LDI  R30,LOW(65)
	OUT  0xC,R30
; 0000 0085                     while(!(UCSRA & (1<<UDRE)));
_0x34:
	SBIS 0xB,5
	RJMP _0x34
; 0000 0086                     UDR = 'I';
	LDI  R30,LOW(73)
	OUT  0xC,R30
; 0000 0087                     while(!(UCSRA & (1<<UDRE)));
_0x37:
	SBIS 0xB,5
	RJMP _0x37
; 0000 0088                     UDR = 'L';
	LDI  R30,LOW(76)
	OUT  0xC,R30
; 0000 0089                     while(!(UCSRA & (1<<UDRE)));
_0x3A:
	SBIS 0xB,5
	RJMP _0x3A
; 0000 008A                     fail_counter++;
	INC  R4
; 0000 008B                     pass = 0;
	CLR  R6
	CLR  R7
; 0000 008C                }
_0x30:
; 0000 008D 
; 0000 008E           }
_0x22:
; 0000 008F     }else if (number == 11){    // Do Nothing
	RJMP _0x3D
_0x5:
	LD   R26,Y
	CPI  R26,LOW(0xB)
	BREQ _0x3F
; 0000 0090 
; 0000 0091     }else if(fail_counter != 3){
	LDI  R30,LOW(3)
	CP   R30,R4
	BREQ _0x40
; 0000 0092         pass = pass * 10 + number;
	MOVW R30,R6
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12U
	MOVW R26,R30
	LD   R30,Y
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R6,R30
; 0000 0093         UDR = '0'+number;
	LD   R30,Y
	SUBI R30,-LOW(48)
	OUT  0xC,R30
; 0000 0094         while(!(UCSRA & (1<<UDRE)));
_0x41:
	SBIS 0xB,5
	RJMP _0x41
; 0000 0095 
; 0000 0096     }
; 0000 0097 
; 0000 0098 
; 0000 0099 }
_0x40:
_0x3F:
_0x3D:
	ADIW R28,1
	RET
; .FEND
;
;
;
;void GET_KEY (void){
; 0000 009D void GET_KEY (void){
_GET_KEY:
; .FSTART _GET_KEY
; 0000 009E     key_pressed = 50;   //
	LDI  R30,LOW(50)
	MOV  R5,R30
; 0000 009F     PORTA=0XFE;
	LDI  R30,LOW(254)
	OUT  0x1B,R30
; 0000 00A0     if(PINB.0==0)
	SBIC 0x16,0
	RJMP _0x44
; 0000 00A1             {
; 0000 00A2             delay_ms(100);
	CALL SUBOPT_0x0
; 0000 00A3             if(PINB.0==0)
	SBIC 0x16,0
	RJMP _0x45
; 0000 00A4                 {
; 0000 00A5                     //while (PINB.0==0){}
; 0000 00A6                     key_pressed=1;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 00A7                 }
; 0000 00A8             }
_0x45:
; 0000 00A9      if(PINB.1==0)
_0x44:
	SBIC 0x16,1
	RJMP _0x46
; 0000 00AA             {
; 0000 00AB             delay_ms(100);
	CALL SUBOPT_0x0
; 0000 00AC             if(PINB.1==0)
	SBIC 0x16,1
	RJMP _0x47
; 0000 00AD                 {
; 0000 00AE                     //while (PINB.1==0){}
; 0000 00AF                     key_pressed=4;
	LDI  R30,LOW(4)
	MOV  R5,R30
; 0000 00B0                 }
; 0000 00B1             }
_0x47:
; 0000 00B2 
; 0000 00B3      if(PINB.2==0)
_0x46:
	SBIC 0x16,2
	RJMP _0x48
; 0000 00B4             {
; 0000 00B5             delay_ms(100);
	CALL SUBOPT_0x0
; 0000 00B6             if(PINB.2==0)
	SBIC 0x16,2
	RJMP _0x49
; 0000 00B7                 {
; 0000 00B8                     //while (PINB.2==0){}
; 0000 00B9                     key_pressed=7;
	LDI  R30,LOW(7)
	MOV  R5,R30
; 0000 00BA                 }
; 0000 00BB             }
_0x49:
; 0000 00BC 
; 0000 00BD      if(PINB.3==0)
_0x48:
	SBIC 0x16,3
	RJMP _0x4A
; 0000 00BE             {
; 0000 00BF             delay_ms(100);
	CALL SUBOPT_0x0
; 0000 00C0             if(PINB.3==0)
	SBIC 0x16,3
	RJMP _0x4B
; 0000 00C1                 {
; 0000 00C2                     //while (PINB.3==0){}
; 0000 00C3                     key_pressed=10;  //      *
	LDI  R30,LOW(10)
	MOV  R5,R30
; 0000 00C4                 }
; 0000 00C5             }
_0x4B:
; 0000 00C6 
; 0000 00C7 
; 0000 00C8 
; 0000 00C9       PORTA=0XFD;
_0x4A:
	LDI  R30,LOW(253)
	OUT  0x1B,R30
; 0000 00CA       if(PINB.0==0)
	SBIC 0x16,0
	RJMP _0x4C
; 0000 00CB             {
; 0000 00CC             delay_ms(100);
	CALL SUBOPT_0x0
; 0000 00CD             if(PINB.0==0)
	SBIC 0x16,0
	RJMP _0x4D
; 0000 00CE                 {
; 0000 00CF                     //while (PINB.0==0){}
; 0000 00D0                     key_pressed=2;
	LDI  R30,LOW(2)
	MOV  R5,R30
; 0000 00D1                 }
; 0000 00D2             }
_0x4D:
; 0000 00D3      if(PINB.1==0)
_0x4C:
	SBIC 0x16,1
	RJMP _0x4E
; 0000 00D4             {
; 0000 00D5             delay_ms(100);
	CALL SUBOPT_0x0
; 0000 00D6             if(PINB.1==0)
	SBIC 0x16,1
	RJMP _0x4F
; 0000 00D7                 {
; 0000 00D8                     //while (PINB.1==0){}
; 0000 00D9                     key_pressed=5;
	LDI  R30,LOW(5)
	MOV  R5,R30
; 0000 00DA                 }
; 0000 00DB             }
_0x4F:
; 0000 00DC 
; 0000 00DD      if(PINB.2==0)
_0x4E:
	SBIC 0x16,2
	RJMP _0x50
; 0000 00DE             {
; 0000 00DF             delay_ms(100);
	CALL SUBOPT_0x0
; 0000 00E0             if(PINB.2==0)
	SBIC 0x16,2
	RJMP _0x51
; 0000 00E1                 {
; 0000 00E2                     //while (PINB.2==0){}
; 0000 00E3                     key_pressed=8;
	LDI  R30,LOW(8)
	MOV  R5,R30
; 0000 00E4                 }
; 0000 00E5             }
_0x51:
; 0000 00E6 
; 0000 00E7      if(PINB.3==0)
_0x50:
	SBIC 0x16,3
	RJMP _0x52
; 0000 00E8             {
; 0000 00E9             delay_ms(100);
	CALL SUBOPT_0x0
; 0000 00EA             if(PINB.3==0)
	SBIS 0x16,3
; 0000 00EB                 {
; 0000 00EC                     //while (PINB.2==0){}
; 0000 00ED                     key_pressed=0;
	CLR  R5
; 0000 00EE                 }
; 0000 00EF             }
; 0000 00F0 
; 0000 00F1       PORTA=0XFB;
_0x52:
	LDI  R30,LOW(251)
	OUT  0x1B,R30
; 0000 00F2       if(PINB.0==0)
	SBIC 0x16,0
	RJMP _0x54
; 0000 00F3             {
; 0000 00F4             delay_ms(100);
	CALL SUBOPT_0x0
; 0000 00F5             if(PINB.0==0)
	SBIC 0x16,0
	RJMP _0x55
; 0000 00F6                 {
; 0000 00F7                     //while (PINB.0==0){}
; 0000 00F8                     key_pressed=3;
	LDI  R30,LOW(3)
	MOV  R5,R30
; 0000 00F9                 }
; 0000 00FA             }
_0x55:
; 0000 00FB      if(PINB.1==0)
_0x54:
	SBIC 0x16,1
	RJMP _0x56
; 0000 00FC             {
; 0000 00FD             delay_ms(100);
	CALL SUBOPT_0x0
; 0000 00FE             if(PINB.1==0)
	SBIC 0x16,1
	RJMP _0x57
; 0000 00FF                 {
; 0000 0100                     //while (PINB.1==0){}
; 0000 0101                     key_pressed=6;
	LDI  R30,LOW(6)
	MOV  R5,R30
; 0000 0102                 }
; 0000 0103             }
_0x57:
; 0000 0104 
; 0000 0105      if(PINB.2==0)
_0x56:
	SBIC 0x16,2
	RJMP _0x58
; 0000 0106             {
; 0000 0107             delay_ms(100);
	CALL SUBOPT_0x0
; 0000 0108             if(PINB.2==0)
	SBIC 0x16,2
	RJMP _0x59
; 0000 0109                 {
; 0000 010A                     //while (PINB.2==0){}
; 0000 010B                     key_pressed=9;
	LDI  R30,LOW(9)
	MOV  R5,R30
; 0000 010C                 }
; 0000 010D             }
_0x59:
; 0000 010E 
; 0000 010F      if(PINB.3==0)
_0x58:
	SBIC 0x16,3
	RJMP _0x5A
; 0000 0110             {
; 0000 0111             delay_ms(100);
	CALL SUBOPT_0x0
; 0000 0112             if(PINB.3==0)
	SBIC 0x16,3
	RJMP _0x5B
; 0000 0113                 {
; 0000 0114                    // while (PINB.3==0){}
; 0000 0115                     key_pressed=11;   //     #
	LDI  R30,LOW(11)
	MOV  R5,R30
; 0000 0116                 }
; 0000 0117             }
_0x5B:
; 0000 0118        if(key_pressed!=50){
_0x5A:
	LDI  R30,LOW(50)
	CP   R30,R5
	BREQ _0x5C
; 0000 0119        send_number(key_pressed);  }
	MOV  R26,R5
	RCALL _send_number
; 0000 011A        PORTA=0XF0;
_0x5C:
	LDI  R30,LOW(240)
	OUT  0x1B,R30
; 0000 011B 
; 0000 011C 
; 0000 011D 
; 0000 011E }
	RET
; .FEND
;
;
;unsigned char ADC_run(void){
; 0000 0121 unsigned char ADC_run(void){
_ADC_run:
; .FSTART _ADC_run
; 0000 0122 
; 0000 0123     ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 0124     while ((ADCSRA & (1<<ADIF))==0);
_0x5D:
	SBIS 0x6,4
	RJMP _0x5D
; 0000 0125     ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 0126     alpha = ADCH;
	IN   R12,5
; 0000 0127     return ADCL;
	IN   R30,0x4
	RET
; 0000 0128 
; 0000 0129 }
; .FEND
;
;void main(void)
; 0000 012C {
_main:
; .FSTART _main
; 0000 012D 
; 0000 012E // Declare your local variables here
; 0000 012F 
; 0000 0130 // Input/Output Ports initialization
; 0000 0131 // Port A initialization
; 0000 0132 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=Out Bit0=Out
; 0000 0133 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
	LDI  R30,LOW(7)
	OUT  0x1A,R30
; 0000 0134 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=0 Bit1=0 Bit0=0
; 0000 0135 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0136 
; 0000 0137 // Port B initialization
; 0000 0138 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0139 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 013A // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=P Bit2=P Bit1=P Bit0=P
; 0000 013B PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (1<<PORTB3) | (1<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);
	LDI  R30,LOW(15)
	OUT  0x18,R30
; 0000 013C 
; 0000 013D // Port C initialization
; 0000 013E // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=Out
; 0000 013F DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(1)
	OUT  0x14,R30
; 0000 0140 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=0
; 0000 0141 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0142 
; 0000 0143 // Port D initialization
; 0000 0144 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0145 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 0146 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0147 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 0148 
; 0000 0149 
; 0000 014A // USART initialization
; 0000 014B // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 014C // USART Receiver: Off
; 0000 014D // USART Transmitter: On
; 0000 014E // USART Mode: Asynchronous
; 0000 014F // USART Baud Rate: 9600
; 0000 0150 UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	OUT  0xB,R30
; 0000 0151 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(8)
	OUT  0xA,R30
; 0000 0152 UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0153 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0154 UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 0155 
; 0000 0156 ADMUX = ADC_INIT | 3;
	LDI  R30,LOW(67)
	OUT  0x7,R30
; 0000 0157 ADCSRA = (1<<ADEN)| (0<<ADSC)| (0<<ADATE)| (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1);
	LDI  R30,LOW(134)
	OUT  0x6,R30
; 0000 0158 
; 0000 0159 
; 0000 015A 
; 0000 015B 
; 0000 015C   //init_adc();
; 0000 015D   //Note we're assuming the channel that you are reading from is FLOATING or hooked up to something very noisy.
; 0000 015E   //Gather bits from the adc, pushing them into your pseudorandom seed.
; 0000 015F   u_seed_rand_val = 0;
	LDI  R30,LOW(0)
	STS  _u_seed_rand_val,R30
	STS  _u_seed_rand_val+1,R30
; 0000 0160   for( i=0; i<16; i++){
	CLR  R13
_0x61:
	LDI  R30,LOW(16)
	CP   R13,R30
	BRSH _0x62
; 0000 0161       u_seed_rand_val = u_seed_rand_val<<1 | (ADC_run()&0b1);
	LDS  R30,_u_seed_rand_val
	LDS  R31,_u_seed_rand_val+1
	LSL  R30
	ROL  R31
	PUSH R31
	PUSH R30
	RCALL _ADC_run
	ANDI R30,LOW(0x1)
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STS  _u_seed_rand_val,R30
	STS  _u_seed_rand_val+1,R31
; 0000 0162   }
	INC  R13
	RJMP _0x61
_0x62:
; 0000 0163 //    passtemp =  u_seed_rand_val;
; 0000 0164 //    for (i=0;i<4;i++){
; 0000 0165 //        temp[i] =  passtemp%10;
; 0000 0166 //        passtemp = passtemp/10;
; 0000 0167 //
; 0000 0168 //    }
; 0000 0169 //    for (i=0;i<4;i++){
; 0000 016A //        UDR = '0'+temp[3-i];
; 0000 016B //        while(!(UCSRA & (1<<UDRE)));
; 0000 016C //
; 0000 016D //    }
; 0000 016E //
; 0000 016F 
; 0000 0170    srand (u_seed_rand_val);
	LDS  R26,_u_seed_rand_val
	LDS  R27,_u_seed_rand_val+1
	CALL _srand
; 0000 0171 
; 0000 0172    password = rand()%9999;
	CALL _rand
	MOVW R26,R30
	LDI  R30,LOW(9999)
	LDI  R31,HIGH(9999)
	CALL __MODW21
	MOVW R8,R30
; 0000 0173     // Global enable interrupts
; 0000 0174     passtemp = password;
	MOVW R10,R8
; 0000 0175     #asm("sei")
	sei
; 0000 0176     for (i=0;i<4;i++){
	CLR  R13
_0x64:
	LDI  R30,LOW(4)
	CP   R13,R30
	BRSH _0x65
; 0000 0177         temp[i] =  passtemp%10;
	MOV  R30,R13
	LDI  R31,0
	SUBI R30,LOW(-_temp)
	SBCI R31,HIGH(-_temp)
	MOVW R22,R30
	MOVW R26,R10
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	MOVW R26,R22
	ST   X,R30
; 0000 0178         passtemp = passtemp/10;
	MOVW R26,R10
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	MOVW R10,R30
; 0000 0179 
; 0000 017A     }
	INC  R13
	RJMP _0x64
_0x65:
; 0000 017B     for (i=0;i<4;i++){
	CLR  R13
_0x67:
	LDI  R30,LOW(4)
	CP   R13,R30
	BRSH _0x68
; 0000 017C         UDR = '0'+temp[3-i];
	MOV  R30,R13
	LDI  R31,0
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	SUBI R30,LOW(-_temp)
	SBCI R31,HIGH(-_temp)
	LD   R30,Z
	SUBI R30,-LOW(48)
	OUT  0xC,R30
; 0000 017D         while(!(UCSRA & (1<<UDRE)));
_0x69:
	SBIS 0xB,5
	RJMP _0x69
; 0000 017E 
; 0000 017F     }
	INC  R13
	RJMP _0x67
_0x68:
; 0000 0180 
; 0000 0181 
; 0000 0182 while (1)
_0x6C:
; 0000 0183       {
; 0000 0184       // Place your code here
; 0000 0185         if ((PINB&0x0F) != 0x0F){
	IN   R30,0x16
	ANDI R30,LOW(0xF)
	CPI  R30,LOW(0xF)
	BREQ _0x6F
; 0000 0186             GET_KEY();
	RCALL _GET_KEY
; 0000 0187             //PORTA.4 = ~PORTA.4;
; 0000 0188             delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0000 0189         }
; 0000 018A 
; 0000 018B       }
_0x6F:
	RJMP _0x6C
; 0000 018C }
_0x70:
	RJMP _0x70
; .FEND
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

	.CSEG

	.CSEG

	.DSEG

	.CSEG
_srand:
; .FSTART _srand
	ST   -Y,R27
	ST   -Y,R26
	LD   R30,Y
	LDD  R31,Y+1
	CALL __CWD1
	CALL SUBOPT_0x1
	ADIW R28,2
	RET
; .FEND
_rand:
; .FSTART _rand
	LDS  R30,__seed_G101
	LDS  R31,__seed_G101+1
	LDS  R22,__seed_G101+2
	LDS  R23,__seed_G101+3
	__GETD2N 0x41C64E6D
	CALL __MULD12U
	__ADDD1N 30562
	CALL SUBOPT_0x1
	movw r30,r22
	andi r31,0x7F
	RET
; .FEND

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_temp:
	.BYTE 0x4
_u_seed_rand_val:
	.BYTE 0x2
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	STS  __seed_G101,R30
	STS  __seed_G101+1,R31
	STS  __seed_G101+2,R22
	STS  __seed_G101+3,R23
	RET


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

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
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

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
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

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
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
