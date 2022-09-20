
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
	.DEF _counter=R5
	.DEF _sec=R4
	.DEF _read_heart=R7
	.DEF _HR=R6
	.DEF _AGE=R9
	.DEF _ID=R8
	.DEF _state=R11
	.DEF _i=R10
	.DEF _flag=R13
	.DEF _key_pressed=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  _ext_int1_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_ovf_isr
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

_0x3:
	.DB  0x45,0x6E,0x74,0x65,0x72,0x20,0x49,0x44
_0x4:
	.DB  0x45,0x6E,0x74,0x65,0x72,0x20,0x41,0x67
	.DB  0x65
_0x5:
	.DB  0x57,0x61,0x69,0x74,0x20,0x31,0x20,0x6D
	.DB  0x69,0x6E
_0x0:
	.DB  0x23,0x0,0x53,0x61,0x76,0x65,0x64,0x0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x08
	.DW  _str_id
	.DW  _0x3*2

	.DW  0x09
	.DW  _str_age
	.DW  _0x4*2

	.DW  0x0A
	.DW  _str_HR
	.DW  _0x5*2

	.DW  0x02
	.DW  _0x25
	.DW  _0x0*2

	.DW  0x06
	.DW  _0x34
	.DW  _0x0*2+2

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
;Date    : 6/30/2022
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
;// Declare your global variables here
;//eeprom unsigned char id@0x00;
;//eeprom unsigned char age@0x01;
;//eeprom unsigned char hr@0x02;
;//int eeprom  *ptr_id;
;//unsigned char eeprom  *ptr_age;
;//unsigned char eeprom  *ptr_hr;
;
;
;unsigned char counter = 0;
;unsigned char sec = 0;
;unsigned char read_heart = 0;
;unsigned char HR = 0;
;unsigned char AGE = 0;
;unsigned char ID = 0;
;unsigned char state =0;
;unsigned char str_id[] = "Enter ID";

	.DSEG
;unsigned char str_age[] = "Enter Age";
;unsigned char str_HR[] = "Wait 1 min";
;unsigned char i;
;unsigned char flag = 0;
;unsigned char key_pressed;
;unsigned char temp[3];
;
;void EEPROM_write(unsigned int uiAddress, unsigned char ucData)
; 0000 0033 {

	.CSEG
_EEPROM_write:
; .FSTART _EEPROM_write
; 0000 0034 /* Wait for completion of previous write */
; 0000 0035 while(EECR & (1<<EEWE))
	ST   -Y,R26
;	uiAddress -> Y+1
;	ucData -> Y+0
_0x6:
	SBIC 0x1C,1
; 0000 0036 ;
	RJMP _0x6
; 0000 0037 /* Set up address and data registers */
; 0000 0038 EEAR = uiAddress;
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	OUT  0x1E+1,R31
	OUT  0x1E,R30
; 0000 0039 EEDR = ucData;
	LD   R30,Y
	OUT  0x1D,R30
; 0000 003A /* Write logical one to EEMWE */
; 0000 003B EECR |= (1<<EEMWE);
	SBI  0x1C,2
; 0000 003C /* Start eeprom write by setting EEWE */
; 0000 003D EECR |= (1<<EEWE);
	SBI  0x1C,1
; 0000 003E }
	ADIW R28,3
	RET
; .FEND
;
;
;
;unsigned char EEPROM_read(unsigned int uiAddress)
; 0000 0043 {
_EEPROM_read:
; .FSTART _EEPROM_read
; 0000 0044 /* Wait for completion of previous write */
; 0000 0045 while(EECR & (1<<EEWE))
	ST   -Y,R27
	ST   -Y,R26
;	uiAddress -> Y+0
_0x9:
	SBIC 0x1C,1
; 0000 0046 ;
	RJMP _0x9
; 0000 0047 /* Set up address register */
; 0000 0048 EEAR = uiAddress;
	LD   R30,Y
	LDD  R31,Y+1
	OUT  0x1E+1,R31
	OUT  0x1E,R30
; 0000 0049 /* Start eeprom read by writing EERE */
; 0000 004A EECR |= (1<<EERE);
	SBI  0x1C,0
; 0000 004B /* Return data from data register */
; 0000 004C return EEDR;
	IN   R30,0x1D
	RJMP _0x2000002
; 0000 004D }
; .FEND
;
;
;void show_msg (unsigned char *a){
; 0000 0050 void show_msg (unsigned char *a){
_show_msg:
; .FSTART _show_msg
; 0000 0051     for (i=0 ; a[i] != '\0';i++ ){
	ST   -Y,R27
	ST   -Y,R26
;	*a -> Y+0
	CLR  R10
_0xD:
	RCALL SUBOPT_0x0
	CPI  R30,0
	BREQ _0xE
; 0000 0052          UDR = a[i];
	RCALL SUBOPT_0x0
	OUT  0xC,R30
; 0000 0053          while(!(UCSRA & (1<<UDRE)));
_0xF:
	SBIS 0xB,5
	RJMP _0xF
; 0000 0054     }
	INC  R10
	RJMP _0xD
_0xE:
; 0000 0055     UDR = '\n';
	LDI  R30,LOW(10)
	OUT  0xC,R30
; 0000 0056     while(!(UCSRA & (1<<UDRE)));
_0x12:
	SBIS 0xB,5
	RJMP _0x12
; 0000 0057 
; 0000 0058 }
_0x2000002:
	ADIW R28,2
	RET
; .FEND
;
;void show_number (unsigned char a){
; 0000 005A void show_number (unsigned char a){
_show_number:
; .FSTART _show_number
; 0000 005B     for (i = 0;i<3;i++){
	ST   -Y,R26
;	a -> Y+0
	CLR  R10
_0x16:
	LDI  R30,LOW(3)
	CP   R10,R30
	BRSH _0x17
; 0000 005C         temp[i] = a%10;
	MOV  R30,R10
	LDI  R31,0
	SUBI R30,LOW(-_temp)
	SBCI R31,HIGH(-_temp)
	MOVW R22,R30
	LD   R26,Y
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	MOVW R26,R22
	ST   X,R30
; 0000 005D         a = a/10;
	LD   R26,Y
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	ST   Y,R30
; 0000 005E     }
	INC  R10
	RJMP _0x16
_0x17:
; 0000 005F     for (i = 0; i < 3 ; i++){
	CLR  R10
_0x19:
	LDI  R30,LOW(3)
	CP   R10,R30
	BRSH _0x1A
; 0000 0060         UDR = '0'+temp[2-i];
	MOV  R30,R10
	LDI  R31,0
	LDI  R26,LOW(2)
	LDI  R27,HIGH(2)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	SUBI R30,LOW(-_temp)
	SBCI R31,HIGH(-_temp)
	LD   R30,Z
	SUBI R30,-LOW(48)
	OUT  0xC,R30
; 0000 0061         while(!(UCSRA & (1<<UDRE)));
_0x1B:
	SBIS 0xB,5
	RJMP _0x1B
; 0000 0062     }
	INC  R10
	RJMP _0x19
_0x1A:
; 0000 0063     UDR = ' ';
	LDI  R30,LOW(32)
	OUT  0xC,R30
; 0000 0064     while(!(UCSRA & (1<<UDRE)));
_0x1E:
	SBIS 0xB,5
	RJMP _0x1E
; 0000 0065 
; 0000 0066 }
	RJMP _0x2000001
; .FEND
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0069 {
_ext_int0_isr:
; .FSTART _ext_int0_isr
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 006A     if (read_heart == 1){
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x21
; 0000 006B        HR++;
	INC  R6
; 0000 006C 
; 0000 006D     }
; 0000 006E 
; 0000 006F }
_0x21:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
; .FEND
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 0073 {
_ext_int1_isr:
; .FSTART _ext_int1_isr
	RCALL SUBOPT_0x1
; 0000 0074     //show();     //todo
; 0000 0075 
; 0000 0076     for (i = 0; i<counter;i++){
	CLR  R10
_0x23:
	CP   R10,R5
	BRSH _0x24
; 0000 0077         show_msg("#");
	__POINTW2MN _0x25,0
	RCALL _show_msg
; 0000 0078         show_number(i);
	MOV  R26,R10
	RCALL SUBOPT_0x2
; 0000 0079         show_number(EEPROM_read(0x00 + i * 3));
	ADIW R30,0
	RCALL SUBOPT_0x3
; 0000 007A         show_number(EEPROM_read(0x01 + i * 3));
	ADIW R30,1
	RCALL SUBOPT_0x3
; 0000 007B         show_number(EEPROM_read(0x02 + i * 3));
	ADIW R30,2
	MOVW R26,R30
	RCALL _EEPROM_read
	MOV  R26,R30
	RCALL _show_number
; 0000 007C         UDR = '\n';
	LDI  R30,LOW(10)
	OUT  0xC,R30
; 0000 007D         while(!(UCSRA & (1<<UDRE)));
_0x26:
	SBIS 0xB,5
	RJMP _0x26
; 0000 007E 
; 0000 007F     }
	INC  R10
	RJMP _0x23
_0x24:
; 0000 0080 
; 0000 0081 
; 0000 0082 }
	RJMP _0x5F
; .FEND

	.DSEG
_0x25:
	.BYTE 0x2
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0086 {

	.CSEG
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	RCALL SUBOPT_0x1
; 0000 0087     sec++;
	INC  R4
; 0000 0088     if (sec < 59){ //should be 59 for one minute
	LDI  R30,LOW(59)
	CP   R4,R30
	BRSH _0x29
; 0000 0089        // Reinitialize Timer1 value
; 0000 008A         TCNT1H=0x85EE >> 8;
	LDI  R30,LOW(133)
	OUT  0x2D,R30
; 0000 008B         TCNT1L=0x85EE & 0xff;
	LDI  R30,LOW(238)
	OUT  0x2C,R30
; 0000 008C     }else{    // turn off timer
	RJMP _0x2A
_0x29:
; 0000 008D         read_heart = 0;
	CLR  R7
; 0000 008E         state = 0;
	CLR  R11
; 0000 008F         show_number(HR);
	MOV  R26,R6
	RCALL _show_number
; 0000 0090         UDR = '\n';
	LDI  R30,LOW(10)
	OUT  0xC,R30
; 0000 0091         while(!(UCSRA & (1<<UDRE)));
_0x2B:
	SBIS 0xB,5
	RJMP _0x2B
; 0000 0092         show_msg(str_id);
	LDI  R26,LOW(_str_id)
	LDI  R27,HIGH(_str_id)
	RCALL _show_msg
; 0000 0093         TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	LDI  R30,LOW(0)
	OUT  0x2E,R30
; 0000 0094         TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0095         flag = 1;
	LDI  R30,LOW(1)
	MOV  R13,R30
; 0000 0096 
; 0000 0097 
; 0000 0098 
; 0000 0099 
; 0000 009A     }
_0x2A:
; 0000 009B 
; 0000 009C }
_0x5F:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;
;
;
;void send_number (unsigned char number){
; 0000 00A1 void send_number (unsigned char number){
_send_number:
; .FSTART _send_number
; 0000 00A2     if(number == 10){     //Enter      state = 0: ID    state = 1: Age      state = 2:  counting HR
	ST   -Y,R26
;	number -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2E
; 0000 00A3          if (state == 0){
	TST  R11
	BRNE _0x2F
; 0000 00A4             show_msg(str_age);
	LDI  R26,LOW(_str_age)
	LDI  R27,HIGH(_str_age)
	RCALL _show_msg
; 0000 00A5             AGE = 0;
	CLR  R9
; 0000 00A6             state = 1;
	LDI  R30,LOW(1)
	RJMP _0x5E
; 0000 00A7          }else if(state == 1){
_0x2F:
	LDI  R30,LOW(1)
	CP   R30,R11
	BRNE _0x31
; 0000 00A8             // Timer/Counter 1 initialization
; 0000 00A9             // Clock source: System Clock
; 0000 00AA             // Clock value: 31.250 kHz
; 0000 00AB             // Mode: Normal top=0xFFFF
; 0000 00AC             // OC1A output: Disconnected
; 0000 00AD             // OC1B output: Disconnected
; 0000 00AE             // Noise Canceler: Off
; 0000 00AF             // Input Capture on Falling Edge
; 0000 00B0             // Timer Period: 1 s
; 0000 00B1             // Timer1 Overflow Interrupt: On
; 0000 00B2             // Input Capture Interrupt: Off
; 0000 00B3             // Compare A Match Interrupt: Off
; 0000 00B4             // Compare B Match Interrupt: Off
; 0000 00B5             sec = 0;
	CLR  R4
; 0000 00B6             HR = 0;
	CLR  R6
; 0000 00B7             TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 00B8             TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (1<<CS12) | (0<<CS11) | (0<<CS10);
	LDI  R30,LOW(4)
	OUT  0x2E,R30
; 0000 00B9             TCNT1H=0x85;
	LDI  R30,LOW(133)
	OUT  0x2D,R30
; 0000 00BA             TCNT1L=0xEE;
	LDI  R30,LOW(238)
	OUT  0x2C,R30
; 0000 00BB             ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 00BC             ICR1L=0x00;
	OUT  0x26,R30
; 0000 00BD             OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00BE             OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00BF             OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00C0             OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00C1 
; 0000 00C2             // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00C3             TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<OCIE0) | (0<<TOIE ...
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0000 00C4             read_heart = 1;
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 00C5             show_msg(str_HR);
	LDI  R26,LOW(_str_HR)
	LDI  R27,HIGH(_str_HR)
	RCALL _show_msg
; 0000 00C6             state = 2;
	LDI  R30,LOW(2)
_0x5E:
	MOV  R11,R30
; 0000 00C7          }
; 0000 00C8 
; 0000 00C9 
; 0000 00CA     }else if (number == 11){    // Save
_0x31:
	RJMP _0x32
_0x2E:
	LD   R26,Y
	CPI  R26,LOW(0xB)
	BRNE _0x33
; 0000 00CB          EEPROM_write(0x00 + counter * 3,ID);
	RCALL SUBOPT_0x4
	ADIW R30,0
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R8
	RCALL _EEPROM_write
; 0000 00CC          EEPROM_write(0x01 + counter * 3,AGE);
	RCALL SUBOPT_0x4
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R9
	RCALL _EEPROM_write
; 0000 00CD          EEPROM_write(0x02 + counter * 3,HR);
	RCALL SUBOPT_0x4
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R6
	RCALL _EEPROM_write
; 0000 00CE          show_number(ID);
	MOV  R26,R8
	RCALL _show_number
; 0000 00CF          show_number(AGE);
	MOV  R26,R9
	RCALL _show_number
; 0000 00D0          show_number(HR);
	MOV  R26,R6
	RCALL _show_number
; 0000 00D1          show_msg("Saved");
	__POINTW2MN _0x34,0
	RCALL _show_msg
; 0000 00D2          counter++;
	INC  R5
; 0000 00D3 
; 0000 00D4 
; 0000 00D5     }else if ((state == 0) ){
	RJMP _0x35
_0x33:
	TST  R11
	BRNE _0x36
; 0000 00D6         if (flag == 1){
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0x37
; 0000 00D7             ID = 0;
	CLR  R8
; 0000 00D8             flag =0;
	CLR  R13
; 0000 00D9             //show_msg("Clear");
; 0000 00DA         }
; 0000 00DB          ID = ID*10 + number;
_0x37:
	MOV  R30,R8
	LDI  R26,LOW(10)
	MULS R30,R26
	MOVW R30,R0
	LD   R26,Y
	ADD  R30,R26
	MOV  R8,R30
; 0000 00DC          UDR = '0'+number;
	LD   R30,Y
	SUBI R30,-LOW(48)
	OUT  0xC,R30
; 0000 00DD          while(!(UCSRA & (1<<UDRE)));
_0x38:
	SBIS 0xB,5
	RJMP _0x38
; 0000 00DE          //show_number(ID);
; 0000 00DF 
; 0000 00E0     }else if ( (state == 1)){
	RJMP _0x3B
_0x36:
	LDI  R30,LOW(1)
	CP   R30,R11
	BRNE _0x3C
; 0000 00E1          AGE = AGE *10 + number;
	MOV  R30,R9
	LDI  R26,LOW(10)
	MULS R30,R26
	MOVW R30,R0
	LD   R26,Y
	ADD  R30,R26
	MOV  R9,R30
; 0000 00E2          UDR = '0'+number;
	LD   R30,Y
	SUBI R30,-LOW(48)
	OUT  0xC,R30
; 0000 00E3          while(!(UCSRA & (1<<UDRE)));
_0x3D:
	SBIS 0xB,5
	RJMP _0x3D
; 0000 00E4 
; 0000 00E5     }
; 0000 00E6 
; 0000 00E7 }
_0x3C:
_0x3B:
_0x35:
_0x32:
_0x2000001:
	ADIW R28,1
	RET
; .FEND

	.DSEG
_0x34:
	.BYTE 0x6
;
;void GET_KEY (void){
; 0000 00E9 void GET_KEY (void){

	.CSEG
_GET_KEY:
; .FSTART _GET_KEY
; 0000 00EA     key_pressed = 50;   //
	LDI  R30,LOW(50)
	MOV  R12,R30
; 0000 00EB     PORTA=0XFE;
	LDI  R30,LOW(254)
	OUT  0x1B,R30
; 0000 00EC     if(PINB.0==0)
	SBIC 0x16,0
	RJMP _0x40
; 0000 00ED             {
; 0000 00EE             delay_ms(100);
	RCALL SUBOPT_0x5
; 0000 00EF             if(PINB.0==0)
	SBIC 0x16,0
	RJMP _0x41
; 0000 00F0                 {
; 0000 00F1                     //while (PINB.0==0){}
; 0000 00F2                     key_pressed=1;
	LDI  R30,LOW(1)
	MOV  R12,R30
; 0000 00F3                 }
; 0000 00F4             }
_0x41:
; 0000 00F5      if(PINB.1==0)
_0x40:
	SBIC 0x16,1
	RJMP _0x42
; 0000 00F6             {
; 0000 00F7             delay_ms(100);
	RCALL SUBOPT_0x5
; 0000 00F8             if(PINB.1==0)
	SBIC 0x16,1
	RJMP _0x43
; 0000 00F9                 {
; 0000 00FA                     //while (PINB.1==0){}
; 0000 00FB                     key_pressed=4;
	LDI  R30,LOW(4)
	MOV  R12,R30
; 0000 00FC                 }
; 0000 00FD             }
_0x43:
; 0000 00FE 
; 0000 00FF      if(PINB.2==0)
_0x42:
	SBIC 0x16,2
	RJMP _0x44
; 0000 0100             {
; 0000 0101             delay_ms(100);
	RCALL SUBOPT_0x5
; 0000 0102             if(PINB.2==0)
	SBIC 0x16,2
	RJMP _0x45
; 0000 0103                 {
; 0000 0104                     //while (PINB.2==0){}
; 0000 0105                     key_pressed=7;
	LDI  R30,LOW(7)
	MOV  R12,R30
; 0000 0106                 }
; 0000 0107             }
_0x45:
; 0000 0108 
; 0000 0109      if(PINB.3==0)
_0x44:
	SBIC 0x16,3
	RJMP _0x46
; 0000 010A             {
; 0000 010B             delay_ms(100);
	RCALL SUBOPT_0x5
; 0000 010C             if(PINB.3==0)
	SBIC 0x16,3
	RJMP _0x47
; 0000 010D                 {
; 0000 010E                     //while (PINB.3==0){}
; 0000 010F                     key_pressed=10;  //      *
	LDI  R30,LOW(10)
	MOV  R12,R30
; 0000 0110                 }
; 0000 0111             }
_0x47:
; 0000 0112 
; 0000 0113 
; 0000 0114 
; 0000 0115       PORTA=0XFD;
_0x46:
	LDI  R30,LOW(253)
	OUT  0x1B,R30
; 0000 0116       if(PINB.0==0)
	SBIC 0x16,0
	RJMP _0x48
; 0000 0117             {
; 0000 0118             delay_ms(100);
	RCALL SUBOPT_0x5
; 0000 0119             if(PINB.0==0)
	SBIC 0x16,0
	RJMP _0x49
; 0000 011A                 {
; 0000 011B                     //while (PINB.0==0){}
; 0000 011C                     key_pressed=2;
	LDI  R30,LOW(2)
	MOV  R12,R30
; 0000 011D                 }
; 0000 011E             }
_0x49:
; 0000 011F      if(PINB.1==0)
_0x48:
	SBIC 0x16,1
	RJMP _0x4A
; 0000 0120             {
; 0000 0121             delay_ms(100);
	RCALL SUBOPT_0x5
; 0000 0122             if(PINB.1==0)
	SBIC 0x16,1
	RJMP _0x4B
; 0000 0123                 {
; 0000 0124                     //while (PINB.1==0){}
; 0000 0125                     key_pressed=5;
	LDI  R30,LOW(5)
	MOV  R12,R30
; 0000 0126                 }
; 0000 0127             }
_0x4B:
; 0000 0128 
; 0000 0129      if(PINB.2==0)
_0x4A:
	SBIC 0x16,2
	RJMP _0x4C
; 0000 012A             {
; 0000 012B             delay_ms(100);
	RCALL SUBOPT_0x5
; 0000 012C             if(PINB.2==0)
	SBIC 0x16,2
	RJMP _0x4D
; 0000 012D                 {
; 0000 012E                     //while (PINB.2==0){}
; 0000 012F                     key_pressed=8;
	LDI  R30,LOW(8)
	MOV  R12,R30
; 0000 0130                 }
; 0000 0131             }
_0x4D:
; 0000 0132 
; 0000 0133      if(PINB.3==0)
_0x4C:
	SBIC 0x16,3
	RJMP _0x4E
; 0000 0134             {
; 0000 0135             delay_ms(100);
	RCALL SUBOPT_0x5
; 0000 0136             if(PINB.3==0)
	SBIS 0x16,3
; 0000 0137                 {
; 0000 0138                     //while (PINB.2==0){}
; 0000 0139                     key_pressed=0;
	CLR  R12
; 0000 013A                 }
; 0000 013B             }
; 0000 013C 
; 0000 013D       PORTA=0XFB;
_0x4E:
	LDI  R30,LOW(251)
	OUT  0x1B,R30
; 0000 013E       if(PINB.0==0)
	SBIC 0x16,0
	RJMP _0x50
; 0000 013F             {
; 0000 0140             delay_ms(100);
	RCALL SUBOPT_0x5
; 0000 0141             if(PINB.0==0)
	SBIC 0x16,0
	RJMP _0x51
; 0000 0142                 {
; 0000 0143                     //while (PINB.0==0){}
; 0000 0144                     key_pressed=3;
	LDI  R30,LOW(3)
	MOV  R12,R30
; 0000 0145                 }
; 0000 0146             }
_0x51:
; 0000 0147      if(PINB.1==0)
_0x50:
	SBIC 0x16,1
	RJMP _0x52
; 0000 0148             {
; 0000 0149             delay_ms(100);
	RCALL SUBOPT_0x5
; 0000 014A             if(PINB.1==0)
	SBIC 0x16,1
	RJMP _0x53
; 0000 014B                 {
; 0000 014C                     //while (PINB.1==0){}
; 0000 014D                     key_pressed=6;
	LDI  R30,LOW(6)
	MOV  R12,R30
; 0000 014E                 }
; 0000 014F             }
_0x53:
; 0000 0150 
; 0000 0151      if(PINB.2==0)
_0x52:
	SBIC 0x16,2
	RJMP _0x54
; 0000 0152             {
; 0000 0153             delay_ms(100);
	RCALL SUBOPT_0x5
; 0000 0154             if(PINB.2==0)
	SBIC 0x16,2
	RJMP _0x55
; 0000 0155                 {
; 0000 0156                     //while (PINB.2==0){}
; 0000 0157                     key_pressed=9;
	LDI  R30,LOW(9)
	MOV  R12,R30
; 0000 0158                 }
; 0000 0159             }
_0x55:
; 0000 015A 
; 0000 015B      if(PINB.3==0)
_0x54:
	SBIC 0x16,3
	RJMP _0x56
; 0000 015C             {
; 0000 015D             delay_ms(100);
	RCALL SUBOPT_0x5
; 0000 015E             if(PINB.3==0)
	SBIC 0x16,3
	RJMP _0x57
; 0000 015F                 {
; 0000 0160                    // while (PINB.3==0){}
; 0000 0161                     key_pressed=11;   //     #
	LDI  R30,LOW(11)
	MOV  R12,R30
; 0000 0162                 }
; 0000 0163             }
_0x57:
; 0000 0164        if(key_pressed!=50){
_0x56:
	LDI  R30,LOW(50)
	CP   R30,R12
	BREQ _0x58
; 0000 0165        send_number(key_pressed);  }
	MOV  R26,R12
	RCALL _send_number
; 0000 0166        PORTA=0XF0;
_0x58:
	LDI  R30,LOW(240)
	OUT  0x1B,R30
; 0000 0167 
; 0000 0168 
; 0000 0169 
; 0000 016A }
	RET
; .FEND
;
;void main(void)
; 0000 016D {
_main:
; .FSTART _main
; 0000 016E // Declare your local variables here
; 0000 016F 
; 0000 0170 // Input/Output Ports initialization
; 0000 0171 // Port A initialization
; 0000 0172 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=Out Bit0=Out
; 0000 0173 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
	LDI  R30,LOW(7)
	OUT  0x1A,R30
; 0000 0174 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=0 Bit1=0 Bit0=0
; 0000 0175 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0176 
; 0000 0177 // Port B initialization
; 0000 0178 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0179 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 017A // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=P Bit2=P Bit1=P Bit0=P
; 0000 017B PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (1<<PORTB3) | (1<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);
	LDI  R30,LOW(15)
	OUT  0x18,R30
; 0000 017C 
; 0000 017D // Port C initialization
; 0000 017E // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 017F DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 0180 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0181 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 0182 
; 0000 0183 // Port D initialization
; 0000 0184 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=Out Bit0=In
; 0000 0185 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (1<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(2)
	OUT  0x11,R30
; 0000 0186 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=P Bit1=0 Bit0=T
; 0000 0187 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(12)
	OUT  0x12,R30
; 0000 0188 
; 0000 0189 
; 0000 018A // External Interrupt(s) initialization
; 0000 018B // INT0: On
; 0000 018C // INT0 Mode: Falling Edge
; 0000 018D // INT1: On
; 0000 018E // INT1 Mode: Falling Edge
; 0000 018F // INT2: Off
; 0000 0190 GICR|=(1<<INT1) | (1<<INT0) | (0<<INT2);
	IN   R30,0x3B
	ORI  R30,LOW(0xC0)
	OUT  0x3B,R30
; 0000 0191 MCUCR=(1<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(10)
	OUT  0x35,R30
; 0000 0192 MCUCSR=(0<<ISC2);
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 0193 GIFR=(1<<INTF1) | (1<<INTF0) | (0<<INTF2);
	LDI  R30,LOW(192)
	OUT  0x3A,R30
; 0000 0194 
; 0000 0195 
; 0000 0196 // USART initialization
; 0000 0197 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0198 // USART Receiver: Off
; 0000 0199 // USART Transmitter: On
; 0000 019A // USART Mode: Asynchronous
; 0000 019B // USART Baud Rate: 9600
; 0000 019C UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 019D UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(8)
	OUT  0xA,R30
; 0000 019E UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 019F UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 01A0 UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 01A1 
; 0000 01A2 // Global enable interrupts
; 0000 01A3 #asm("sei")
	sei
; 0000 01A4 show_msg(str_id);
	LDI  R26,LOW(_str_id)
	LDI  R27,HIGH(_str_id)
	RCALL _show_msg
; 0000 01A5 while (1)
_0x59:
; 0000 01A6       {
; 0000 01A7       if ((PINB&0x0F) != 0x0F){
	IN   R30,0x16
	ANDI R30,LOW(0xF)
	CPI  R30,LOW(0xF)
	BREQ _0x5C
; 0000 01A8             GET_KEY();
	RCALL _GET_KEY
; 0000 01A9             //PORTA.4 = ~PORTA.4;
; 0000 01AA             delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0000 01AB       }
; 0000 01AC       }
_0x5C:
	RJMP _0x59
; 0000 01AD }
_0x5D:
	RJMP _0x5D
; .FEND

	.DSEG
_str_id:
	.BYTE 0x9
_str_age:
	.BYTE 0xA
_str_HR:
	.BYTE 0xB
_temp:
	.BYTE 0x3

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LD   R26,Y
	LDD  R27,Y+1
	CLR  R30
	ADD  R26,R10
	ADC  R27,R30
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	RCALL _show_number
	MOV  R26,R10
	LDI  R30,LOW(3)
	MUL  R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	MOVW R26,R30
	RCALL _EEPROM_read
	MOV  R26,R30
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	MOV  R26,R5
	LDI  R30,LOW(3)
	MUL  R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x5:
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
