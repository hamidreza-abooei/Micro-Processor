/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 6/29/2022
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

// Declare your global variables here

// Standard Input/Output functions
#include <stdio.h>
#include <stdlib.h>
#include <delay.h>
#define ADC_INIT ((1<<REFS0) | (0<<ADLAR))

unsigned char key_pressed;
unsigned int pass = 0;
unsigned int password = 0,passtemp;
unsigned char fail_counter = 0,i;
unsigned char temp[4];
unsigned char alpha;
//Init and seed.
unsigned int u_seed_rand_val = 0;
// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Place your code here

PORTC.0 = ~PORTC.0;
}

// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
    TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
    TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
    TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);       
    SREG.7=0;

}

void send_number(unsigned char number){
    if(number == 10){     //Enter
          if(pass == password){
               UDR = 'H';
               while(!(UCSRA & (1<<UDRE)));
               UDR = 'a';
               while(!(UCSRA & (1<<UDRE)));
               UDR = 'm';
               while(!(UCSRA & (1<<UDRE)));
               UDR = 'i';
               while(!(UCSRA & (1<<UDRE)));
               UDR = 'd';
               while(!(UCSRA & (1<<UDRE)));
               UDR = 'R';
               while(!(UCSRA & (1<<UDRE)));
               UDR = 'e';
               while(!(UCSRA & (1<<UDRE)));
               UDR = 'z';
               while(!(UCSRA & (1<<UDRE)));
               UDR = 'a';
               while(!(UCSRA & (1<<UDRE)));
          }else{
               
               if (fail_counter == 2){
                    UDR = 'L';
                    while(!(UCSRA & (1<<UDRE))); 
                    UDR = 'O';
                    while(!(UCSRA & (1<<UDRE)));
                    UDR = 'C';
                    while(!(UCSRA & (1<<UDRE)));
                    UDR = 'K';
                    while(!(UCSRA & (1<<UDRE)));  
                    // Timer/Counter 0 initialization
                    // Clock source: System Clock
                    // Clock value: 1000.000 kHz
                    // Mode: Normal top=0xFF
                    // OC0 output: Disconnected
                    // Timer Period: 0.256 ms
                    TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (1<<CS01) | (0<<CS00);
                    TCNT0=0x00;
                    OCR0=0x00;

                    // Timer/Counter 1 initialization
                    // Clock source: System Clock
                    // Clock value: 7.813 kHz
                    // Mode: Normal top=0xFFFF
                    // OC1A output: Disconnected
                    // OC1B output: Disconnected
                    // Noise Canceler: Off
                    // Input Capture on Falling Edge
                    // Timer Period: 2.9999 s
                    // Timer1 Overflow Interrupt: On
                    // Input Capture Interrupt: Off
                    // Compare A Match Interrupt: Off
                    // Compare B Match Interrupt: Off
                    TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
                    TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (1<<CS12) | (0<<CS11) | (1<<CS10);
                    TCNT1H=0xA4;
                    TCNT1L=0x73;
                    ICR1H=0x00;
                    ICR1L=0x00;
                    OCR1AH=0x00;
                    OCR1AL=0x00;
                    OCR1BH=0x00;
                    OCR1BL=0x00;

                    // Timer(s)/Counter(s) Interrupt(s) initialization
                    TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);

               }else{
                    UDR = 'F';
                    while(!(UCSRA & (1<<UDRE))); 
                    UDR = 'A';
                    while(!(UCSRA & (1<<UDRE)));
                    UDR = 'I';
                    while(!(UCSRA & (1<<UDRE)));
                    UDR = 'L';
                    while(!(UCSRA & (1<<UDRE)));
                    fail_counter++;
                    pass = 0;
               }
          
          }      
    }else if (number == 11){    // Do Nothing
    
    }else if(fail_counter != 3){
        pass = pass * 10 + number;
        UDR = '0'+number;
        while(!(UCSRA & (1<<UDRE)));
        
    }
     

}



void GET_KEY (void){
    key_pressed = 50;   //  
    PORTA=0XFE;
    if(PINB.0==0)
            {
            delay_ms(100);
            if(PINB.0==0)
                {
                    //while (PINB.0==0){}
                    key_pressed=1;  
                }
            }
     if(PINB.1==0)
            {
            delay_ms(100);
            if(PINB.1==0)
                {
                    //while (PINB.1==0){}
                    key_pressed=4;  
                }
            }
            
     if(PINB.2==0)
            {
            delay_ms(100);
            if(PINB.2==0)
                {
                    //while (PINB.2==0){}
                    key_pressed=7;  
                }
            }  
            
     if(PINB.3==0)
            {
            delay_ms(100);
            if(PINB.3==0)
                {
                    //while (PINB.3==0){}
                    key_pressed=10;  //      *
                }
            }

   
        
      PORTA=0XFD;
      if(PINB.0==0)
            {
            delay_ms(100);
            if(PINB.0==0)
                {
                    //while (PINB.0==0){}
                    key_pressed=2;  
                }
            }
     if(PINB.1==0)
            {
            delay_ms(100);
            if(PINB.1==0)
                {
                    //while (PINB.1==0){}
                    key_pressed=5;  
                }
            }
            
     if(PINB.2==0)
            {
            delay_ms(100);
            if(PINB.2==0)
                {
                    //while (PINB.2==0){}
                    key_pressed=8;  
                }
            }  
            
     if(PINB.3==0)
            {
            delay_ms(100);
            if(PINB.3==0)
                {
                    //while (PINB.2==0){}
                    key_pressed=0;     
                }
            }
              
      PORTA=0XFB;
      if(PINB.0==0)
            {
            delay_ms(100);
            if(PINB.0==0)
                {
                    //while (PINB.0==0){}
                    key_pressed=3;  
                }
            }
     if(PINB.1==0)
            {
            delay_ms(100);
            if(PINB.1==0)
                {
                    //while (PINB.1==0){}
                    key_pressed=6;  
                }
            }
            
     if(PINB.2==0)
            {
            delay_ms(100);
            if(PINB.2==0)
                {
                    //while (PINB.2==0){}
                    key_pressed=9;  
                }
            }  
            
     if(PINB.3==0)
            {
            delay_ms(100);
            if(PINB.3==0)
                {
                   // while (PINB.3==0){}
                    key_pressed=11;   //     #
                }
            } 
       if(key_pressed!=50){     
       send_number(key_pressed);  }   
       PORTA=0XF0;  
            
            

}


unsigned char ADC_run(void){
    
    ADCSRA|=(1<<ADSC);
    while ((ADCSRA & (1<<ADIF))==0);
    ADCSRA|=(1<<ADIF);
    alpha = ADCH;
    return ADCL;

}

void main(void)
{

// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=Out Bit0=Out 
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=0 Bit1=0 Bit0=0 
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=P Bit2=P Bit1=P Bit0=P 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (1<<PORTB3) | (1<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);

// Port C initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=Out 
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (1<<DDC0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=0 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);


// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: Off
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x33;

ADMUX = ADC_INIT | 3;
ADCSRA = (1<<ADEN)| (0<<ADSC)| (0<<ADATE)| (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1);
    



  //init_adc();
  //Note we're assuming the channel that you are reading from is FLOATING or hooked up to something very noisy.  
  //Gather bits from the adc, pushing them into your pseudorandom seed.        
  u_seed_rand_val = 0;
  for( i=0; i<16; i++){
      u_seed_rand_val = u_seed_rand_val<<1 | (ADC_run()&0b1);
  } 
//    passtemp =  u_seed_rand_val;
//    for (i=0;i<4;i++){
//        temp[i] =  passtemp%10;
//        passtemp = passtemp/10;
//        
//    }
//    for (i=0;i<4;i++){
//        UDR = '0'+temp[3-i];
//        while(!(UCSRA & (1<<UDRE)));
//    
//    } 
//  
  
   srand (u_seed_rand_val);

   password = rand()%9999;
    // Global enable interrupts 
    passtemp = password;
    #asm("sei") 
    for (i=0;i<4;i++){
        temp[i] =  passtemp%10;
        passtemp = passtemp/10;
        
    }
    for (i=0;i<4;i++){
        UDR = '0'+temp[3-i];
        while(!(UCSRA & (1<<UDRE)));
    
    }   
    
     
while (1)
      {
      // Place your code here
        if ((PINB&0x0F) != 0x0F){
            GET_KEY();
            //PORTA.4 = ~PORTA.4; 
            delay_ms(200);
        }
        
      }
}
