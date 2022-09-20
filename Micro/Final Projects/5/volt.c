/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 6/30/2022
Author  : 
Company : 
Comments: 


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/

#include <mega32.h>

#include <delay.h>
// Voltage Reference: AREF pin
#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (1<<ADLAR))
// Declare your global variables here
unsigned int data,data1;
float res;
unsigned char outl,outh;
unsigned char temp;
const unsigned char seven[] = {0x40, 0x79, 0x24, 0x30, 0x19, 0x12, 0x2, 0x78, 0x0, 0x10}; 



void show(unsigned char outh,unsigned char outl){
    temp = outh / 10;
    PORTD = 0x01;  
    PORTC = seven[temp]| 0x80;
    delay_us(550);     
    
    temp = outh % 10;
    PORTD = 0x02;
    PORTC = seven[temp] ;   
    delay_us(550); 
    
    temp = outl / 10; 
    PORTD = 0x04;
    PORTC = seven[temp]| 0x80;     
    delay_us(550); 
    
    
    temp = outl % 10;
    PORTD = 0x08;
    PORTC = seven[temp]| 0x80; 
    delay_us(550);
    
    


}

// ADC interrupt service routine
// with auto input scanning
//interrupt [ADC_INT] void adc_isr(void)
//{
//
//    data = ADCL;
//    data = data + ADCH<<8; 
//    PORTB = data;
//    res = data * 5.0 / 1024.0;
//    outh = (unsigned char) res; 
//    //PORTB = outh;
//    outl = (unsigned char) ((res - outh)*100);
//    
//// Delay needed for the stabilization of the ADC input voltage
////delay_us(10);
//// Start the AD conversion
//ADCSRA|=(1<<ADSC);
//}

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
//DDRB = 0xff;
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// ADC initialization
// ADC Clock frequency: 1000.000 kHz
// ADC Voltage Reference: AREF pin
// ADC Auto Trigger Source: Free Running
ADMUX= ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (1<<ADSC) | (1<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);

// Global enable interrupts
#asm("sei")

while (1)
      {
      // Place your code here  
      
      
    
    
    // Delay needed for the stabilization of the ADC input voltage
    //delay_us(10);
    // Start the AD conversion
    ADCSRA|=(1<<ADSC);  
    while((ADCSRA & (1<<ADIF))==0){
        show(outh,outl);
    }
    //temp = ADCL;
    //PORTB = temp;
    //data = temp + ADCH<<8; 
    data = ADCL;
    data = temp>>6;
    data1 = ADCH;
    data1 = data1<<2;
    res = (data1 + data) * 100.0 / 1024.0;
    outh = (unsigned char) res; 
    //PORTB = outh;
    outl = (unsigned char) ((res - outh)*100);
    
      
      }
}
