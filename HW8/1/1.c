//
// * 1.c
// *
// * Created: 6/21/2022 4:46:04 PM
// * Author: Hamidreza Abooei
// 
//      
//#include <mega32.h>
//#include <delay.h>
//#define EN PORTC.2
//#define RW PORTC.1
//#define RS PORTC.0
//#define lcd PORTD
//
//
//
//unsigned char fname[] = "Hamidreza";
//unsigned char lname[] = "Abooei";
//unsigned char i;
//
//void lcd_command(unsigned char data){
//    lcd = data & 0xf0;
//    RS = 0;
//    RW = 0;
//    EN = 0;
//    delay_ms(2);
//    EN = 1;
//    lcd = data * 0x10;
//    EN = 0;
//    delay_ms(2);
//    EN = 1; 
//}
//
//void lcd_data(unsigned char data){
//    lcd = data & 0xF0;
//    RS = 1;
//    RW = 0;
//    EN = 0;
//    delay_ms(2);
//    EN = 1; 
//    lcd = data * 0x10;
//    EN = 0;
//    delay_ms(2);
//    EN = 1; 
//}
//
//void lcd_init(void){
//    lcd_command(0b101000);function set
//    lcd_command(0b1111);on/off display
//    lcd_command(0b110);inc
//    lcd_command(0x01);clear
//}
//
//
//void main(void)
//{
//    DDRD = 0xF0;
//    DDRC = 0b111;
//    
//    lcd_init(); 
//    
//
//    lcd_data('a');
//    for (i=0;fname[i]!='\0';i++){
//        lcd_data(fname[i]);
//    }
//    
//    lcd_command(0b11000000); next line = DDRAM: 40
//    
//    for (i=0;lname[i]!='\0';i++){
//        lcd_data(lname[i]);
//    }
//
//
//while (1)
//    {
//        lcd_data('a');
//    
//    }
//}



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



unsigned char fname[] = "Hamidreza";
unsigned char lname[] = "Abooei";
unsigned char i;

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
    lcd_command(0x20);//function set
    lcd_command(0x20);//function set
    lcd_command(0x80);//function set
    
    lcd_command(0b0);//on/off display
    lcd_command(0b11110000);//on/off display  
    
    lcd_command(0b0);//inc
    lcd_command(0b1100000);//inc    
    
    lcd_command(0x00);//clear
    lcd_command(0x10);//clear
}


void main(void)
{
    DDRD = 0xFF;
    DDRC = 0b111;
    PORTC = 0b100;
    
    lcd_init(); 
    

    //lcd_data('a');
    for (i=0;fname[i]!='\0';i++){
        lcd_data(fname[i]&0xF0);
        lcd_data(fname[i]*0x10);
    }
    
    lcd_command(0xC0);// next line = DDRAM: 40    
    lcd_command(0x00);
    for (i=0;lname[i]!='\0';i++){
       lcd_data(lname[i]&0xF0);
       lcd_data(lname[i]*0x10);

    }


while (1)
    {
//        lcd_data('a');
//        delay_ms(300);
    
    }
}
