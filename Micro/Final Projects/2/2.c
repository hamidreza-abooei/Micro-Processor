/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
? Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 6/28/2022
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
#define EN PORTC.2
#define RW PORTC.1
#define RS PORTC.0
#define lcd PORTD


unsigned char key_pressed;
int value1;
int value2;
//unsigned int value3;
unsigned char command_pressed = 0;
unsigned char command = 0;
unsigned char i;
unsigned char temp[16];
unsigned char counter = 0;



void lcd_command(unsigned char data){
    lcd = data;
    RS = 0;
    RW = 0;
    EN = 0;
    delay_ms(2);
    EN = 1; 
    RS = 0;
    RW = 0;
    
}

void lcd_data(unsigned char data){
    lcd = data;
    RS = 1;
    RW = 0;
    EN = 0;
    delay_ms(2);
    EN = 1; 
    RS = 0;
    RW = 0;
}

void lcd_init(void){
    lcd_command(0x38);//function set
    lcd_command(0b1100);//on/off display
    lcd_command(0b110);//inc
    lcd_command(0x01);//clear
}

void lcd_clear(void){
   lcd_command(0x01);

}

void lcd_write_number(int number){
    lcd_clear();     
    if (number<0){
        lcd_data('-');
    }    
    counter = 0;
    while(number!=0 ){
        temp[counter] = number%10;
        number = number/10;
        counter++;
    }
    for (i = 0;i<counter;i++){
        lcd_data('0'+temp[counter-i-1]);
    }

}

void calculator (unsigned char key){
    if (key >=20){          // command sent
        command_pressed = 1;
        command = key; 
        if (command == 20){    //       /
          lcd_clear();
          lcd_data(253);
        }                
        if (command == 21){    //       *
          lcd_clear();
          lcd_data('*');
        }
        if (command == 22){    //       -
          lcd_clear();
          lcd_data('-');
        }
        if (command == 23){    //       +
          lcd_clear();
          lcd_data('+');
        }
              
        
    }else if (key == 19){         // on/c
         lcd_clear ();
         value1 = 0;
         value2 = 0;
         command_pressed = 0;
         command = 0;
         
    
    }else if (key == 18){          // = 
         //if (command==0){
            
         //}
         if (command == 20){           //   /
           value1 = value1/value2; 
           value2 = 0;
         }
         
         if (command == 21){           //   *
            value1 = value1* value2; 
            value2 = 0;
         }
         
         if (command == 22){          //    -
            value1 = value1 - value2; 
            value2 = 0;
         }  
         
         if (command == 23){           //   +
            value1 = value1 + value2; 
            value2 = 0;

         }
         lcd_write_number(value1);
         command_pressed = 0;
         command = 0;
    }else if (key < 10 ) {                        // numbers
        if (command_pressed == 0){   // value 1
            value1 = value1*10+key;
            lcd_write_number(value1);
        }else{                       //value2
            value2 = value2*10+key; 
            lcd_write_number(value2);
        }
        
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
                    key_pressed=7;  
                }
            }
     if(PINB.1==0)
            {
            delay_ms(100);
            if(PINB.1==0)
                {
                    //while (PINB.1==0){}
                    key_pressed=8;  
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
                    //while (PINB.3==0){}
                    key_pressed=20;  //      /
                }
            }

   
        
      PORTA=0XFD;
      if(PINB.0==0)
            {
            delay_ms(100);
            if(PINB.0==0)
                {
                    //while (PINB.0==0){}
                    key_pressed=4;  
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
                    key_pressed=6;  
                }
            }  
            
     if(PINB.3==0)
            {
            delay_ms(100);
            if(PINB.3==0)
                {
                    //while (PINB.2==0){}
                    key_pressed=21;     //   *
                }
            }
              
      PORTA=0XFB;
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
                    key_pressed=2;  
                }
            }
            
     if(PINB.2==0)
            {
            delay_ms(100);
            if(PINB.2==0)
                {
                    //while (PINB.2==0){}
                    key_pressed=3;  
                }
            }  
            
     if(PINB.3==0)
            {
            delay_ms(100);
            if(PINB.3==0)
                {
                   // while (PINB.3==0){}
                    key_pressed=22;   //     -
                }
            } 
            
            
     PORTA=0XF7;       
     if(PINB.0==0)
            {
            delay_ms(100);
            if(PINB.0==0)
                {
                    //while (PINB.0==0){}
                    key_pressed=19;  //      on/c
                }
            }
     if(PINB.1==0)
            {
            delay_ms(100);
            if(PINB.1==0)
                {
                    //while (PINB.1==0){}
                    key_pressed=0;    
                }
            }
            
     if(PINB.2==0)
            {
            delay_ms(100);
            if(PINB.2==0)
                {
                    //while (PINB.2==0){}
                    key_pressed=18;    //    =
                }
            }  
            
     if(PINB.3==0)
            {
            delay_ms(100);
            if(PINB.3==0)
                {
                    //while (PINB.3==0){}
                    key_pressed=23;     //     +
                }
            }
       calculator(key_pressed);     
       PORTA=0XF0;  
            
            

}



void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=P Bit2=P Bit1=P Bit0=P 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (1<<PORTB3) | (1<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);

// Port C initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=Out Bit0=Out 
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=1 Bit1=0 Bit0=0 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (1<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
lcd_init();
while (1)
      {
        if ((PINB&0x0F) != 0x0F){
            GET_KEY();
            //PORTA.4 = ~PORTA.4; 
            delay_ms(200);
        }

      }
}
