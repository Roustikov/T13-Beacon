
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATtiny13A
;Program type             : Application
;Clock frequency          : 8,000000 MHz
;Memory model             : Tiny
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 16 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Smart register allocation          : Off
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATtiny13A
	#pragma AVRPART MEMORY PROG_FLASH 1024
	#pragma AVRPART MEMORY EEPROM 64
	#pragma AVRPART MEMORY INT_SRAM SIZE 159
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E

	.EQU WDTCR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
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
	.EQU __SRAM_END=0x009F
	.EQU __DSTACK_SIZE=0x0010
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
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
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
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
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
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __GETB1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOV  R30,R0
	MOV  R31,R1
	.ENDM

	.MACRO __GETB2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOV  R26,R0
	MOV  R27,R1
	.ENDM

	.MACRO __GETBRSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOV  R26,R28
	MOV  R27,R29
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
	MOV  R26,R28
	MOV  R27,R29
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
	MOV  R26,R28
	MOV  R27,R29
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

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _mode=R4
	.DEF _delay_t=R6
	.DEF _isSleep=R8

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP _ext_int0_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_0x56:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x06
	.DW  0x04
	.DW  _0x56*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,__CLEAR_SRAM_SIZE
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM
	ADIW R30,1
	MOV  R24,R0
	LPM
	ADIW R30,1
	MOV  R25,R0
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM
	ADIW R30,1
	MOV  R26,R0
	LPM
	ADIW R30,1
	MOV  R27,R0
	LPM
	ADIW R30,1
	MOV  R1,R0
	LPM
	ADIW R30,1
	MOV  R22,R30
	MOV  R23,R31
	MOV  R31,R0
	MOV  R30,R1
__GLOBAL_INI_LOOP:
	LPM
	ADIW R30,1
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOV  R30,R22
	MOV  R31,R23
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x70

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.3 Standard
;Automatic Program Generator
;© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 09.05.2014
;Author  : MakZ
;Company :
;Comments:
;
;
;Chip type               : ATtiny13A
;AVR Core Clock frequency: 8,000000 MHz
;Memory model            : Tiny
;External RAM size       : 0
;Data Stack size         : 16
;*****************************************************/
;
;#include <tiny13a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x18
	.EQU __sm_adc_noise_red=0x08
	.EQU __sm_powerdown=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <sleep.h>
;#include <delay.h>
;
;#define OFF 1
;#define ON 0
;
;#define LIGHT1(X) PORTB.0 = X;
;#define LIGHT2(X) PORTB.2 = X;
;
;int mode = 0;
;int delay_t = 0;
;int isSleep = 0;
;
;void mode_switch()
; 0000 0026 {

	.CSEG
_mode_switch:
; 0000 0027     if(isSleep == 1)
	RCALL SUBOPT_0x0
	CP   R30,R8
	CPC  R31,R9
	BRNE _0x3
; 0000 0028     {
; 0000 0029         mode = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	__PUTW1R 4,5
; 0000 002A     }
; 0000 002B     else
	RJMP _0x4
_0x3:
; 0000 002C     {
; 0000 002D         mode++;
	RCALL SUBOPT_0x0
	__ADDWRR 4,5,30,31
; 0000 002E         if(mode == 6)
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RCALL SUBOPT_0x1
	BRNE _0x5
; 0000 002F             mode = 0;
	CLR  R4
	CLR  R5
; 0000 0030     }
_0x5:
_0x4:
; 0000 0031     isSleep = 0;
	CLR  R8
	CLR  R9
; 0000 0032 }
	RET
;
;void mode_set(int mode_number)
; 0000 0035 {
_mode_set:
; 0000 0036     mode = mode_number;
	ST   -Y,R27
	ST   -Y,R26
;	mode_number -> Y+0
	__GETWRS 4,5,0
; 0000 0037 }
	RJMP _0x2020001
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 003B {
_ext_int0_isr:
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
; 0000 003C     sleep_disable();
	RCALL _sleep_disable
; 0000 003D     delay_ms(600);
	LDI  R26,LOW(600)
	LDI  R27,HIGH(600)
	RCALL _delay_ms
; 0000 003E 
; 0000 003F     if(PINB.1 == 1)
	SBIS 0x16,1
	RJMP _0x6
; 0000 0040     {
; 0000 0041         mode_switch();
	RCALL _mode_switch
; 0000 0042     }
; 0000 0043     else
	RJMP _0x7
_0x6:
; 0000 0044     {
; 0000 0045         mode_set(5);
	LDI  R26,LOW(5)
	RCALL SUBOPT_0x2
	RCALL _mode_set
; 0000 0046         isSleep = 1;
	RCALL SUBOPT_0x0
	__PUTW1R 8,9
; 0000 0047     }
_0x7:
; 0000 0048 }
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
;
;// Declare your global variables here
;
;void strobe(int length)
; 0000 004D {
_strobe:
; 0000 004E     LIGHT1(ON);
	ST   -Y,R27
	ST   -Y,R26
;	length -> Y+0
	CBI  0x18,0
; 0000 004F     LIGHT2(ON);
	CBI  0x18,2
; 0000 0050     delay_ms(length);
	LD   R26,Y
	LDD  R27,Y+1
	RCALL _delay_ms
; 0000 0051     LIGHT1(OFF);
	SBI  0x18,0
; 0000 0052     LIGHT2(OFF);
	SBI  0x18,2
; 0000 0053     delay_ms(length);
	LD   R26,Y
	LDD  R27,Y+1
	RCALL _delay_ms
; 0000 0054 }
_0x2020001:
	ADIW R28,2
	RET
;
;
;void main(void)
; 0000 0058 {
_main:
; 0000 0059 // Declare your local variables here
; 0000 005A int i = 0;
; 0000 005B // Crystal Oscillator division factor: 1
; 0000 005C #pragma optsize-
; 0000 005D CLKPR=0x80;
;	i -> R16,R17
	__GETWRN 16,17,0
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 005E CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 005F #ifdef _OPTIMIZE_SIZE_
; 0000 0060 #pragma optsize+
; 0000 0061 #endif
; 0000 0062 
; 0000 0063 // Input/Output Ports initialization
; 0000 0064 // Port B initialization
; 0000 0065 // Func5=In Func4=In Func3=In Func2=Out Func1=In Func0=Out
; 0000 0066 // State5=T State4=T State3=T State2=0 State1=T State0=0
; 0000 0067 PORTB=0x00;
	OUT  0x18,R30
; 0000 0068 DDRB=0x05;
	LDI  R30,LOW(5)
	OUT  0x17,R30
; 0000 0069 
; 0000 006A // Timer/Counter 0 initialization
; 0000 006B // Clock source: System Clock
; 0000 006C // Clock value: Timer 0 Stopped
; 0000 006D // Mode: Normal top=0xFF
; 0000 006E // OC0A output: Disconnected
; 0000 006F // OC0B output: Disconnected
; 0000 0070 TCCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0071 TCCR0B=0x00;
	OUT  0x33,R30
; 0000 0072 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0073 OCR0A=0x00;
	OUT  0x36,R30
; 0000 0074 OCR0B=0x00;
	OUT  0x29,R30
; 0000 0075 
; 0000 0076 // External Interrupt(s) initialization
; 0000 0077 // INT0: On
; 0000 0078 // INT0 Mode: Low level
; 0000 0079 // Interrupt on any change on pins PCINT0-5: Off
; 0000 007A GIMSK=0x40;
	LDI  R30,LOW(64)
	OUT  0x3B,R30
; 0000 007B MCUCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 007C GIFR=0x40;
	LDI  R30,LOW(64)
	OUT  0x3A,R30
; 0000 007D 
; 0000 007E // Timer/Counter 0 Interrupt(s) initialization
; 0000 007F TIMSK0=0x00;
	LDI  R30,LOW(0)
	OUT  0x39,R30
; 0000 0080 
; 0000 0081 // Analog Comparator initialization
; 0000 0082 // Analog Comparator: Off
; 0000 0083 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0084 ADCSRB=0x00;
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 0085 DIDR0=0x00;
	OUT  0x14,R30
; 0000 0086 
; 0000 0087 // ADC initialization
; 0000 0088 // ADC disabled
; 0000 0089 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 008A 
; 0000 008B // Global enable interrupts
; 0000 008C #asm("sei")
	sei
; 0000 008D 
; 0000 008E while (1)
_0x10:
; 0000 008F       {
; 0000 0090             while(mode == 0)
_0x13:
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x15
; 0000 0091             {
; 0000 0092                 LIGHT1(ON);
	CBI  0x18,0
; 0000 0093                 LIGHT2(ON);
	CBI  0x18,2
; 0000 0094             }
	RJMP _0x13
_0x15:
; 0000 0095 
; 0000 0096             while(mode == 1)
_0x1A:
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	BRNE _0x1C
; 0000 0097             {
; 0000 0098                 strobe(200);
	LDI  R26,LOW(200)
	RCALL SUBOPT_0x2
	RCALL _strobe
; 0000 0099             }
	RJMP _0x1A
_0x1C:
; 0000 009A 
; 0000 009B             while(mode == 2)
_0x1D:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL SUBOPT_0x1
	BRNE _0x1F
; 0000 009C             {
; 0000 009D                 delay_t = 0;
	RCALL SUBOPT_0x3
; 0000 009E 
; 0000 009F                 for(i = 0; i < 7; i++)
	__GETWRN 16,17,0
_0x21:
	__CPWRN 16,17,7
	BRGE _0x22
; 0000 00A0                 {
; 0000 00A1                     strobe(50);
	LDI  R26,LOW(50)
	RCALL SUBOPT_0x2
	RCALL _strobe
; 0000 00A2                 }
	__ADDWRN 16,17,1
	RJMP _0x21
_0x22:
; 0000 00A3 
; 0000 00A4                 while(mode == 2 && delay_t < 7)
_0x23:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL SUBOPT_0x1
	BRNE _0x26
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	RCALL SUBOPT_0x4
	BRLT _0x27
_0x26:
	RJMP _0x25
_0x27:
; 0000 00A5                 {
; 0000 00A6                     delay_ms(100);
	RCALL SUBOPT_0x5
; 0000 00A7                     delay_t++;
; 0000 00A8                 }
	RJMP _0x23
_0x25:
; 0000 00A9             }
	RJMP _0x1D
_0x1F:
; 0000 00AA 
; 0000 00AB             while(mode == 3)
_0x28:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0x1
	BRNE _0x2A
; 0000 00AC             {
; 0000 00AD                 LIGHT1(ON);
	CBI  0x18,0
; 0000 00AE                 LIGHT2(ON);
	CBI  0x18,2
; 0000 00AF                 delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	RCALL _delay_ms
; 0000 00B0                 LIGHT1(OFF);
	SBI  0x18,0
; 0000 00B1                 LIGHT2(OFF);
	SBI  0x18,2
; 0000 00B2 
; 0000 00B3                 delay_t = 0;
	RCALL SUBOPT_0x3
; 0000 00B4                 while(mode == 3 && delay_t < 11)
_0x33:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0x1
	BRNE _0x36
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	RCALL SUBOPT_0x4
	BRLT _0x37
_0x36:
	RJMP _0x35
_0x37:
; 0000 00B5                 {
; 0000 00B6                     delay_ms(100);
	RCALL SUBOPT_0x5
; 0000 00B7                     delay_t++;
; 0000 00B8                 }
	RJMP _0x33
_0x35:
; 0000 00B9             }
	RJMP _0x28
_0x2A:
; 0000 00BA 
; 0000 00BB             while(mode == 4)
_0x38:
	RCALL SUBOPT_0x6
	BRNE _0x3A
; 0000 00BC             {
; 0000 00BD                 LIGHT2(OFF);
	SBI  0x18,2
; 0000 00BE                 LIGHT1(ON);
	CBI  0x18,0
; 0000 00BF 
; 0000 00C0                 delay_t = 0;
	RCALL SUBOPT_0x3
; 0000 00C1                 while(mode == 4 && delay_t < 4)
_0x3F:
	RCALL SUBOPT_0x6
	BRNE _0x42
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RCALL SUBOPT_0x4
	BRLT _0x43
_0x42:
	RJMP _0x41
_0x43:
; 0000 00C2                 {
; 0000 00C3                     delay_ms(100);
	RCALL SUBOPT_0x5
; 0000 00C4                     delay_t++;
; 0000 00C5                 }
	RJMP _0x3F
_0x41:
; 0000 00C6 
; 0000 00C7                 if(mode != 4)
	RCALL SUBOPT_0x6
	BRNE _0x3A
; 0000 00C8                     break;
; 0000 00C9 
; 0000 00CA                 LIGHT2(ON);
	CBI  0x18,2
; 0000 00CB                 LIGHT1(OFF);
	SBI  0x18,0
; 0000 00CC 
; 0000 00CD                 delay_t = 0;
	RCALL SUBOPT_0x3
; 0000 00CE                 while(mode == 4 && delay_t < 4)
_0x49:
	RCALL SUBOPT_0x6
	BRNE _0x4C
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RCALL SUBOPT_0x4
	BRLT _0x4D
_0x4C:
	RJMP _0x4B
_0x4D:
; 0000 00CF                 {
; 0000 00D0                     delay_ms(100);
	RCALL SUBOPT_0x5
; 0000 00D1                     delay_t++;
; 0000 00D2                 }
	RJMP _0x49
_0x4B:
; 0000 00D3             }
	RJMP _0x38
_0x3A:
; 0000 00D4 
; 0000 00D5             while(mode == 5)
_0x4E:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RCALL SUBOPT_0x1
	BRNE _0x50
; 0000 00D6             {
; 0000 00D7                  LIGHT1(OFF);
	SBI  0x18,0
; 0000 00D8                  LIGHT2(OFF);
	SBI  0x18,2
; 0000 00D9                  sleep_enable();
	RCALL _sleep_enable
; 0000 00DA                  powerdown();
	RCALL _powerdown
; 0000 00DB             }
	RJMP _0x4E
_0x50:
; 0000 00DC       }
	RJMP _0x10
; 0000 00DD }
_0x55:
	RJMP _0x55
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x18
	.EQU __sm_adc_noise_red=0x08
	.EQU __sm_powerdown=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_sleep_enable:
   in   r30,power_ctrl_reg
   sbr  r30,__se_bit
   out  power_ctrl_reg,r30
	RET
_sleep_disable:
   in   r30,power_ctrl_reg
   cbr  r30,__se_bit
   out  power_ctrl_reg,r30
	RET
_powerdown:
   in   r30,power_ctrl_reg
   cbr  r30,__sm_mask
   sbr  r30,__sm_powerdown
   out  power_ctrl_reg,r30
   in   r30,sreg
   sei
   sleep
   out  sreg,r30
	RET

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1:
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x2:
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	CLR  R6
	CLR  R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	CP   R6,R30
	CPC  R7,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(100)
	RCALL SUBOPT_0x2
	RCALL _delay_ms
	RCALL SUBOPT_0x0
	__ADDWRR 6,7,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RJMP SUBOPT_0x1


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

;END OF CODE MARKER
__END_OF_CODE:
