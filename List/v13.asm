
;CodeVisionAVR C Compiler V3.40 Advanced
;(C) Copyright 1998-2020 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Release
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 11,059200 MHz
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
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Mode 1
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

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
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
	CALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETD1Z
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
	CALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETD2X
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
	.DEF _hitung=R4
	.DEF _hitung_msb=R5
	.DEF _nadc7=R6
	.DEF _nadc7_msb=R7
	.DEF _i=R8
	.DEF _i_msb=R9
	.DEF _k=R10
	.DEF _k_msb=R11
	.DEF _pos_servo1=R13
	.DEF _pos_servo2=R12

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
	JMP  _timer0_comp_isr
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

_0x6:
	.DB  0xA
_0x7:
	.DB  0x64
_0x8:
	.DB  0xC8
_0x9:
	.DB  0x60,0xFF
_0xA:
	.DB  0xC8
_0xB:
	.DB  0xDC
_0xC:
	.DB  0x50
_0xD:
	.DB  0xA0
_0xE:
	.DB  0xAA
_0xF:
	.DB  0x5
_0x10:
	.DB  0x55
_0x0:
	.DB  0x25,0x64,0x25,0x64,0x25,0x64,0x25,0x64
	.DB  0x25,0x64,0x25,0x64,0x25,0x64,0x0,0x42
	.DB  0x61,0x63,0x61,0x20,0x4C,0x69,0x6E,0x65
	.DB  0x0,0x73,0x65,0x6E,0x73,0x6F,0x72,0x3A
	.DB  0x25,0x64,0x20,0x3D,0x20,0x25,0x64,0x20
	.DB  0x20,0x0,0x42,0x61,0x63,0x61,0x20,0x42
	.DB  0x61,0x63,0x6B,0x67,0x72,0x6F,0x75,0x6E
	.DB  0x64,0x0,0x43,0x65,0x6E,0x74,0x65,0x72
	.DB  0x20,0x50,0x6F,0x69,0x6E,0x74,0x20,0x20
	.DB  0x20,0x20,0x0,0x73,0x65,0x6E,0x73,0x6F
	.DB  0x72,0x3A,0x25,0x64,0x20,0x2D,0x2D,0x3E
	.DB  0x20,0x25,0x64,0x20,0x20,0x0,0x25,0x64
	.DB  0x20,0x20,0x20,0x0,0x4D,0x65,0x6E,0x75
	.DB  0x0,0x43,0x61,0x6C,0x69,0x62,0x72,0x61
	.DB  0x74,0x69,0x6F,0x6E,0x0,0x52,0x75,0x6E
	.DB  0x20,0x42,0x6F,0x74,0x0,0x53,0x65,0x6E
	.DB  0x73,0x20,0x57,0x61,0x72,0x6E,0x61,0x0
	.DB  0x4D,0x61,0x70,0x20,0x42,0x69,0x72,0x75
	.DB  0x0,0x4D,0x61,0x70,0x20,0x4D,0x65,0x72
	.DB  0x61,0x68,0x0,0x4D,0x6F,0x74,0x6F,0x72
	.DB  0x0,0x42,0x75,0x74,0x74,0x6F,0x6E,0x0
	.DB  0x43,0x61,0x70,0x69,0x74,0x0,0x43,0x6C
	.DB  0x69,0x63,0x6B,0x20,0x32,0x20,0x74,0x6F
	.DB  0x20,0x73,0x74,0x61,0x72,0x74,0x0,0x52
	.DB  0x75,0x6E,0x6E,0x69,0x6E,0x67,0x2E,0x2E
	.DB  0x2E,0x0,0x54,0x65,0x73,0x74,0x20,0x4D
	.DB  0x6F,0x74,0x6F,0x72,0x0,0x2B,0x31,0x30
	.DB  0x30,0x20,0x2B,0x31,0x30,0x30,0x0,0x2D
	.DB  0x31,0x30,0x30,0x20,0x2D,0x31,0x30,0x30
	.DB  0x0,0x2B,0x31,0x30,0x30,0x20,0x2D,0x31
	.DB  0x30,0x30,0x0,0x2D,0x31,0x30,0x30,0x20
	.DB  0x2B,0x31,0x30,0x30,0x0,0x43,0x6C,0x69
	.DB  0x63,0x6B,0x20,0x31,0x20,0x74,0x6F,0x20
	.DB  0x65,0x78,0x69,0x74,0x0,0x74,0x6F,0x6D
	.DB  0x62,0x6F,0x6C,0x20,0x3D,0x20,0x31,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0x74,0x6F,0x6D
	.DB  0x62,0x6F,0x6C,0x20,0x3D,0x20,0x32,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0x74,0x6F,0x6D
	.DB  0x62,0x6F,0x6C,0x20,0x3D,0x20,0x33,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0x74,0x6F,0x6D
	.DB  0x62,0x6F,0x6C,0x20,0x3D,0x20,0x34,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0x57,0x61,0x72
	.DB  0x6E,0x61,0x3A,0x0,0x45,0x78,0x69,0x74
	.DB  0x69,0x6E,0x67,0x2E,0x2E,0x2E,0x0,0x54
	.DB  0x65,0x73,0x74,0x20,0x43,0x61,0x70,0x69
	.DB  0x74,0x0,0x43,0x61,0x70,0x69,0x74,0x3A
	.DB  0x20,0x3E,0x20,0x3C,0x0,0x43,0x61,0x70
	.DB  0x69,0x74,0x3A,0x20,0x3C,0x20,0x3E,0x0
	.DB  0x43,0x61,0x70,0x69,0x74,0x3A,0x20,0x5C
	.DB  0x2F,0x0,0x43,0x61,0x70,0x69,0x74,0x3A
	.DB  0x20,0x2F,0x5C,0x0,0x48,0x6F,0x6C,0x64
	.DB  0x20,0x31,0x20,0x74,0x6F,0x20,0x65,0x78
	.DB  0x69,0x74,0x0,0x58,0x44,0x0,0x20,0x20
	.DB  0x20,0x20,0x20,0x4C,0x45,0x47,0x49,0x4F
	.DB  0x4E,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x4D,0x41,0x4E,0x20,0x34,0x20,0x4A,0x4F
	.DB  0x4D,0x42,0x41,0x4E,0x47,0x20,0x0
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2060003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _kp
	.DW  _0x6*2

	.DW  0x01
	.DW  _kd
	.DW  _0x7*2

	.DW  0x01
	.DW  _SPEED
	.DW  _0x8*2

	.DW  0x02
	.DW  _MIN_SPEED
	.DW  _0x9*2

	.DW  0x01
	.DW  _MAX_SPEED
	.DW  _0xA*2

	.DW  0x01
	.DW  _maxHijau
	.DW  _0xB*2

	.DW  0x01
	.DW  _maxKuning
	.DW  _0xC*2

	.DW  0x01
	.DW  _maxMerah
	.DW  _0xD*2

	.DW  0x01
	.DW  _minHijau
	.DW  _0xE*2

	.DW  0x01
	.DW  _minKuning
	.DW  _0xF*2

	.DW  0x01
	.DW  _minMerah
	.DW  _0x10*2

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

	.DW  0x02
	.DW  __base_y_G103
	.DW  _0x2060003*2

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

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

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
	.ORG 0x00

	.DSEG
	.ORG 0x260

	.CSEG
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
   .equ __lcd_port=0x18 ;PORTB
; 0000 002F #endasm
;unsigned char read_adc(unsigned char adc_input)
; 0000 0036 {

	.CSEG
_read_adc:
; .FSTART _read_adc
; 0000 0037 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,LOW(0x60)
	OUT  0x7,R30
; 0000 0038 // Start the AD conversion
; 0000 0039 ADCSRA|=0x40;
	SBI  0x6,6
; 0000 003A // Wait for the AD conversion to complete
; 0000 003B while ((ADCSRA & 0x10)==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 003C ADCSRA|=0x10;
	SBI  0x6,4
; 0000 003D return ADCH;
	IN   R30,0x5
	ADIW R28,1
	RET
; 0000 003E }
; .FEND
;int hitung = 0;
;unsigned int nadc7 = 0;
;char buff[33];
;int i, k;
;unsigned char pos_servo1, pos_servo2, a;
;int count_btn = 0;
;int count_child_btn = 0;
;bool isChildSelect = false;
;bool isTestTombol = false;
;eeprom int garis[7], back[7], tengah[7];
;char sen[7];
;int sensor;
;int error = 0;
;int lastError = 0;
;int kp = 10;

	.DSEG
;int kd = 100;
;int SPEED = 200;
;int MIN_SPEED = -160;
;int MAX_SPEED = 200;
;int count = 0;
;int second = 0;
;int positionD = 0;
;eeprom int mapMirror; // 0 - map/lintasan bagian biru, 1 - map/lintasan bagian m ...
;int maxHijau = 220;
;int maxKuning = 80;
;int maxMerah = 160;
;int minHijau = 170;
;int minKuning = 5;
;int minMerah = 85;
;void delay(int ms)
; 0000 0060 {

	.CSEG
_delay:
; .FSTART _delay
;delay_ms(ms);
	ST   -Y,R27
	ST   -Y,R26
;	ms -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	CALL _delay_ms
	RJMP _0x20C000F
; .FEND
;void lcd_kedip(int ulangi)
;for(i = 0; i < ulangi; i++)
;	ulangi -> Y+0
;lampu=0;
;delay_ms(100);
;lampu=1;
;delay_ms(100);
;void konvert_logic()
; 0000 0061 {
_konvert_logic:
; .FSTART _konvert_logic
;for(i = 0; i < 7; i++)
	CLR  R8
	CLR  R9
_0x19:
	CALL SUBOPT_0x0
	BRGE _0x1A
;if(read_adc(i) > tengah[i]) {
	CALL SUBOPT_0x1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x1B
;sen[i]=1;
	LDI  R26,LOW(_sen)
	LDI  R27,HIGH(_sen)
	ADD  R26,R8
	ADC  R27,R9
	LDI  R30,LOW(1)
	RJMP _0x17C
;else if(read_adc(i) < tengah[i]) {
_0x1B:
	CALL SUBOPT_0x1
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x1D
;sen[i]=0;
	LDI  R26,LOW(_sen)
	LDI  R27,HIGH(_sen)
	ADD  R26,R8
	ADC  R27,R9
	LDI  R30,LOW(0)
_0x17C:
	ST   X,R30
_0x1D:
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	RJMP _0x19
_0x1A:
	RET
; .FEND
;void logika()
_logika:
; .FSTART _logika
;sensor = (sen[6] * 64) + (sen[5] * 32) + (sen[4] * 16) + (sen[3] * 8) + (sen[2]  ...
	__GETB2MN _sen,6
	LDI  R30,LOW(64)
	MUL  R30,R26
	MOVW R22,R0
	__GETB2MN _sen,5
	LDI  R30,LOW(32)
	CALL SUBOPT_0x2
	__GETB2MN _sen,4
	LDI  R30,LOW(16)
	CALL SUBOPT_0x2
	__GETB2MN _sen,3
	LDI  R30,LOW(8)
	CALL SUBOPT_0x2
	__GETB2MN _sen,2
	LDI  R30,LOW(4)
	CALL SUBOPT_0x2
	__GETB2MN _sen,1
	LDI  R30,LOW(2)
	CALL SUBOPT_0x2
	LDS  R26,_sen
	LDI  R30,LOW(1)
	MUL  R30,R26
	MOVW R30,R0
	ADD  R30,R22
	ADC  R31,R23
	STS  _sensor,R30
	STS  _sensor+1,R31
	RET
; .FEND
;void cek_sensor()
_cek_sensor:
; .FSTART _cek_sensor
;konvert_logic();
	RCALL _konvert_logic
;logika();
	RCALL _logika
	RET
; .FEND
;void display_sensor()
_display_sensor:
; .FSTART _display_sensor
;konvert_logic();
	RCALL _konvert_logic
;lcd_gotoxy(9, 0);
	LDI  R30,LOW(9)
	CALL SUBOPT_0x3
;sprintf(buff, "%d%d%d%d%d%d%d", sen[0] , sen[1] , sen[2], sen[3], sen[4], sen[5] ...
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_sen
	CALL SUBOPT_0x5
	__GETB1MN _sen,1
	CALL SUBOPT_0x5
	__GETB1MN _sen,2
	CALL SUBOPT_0x5
	__GETB1MN _sen,3
	CALL SUBOPT_0x5
	__GETB1MN _sen,4
	CALL SUBOPT_0x5
	__GETB1MN _sen,5
	CALL SUBOPT_0x5
	__GETB1MN _sen,6
	CALL SUBOPT_0x5
	LDI  R24,28
	CALL _sprintf
	ADIW R28,32
;lcd_puts(buff);
	RJMP _0x20C000E
; .FEND
;void scan_garis()
_scan_garis:
; .FSTART _scan_garis
;for (i = 0; i < 7; i++)
	CLR  R8
	CLR  R9
_0x1F:
	CALL SUBOPT_0x0
	BRGE _0x20
;garis[i] = read_adc(i);
	CALL SUBOPT_0x6
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	MOV  R26,R8
	RCALL _read_adc
	POP  R26
	POP  R27
	CALL SUBOPT_0x7
;lcd_gotoxy(0, 0);
;lcd_putsf("Baca Line");
	__POINTW2FN _0x0,15
	CALL SUBOPT_0x8
;lcd_gotoxy(0, 1);
;sprintf(buff, "sensor:%d = %d  ", i, garis[i]);
	CALL SUBOPT_0x9
	CALL SUBOPT_0x6
	CALL SUBOPT_0xA
;lcd_puts(buff);
;lampu = 0;
;delay_ms(10);
;lampu = 1;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	RJMP _0x1F
_0x20:
	RET
; .FEND
;void scan_back()
_scan_back:
; .FSTART _scan_back
;for (i = 0; i < 7; i++)
	CLR  R8
	CLR  R9
_0x26:
	CALL SUBOPT_0x0
	BRGE _0x27
;back[i] = read_adc(i);
	CALL SUBOPT_0xB
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	MOV  R26,R8
	RCALL _read_adc
	POP  R26
	POP  R27
	CALL SUBOPT_0x7
;lcd_gotoxy(0, 0);
;lcd_putsf("Baca Background");
	__POINTW2FN _0x0,42
	CALL SUBOPT_0x8
;lcd_gotoxy(0, 1);
;sprintf(buff, "sensor:%d = %d  ", i, back[i]);
	CALL SUBOPT_0x9
	CALL SUBOPT_0xB
	CALL SUBOPT_0xA
;lcd_puts(buff);
;lampu = 0;
;delay_ms(10);
;lampu = 1;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	RJMP _0x26
_0x27:
	RET
; .FEND
;void hit_tengah()
_hit_tengah:
; .FSTART _hit_tengah
;for (i = 0; i < 7; i++)
	CLR  R8
	CLR  R9
_0x2D:
	CALL SUBOPT_0x0
	BRLT PC+2
	RJMP _0x2E
;tengah[i] = (back[i] + garis[i]) / 2;
	MOVW R30,R8
	LDI  R26,LOW(_tengah)
	LDI  R27,HIGH(_tengah)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
	MOVW R0,R30
	CALL SUBOPT_0x6
	CALL SUBOPT_0xC
	MOVW R26,R0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	MOVW R26,R22
	CALL __EEPROMWRW
;lcd_gotoxy(0, 0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x3
;lcd_putsf("Center Point    ");
	__POINTW2FN _0x0,58
	CALL SUBOPT_0x8
;lcd_gotoxy(0, 1);
;sprintf(buff, "sensor:%d --> %d  ", i, tengah[i]);
	__POINTW1FN _0x0,75
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R8
	CALL SUBOPT_0xD
	MOVW R30,R8
	LDI  R26,LOW(_tengah)
	LDI  R27,HIGH(_tengah)
	LSL  R30
	ROL  R31
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
;lcd_puts(buff);
	LDI  R26,LOW(_buff)
	LDI  R27,HIGH(_buff)
	CALL _lcd_puts
;lampu = 0;
	CBI  0x18,3
;lampu = 1;
	SBI  0x18,3
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	RJMP _0x2D
_0x2E:
	RET
; .FEND
;void cekdatasensor()
;for (i = 0; i < 7; i++)
;lcd_gotoxy(0, 0);
;sprintf(buff, " %d  ", garis[i]);
;lcd_puts(buff);
;lcd_gotoxy(10, 0);
;sprintf(buff, " %d  ", back[i]);
;lcd_puts(buff);
;lcd_gotoxy(0, 1);
;sprintf(buff, " %d  ", tengah[i]);
;lcd_puts(buff);
;lcd_gotoxy(10, 1);
;sprintf(buff, " %d  ", read_adc(i));
;lcd_puts(buff);
;delay_ms(200);
;void maju(unsigned char ki, unsigned char ka)
; 0000 0062 {
_maju:
; .FSTART _maju
;pwmka = ka;
	CALL SUBOPT_0xE
;	ki -> Y+1
;	ka -> Y+0
;pwmki = ki;
;PORTD.2 = 1;
	SBI  0x12,2
;PORTD.3 = 0;
	CBI  0x12,3
;PORTD.6 = 0;
	CBI  0x12,6
;PORTD.7 = 1;
	SBI  0x12,7
	RJMP _0x20C000F
; .FEND
;void mundur(unsigned char ki, unsigned char ka)
_mundur:
; .FSTART _mundur
;pwmka = ka;
	CALL SUBOPT_0xE
;	ki -> Y+1
;	ka -> Y+0
;pwmki = ki;
;PORTD.2 = 0;
	CBI  0x12,2
;PORTD.3 = 1;
	SBI  0x12,3
;PORTD.6 = 1;
	SBI  0x12,6
;PORTD.7 = 0;
	CBI  0x12,7
	RJMP _0x20C000F
; .FEND
;void kanan(unsigned char ki, unsigned char ka)
_kanan:
; .FSTART _kanan
;pwmka = ka;
	CALL SUBOPT_0xE
;	ki -> Y+1
;	ka -> Y+0
;pwmki = ki;
;PORTD.2 = 0;
	CBI  0x12,2
;PORTD.3 = 1;
	SBI  0x12,3
;PORTD.6 = 0;
	CBI  0x12,6
;PORTD.7 = 1;
	SBI  0x12,7
	RJMP _0x20C000F
; .FEND
;void kiri(unsigned char ki, unsigned char ka)
_kiri:
; .FSTART _kiri
;pwmka = ka;
	CALL SUBOPT_0xE
;	ki -> Y+1
;	ka -> Y+0
;pwmki = ki;
;PORTD.2 = 1;
	SBI  0x12,2
;PORTD.3 = 0;
	CBI  0x12,3
;PORTD.6 = 1;
	SBI  0x12,6
;PORTD.7 = 0;
	CBI  0x12,7
	RJMP _0x20C000F
; .FEND
;void setMotor(int ki, int ka)
_setMotor:
; .FSTART _setMotor
;if (ki > 0)
	ST   -Y,R27
	ST   -Y,R26
;	ki -> Y+2
;	ka -> Y+0
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __CPW02
	BRGE _0x56
;PORTD.2 = 1;
	SBI  0x12,2
;PORTD.3 = 0;
	CBI  0x12,3
;else
	RJMP _0x5B
_0x56:
;PORTD.2 = 0;
	CBI  0x12,2
;PORTD.3 = 1;
	SBI  0x12,3
;ki = abs(ki);
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL _abs
	STD  Y+2,R30
	STD  Y+2+1,R31
_0x5B:
;pwmki = ki;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	OUT  0x2A+1,R31
	OUT  0x2A,R30
;if (ka > 0)
	CALL SUBOPT_0xF
	BRGE _0x60
;PORTD.7 = 1;
	SBI  0x12,7
;PORTD.6 = 0;
	CBI  0x12,6
;else
	RJMP _0x65
_0x60:
;PORTD.7 = 0;
	CBI  0x12,7
;PORTD.6 = 1;
	SBI  0x12,6
;ka = abs(ka);
	LD   R26,Y
	LDD  R27,Y+1
	CALL _abs
	ST   Y,R30
	STD  Y+1,R31
_0x65:
;pwmka = ka;
	LD   R30,Y
	LDD  R31,Y+1
	OUT  0x28+1,R31
	OUT  0x28,R30
	RJMP _0x20C0010
; .FEND
;void rem(int nilai_rem)
_rem:
; .FSTART _rem
;PORTD .4 = 1;
	ST   -Y,R27
	ST   -Y,R26
;	nilai_rem -> Y+0
	SBI  0x12,4
;PORTD .5 = 1;
	SBI  0x12,5
;PORTD .2 = 0;
	CBI  0x12,2
;PORTD .3 = 0;
	CBI  0x12,3
;PORTD .6 = 0;
	CBI  0x12,6
;PORTD .7 = 0;
	CBI  0x12,7
;delay_ms(nilai_rem);
	LD   R26,Y
	LDD  R27,Y+1
	CALL _delay_ms
	RJMP _0x20C000F
; .FEND
;void maju_delay(int kec, int lama)
_maju_delay:
; .FSTART _maju_delay
;maju(kec, kec);
	ST   -Y,R27
	ST   -Y,R26
;	kec -> Y+2
;	lama -> Y+0
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R26,Y+3
	RCALL _maju
;delay(lama);
	CALL SUBOPT_0x10
	RJMP _0x20C0010
; .FEND
;void pilihSpeed(int kec)
_pilihSpeed:
; .FSTART _pilihSpeed
;kp = kec * 0.15;
	ST   -Y,R27
	ST   -Y,R26
;	kec -> Y+0
	CALL SUBOPT_0x11
	__GETD2N 0x3E19999A
	CALL __MULF12
	LDI  R26,LOW(_kp)
	LDI  R27,HIGH(_kp)
	CALL SUBOPT_0x12
;kd = kec * 0.6;
	CALL SUBOPT_0x11
	__GETD2N 0x3F19999A
	CALL __MULF12
	LDI  R26,LOW(_kd)
	LDI  R27,HIGH(_kd)
	CALL SUBOPT_0x12
;SPEED = kec;
	LD   R30,Y
	LDD  R31,Y+1
	STS  _SPEED,R30
	STS  _SPEED+1,R31
;MIN_SPEED = -(kec * 0.75);
	CALL SUBOPT_0x11
	__GETD2N 0x3F400000
	CALL __MULF12
	CALL __ANEGF1
	LDI  R26,LOW(_MIN_SPEED)
	LDI  R27,HIGH(_MIN_SPEED)
	CALL SUBOPT_0x12
;MAX_SPEED = kec;
	LD   R30,Y
	LDD  R31,Y+1
	STS  _MAX_SPEED,R30
	STS  _MAX_SPEED+1,R31
	RJMP _0x20C000F
; .FEND
;void maju_cari_garis()
;maju(180, 182);
;cek_sensor(); // 0b01000000)!=0b00000000)
;while ((sensor & 0b00000001) != 0b00000000)
;cek_sensor();
;rem(100);
;void parkir()
_parkir:
; .FSTART _parkir
;lampu = 0;
	CBI  0x18,3
;while (1)
_0x7B:
;rem(100);
	CALL SUBOPT_0x13
	RJMP _0x7B
; .FEND
;void scan(int kec)
_scan:
; .FSTART _scan
;int rateError;
;int moveVal, moveLeft, moveRight;
;pilihSpeed(kec);
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,2
	CALL __SAVELOCR6
;	kec -> Y+8
;	rateError -> R16,R17
;	moveVal -> R18,R19
;	moveLeft -> R20,R21
;	moveRight -> Y+6
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	RCALL _pilihSpeed
;sensor = sensor & 0b01111111;
	CALL SUBOPT_0x14
	ANDI R30,LOW(0x7F)
	ANDI R31,HIGH(0x7F)
	STS  _sensor,R30
	STS  _sensor+1,R31
;switch (sensor) //  1=kiri 8=kanan
	CALL SUBOPT_0x14
;{               //  7......1
;case 0b00000001:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x81
;error = -6;
	LDI  R30,LOW(65530)
	LDI  R31,HIGH(65530)
	RJMP _0x17D
;break; // DOMINAN KANAN
;case 0b00000011:
_0x81:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x82
;error = -5;
	LDI  R30,LOW(65531)
	LDI  R31,HIGH(65531)
	RJMP _0x17D
;break;
;case 0b00000010:
_0x82:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x83
;error = -4;
	LDI  R30,LOW(65532)
	LDI  R31,HIGH(65532)
	RJMP _0x17D
;break;
;case 0b00000110:
_0x83:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x84
;error = -3;
	LDI  R30,LOW(65533)
	LDI  R31,HIGH(65533)
	RJMP _0x17D
;break;
;case 0b00000100:
_0x84:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x85
;error = -2;
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	RJMP _0x17D
;break;
;case 0b00001100:
_0x85:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x86
;error = -1;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x17D
;break;
;case 0b00001000:
_0x86:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x87
;error = 0;
	LDI  R30,LOW(0)
	STS  _error,R30
	STS  _error+1,R30
;break;
	RJMP _0x80
;case 0b00011000:
_0x87:
	CPI  R30,LOW(0x18)
	LDI  R26,HIGH(0x18)
	CPC  R31,R26
	BRNE _0x88
;error = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x17D
;break;
;case 0b00010000:
_0x88:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0x89
;error = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x17D
;break;
;case 0b00110000:
_0x89:
	CPI  R30,LOW(0x30)
	LDI  R26,HIGH(0x30)
	CPC  R31,R26
	BRNE _0x8A
;error = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP _0x17D
;break;
;case 0b00100000:
_0x8A:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0x8B
;error = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RJMP _0x17D
;break;
;case 0b01100000:
_0x8B:
	CPI  R30,LOW(0x60)
	LDI  R26,HIGH(0x60)
	CPC  R31,R26
	BRNE _0x8C
;error = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RJMP _0x17D
;break;
;case 0b01000000:
_0x8C:
	CPI  R30,LOW(0x40)
	LDI  R26,HIGH(0x40)
	CPC  R31,R26
	BRNE _0x80
;error = 6;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
_0x17D:
	STS  _error,R30
	STS  _error+1,R31
;break; // DOMINAN KIRI
_0x80:
;rateError = error - lastError;
	LDS  R26,_lastError
	LDS  R27,_lastError+1
	LDS  R30,_error
	LDS  R31,_error+1
	SUB  R30,R26
	SBC  R31,R27
	MOVW R16,R30
;lastError = error;
	LDS  R30,_error
	LDS  R31,_error+1
	STS  _lastError,R30
	STS  _lastError+1,R31
;moveVal = (int)(error * kp) + (rateError * kd);
	LDS  R30,_kp
	LDS  R31,_kp+1
	LDS  R26,_error
	LDS  R27,_error+1
	CALL __MULW12
	MOVW R22,R30
	LDS  R30,_kd
	LDS  R31,_kd+1
	MOVW R26,R16
	CALL __MULW12
	ADD  R30,R22
	ADC  R31,R23
	MOVW R18,R30
;moveLeft = SPEED + moveVal;
	LDS  R26,_SPEED
	LDS  R27,_SPEED+1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R20,R30
;moveRight = SPEED - moveVal;
	LDS  R30,_SPEED
	LDS  R31,_SPEED+1
	SUB  R30,R18
	SBC  R31,R19
	STD  Y+6,R30
	STD  Y+6+1,R31
;if (moveLeft > MAX_SPEED)
	CALL SUBOPT_0x15
	CP   R30,R20
	CPC  R31,R21
	BRGE _0x8E
;moveLeft = MAX_SPEED;
	__GETWRMN 20,21,0,_MAX_SPEED
;if (moveLeft < MIN_SPEED)
_0x8E:
	CALL SUBOPT_0x16
	CP   R20,R30
	CPC  R21,R31
	BRGE _0x8F
;moveLeft = MIN_SPEED;
	__GETWRMN 20,21,0,_MIN_SPEED
;if (moveRight > MAX_SPEED)
_0x8F:
	CALL SUBOPT_0x15
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x90
;moveRight = MAX_SPEED;
	CALL SUBOPT_0x15
	STD  Y+6,R30
	STD  Y+6+1,R31
;if (moveRight < MIN_SPEED)
_0x90:
	CALL SUBOPT_0x16
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x91
;moveRight = MIN_SPEED;
	CALL SUBOPT_0x16
	STD  Y+6,R30
	STD  Y+6+1,R31
;setMotor(moveLeft, moveRight);
_0x91:
	ST   -Y,R21
	ST   -Y,R20
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	RCALL _setMotor
	CALL __LOADLOCR6
	ADIW R28,10
	RET
; .FEND
;void scanX(int brpkali, int kec)
_scanX:
; .FSTART _scanX
;while (hitung < brpkali)
	ST   -Y,R27
	ST   -Y,R26
;	brpkali -> Y+2
;	kec -> Y+0
_0x92:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CP   R4,R30
	CPC  R5,R31
	BRGE _0x94
;while ((sensor & 0b00011100) != 0b00011100)
_0x95:
	CALL SUBOPT_0x17
	BREQ _0x97
;cek_sensor();
	RCALL _cek_sensor
;scan(kec);
	LD   R26,Y
	LDD  R27,Y+1
	RCALL _scan
	RJMP _0x95
_0x97:
;while ((sensor & 0b00011100) == 0b00011100)
_0x98:
	CALL SUBOPT_0x17
	BRNE _0x9A
;cek_sensor();
	RCALL _cek_sensor
;lampu = 0;
	CBI  0x18,3
;scan(kec);
	LD   R26,Y
	LDD  R27,Y+1
	RCALL _scan
;if ((sensor & 0b00011100) != 0b00011100)
	CALL SUBOPT_0x17
	BREQ _0x9D
;hitung++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
	SBIW R30,1
;lampu = 1;
	SBI  0x18,3
;};
_0x9D:
	RJMP _0x98
_0x9A:
;};
	RJMP _0x92
_0x94:
;hitung = 0;
	CLR  R4
	CLR  R5
	RJMP _0x20C0010
; .FEND
;void scanTimer(int countGoal, int kec, int lama)
_scanTimer:
; .FSTART _scanTimer
;count = 0;
	ST   -Y,R27
	ST   -Y,R26
;	countGoal -> Y+4
;	kec -> Y+2
;	lama -> Y+0
	LDI  R30,LOW(0)
	STS  _count,R30
	STS  _count+1,R30
;while (count < countGoal)
_0xA0:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDS  R26,_count
	LDS  R27,_count+1
	CP   R26,R30
	CPC  R27,R31
	BRGE _0xA2
;cek_sensor();
	CALL SUBOPT_0x18
;scan(kec);
;count++;
	LDI  R26,LOW(_count)
	LDI  R27,HIGH(_count)
	CALL SUBOPT_0x19
	RJMP _0xA0
_0xA2:
;rem(lama);
	CALL SUBOPT_0x1A
	RJMP _0x20C0011
; .FEND
;void scanKotak(int brpkali, int kec, int lama_rem) {
_scanKotak:
; .FSTART _scanKotak
;while (hitung < brpkali) {
	ST   -Y,R27
	ST   -Y,R26
;	brpkali -> Y+4
;	kec -> Y+2
;	lama_rem -> Y+0
_0xA3:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CP   R4,R30
	CPC  R5,R31
	BRGE _0xA5
;while(1)
_0xA6:
;cek_sensor();
	CALL SUBOPT_0x18
;scan(kec);
;if((sensor & 0b01111111) == 0b01111111) {
	CALL SUBOPT_0x14
	ANDI R30,0x7F
	CPI  R30,LOW(0x7F)
	BRNE _0xA9
;hitung++; mundur(kec, kec); delay(lama_rem); rem(10); break;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
	SBIW R30,1
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R26,Y+3
	RCALL _mundur
	CALL SUBOPT_0x10
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _rem
	RJMP _0xA8
_0xA9:
	RJMP _0xA6
_0xA8:
	RJMP _0xA3
_0xA5:
;hitung = 0;
	CLR  R4
	CLR  R5
_0x20C0011:
	ADIW R28,6
	RET
; .FEND
;void scanTka(int brpkali)
;while (hitung < brpkali)
;	brpkali -> Y+0
;cek_sensor();
;while ((sensor & 0b01110000) != 0b01110000) // kanan
;cek_sensor();
;scan(170);
;while ((sensor & 0b01110000) == 0b01110000)
;cek_sensor();
;scan(170);
;if ((sensor & 0b01110000) != 0b01110000)
;hitung++;
;lcd_kedip(1);
;};
;};
;hitung = 0;
;void scanTki(int brpkali)
;while (hitung < brpkali)
;	brpkali -> Y+0
;cek_sensor();
;while ((sensor & 0b00000111) != 0b00000111) // kanan
;cek_sensor();
;scan(170);
;while ((sensor & 0b00000111) == 0b00000111)
;cek_sensor();
;scan(170);
;if ((sensor & 0b00000111) != 0b00000111)
;hitung++;
;lcd_kedip(1);
;};
;};
;hitung = 0;
;void scan7ki()
;cek_sensor();
;while ((sensor & 0b01000000) != 0b01000000)
;cek_sensor();
;scan(170);
;void scan7ka()
;cek_sensor();
;while ((sensor & 0b01000000) != 0b00000000)
;cek_sensor();
;scan(170);
;void scan7ki2()
;cek_sensor();
;while (sensor == 0b00000000) // sensor !=0b00111111||0b00000011|| 0b00000001
;cek_sensor();
;scan(170);
;void belki(int kec, int lama)
_belki:
; .FSTART _belki
;cek_sensor();
	ST   -Y,R27
	ST   -Y,R26
;	kec -> Y+2
;	lama -> Y+0
	RCALL _cek_sensor
;while (sen[0] || sen[1])
_0xC7:
	LDS  R30,_sen
	CPI  R30,0
	BRNE _0xCA
	__GETB1MN _sen,1
	CPI  R30,0
	BREQ _0xC9
_0xCA:
;kiri(kec, kec);
	CALL SUBOPT_0x1B
;cek_sensor();
	RJMP _0xC7
_0xC9:
;while (!sen[0] && !sen[1])
_0xCC:
	LDS  R30,_sen
	CPI  R30,0
	BRNE _0xCF
	__GETB1MN _sen,1
	CPI  R30,0
	BREQ _0xD0
_0xCF:
	RJMP _0xCE
_0xD0:
;kiri(kec, kec);
	CALL SUBOPT_0x1B
;cek_sensor();
	RJMP _0xCC
_0xCE:
;if (lama > 0)
	CALL SUBOPT_0xF
	BRGE _0xD1
;rem(lama);
	CALL SUBOPT_0x1A
_0xD1:
	RJMP _0x20C0010
; .FEND
;void belki2()
;cek_sensor();
;while ((sensor & 0b00000001) != 0b00000000)
;cek_sensor();
;kiri(150, 150);
;void belka(int kec, int lama)
_belka:
; .FSTART _belka
;cek_sensor();
	ST   -Y,R27
	ST   -Y,R26
;	kec -> Y+2
;	lama -> Y+0
	RCALL _cek_sensor
;while (sen[5] || sen[6])
_0xD5:
	__GETB1MN _sen,5
	CPI  R30,0
	BRNE _0xD8
	__GETB1MN _sen,6
	CPI  R30,0
	BREQ _0xD7
_0xD8:
;kanan(kec, kec);
	CALL SUBOPT_0x1C
;cek_sensor();
	RJMP _0xD5
_0xD7:
;while (!sen[5] && !sen[6])
_0xDA:
	__GETB1MN _sen,5
	CPI  R30,0
	BRNE _0xDD
	__GETB1MN _sen,6
	CPI  R30,0
	BREQ _0xDE
_0xDD:
	RJMP _0xDC
_0xDE:
;kanan(kec, kec);
	CALL SUBOPT_0x1C
;cek_sensor();
	RJMP _0xDA
_0xDC:
;if (lama > 0)
	CALL SUBOPT_0xF
	BRGE _0xDF
;rem(lama);
	CALL SUBOPT_0x1A
_0xDF:
	RJMP _0x20C0010
; .FEND
;void belkacenter()
;cek_sensor();
;while ((sensor & 0b00001000) != 0b00001000)
;cek_sensor();
;kanan(180, 180);
;if ((sensor & 0b10000000) == 0b10000000)
;lcd_kedip(1);
;void scan_delay(int ms)
;k = 0;
;	ms -> Y+0
;maju(172, 170);
;while (k < ms / 10)
;delay_ms(10);
;k++;
;cek_sensor();
;scan(180);
;void belokKanan(int kec, int lama_rem) {
_belokKanan:
; .FSTART _belokKanan
;if(mapMirror == 0) {
	CALL SUBOPT_0x1D
;	kec -> Y+2
;	lama_rem -> Y+0
	BRNE _0xE7
;belka(kec, lama_rem);
	CALL SUBOPT_0x1E
	RCALL _belka
;} else {
	RJMP _0xE8
_0xE7:
;belki(kec, lama_rem);
	CALL SUBOPT_0x1E
	RCALL _belki
_0xE8:
	RJMP _0x20C0010
; .FEND
;void belokKiri(int kec, int lama_rem) {
_belokKiri:
; .FSTART _belokKiri
;if(mapMirror == 0) {
	CALL SUBOPT_0x1D
;	kec -> Y+2
;	lama_rem -> Y+0
	BRNE _0xE9
;belki(kec, lama_rem);
	CALL SUBOPT_0x1E
	RCALL _belki
;} else {
	RJMP _0xEA
_0xE9:
;belka(kec, lama_rem);
	CALL SUBOPT_0x1E
	RCALL _belka
_0xEA:
_0x20C0010:
	ADIW R28,4
	RET
; .FEND
;void griper()
; 0000 0064 {
;capit_lepas;
;lengan_tengah;
;delay_ms(5000);
;lengan_bawah;
;delay_ms(5000);
;capit_ambil;
;delay_ms(7000);
;lengan_atas;
;delay_ms(5000);
;lengan_bawah;
;delay_ms(5000);
;capit_lepas;
;void ambil(int lama)
_ambil:
; .FSTART _ambil
;capit_ambil;
	ST   -Y,R27
	ST   -Y,R26
;	lama -> Y+0
	LDI  R30,LOW(237)
	MOV  R13,R30
;delay(lama);
	CALL SUBOPT_0x10
;lengan_atas;
	LDI  R30,LOW(234)
	MOV  R12,R30
;delay(lama);
	CALL SUBOPT_0x10
	RJMP _0x20C000F
; .FEND
;void taruh(int lama)
_taruh:
; .FSTART _taruh
;lengan_bawah;
	ST   -Y,R27
	ST   -Y,R26
;	lama -> Y+0
	LDI  R30,LOW(240)
	MOV  R12,R30
;delay(lama);
	CALL SUBOPT_0x10
;capit_lepas;
	LDI  R30,LOW(230)
	MOV  R13,R30
;delay(lama);
	CALL SUBOPT_0x10
;lengan_atas;
	LDI  R30,LOW(234)
	MOV  R12,R30
_0x20C000F:
	ADIW R28,2
	RET
; .FEND
;void bawah_lepas()
_bawah_lepas:
; .FSTART _bawah_lepas
;lengan_bawah;
	LDI  R30,LOW(240)
	MOV  R12,R30
;capit_lepas;
	LDI  R30,LOW(230)
	MOV  R13,R30
	RET
; .FEND
;void atas_lepas()
;lengan_atas;
;capit_lepas;
;void bacawarna()
; 0000 0065 {
_bacawarna:
; .FSTART _bacawarna
;nadc7 = read_adc(7);
	LDI  R26,LOW(7)
	RCALL _read_adc
	MOV  R6,R30
	CLR  R7
;lcd_gotoxy(13, 1);
	LDI  R30,LOW(13)
	CALL SUBOPT_0x1F
;sprintf(buff, "%d   ", nadc7);
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,94
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R6
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
;lcd_puts(buff);
_0x20C000E:
	LDI  R26,LOW(_buff)
	LDI  R27,HIGH(_buff)
	CALL _lcd_puts
	RET
; .FEND
;int checkWarna() {
_checkWarna:
; .FSTART _checkWarna
;int warna;
;nadc7 = read_adc(7);
	ST   -Y,R17
	ST   -Y,R16
;	warna -> R16,R17
	LDI  R26,LOW(7)
	RCALL _read_adc
	MOV  R6,R30
	CLR  R7
;if(nadc7>minMerah && nadc7<maxMerah){
	LDS  R30,_minMerah
	LDS  R31,_minMerah+1
	CP   R30,R6
	CPC  R31,R7
	BRSH _0xEC
	LDS  R30,_maxMerah
	LDS  R31,_maxMerah+1
	CP   R6,R30
	CPC  R7,R31
	BRLO _0xED
_0xEC:
	RJMP _0xEB
_0xED:
;warna = 0;
	__GETWRN 16,17,0
;else if(nadc7>minKuning && nadc7<maxKuning){
	RJMP _0xEE
_0xEB:
	LDS  R30,_minKuning
	LDS  R31,_minKuning+1
	CP   R30,R6
	CPC  R31,R7
	BRSH _0xF0
	LDS  R30,_maxKuning
	LDS  R31,_maxKuning+1
	CP   R6,R30
	CPC  R7,R31
	BRLO _0xF1
_0xF0:
	RJMP _0xEF
_0xF1:
;warna = 1;
	__GETWRN 16,17,1
;else if(nadc7>minHijau && nadc7<maxHijau){
	RJMP _0xF2
_0xEF:
	LDS  R30,_minHijau
	LDS  R31,_minHijau+1
	CP   R30,R6
	CPC  R31,R7
	BRSH _0xF4
	LDS  R30,_maxHijau
	LDS  R31,_maxHijau+1
	CP   R6,R30
	CPC  R7,R31
	BRLO _0xF5
_0xF4:
	RJMP _0xF3
_0xF5:
;warna = 2;
	__GETWRN 16,17,2
;}else{
	RJMP _0xF6
_0xF3:
;warna = 3;
	__GETWRN 16,17,3
_0xF6:
_0xF2:
_0xEE:
;return warna;
	MOVW R30,R16
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;int isWarna;
;void balikKiri(void);
;void fromBtoGreen()
; 0000 0066 {
_fromBtoGreen:
; .FSTART _fromBtoGreen
;scanX(2, 120);
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;delay(15); scanKotak(1, 90, 5);
	CALL SUBOPT_0x24
	CALL SUBOPT_0x25
;taruh(20);
;mundur(100, 100); delay(38);
;belokKiri(100, 20);
	CALL SUBOPT_0x26
;scanX(2, 100);
	CALL SUBOPT_0x23
;belokKiri(100, 20);
	CALL SUBOPT_0x27
	CALL SUBOPT_0x26
;scanX(2, 120);
	CALL SUBOPT_0x21
;bawah_lepas();
	CALL SUBOPT_0x28
;scanX(1, 90);
	LDI  R26,LOW(90)
	RJMP _0x20C000D
;scanTimer(33, 80, 50);
;ambil(20);
; .FEND
;void fromBtoYellow()
_fromBtoYellow:
; .FSTART _fromBtoYellow
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;belokKanan(100, 20);
	CALL SUBOPT_0x27
	CALL SUBOPT_0x29
;scanX(2, 120);
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;delay(15); scanKotak(1, 90, 5);
	CALL SUBOPT_0x24
	CALL SUBOPT_0x25
;taruh(20);
;mundur(100, 100); delay(38);
;belokKiri(100, 5); belokKiri(100, 20);
	LDI  R26,LOW(5)
	LDI  R27,0
	RCALL _belokKiri
	CALL SUBOPT_0x27
	CALL SUBOPT_0x2A
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;scanX(3, 120);
	CALL SUBOPT_0x2B
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;belokKiri(100, 20);
	CALL SUBOPT_0x27
	CALL SUBOPT_0x2A
;bawah_lepas();
	CALL SUBOPT_0x28
;scanX(1, 100);
	CALL SUBOPT_0x23
;scanTimer(50, 90, 50);
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	RJMP _0x20C000C
;ambil(20);
; .FEND
;void fromBtoRed() {
_fromBtoRed:
; .FSTART _fromBtoRed
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;belokKiri(100, 20);
	CALL SUBOPT_0x27
	CALL SUBOPT_0x26
;scanX(2, 120);
	CALL SUBOPT_0x21
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;delay(15); scanKotak(1, 90, 5);
	CALL SUBOPT_0x24
	CALL SUBOPT_0x25
;taruh(20);
;mundur(100, 100); delay(38);
;belokKanan(100, 5); belokKanan(100, 20);
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x29
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;belokKanan(100, 20);
	CALL SUBOPT_0x27
	CALL SUBOPT_0x29
;bawah_lepas();
	CALL SUBOPT_0x28
;scanX(1, 100);
	CALL SUBOPT_0x23
;scanTimer(43, 95, 50);
	LDI  R30,LOW(43)
	LDI  R31,HIGH(43)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(95)
	LDI  R31,HIGH(95)
	RJMP _0x20C000C
;ambil(20);
; .FEND
;void fromCtoGreen() {
_fromCtoGreen:
; .FSTART _fromCtoGreen
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;belokKiri(100, 20);
	CALL SUBOPT_0x27
	CALL SUBOPT_0x2A
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;scanX(2, 120);
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
;scanX(2, 100);
	CALL SUBOPT_0x20
	CALL SUBOPT_0x23
;delay(15); scanKotak(1, 90, 5);
	CALL SUBOPT_0x24
	CALL SUBOPT_0x25
;taruh(20);
;mundur(100, 100); delay(38);
;belokKanan(100, 5); belokKanan(100, 20);
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x29
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;scanX(2, 100);
	CALL SUBOPT_0x20
	CALL SUBOPT_0x23
;belokKanan(100, 20);
	CALL SUBOPT_0x27
	CALL SUBOPT_0x29
;scanX(2, 120);
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;belokKanan(90, 10);
	CALL SUBOPT_0x2D
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _belokKanan
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;bawah_lepas();
	RCALL _bawah_lepas
;scanTimer(63, 80, 50);
	LDI  R30,LOW(63)
	LDI  R31,HIGH(63)
	RJMP _0x20C000B
;ambil(20);
; .FEND
;void fromCtoYellow() {
_fromCtoYellow:
; .FSTART _fromCtoYellow
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;belokKanan(100, 20);
	CALL SUBOPT_0x27
	CALL SUBOPT_0x29
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;delay(15); scanKotak(1, 90, 5);
	CALL SUBOPT_0x24
	CALL SUBOPT_0x25
;taruh(20);
;mundur(100, 100); delay(38);
;belokKanan(100, 20);
	CALL SUBOPT_0x29
;scanX(2, 120);
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;belokKanan(100, 20);
	CALL SUBOPT_0x27
	CALL SUBOPT_0x29
;scanX(2, 120);
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x20C000A
;scanX(1, 100);
;bawah_lepas();
;scanX(1, 100);
;scanTimer(33, 80, 50);
;ambil(20);
; .FEND
;void fromCtoRed() {
_fromCtoRed:
; .FSTART _fromCtoRed
;mundur(100, 100); delay(33);
	CALL SUBOPT_0x2E
;belokKanan(100, 5); belokKanan(100, 20);
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x29
;scanX(1, 90);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x2F
;scanX(1, 120);
	CALL SUBOPT_0x21
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;delay(15); scanKotak(1, 90, 5);
	CALL SUBOPT_0x24
	CALL SUBOPT_0x25
;taruh(20);
;mundur(100, 100); delay(38);
;belokKanan(100, 20);
	CALL SUBOPT_0x29
;scanX(1, 120);
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
_0x20C000A:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x21
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;bawah_lepas();
	CALL SUBOPT_0x28
;scanX(1, 100);
	LDI  R26,LOW(100)
_0x20C000D:
	LDI  R27,0
	RCALL _scanX
;scanTimer(33, 80, 50);
	LDI  R30,LOW(33)
	LDI  R31,HIGH(33)
_0x20C000B:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
_0x20C000C:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x30
;ambil(20);
	RET
; .FEND
;void fromAtoGreen() {
_fromAtoGreen:
; .FSTART _fromAtoGreen
;mundur(100, 100); delay(33);
	CALL SUBOPT_0x2E
;belokKanan(100, 5); belokKanan(100, 20);
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x29
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;scanX(1, 120);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x21
;scanX(1, 120);
	RJMP _0x20C0009
;scanX(1, 100);
;delay(15); scanKotak(1, 90, 5);
;taruh(20);
; .FEND
;void fromAtoYellow() {
_fromAtoYellow:
; .FSTART _fromAtoYellow
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;belokKiri(100, 20);
	CALL SUBOPT_0x27
	CALL SUBOPT_0x2A
;delay(15); scanKotak(1, 100, 5);
	CALL SUBOPT_0x24
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RJMP _0x20C0008
;taruh(20);
; .FEND
;void fromAtoRed() {
_fromAtoRed:
; .FSTART _fromAtoRed
;scanX(1, 120);
_0x20C0009:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x21
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;delay(15); scanKotak(1, 90, 5);
	CALL SUBOPT_0x24
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
_0x20C0008:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x31
;taruh(20);
	RCALL _taruh
	RET
; .FEND
;void vertikalLineD(void);
;void fromGreenAtoD() {
_fromGreenAtoD:
; .FSTART _fromGreenAtoD
;if(positionD == 0) {
	CALL SUBOPT_0x32
	BRNE _0xF7
;mundur(100, 100); delay(38);
	CALL SUBOPT_0x33
;belokKiri(100, 20);
	CALL SUBOPT_0x2A
;} else if(positionD == 1) {
	RJMP _0xF8
_0xF7:
	CALL SUBOPT_0x34
	SBIW R26,1
	BRNE _0xF9
;mundur(100, 100); delay(38);
	CALL SUBOPT_0x33
;belokKanan(100, 5); belokKanan(100, 20);
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x29
;scanX(1, 100);
	CALL SUBOPT_0x22
	LDI  R26,LOW(100)
	RJMP _0x17E
;scanX(1, 100);
;belokKanan(100, 20);
;} else if(positionD == 2) {
_0xF9:
	CALL SUBOPT_0x34
	SBIW R26,2
	BRNE _0xFB
;mundur(100, 100); delay(38);
	CALL SUBOPT_0x33
;belokKanan(100, 5); belokKanan(100, 20);
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x29
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;scanX(2, 120);
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x17F
;scanX(1, 100);
;belokKanan(100, 20);
;} else if(positionD == 3) {
_0xFB:
	CALL SUBOPT_0x34
	SBIW R26,3
	BRNE _0xFD
;mundur(100, 100); delay(38);
	CALL SUBOPT_0x33
;belokKanan(100, 5); belokKanan(100, 20);
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x29
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;scanX(4, 120);
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
_0x17F:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(120)
_0x17E:
	LDI  R27,0
	RCALL _scanX
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;belokKanan(100, 20);
	CALL SUBOPT_0x27
	CALL SUBOPT_0x29
;vertikalLineD();
_0xFD:
_0xF8:
	RJMP _0x20C0007
; .FEND
;void fromYellowAtoD() {
_fromYellowAtoD:
; .FSTART _fromYellowAtoD
;if(positionD == 0) {
	CALL SUBOPT_0x32
	BRNE _0xFE
;mundur(100, 100); delay(38);
	LDI  R30,LOW(100)
	ST   -Y,R30
	LDI  R26,LOW(100)
	RCALL _mundur
	LDI  R26,LOW(38)
	LDI  R27,0
	RCALL _delay
;belokKiri(80, 20);
	CALL SUBOPT_0x35
	CALL SUBOPT_0x2A
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;scanX(3, 120);
	CALL SUBOPT_0x2B
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;belokKiri(100, 20);
	CALL SUBOPT_0x27
	CALL SUBOPT_0x2A
;} else if(positionD == 1) {
	RJMP _0xFF
_0xFE:
	CALL SUBOPT_0x34
	SBIW R26,1
	BRNE _0x100
;mundur(100, 100); delay(38);
	CALL SUBOPT_0x33
;belokKiri(100, 20);
	CALL SUBOPT_0x2A
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;scanX(1, 120);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x21
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;belokKiri(100, 20);
	CALL SUBOPT_0x27
	CALL SUBOPT_0x2A
;} else if(positionD == 2) {
	RJMP _0x101
_0x100:
	CALL SUBOPT_0x34
	SBIW R26,2
	BRNE _0x102
;mundur(100, 100); delay(38);
	CALL SUBOPT_0x33
;belokKiri(100, 20);
	CALL SUBOPT_0x2A
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;belokKiri(100, 20);
	CALL SUBOPT_0x27
	CALL SUBOPT_0x2A
;} else if(positionD == 3) {
	RJMP _0x103
_0x102:
	CALL SUBOPT_0x34
	SBIW R26,3
	BRNE _0x104
;mundur(100, 100); delay(38);
	CALL SUBOPT_0x33
;belokKanan(100, 20);
	CALL SUBOPT_0x29
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;belokKanan(100, 20);
	CALL SUBOPT_0x27
	CALL SUBOPT_0x29
;vertikalLineD();
_0x104:
_0x103:
_0x101:
_0xFF:
	RJMP _0x20C0007
; .FEND
;void fromRedAtoD() {
_fromRedAtoD:
; .FSTART _fromRedAtoD
;if(positionD == 0) {
	CALL SUBOPT_0x32
	BRNE _0x105
;mundur(100, 100); delay(38);
	CALL SUBOPT_0x33
;belokKanan(100, 5); belokKanan(100, 20);
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x29
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;scanX(4, 120);
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x21
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;belokKiri(100, 20);
	CALL SUBOPT_0x27
	CALL SUBOPT_0x2A
;} else if(positionD == 1) {
	RJMP _0x106
_0x105:
	CALL SUBOPT_0x34
	SBIW R26,1
	BRNE _0x107
;mundur(100, 100); delay(38);
	CALL SUBOPT_0x33
;belokKanan(100, 5); belokKanan(100, 20);
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x29
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;scanX(2, 120);
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;belokKiri(100, 20);
	CALL SUBOPT_0x27
	CALL SUBOPT_0x2A
;} else if(positionD == 2) {
	RJMP _0x108
_0x107:
	CALL SUBOPT_0x34
	SBIW R26,2
	BRNE _0x109
;mundur(100, 100); delay(38);
	CALL SUBOPT_0x33
;belokKiri(100, 20);
	CALL SUBOPT_0x2A
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;belokKiri(100, 20);
	CALL SUBOPT_0x27
	CALL SUBOPT_0x2A
;} else if(positionD == 3) {
	RJMP _0x10A
_0x109:
	CALL SUBOPT_0x34
	SBIW R26,3
	BRNE _0x10B
;mundur(100, 100); delay(38);
	CALL SUBOPT_0x33
;belokKanan(100, 20);
	CALL SUBOPT_0x29
;vertikalLineD();
_0x10B:
_0x10A:
_0x108:
_0x106:
_0x20C0007:
	RCALL _vertikalLineD
	RET
; .FEND
;void fromDto4(void);
;void vertikalLineD() {
_vertikalLineD:
; .FSTART _vertikalLineD
;scanX(3, 120);
	CALL SUBOPT_0x2B
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;bawah_lepas();
	CALL SUBOPT_0x28
;scanX(1, 100);
	CALL SUBOPT_0x23
;delay(15); scanKotak(1, 90, 5);
	CALL SUBOPT_0x24
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x31
;ambil(20);
	RCALL _ambil
;fromDto4();
	RCALL _fromDto4
	RET
; .FEND
;void returnHome(void);
;void fromDto4() {
_fromDto4:
; .FSTART _fromDto4
;mundur(100, 100); delay(38);
	CALL SUBOPT_0x33
;belokKanan(100, 10); belokKanan(100, 20);
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _belokKanan
	CALL SUBOPT_0x27
	CALL SUBOPT_0x29
;scanX(1, 90);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x2F
;scanX(1, 120);
	CALL SUBOPT_0x21
;belokKiri(100, 20);
	CALL SUBOPT_0x27
	CALL SUBOPT_0x2A
;if(positionD == 0) {
	CALL SUBOPT_0x32
	BRNE _0x10C
;scanX(1, 100);
	CALL SUBOPT_0x22
	LDI  R26,LOW(100)
	RJMP _0x180
;} else if(positionD == 1) {
_0x10C:
	CALL SUBOPT_0x34
	SBIW R26,1
	BRNE _0x10E
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;scanX(1, 120);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x21
;scanX(1, 120);
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x181
;} else if(positionD == 2) {
_0x10E:
	CALL SUBOPT_0x34
	SBIW R26,2
	BRNE _0x110
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;scanX(4, 120);
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RJMP _0x181
;} else if(positionD == 3) {
_0x110:
	CALL SUBOPT_0x34
	SBIW R26,3
	BRNE _0x112
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;scanX(6, 120);
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
_0x181:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(120)
_0x180:
	LDI  R27,0
	RCALL _scanX
;delay(15); scanKotak(1, 90, 5);
_0x112:
	CALL SUBOPT_0x24
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x31
;taruh(20);
	RCALL _taruh
;returnHome();
	RCALL _returnHome
	RET
; .FEND
;void returnHome() {
_returnHome:
; .FSTART _returnHome
;mundur(100, 100); delay(20);
	LDI  R30,LOW(100)
	ST   -Y,R30
	LDI  R26,LOW(100)
	RCALL _mundur
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _delay
;belokKanan(100, 20);
	CALL SUBOPT_0x27
	CALL SUBOPT_0x29
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;scanX(3, 120);
	CALL SUBOPT_0x2B
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;belokKanan(100, 20);
	CALL SUBOPT_0x27
	CALL SUBOPT_0x29
;scanX(1, 120);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x21
;scanX(1, 100);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;delay(15); scanKotak(1, 90, 5);
	CALL SUBOPT_0x24
	CALL SUBOPT_0x2D
	LDI  R26,LOW(5)
	LDI  R27,0
	RCALL _scanKotak
;maju(100, 100); delay(30); rem(100);
	LDI  R30,LOW(100)
	ST   -Y,R30
	LDI  R26,LOW(100)
	RCALL _maju
	LDI  R26,LOW(30)
	LDI  R27,0
	RCALL _delay
	CALL SUBOPT_0x13
;parkir();
	RCALL _parkir
	RET
; .FEND
;void Program_Jalan()
_Program_Jalan:
; .FSTART _Program_Jalan
;maju_delay(80, 60);
	CALL SUBOPT_0x35
	LDI  R26,LOW(60)
	LDI  R27,0
	RCALL _maju_delay
;scanX(2, 120);
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
;bawah_lepas();
	CALL SUBOPT_0x28
;scanX(1, 100);
	CALL SUBOPT_0x23
;scanTimer(28, 80, 50);
	LDI  R30,LOW(28)
	LDI  R31,HIGH(28)
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x35
	CALL SUBOPT_0x30
;ambil(20);
;delay(50);
	CALL SUBOPT_0x36
;isWarna = checkWarna();
;if(isWarna == merah) {
	BRNE _0x113
;fromBtoRed();
	RCALL _fromBtoRed
;} else if(isWarna == kuning) {
	RJMP _0x114
_0x113:
	CALL SUBOPT_0x37
	SBIW R26,1
	BRNE _0x115
;fromBtoYellow();
	RCALL _fromBtoYellow
;} else if(isWarna == hijau) {
	RJMP _0x116
_0x115:
	CALL SUBOPT_0x37
	SBIW R26,2
	BRNE _0x117
;fromBtoGreen();
;} else {
_0x117:
;fromBtoGreen();
_0x182:
	RCALL _fromBtoGreen
_0x116:
_0x114:
;isWarna = checkWarna();
	RCALL _checkWarna
	STS  _isWarna,R30
	STS  _isWarna+1,R31
;if(isWarna == merah) {
	SBIW R30,0
	BRNE _0x119
;fromCtoRed();
	RCALL _fromCtoRed
;} else if(isWarna == kuning) {
	RJMP _0x11A
_0x119:
	CALL SUBOPT_0x37
	SBIW R26,1
	BRNE _0x11B
;fromCtoYellow();
	RCALL _fromCtoYellow
;} else if(isWarna == hijau) {
	RJMP _0x11C
_0x11B:
	CALL SUBOPT_0x37
	SBIW R26,2
	BRNE _0x11D
;fromCtoGreen();
;} else {
_0x11D:
;fromCtoGreen();
_0x183:
	RCALL _fromCtoGreen
_0x11C:
_0x11A:
;delay(50);
	CALL SUBOPT_0x36
;isWarna = checkWarna();
;if(isWarna == merah) {
	BRNE _0x11F
;fromAtoRed();
	RCALL _fromAtoRed
;fromRedAtoD();
	RCALL _fromRedAtoD
;} else if(isWarna == kuning) {
	RJMP _0x120
_0x11F:
	CALL SUBOPT_0x37
	SBIW R26,1
	BRNE _0x121
;fromAtoYellow();
	RCALL _fromAtoYellow
;fromYellowAtoD();
	RCALL _fromYellowAtoD
;} else if(isWarna == hijau) {
	RJMP _0x122
_0x121:
	CALL SUBOPT_0x37
	SBIW R26,2
	BRNE _0x123
;fromAtoGreen();
;fromGreenAtoD();
;} else {
_0x123:
;fromAtoGreen();
_0x184:
	RCALL _fromAtoGreen
;fromGreenAtoD();
	RCALL _fromGreenAtoD
_0x122:
_0x120:
	RET
; .FEND
;void balikKanan() {
;mundur(100, 100); delay(38);
;belokKanan(80, 0); belokKanan(80, 10);
;void balikKiri() {
;belki(100, 5); belki(100, 20);
;void mundurKanan() {
;mundur(100, 100); delay(38);
;belokKanan(80, 10);
;void runBot(void);
;void calibration(void);
;void Program_Jalan(void);
;void test_motor(void);
;void test_tombol(void);
;void map_select(int map_num);
;void sens_warna(void);
;void test_capit(void);
;void changeMenu(int menuSelect, bool isSelect, int childMenuSelect) {
; 0000 0067 void changeMenu(int menuSelect, _Bool isSelect, int childMenuSelect) {
_changeMenu:
; .FSTART _changeMenu
;lampu = 0;
	ST   -Y,R27
	ST   -Y,R26
;	menuSelect -> Y+3
;	isSelect -> Y+2
;	childMenuSelect -> Y+0
	CBI  0x18,3
;count_btn = menuSelect;
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	STS  _count_btn,R30
	STS  _count_btn+1,R31
;count_child_btn = childMenuSelect;
	LD   R30,Y
	LDD  R31,Y+1
	STS  _count_child_btn,R30
	STS  _count_child_btn+1,R31
;if(!isSelect && !isChildSelect) {
	LDD  R30,Y+2
	CPI  R30,0
	BRNE _0x128
	LDS  R30,_isChildSelect
	CPI  R30,0
	BREQ _0x129
_0x128:
	RJMP _0x127
_0x129:
;lcd_clear();
	CALL SUBOPT_0x38
;lcd_gotoxy(0, 0);
;lcd_putsf("Menu");
	__POINTW2FN _0x0,100
	CALL _lcd_putsf
;switch (menuSelect) {
_0x127:
	LDD  R30,Y+3
	LDD  R31,Y+3+1
;case 0: // Calibration
	SBIW R30,0
	BRNE _0x12D
;if(isSelect) { calibration(); break; }
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x12E
	RCALL _calibration
	RJMP _0x12C
;lcd_gotoxy(0, 1);
_0x12E:
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1F
;lcd_putsf("Calibration");
	__POINTW2FN _0x0,105
	CALL _lcd_putsf
;break;
	RJMP _0x12C
;case 1: // Run bot
_0x12D:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x12F
;if(isSelect || isChildSelect) { runBot(); break; }
	LDD  R30,Y+2
	CPI  R30,0
	BRNE _0x131
	LDS  R30,_isChildSelect
	CPI  R30,0
	BREQ _0x130
_0x131:
	RCALL _runBot
	RJMP _0x12C
;lcd_gotoxy(0, 1);
_0x130:
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1F
;lcd_putsf("Run Bot");
	__POINTW2FN _0x0,117
	CALL _lcd_putsf
;break;
	RJMP _0x12C
;case 2: // Sensor Warna
_0x12F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x133
;if(isSelect) { sens_warna(); break; }
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x134
	RCALL _sens_warna
	RJMP _0x12C
;lcd_gotoxy(0, 1);
_0x134:
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1F
;lcd_putsf("Sens Warna");
	__POINTW2FN _0x0,125
	CALL _lcd_putsf
;break;
	RJMP _0x12C
;case 3: // Map Select
_0x133:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x135
;if(isSelect || isChildSelect) { map_select(0); break; }
	LDD  R30,Y+2
	CPI  R30,0
	BRNE _0x137
	LDS  R30,_isChildSelect
	CPI  R30,0
	BREQ _0x136
_0x137:
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _map_select
	RJMP _0x12C
;lcd_gotoxy(0, 1);
_0x136:
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1F
;lcd_putsf("Map Biru");
	__POINTW2FN _0x0,136
	CALL _lcd_putsf
;break;
	RJMP _0x12C
;case 4: // Map Select
_0x135:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x139
;if(isSelect || isChildSelect) { map_select(1); break; }
	LDD  R30,Y+2
	CPI  R30,0
	BRNE _0x13B
	LDS  R30,_isChildSelect
	CPI  R30,0
	BREQ _0x13A
_0x13B:
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _map_select
	RJMP _0x12C
;lcd_gotoxy(0, 1);
_0x13A:
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1F
;lcd_putsf("Map Merah");
	__POINTW2FN _0x0,145
	CALL _lcd_putsf
;break;
	RJMP _0x12C
;case 5: // Test Motor
_0x139:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x13D
;if(isSelect) { test_motor(); break; }
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x13E
	RCALL _test_motor
	RJMP _0x12C
;lcd_gotoxy(0, 1);
_0x13E:
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1F
;lcd_putsf("Motor");
	__POINTW2FN _0x0,155
	CALL _lcd_putsf
;break;
	RJMP _0x12C
;case 6: // Test tombol
_0x13D:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x13F
;if(isSelect) { test_tombol(); break; }
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x140
	RCALL _test_tombol
	RJMP _0x12C
;lcd_gotoxy(0, 1);
_0x140:
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1F
;lcd_putsf("Button");
	__POINTW2FN _0x0,161
	CALL _lcd_putsf
;break;
	RJMP _0x12C
;case 7: // Test Capit
_0x13F:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x143
;if(isSelect) { test_capit(); break; }
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x142
	RCALL _test_capit
	RJMP _0x12C
;lcd_gotoxy(0, 1);
_0x142:
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1F
;lcd_putsf("Capit");
	__POINTW2FN _0x0,168
	CALL _lcd_putsf
;break;
;default:
_0x143:
;break;
_0x12C:
	RJMP _0x20C0005
; .FEND
;void runBot() {
_runBot:
; .FSTART _runBot
;if(!isChildSelect) {
	LDS  R30,_isChildSelect
	CPI  R30,0
	BRNE _0x144
;lcd_clear();
	CALL SUBOPT_0x38
;lcd_gotoxy(0, 0);
;lcd_putsf("Run Bot");
	__POINTW2FN _0x0,117
	CALL SUBOPT_0x39
;lcd_gotoxy(0, 1);
;lcd_putsf("Click 2 to start");
	__POINTW2FN _0x0,174
	CALL _lcd_putsf
;isChildSelect = true;
	LDI  R30,LOW(1)
	STS  _isChildSelect,R30
;} else if(isChildSelect) {
	RJMP _0x145
_0x144:
	LDS  R30,_isChildSelect
	CPI  R30,0
	BREQ _0x146
;lcd_clear();
	CALL _lcd_clear
;lcd_gotoxy(0, 1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1F
;lcd_putsf("Running...");
	__POINTW2FN _0x0,191
	CALL _lcd_putsf
;Program_Jalan();
	RCALL _Program_Jalan
;isChildSelect = false;
	LDI  R30,LOW(0)
	STS  _isChildSelect,R30
;count_child_btn = 0;
	STS  _count_child_btn,R30
	STS  _count_child_btn+1,R30
;changeMenu(0, false, 0);
	CALL SUBOPT_0x3A
_0x146:
_0x145:
	RET
; .FEND
;void calibration() {
_calibration:
; .FSTART _calibration
;scan_garis();
	RCALL _scan_garis
;delay(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	RCALL _delay
;scan_back();
	RCALL _scan_back
;delay(100);
	CALL SUBOPT_0x3B
;hit_tengah();
	RCALL _hit_tengah
;isChildSelect = false;
	RJMP _0x20C0006
;changeMenu(0, false, 0);
; .FEND
;void map_select(int map_num) {
_map_select:
; .FSTART _map_select
;if(map_num != 0 && map_num != 1) map_num = 0;
	ST   -Y,R27
	ST   -Y,R26
;	map_num -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,0
	BREQ _0x148
	SBIW R26,1
	BRNE _0x149
_0x148:
	RJMP _0x147
_0x149:
	LDI  R30,LOW(0)
	STD  Y+0,R30
	STD  Y+0+1,R30
;mapMirror = map_num;
_0x147:
	LD   R30,Y
	LDD  R31,Y+1
	LDI  R26,LOW(_mapMirror)
	LDI  R27,HIGH(_mapMirror)
	CALL __EEPROMWRW
;isChildSelect = false;
	LDI  R30,LOW(0)
	STS  _isChildSelect,R30
;changeMenu(0, false, 0);
	CALL SUBOPT_0x3A
	JMP  _0x20C0003
; .FEND
;void test_motor()
_test_motor:
; .FSTART _test_motor
;lcd_clear();
	CALL SUBOPT_0x38
;lcd_gotoxy(0, 0);
;lcd_putsf("Test Motor");
	__POINTW2FN _0x0,202
	CALL SUBOPT_0x39
;lcd_gotoxy(0, 1);
;lcd_putsf("+100 +100");
	__POINTW2FN _0x0,213
	CALL _lcd_putsf
;setMotor(100, 100);
	CALL SUBOPT_0x27
	CALL SUBOPT_0x3C
;delay_ms(200);
;lcd_gotoxy(0, 1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1F
;lcd_putsf("-100 -100");
	__POINTW2FN _0x0,223
	CALL SUBOPT_0x3D
;setMotor(-100, -100);
	CALL SUBOPT_0x3E
;delay_ms(200);
;lcd_gotoxy(0, 1);
;lcd_putsf("+100 -100");
	__POINTW2FN _0x0,233
	CALL _lcd_putsf
;setMotor(100, -100);
	CALL SUBOPT_0x27
	CALL SUBOPT_0x3E
;delay_ms(200);
;lcd_gotoxy(0, 1);
;lcd_putsf("-100 +100");
	__POINTW2FN _0x0,243
	CALL SUBOPT_0x3D
;setMotor(-100, 100);
	CALL SUBOPT_0x3C
;delay_ms(200);
;rem(100);
	CALL SUBOPT_0x13
;lcd_clear();
	CALL SUBOPT_0x38
;lcd_gotoxy(0, 0);
;isChildSelect = false;
_0x20C0006:
	LDI  R30,LOW(0)
	STS  _isChildSelect,R30
;changeMenu(0, false, 0);
	CALL SUBOPT_0x3A
	RET
; .FEND
;void test_tombol()
_test_tombol:
; .FSTART _test_tombol
;lcd_gotoxy(0, 1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1F
;lcd_putsf("Click 1 to exit");
	__POINTW2FN _0x0,253
	CALL _lcd_putsf
;isTestTombol = true;
	LDI  R30,LOW(1)
	STS  _isTestTombol,R30
;while (1)
_0x14A:
;if (!isTestTombol) break;
	LDS  R30,_isTestTombol
	CPI  R30,0
	BREQ _0x14C
;if ((t1 == 0))
	SBIC 0x13,0
	RJMP _0x14E
;lcd_gotoxy(0, 0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x3
;lcd_putsf("tombol = 1     ");
	__POINTW2FN _0x0,269
	CALL SUBOPT_0x3F
;isTestTombol = false;
;delay(50);
;changeMenu(0, false, 0);
	CALL SUBOPT_0x3A
;if (t2 == 0)
_0x14E:
	SBIC 0x13,1
	RJMP _0x14F
;lcd_gotoxy(0, 0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x3
;lcd_putsf("tombol = 2     ");
	__POINTW2FN _0x0,285
	CALL _lcd_putsf
;if (t3 == 0)
_0x14F:
	SBIC 0x13,2
	RJMP _0x150
;lcd_gotoxy(0, 0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x3
;lcd_putsf("tombol = 3     ");
	__POINTW2FN _0x0,301
	CALL _lcd_putsf
;if (t4 == 0)
_0x150:
	SBIC 0x13,3
	RJMP _0x151
;lcd_gotoxy(0, 0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x3
;lcd_putsf("tombol = 4     ");
	__POINTW2FN _0x0,317
	CALL _lcd_putsf
_0x151:
	RJMP _0x14A
_0x14C:
	RET
; .FEND
;void sens_warna()
_sens_warna:
; .FSTART _sens_warna
;lcd_clear();
	CALL SUBOPT_0x38
;lcd_gotoxy(0, 0);
;lcd_putsf("Sens Warna");
	__POINTW2FN _0x0,125
	CALL SUBOPT_0x39
;lcd_gotoxy(0, 1);
;lcd_putsf("Warna:");
	__POINTW2FN _0x0,333
	CALL _lcd_putsf
;isTestTombol = true;
	LDI  R30,LOW(1)
	STS  _isTestTombol,R30
;bawah_lepas();
	RCALL _bawah_lepas
;delay(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay
;ambil(20);
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _ambil
;while (1)
_0x152:
;bacawarna();
	RCALL _bacawarna
;if (!isTestTombol) { lcd_clear(); capit_lepas; changeMenu(0, false, 0); break; }
	LDS  R30,_isTestTombol
	CPI  R30,0
	BRNE _0x155
	CALL _lcd_clear
	LDI  R30,LOW(230)
	MOV  R13,R30
	CALL SUBOPT_0x3A
	RJMP _0x154
;if ((t1 == 0))
_0x155:
	SBIC 0x13,0
	RJMP _0x156
;lcd_gotoxy(0, 0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x3
;lcd_putsf("Exiting...");
	__POINTW2FN _0x0,340
	CALL SUBOPT_0x3F
;isTestTombol = false;
;delay(50);
_0x156:
	RJMP _0x152
_0x154:
	RET
; .FEND
;void test_capit()
_test_capit:
; .FSTART _test_capit
;lcd_clear();
	CALL SUBOPT_0x38
;lcd_gotoxy(0, 0);
;lcd_putsf("Test Capit");
	__POINTW2FN _0x0,351
	CALL SUBOPT_0x39
;lcd_gotoxy(0, 1);
;lcd_putsf("Capit: > <");
	__POINTW2FN _0x0,362
	CALL _lcd_putsf
;capit_ambil;
	LDI  R30,LOW(237)
	MOV  R13,R30
;delay(50);
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay
;lcd_gotoxy(0, 1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1F
;lcd_putsf("Capit: < >");
	__POINTW2FN _0x0,373
	CALL _lcd_putsf
;capit_lepas;
	LDI  R30,LOW(230)
	MOV  R13,R30
;delay(100);
	CALL SUBOPT_0x3B
;lcd_gotoxy(0, 1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1F
;lcd_putsf("Capit: \\/");
	__POINTW2FN _0x0,384
	CALL _lcd_putsf
;lengan_bawah;
	LDI  R30,LOW(240)
	MOV  R12,R30
;delay(100);
	CALL SUBOPT_0x3B
;lcd_gotoxy(0, 1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1F
;lcd_putsf("Capit: /\\");
	__POINTW2FN _0x0,394
	CALL _lcd_putsf
;lengan_atas;
	LDI  R30,LOW(234)
	MOV  R12,R30
;delay(100);
	CALL SUBOPT_0x3B
	RET
; .FEND
;void tepuk_tangan() {
;lcd_clear();
;lcd_gotoxy(0, 1);
;lcd_putsf("Hold 1 to exit");
;lcd_gotoxy(0, 0);
;while (1)
;lcd_putsf("XD");
;if(t1 == 0) break;
;capit_lepas;
;if(t1 == 0) break;
;delay(50);
;if(t1 == 0) break;
;capit_ambil;
;if(t1 == 0) break;
;delay(50);
;if(t1 == 0) break;
;void display_map() {
_display_map:
; .FSTART _display_map
;cek_sensor();
	CALL _cek_sensor
;lcd_gotoxy(7, 0);
	LDI  R30,LOW(7)
	CALL SUBOPT_0x3
;sprintf(buff, "%d", mapMirror);
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,12
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_mapMirror)
	LDI  R27,HIGH(_mapMirror)
	CALL __EEPROMRDW
	CALL SUBOPT_0xD
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
;lcd_puts(buff);
	LDI  R26,LOW(_buff)
	LDI  R27,HIGH(_buff)
	CALL _lcd_puts
	RET
; .FEND
;void tes_sensor()
;for (i = 0; i < 7; i++)
;lcd_gotoxy(0, 0);
;sprintf(buff, "sensor:%d = %d  ", i, read_adc(i));
;lcd_puts(buff);
;delay_ms(100);
;void tampil_count()
;lcd_gotoxy(0, 0);
;sprintf(buff, " %d  ", second);
;lcd_puts(buff);
;interrupt[TIM0_OVF] void timer0_ovf_isr(void)
; 0000 006C {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 006D TCNT0 = 0x96; // BE
	LDI  R30,LOW(150)
	OUT  0x32,R30
; 0000 006E a++;
	LDS  R30,_a
	SUBI R30,-LOW(1)
	STS  _a,R30
; 0000 006F 
; 0000 0070 if (a <= pos_servo1)
	LDS  R26,_a
	CP   R13,R26
	BRLO _0x162
; 0000 0071 {
; 0000 0072 servo1 = 0;
	CBI  0x15,6
; 0000 0073 }
; 0000 0074 else
	RJMP _0x165
_0x162:
; 0000 0075 {
; 0000 0076 servo1 = 1;
	SBI  0x15,6
; 0000 0077 }
_0x165:
; 0000 0078 if (a <= pos_servo2)
	LDS  R26,_a
	CP   R12,R26
	BRLO _0x168
; 0000 0079 {
; 0000 007A servo2 = 0;
	CBI  0x15,7
; 0000 007B }
; 0000 007C else
	RJMP _0x16B
_0x168:
; 0000 007D {
; 0000 007E servo2 = 1;
	SBI  0x15,7
; 0000 007F }
_0x16B:
; 0000 0080 // if (a <= pos_gulung)
; 0000 0081 // {
; 0000 0082 //     servo_gulung = 0;
; 0000 0083 // }
; 0000 0084 // else
; 0000 0085 // {
; 0000 0086 //     servo_gulung = 1;
; 0000 0087 // }
; 0000 0088 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;interrupt[TIM0_COMP] void timer0_comp_isr(void)
; 0000 008C {
_timer0_comp_isr:
; .FSTART _timer0_comp_isr
; 0000 008D // Place your code here
; 0000 008E }
	RETI
; .FEND
;void main(void)
; 0000 0091 {
_main:
; .FSTART _main
; 0000 0092 // Declare your local variables here
; 0000 0093 
; 0000 0094 // Input/Output Ports initialization
; 0000 0095 // Port A initialization
; 0000 0096 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0097 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0098 PORTA = 0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0099 DDRA = 0x00;
	OUT  0x1A,R30
; 0000 009A 
; 0000 009B // Port B initialization
; 0000 009C // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 009D // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 009E PORTB = 0x08;
	LDI  R30,LOW(8)
	OUT  0x18,R30
; 0000 009F DDRB = 0Xff; // 0x08;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 00A0 
; 0000 00A1 // Port C initialization
; 0000 00A2 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00A3 // State7=T State6=T State5=T State4=T State3=P State2=P State1=P State0=P
; 0000 00A4 PORTC = 0xFF;
	OUT  0x15,R30
; 0000 00A5 DDRC = 0xF0; // C0
	LDI  R30,LOW(240)
	OUT  0x14,R30
; 0000 00A6 
; 0000 00A7 // Port D initialization
; 0000 00A8 // Func7=In Func6=In Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 00A9 // State7=T State6=T State5=0 State4=0 State3=T State2=T State1=T State0=T
; 0000 00AA PORTD = 0x03;
	LDI  R30,LOW(3)
	OUT  0x12,R30
; 0000 00AB DDRD = 0xFC; // 3F
	LDI  R30,LOW(252)
	OUT  0x11,R30
; 0000 00AC 
; 0000 00AD // Timer/Counter 0 initialization
; 0000 00AE TCCR0 = 0x4A;
	LDI  R30,LOW(74)
	OUT  0x33,R30
; 0000 00AF TCNT0 = 0x96;
	LDI  R30,LOW(150)
	OUT  0x32,R30
; 0000 00B0 OCR0 = 0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 00B1 
; 0000 00B2 // Timer/Counter 1 initialization
; 0000 00B3 TCCR1A = 0xA1;
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0000 00B4 TCCR1B = 0x09;
	LDI  R30,LOW(9)
	OUT  0x2E,R30
; 0000 00B5 TCNT1H = 0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 00B6 TCNT1L = 0x00;
	OUT  0x2C,R30
; 0000 00B7 ICR1H = 0x00;
	OUT  0x27,R30
; 0000 00B8 ICR1L = 0x00;
	OUT  0x26,R30
; 0000 00B9 OCR1AH = 0x00;
	OUT  0x2B,R30
; 0000 00BA OCR1AL = 0x00;
	OUT  0x2A,R30
; 0000 00BB OCR1BH = 0x00;
	OUT  0x29,R30
; 0000 00BC OCR1BL = 0x00;
	OUT  0x28,R30
; 0000 00BD 
; 0000 00BE // Timer/Counter 2 initialization
; 0000 00BF // Clock source: System Clock
; 0000 00C0 // Clock value: Timer 2 Stopped
; 0000 00C1 // Mode: Normal top=FFh
; 0000 00C2 // OC2 output: Disconnected
; 0000 00C3 ASSR = 0x00;
	OUT  0x22,R30
; 0000 00C4 TCCR2 = 0x00;
	OUT  0x25,R30
; 0000 00C5 TCNT2 = 0x00;
	OUT  0x24,R30
; 0000 00C6 OCR2 = 0x00;
	OUT  0x23,R30
; 0000 00C7 
; 0000 00C8 // External Interrupt(s) initialization
; 0000 00C9 // INT0: Off
; 0000 00CA // INT1: Off
; 0000 00CB // INT2: Off
; 0000 00CC MCUCR = 0x00;
	OUT  0x35,R30
; 0000 00CD MCUCSR = 0x00;
	OUT  0x34,R30
; 0000 00CE 
; 0000 00CF // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00D0 TIMSK = 0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 00D1 
; 0000 00D2 // Analog Comparator initialization
; 0000 00D3 // Analog Comparator: Off
; 0000 00D4 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00D5 ACSR = 0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00D6 SFIOR = 0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00D7 
; 0000 00D8 MCUCR = 0x00;
	OUT  0x35,R30
; 0000 00D9 MCUCSR = 0x00;
	OUT  0x34,R30
; 0000 00DA 
; 0000 00DB // USART, UNTUK KOMUNIKASI BLUETOOTH
; 0000 00DC UCSRA = 0x00;
	OUT  0xB,R30
; 0000 00DD UCSRB = 0x18;
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 00DE UCSRC = 0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 00DF UBRRH = 0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 00E0 UBRRL = 0x47;
	LDI  R30,LOW(71)
	OUT  0x9,R30
; 0000 00E1 // ADC initialization
; 0000 00E2 // ADC Clock frequency: 691.200 kHz
; 0000 00E3 // ADC Voltage Reference: AVCC pin
; 0000 00E4 // ADC Auto Trigger Source: None
; 0000 00E5 // Only the 8 most significant bits of
; 0000 00E6 // the AD conversion result are used
; 0000 00E7 ADMUX = ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(96)
	OUT  0x7,R30
; 0000 00E8 ADCSRA = 0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 00E9 // ADCSRA=0xA6;
; 0000 00EA SFIOR &= 0x1F;
	IN   R30,0x30
	ANDI R30,LOW(0x1F)
	OUT  0x30,R30
; 0000 00EB 
; 0000 00EC // LCD module initialization
; 0000 00ED lcd_init(16); //
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 00EE lcd_clear();  //
	CALL _lcd_clear
; 0000 00EF lampu = 0;    //
	CBI  0x18,3
; 0000 00F0 // k,b
; 0000 00F1 lcd_gotoxy(0, 0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x3
; 0000 00F2 lcd_putsf("     LEGION     ");
	__POINTW2FN _0x0,422
	CALL SUBOPT_0x39
; 0000 00F3 lcd_gotoxy(0, 1);
; 0000 00F4 lcd_putsf(" MAN 4 JOMBANG ");
	__POINTW2FN _0x0,439
	CALL _lcd_putsf
; 0000 00F5 delay_ms(50);
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
; 0000 00F6 lcd_clear();
	CALL _lcd_clear
; 0000 00F7 
; 0000 00F8 // PROGRAM UTAMA
; 0000 00F9 // Global enable interrupts
; 0000 00FA #asm("sei")
	SEI
; 0000 00FB lengan_atas;
	LDI  R30,LOW(234)
	MOV  R12,R30
; 0000 00FC capit_lepas;
	LDI  R30,LOW(230)
	MOV  R13,R30
; 0000 00FD // gulung_stop;
; 0000 00FE 
; 0000 00FF /// mapMirror = 0 - map/lintasan bagian biru
; 0000 0100 /// mapMirror = 1 - map/lintasan bagian merah
; 0000 0101 if(mapMirror != 0 && mapMirror != 1) mapMirror = 0;
	LDI  R26,LOW(_mapMirror)
	LDI  R27,HIGH(_mapMirror)
	CALL __EEPROMRDW
	SBIW R30,0
	BREQ _0x171
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x172
_0x171:
	RJMP _0x170
_0x172:
	LDI  R26,LOW(_mapMirror)
	LDI  R27,HIGH(_mapMirror)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EEPROMWRW
; 0000 0102 
; 0000 0103 lcd_clear();
_0x170:
	CALL SUBOPT_0x38
; 0000 0104 lcd_gotoxy(0, 0);
; 0000 0105 lcd_putsf("Menu");
	__POINTW2FN _0x0,100
	CALL SUBOPT_0x39
; 0000 0106 lcd_gotoxy(0, 1);
; 0000 0107 lcd_putsf("Calibration");
	__POINTW2FN _0x0,105
	CALL _lcd_putsf
; 0000 0108 
; 0000 0109 while(1) {
_0x173:
; 0000 010A if(!isChildSelect) {
	LDS  R30,_isChildSelect
	CPI  R30,0
	BRNE _0x176
; 0000 010B display_sensor();
	CALL _display_sensor
; 0000 010C bacawarna();
	RCALL _bacawarna
; 0000 010D display_map();
	RCALL _display_map
; 0000 010E }
; 0000 010F 
; 0000 0110 // lcd_gotoxy(0, 1);
; 0000 0111 // sprintf(buff, "button1 = %d  ", count_btn);
; 0000 0112 // lcd_puts(buff);
; 0000 0113 
; 0000 0114 //bacawarna();
; 0000 0115 if((t1 == 0)) {
_0x176:
	SBIC 0x13,0
	RJMP _0x177
; 0000 0116 // Program_Jalan();
; 0000 0117 
; 0000 0118 if(!isChildSelect) count_btn ++;
	LDS  R30,_isChildSelect
	CPI  R30,0
	BRNE _0x178
	LDI  R26,LOW(_count_btn)
	LDI  R27,HIGH(_count_btn)
	CALL SUBOPT_0x19
; 0000 0119 // if(isChildSelect) count_child_btn ++;
; 0000 011A if(count_btn >= 7) count_btn = 0;
_0x178:
	LDS  R26,_count_btn
	LDS  R27,_count_btn+1
	SBIW R26,7
	BRLT _0x179
	LDI  R30,LOW(0)
	STS  _count_btn,R30
	STS  _count_btn+1,R30
; 0000 011B delay(10);
_0x179:
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay
; 0000 011C changeMenu(count_btn, false, count_child_btn);
	CALL SUBOPT_0x40
	LDI  R30,LOW(0)
	CALL SUBOPT_0x41
; 0000 011D 
; 0000 011E // buttonhold[0] += 1;
; 0000 011F // while((t1 == 0) && !isTestTombol && !isDelayClick1) {
; 0000 0120 //     isDelayClick1 = true;
; 0000 0121 //     delay(3);
; 0000 0122 //     if(buttonhold[0] > 20) {
; 0000 0123 //         isSelect = true;
; 0000 0124 //         changeMenu();
; 0000 0125 //     } else {
; 0000 0126 //         isSelect = false; isChildSelect = false;
; 0000 0127 //         changeMenu();
; 0000 0128 //         buttonhold[0] = 0;
; 0000 0129 //     }
; 0000 012A //     isDelayClick1 = false; break;
; 0000 012B // }
; 0000 012C // lcd_gotoxy(0, 0);
; 0000 012D // sprintf(buff, "button1 = %d  ", button1click);
; 0000 012E }
; 0000 012F if((t2 == 0)) {
_0x177:
	SBIC 0x13,1
	RJMP _0x17A
; 0000 0130 changeMenu(count_btn, true, count_child_btn);
	CALL SUBOPT_0x40
	LDI  R30,LOW(1)
	CALL SUBOPT_0x41
; 0000 0131 delay(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay
; 0000 0132 }
; 0000 0133 // lcd_puts(buff);
; 0000 0134 // } else if((t1 == 1)) {
; 0000 0135 //     buttonhold[0] = 0;
; 0000 0136 //     isDelayClick1 = false;
; 0000 0137 // }
; 0000 0138 
; 0000 0139 // if ((count_btn==0) && (t2==0)){
; 0000 013A //     lcd_clear();
; 0000 013B //     lcd_gotoxy(0, 0);
; 0000 013C //     lcd_putsf("menu 1");
; 0000 013D // } else if((count_btn == 1) && (t2 == 0)) {
; 0000 013E //     lcd_clear();
; 0000 013F //     lcd_gotoxy(0, 0);
; 0000 0140 //     lcd_putsf("menu 2");
; 0000 0141 // } else if((count_btn == 2) && (t2 == 0)) {
; 0000 0142 //     lcd_clear();
; 0000 0143 //     lcd_gotoxy(0, 0);
; 0000 0144 //     lcd_putsf("menu 3");
; 0000 0145 // } else if((count_btn == 3) && (t2 == 0)) {
; 0000 0146 //     lcd_clear();
; 0000 0147 //     lcd_gotoxy(0, 0);
; 0000 0148 //     lcd_putsf("menu 4");
; 0000 0149 // } else if((count_btn == 4) && (t2 == 0)) {
; 0000 014A //     lcd_clear();
; 0000 014B //     lcd_gotoxy(0, 0);
; 0000 014C //     lcd_putsf("menu 5");
; 0000 014D // } else if((count_btn == 5) && (t2 == 0)) {
; 0000 014E //     lcd_clear();
; 0000 014F //     lcd_gotoxy(0, 0);
; 0000 0150 //     lcd_putsf("menu 6");
; 0000 0151 // } else if((count_btn == 6) && (t2 == 0)) {
; 0000 0152 //     lcd_clear();
; 0000 0153 //     lcd_gotoxy(0, 0);
; 0000 0154 //     lcd_putsf("menu 7");
; 0000 0155 // } else if((count_btn == 7) && (t2 == 0)) {
; 0000 0156 //     lcd_clear();
; 0000 0157 //     lcd_gotoxy(0, 0);
; 0000 0158 //     lcd_putsf("menu 8");
; 0000 0159 // } else if((count_btn == 8) && (t2 == 0)) {
; 0000 015A //     lcd_clear();
; 0000 015B //     lcd_gotoxy(0, 0);
; 0000 015C //     lcd_putsf("menu 9");
; 0000 015D // } else if((count_btn == 9) && (t2 == 0)) {
; 0000 015E //     lcd_clear();
; 0000 015F //     lcd_gotoxy(0, 0);
; 0000 0160 //     lcd_putsf("menu 10");
; 0000 0161 // } else if((count_btn == 10) && (t2 == 0)) {
; 0000 0162 //     lcd_clear();
; 0000 0163 //     lcd_gotoxy(0, 0);
; 0000 0164 // }
; 0000 0165 
; 0000 0166 // if (    (t2 == 0)
; 0000 0167 //         && !isTestTombol
; 0000 0168 //         && (!isChildSelect && menuSelect == 0) // Jika Menu di Run Bot, janga ...
; 0000 0169 //     ) {
; 0000 016A 
; 0000 016B //         // lengan_bawah;
; 0000 016C //         // delay(50);
; 0000 016D //     // menuSelect += 1;
; 0000 016E //     // if(menuSelect >= 4) menuSelect = 0;
; 0000 016F //     // changeMenu();
; 0000 0170 
; 0000 0171 //     scan_garis();
; 0000 0172 //     delay(300);
; 0000 0173 //     scan_back();
; 0000 0174 //     delay(100);
; 0000 0175 //     hit_tengah();
; 0000 0176 
; 0000 0177 //     // button1click = 0;
; 0000 0178 //     // lcd_gotoxy(0, 0);
; 0000 0179 //     // sprintf(buff, "button1 = %d  ", button1click);
; 0000 017A //     // lcd_puts(buff);
; 0000 017B // }
; 0000 017C }
_0x17A:
	RJMP _0x173
; 0000 017D }
_0x17B:
	RJMP _0x17B
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
_put_buff_G100:
; .FSTART _put_buff_G100
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x19
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2000013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2000014
	CALL SUBOPT_0x19
_0x2000014:
	RJMP _0x2000015
_0x2000010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x20C0005:
	ADIW R28,5
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	CALL SUBOPT_0x42
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0x42
	RJMP _0x20000CC
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	CALL SUBOPT_0x43
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x44
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0x43
	CALL SUBOPT_0x45
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0x43
	CALL SUBOPT_0x45
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	CALL SUBOPT_0x43
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	CALL SUBOPT_0x43
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	CALL SUBOPT_0x42
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	CALL SUBOPT_0x42
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CD
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x44
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0x42
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x44
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000CC:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LD   R30,X+
	LD   R31,X+
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	SBIW R30,0
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0004
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	LD   R30,X+
	LD   R31,X+
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	LD   R30,X+
	LD   R31,X+
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20C0004:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG
_abs:
; .FSTART _abs
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    sbiw r30,0
    brpl __abs0
    com  r30
    com  r31
    adiw r30,1
__abs0:
    ret
; .FEND

	.DSEG

	.CSEG
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
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G103:
; .FSTART __lcd_delay_G103
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
; .FEND
__lcd_ready:
; .FSTART __lcd_ready
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	RCALL __lcd_delay_G103
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G103
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G103
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G103
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
; .FEND
__lcd_write_nibble_G103:
; .FSTART __lcd_write_nibble_G103
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G103
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G103
	RET
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G103
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G103
    sbi   __lcd_port,__lcd_rd     ;RD=1
	JMP  _0x20C0001
; .FEND
__lcd_read_nibble_G103:
; .FSTART __lcd_read_nibble_G103
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G103
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G103
    andi  r30,0xf0
	RET
; .FEND
_lcd_read_byte0_G103:
; .FSTART _lcd_read_byte0_G103
	CALL __lcd_delay_G103
	RCALL __lcd_read_nibble_G103
    mov   r26,r30
	RCALL __lcd_read_nibble_G103
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	CALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G103)
	SBCI R31,HIGH(-__base_y_G103)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	CALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x20C0003:
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	CALL __lcd_ready
	LDI  R26,LOW(2)
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R26,LOW(12)
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R26,LOW(1)
	CALL __lcd_write_data
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2060004
	__lcd_putchar1:
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2060004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
	LD   R26,Y
	CALL __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	JMP  _0x20C0001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2060005:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2060007
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2060005
_0x2060007:
	RJMP _0x20C0002
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2060008:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x206000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2060008
_0x206000A:
_0x20C0002:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
__long_delay_G103:
; .FSTART __long_delay_G103
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
; .FEND
__lcd_init_write_G103:
; .FSTART __lcd_init_write_G103
	ST   -Y,R26
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	CALL __lcd_write_nibble_G103
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x20C0001
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G103,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G103,3
	CALL SUBOPT_0x46
	CALL SUBOPT_0x46
	CALL SUBOPT_0x46
	RCALL __long_delay_G103
	LDI  R26,LOW(32)
	RCALL __lcd_init_write_G103
	RCALL __long_delay_G103
	LDI  R26,LOW(40)
	CALL SUBOPT_0x47
	LDI  R26,LOW(4)
	CALL SUBOPT_0x47
	LDI  R26,LOW(133)
	CALL SUBOPT_0x47
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G103
	CPI  R30,LOW(0x5)
	BREQ _0x206000B
	LDI  R30,LOW(0)
	RJMP _0x20C0001
_0x206000B:
	CALL __lcd_ready
	LDI  R26,LOW(6)
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x20C0001:
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.CSEG

	.DSEG
_buff:
	.BYTE 0x21
_a:
	.BYTE 0x1
_count_btn:
	.BYTE 0x2
_count_child_btn:
	.BYTE 0x2
_isChildSelect:
	.BYTE 0x1
_isTestTombol:
	.BYTE 0x1

	.ESEG
_garis:
	.BYTE 0xE
_back:
	.BYTE 0xE
_tengah:
	.BYTE 0xE

	.DSEG
_sen:
	.BYTE 0x7
_sensor:
	.BYTE 0x2
_error:
	.BYTE 0x2
_lastError:
	.BYTE 0x2
_kp:
	.BYTE 0x2
_kd:
	.BYTE 0x2
_SPEED:
	.BYTE 0x2
_MIN_SPEED:
	.BYTE 0x2
_MAX_SPEED:
	.BYTE 0x2
_count:
	.BYTE 0x2
_second:
	.BYTE 0x2
_positionD:
	.BYTE 0x2

	.ESEG
_mapMirror:
	.BYTE 0x2

	.DSEG
_maxHijau:
	.BYTE 0x2
_maxKuning:
	.BYTE 0x2
_maxMerah:
	.BYTE 0x2
_minHijau:
	.BYTE 0x2
_minKuning:
	.BYTE 0x2
_minMerah:
	.BYTE 0x2
_isWarna:
	.BYTE 0x2
__seed_G102:
	.BYTE 0x4
__base_y_G103:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CP   R8,R30
	CPC  R9,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1:
	MOV  R26,R8
	CALL _read_adc
	MOV  R0,R30
	MOVW R30,R8
	LDI  R26,LOW(_tengah)
	LDI  R27,HIGH(_tengah)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	MOV  R26,R0
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	MUL  R30,R26
	MOVW R30,R0
	__ADDWRR 22,23,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x3:
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(_buff)
	LDI  R31,HIGH(_buff)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x5:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	MOVW R30,R8
	LDI  R26,LOW(_garis)
	LDI  R27,HIGH(_garis)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R31,0
	CALL __EEPROMWRW
	LDI  R30,LOW(0)
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x8:
	CALL _lcd_putsf
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9:
	__POINTW1FN _0x0,25
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R8
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xA:
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
	LDI  R26,LOW(_buff)
	LDI  R27,HIGH(_buff)
	CALL _lcd_puts
	CBI  0x18,3
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
	SBI  0x18,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	MOVW R30,R8
	LDI  R26,LOW(_back)
	LDI  R27,HIGH(_back)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xE:
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	OUT  0x28+1,R31
	OUT  0x28,R30
	LDD  R30,Y+1
	LDI  R31,0
	OUT  0x2A+1,R31
	OUT  0x2A,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x10:
	LD   R26,Y
	LDD  R27,Y+1
	JMP  _delay

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	LD   R30,Y
	LDD  R31,Y+1
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	CALL __CFD1
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _rem

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x14:
	LDS  R30,_sensor
	LDS  R31,_sensor+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	LDS  R30,_MAX_SPEED
	LDS  R31,_MAX_SPEED+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	LDS  R30,_MIN_SPEED
	LDS  R31,_MIN_SPEED+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	RCALL SUBOPT_0x14
	ANDI R30,LOW(0x1C)
	CPI  R30,LOW(0x1C)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	CALL _cek_sensor
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	JMP  _scan

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x19:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	LD   R26,Y
	LDD  R27,Y+1
	JMP  _rem

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1B:
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R26,Y+3
	CALL _kiri
	JMP  _cek_sensor

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1C:
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R26,Y+3
	CALL _kanan
	JMP  _cek_sensor

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1D:
	ST   -Y,R27
	ST   -Y,R26
	LDI  R26,LOW(_mapMirror)
	LDI  R27,HIGH(_mapMirror)
	CALL __EEPROMRDW
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1E:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x1F:
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x20:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x21:
	LDI  R26,LOW(120)
	LDI  R27,0
	JMP  _scanX

;OPTIMIZER ADDED SUBROUTINE, CALLED 72 TIMES, CODE SIZE REDUCTION:139 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 52 TIMES, CODE SIZE REDUCTION:99 WORDS
SUBOPT_0x23:
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _scanX

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x24:
	LDI  R26,LOW(15)
	LDI  R27,0
	CALL _delay
	RJMP SUBOPT_0x22

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:112 WORDS
SUBOPT_0x25:
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(5)
	LDI  R27,0
	CALL _scanKotak
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _taruh
	LDI  R30,LOW(100)
	ST   -Y,R30
	LDI  R26,LOW(100)
	CALL _mundur
	LDI  R26,LOW(38)
	LDI  R27,0
	CALL _delay
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x26:
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _belokKiri
	RJMP SUBOPT_0x20

;OPTIMIZER ADDED SUBROUTINE, CALLED 48 TIMES, CODE SIZE REDUCTION:91 WORDS
SUBOPT_0x27:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x28:
	CALL _bawah_lepas
	RJMP SUBOPT_0x22

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x29:
	LDI  R26,LOW(20)
	LDI  R27,0
	JMP  _belokKanan

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x2A:
	LDI  R26,LOW(20)
	LDI  R27,0
	JMP  _belokKiri

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2B:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x2C:
	LDI  R26,LOW(5)
	LDI  R27,0
	CALL _belokKanan
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2D:
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2E:
	LDI  R30,LOW(100)
	ST   -Y,R30
	LDI  R26,LOW(100)
	CALL _mundur
	LDI  R26,LOW(33)
	LDI  R27,0
	CALL _delay
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	LDI  R26,LOW(90)
	LDI  R27,0
	CALL _scanX
	RJMP SUBOPT_0x22

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x30:
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _scanTimer
	LDI  R26,LOW(20)
	LDI  R27,0
	JMP  _ambil

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x31:
	LDI  R26,LOW(5)
	LDI  R27,0
	CALL _scanKotak
	LDI  R26,LOW(20)
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x32:
	LDS  R30,_positionD
	LDS  R31,_positionD+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:96 WORDS
SUBOPT_0x33:
	LDI  R30,LOW(100)
	ST   -Y,R30
	LDI  R26,LOW(100)
	CALL _mundur
	LDI  R26,LOW(38)
	LDI  R27,0
	CALL _delay
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x34:
	LDS  R26,_positionD
	LDS  R27,_positionD+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x36:
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay
	CALL _checkWarna
	STS  _isWarna,R30
	STS  _isWarna+1,R31
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x37:
	LDS  R26,_isWarna
	LDS  R27,_isWarna+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x38:
	CALL _lcd_clear
	LDI  R30,LOW(0)
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x39:
	CALL _lcd_putsf
	LDI  R30,LOW(0)
	RJMP SUBOPT_0x1F

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x3A:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(0)
	LDI  R27,0
	JMP  _changeMenu

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3B:
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _delay

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3C:
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _setMotor
	LDI  R26,LOW(200)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3D:
	CALL _lcd_putsf
	LDI  R30,LOW(65436)
	LDI  R31,HIGH(65436)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3E:
	LDI  R26,LOW(65436)
	LDI  R27,HIGH(65436)
	CALL _setMotor
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
	LDI  R30,LOW(0)
	RJMP SUBOPT_0x1F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3F:
	CALL _lcd_putsf
	LDI  R30,LOW(0)
	STS  _isTestTombol,R30
	LDI  R26,LOW(50)
	LDI  R27,0
	JMP  _delay

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x40:
	LDS  R30,_count_btn
	LDS  R31,_count_btn+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x41:
	ST   -Y,R30
	LDS  R26,_count_child_btn
	LDS  R27,_count_child_btn+1
	JMP  _changeMenu

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x42:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x43:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x44:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x45:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x46:
	CALL __long_delay_G103
	LDI  R26,LOW(48)
	JMP  __lcd_init_write_G103

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x47:
	CALL __lcd_write_data
	JMP  __long_delay_G103

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
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

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	NEG  R27
	NEG  R26
	SBCI R27,0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	MOVW R22,R30
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0xACD
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
