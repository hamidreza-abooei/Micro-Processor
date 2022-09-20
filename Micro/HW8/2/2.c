/*
 * 1.c
 *
 * Created: 6/21/2022 4:46:04 PM
 * Author: Hamidreza Abooei
 */
      
#include <mega32.h>
#include <delay.h>
#define EN PORTC.2
#define RW PORTC.1
#define RS PORTC.0
#define lcd PORTD



unsigned char str[] = " MICROPROCESSOR ";
unsigned char i,j;

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


void main(void)
{
    DDRD = 0xFF;
    DDRC = 0b111;
    
    lcd_init(); 
    

    //lcd_data('a');
    for (i=0;str[i]!='\0';i++){
        lcd_command(0x80);//home
        for (j=0;j<=i;j++){ 
            lcd_data(str[15-i+j]); 
        }   
        delay_ms(150);
    } 
//    lcd_data(' '); 
//    lcd_command(0x14); 
//
//    for (i=0;str[i]!='\0';i++){
//           
//           lcd_data(str[3]);
//           
//           lcd_command(0x10);
//           
//           lcd_command(0x10);
//           
//           lcd_command(0x1C);
//           
//            
//           //lcd_command(0x10);
//           //lcd_command(0x10);
//
//           //lcd_command(0x10);
//           //lcd_command(0x10);
//           //lcd_command(0x02);
//           delay_ms(150);
//        }
    
    //lcd_command(0xC3);// next line = DDRAM: 40
    //lcd_data('Z');
//    for (i=0;lname[i]!='\0';i++){
//        lcd_data(lname[i]);
//    }


while (1)
    {
    
        
//        lcd_data('a');
//        delay_ms(300);
    
    }
}
