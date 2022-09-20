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
// Declare your global variables here
//eeprom unsigned char id@0x00;
//eeprom unsigned char age@0x01;
//eeprom unsigned char hr@0x02;
//int eeprom  *ptr_id;
//unsigned char eeprom  *ptr_age;
//unsigned char eeprom  *ptr_hr;


unsigned char counter = 0;
unsigned char sec = 0;
unsigned char read_heart = 0;
unsigned char HR = 0;
unsigned char AGE = 0;
unsigned char ID = 0;
unsigned char state =0;
unsigned char str_id[] = "Enter ID";
unsigned char str_age[] = "Enter Age";
unsigned char str_HR[] = "Wait 1 min";
unsigned char i;
unsigned char flag = 0;
unsigned char key_pressed;
unsigned char temp[3];

void EEPROM_write(unsigned int uiAddress, unsigned char ucData)
{
/* Wait for completion of previous write */
while(EECR & (1<<EEWE))
;
/* Set up address and data registers */
EEAR = uiAddress;
EEDR = ucData;
/* Write logical one to EEMWE */
EECR |= (1<<EEMWE);
/* Start eeprom write by setting EEWE */
EECR |= (1<<EEWE);
}



unsigned char EEPROM_read(unsigned int uiAddress)
{
/* Wait for completion of previous write */
while(EECR & (1<<EEWE))
;
/* Set up address register */
EEAR = uiAddress;
/* Start eeprom read by writing EERE */
EECR |= (1<<EERE);
/* Return data from data register */
return EEDR;
}


void show_msg (unsigned char *a){
    for (i=0 ; a[i] != '\0';i++ ){
         UDR = a[i];
         while(!(UCSRA & (1<<UDRE)));
    }
    UDR = '\n';
    while(!(UCSRA & (1<<UDRE)));

}

void show_number (unsigned char a){
    for (i = 0;i<3;i++){
        temp[i] = a%10;
        a = a/10;
    }
    for (i = 0; i < 3 ; i++){
        UDR = '0'+temp[2-i];
        while(!(UCSRA & (1<<UDRE)));
    }
    UDR = ' ';
    while(!(UCSRA & (1<<UDRE)));

}
// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
    if (read_heart == 1){
       HR++;

    }

}

// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)
{
    //show();     //todo
    
    for (i = 0; i<counter;i++){
        show_msg("#");
        show_number(i);
        show_number(EEPROM_read(0x00 + i * 3)); 
        show_number(EEPROM_read(0x01 + i * 3)); 
        show_number(EEPROM_read(0x02 + i * 3)); 
        UDR = '\n';
        while(!(UCSRA & (1<<UDRE)));    
    
    }  
    

}

// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
    sec++;
    if (sec < 59){ //should be 59 for one minute
       // Reinitialize Timer1 value
        TCNT1H=0x85EE >> 8;
        TCNT1L=0x85EE & 0xff;
    }else{    // turn off timer
        read_heart = 0;
        state = 0; 
        show_number(HR);
        UDR = '\n';
        while(!(UCSRA & (1<<UDRE)));    
        show_msg(str_id);
        TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
        TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
        flag = 1; 
        
        
        

    }

}




void send_number (unsigned char number){
    if(number == 10){     //Enter      state = 0: ID    state = 1: Age      state = 2:  counting HR 
         if (state == 0){
            show_msg(str_age);
            AGE = 0;
            state = 1;
         }else if(state == 1){
            // Timer/Counter 1 initialization
            // Clock source: System Clock
            // Clock value: 31.250 kHz
            // Mode: Normal top=0xFFFF
            // OC1A output: Disconnected
            // OC1B output: Disconnected
            // Noise Canceler: Off
            // Input Capture on Falling Edge
            // Timer Period: 1 s
            // Timer1 Overflow Interrupt: On
            // Input Capture Interrupt: Off
            // Compare A Match Interrupt: Off
            // Compare B Match Interrupt: Off
            sec = 0; 
            HR = 0;
            TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
            TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (1<<CS12) | (0<<CS11) | (0<<CS10);
            TCNT1H=0x85;
            TCNT1L=0xEE;
            ICR1H=0x00;
            ICR1L=0x00;
            OCR1AH=0x00;
            OCR1AL=0x00;
            OCR1BH=0x00;
            OCR1BL=0x00;

            // Timer(s)/Counter(s) Interrupt(s) initialization
            TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
            read_heart = 1;
            show_msg(str_HR);
            state = 2;
         }
         
               
    }else if (number == 11){    // Save 
         EEPROM_write(0x00 + counter * 3,ID);
         EEPROM_write(0x01 + counter * 3,AGE);
         EEPROM_write(0x02 + counter * 3,HR); 
         show_number(ID);   
         show_number(AGE);
         show_number(HR);
         show_msg("Saved");
         counter++;
         
         
    }else if ((state == 0) ){ 
        if (flag == 1){
            ID = 0;
            flag =0;
            //show_msg("Clear");
        }
         ID = ID*10 + number;
         UDR = '0'+number;
         while(!(UCSRA & (1<<UDRE)));
         //show_number(ID);
        
    }else if ( (state == 1)){
         AGE = AGE *10 + number;
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
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=Out Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (1<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=P Bit1=0 Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);


// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Falling Edge
// INT1: On
// INT1 Mode: Falling Edge
// INT2: Off
GICR|=(1<<INT1) | (1<<INT0) | (0<<INT2);
MCUCR=(1<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);
GIFR=(1<<INTF1) | (1<<INTF0) | (0<<INTF2);


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

// Global enable interrupts
#asm("sei")
show_msg(str_id);
while (1)
      {
      if ((PINB&0x0F) != 0x0F){
            GET_KEY();
            //PORTA.4 = ~PORTA.4; 
            delay_ms(200);
      }
      }
}
