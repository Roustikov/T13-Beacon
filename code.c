/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.3 Standard
Automatic Program Generator
© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 09.05.2014
Author  : MakZ
Company : 
Comments: 


Chip type               : ATtiny13A
AVR Core Clock frequency: 8,000000 MHz
Memory model            : Tiny
External RAM size       : 0
Data Stack size         : 16
*****************************************************/

#include <tiny13a.h>
#include <sleep.h>
#include <delay.h>

#define OFF 1
#define ON 0

#define LIGHT1(X) PORTB.0 = X;
#define LIGHT2(X) PORTB.2 = X;

int mode = 0;
int delay_t = 0;
int isSleep = 0;

void mode_switch()
{
    if(isSleep == 1)
    {
        mode = 5;
    }
    else
    {
        mode++;
        if(mode == 6)
            mode = 0; 
    }  
    isSleep = 0;
}

void mode_set(int mode_number)
{
    mode = mode_number; 
}

// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
    sleep_disable();
    delay_ms(600);
     
    if(PINB.1 == 1)
    {
        mode_switch();
    }
    else
    {
        mode_set(5);
        isSleep = 1;
    }
}

// Declare your global variables here

void strobe(int length)
{
    LIGHT1(ON);
    LIGHT2(ON);
    delay_ms(length);
    LIGHT1(OFF);
    LIGHT2(OFF);
    delay_ms(length);
}


void main(void)
{
// Declare your local variables here
int i = 0;
// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Input/Output Ports initialization
// Port B initialization
// Func5=In Func4=In Func3=In Func2=Out Func1=In Func0=Out 
// State5=T State4=T State3=T State2=0 State1=T State0=0 
PORTB=0x00;
DDRB=0x05;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=0x00;
TCCR0B=0x00;
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Low level
// Interrupt on any change on pins PCINT0-5: Off
GIMSK=0x40;
MCUCR=0x00;
GIFR=0x40;

// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
ACSR=0x80;
ADCSRB=0x00;
DIDR0=0x00;

// ADC initialization
// ADC disabled
ADCSRA=0x00;

// Global enable interrupts
#asm("sei")

while (1)
      {
            while(mode == 0)
            {
                LIGHT1(ON);
                LIGHT2(ON);
            }
            
            while(mode == 1)
            {
                strobe(200);
            }    
       
            while(mode == 2)
            {   
                delay_t = 0;
                
                for(i = 0; i < 7; i++)
                {
                    strobe(50);
                }
                
                while(mode == 2 && delay_t < 7)
                {
                    delay_ms(100);
                    delay_t++;
                }                
            }   
            
            while(mode == 3)
            {
                LIGHT1(ON);
                LIGHT2(ON);     
                delay_ms(300);
                LIGHT1(OFF);
                LIGHT2(OFF);  
                
                delay_t = 0;
                while(mode == 3 && delay_t < 11)
                {
                    delay_ms(100);
                    delay_t++;
                }        
            }
            
            while(mode == 4)
            {
                LIGHT2(OFF);
                LIGHT1(ON);
                
                delay_t = 0;
                while(mode == 4 && delay_t < 4)
                {
                    delay_ms(100);
                    delay_t++;
                }    

                if(mode != 4)
                    break;           
                
                LIGHT2(ON);
                LIGHT1(OFF);

                delay_t = 0;
                while(mode == 4 && delay_t < 4)
                {
                    delay_ms(100);
                    delay_t++;
                }
            }
            
            while(mode == 5)
            {    
                 LIGHT1(OFF);
                 LIGHT2(OFF);
                 sleep_enable();
                 powerdown();  
            }   
      }
}
