/*
 * two.c
 *
 * Created: 5/6/2022 6:01:30 PM
 * Author: Hamidreza
 */
#include <mega32.h>
#include <io.h>
#include <delay.h>

unsigned char state = 0; //Flag : 1:Start 0:Stop
unsigned char number = 0;   //Number that counts


void show_number(void){
    PORTA = number / 10;
    PORTC = number % 10;
}

interrupt [2] void int_interrupt0 (void){
    if (state == 0){
        state = 1;  //state: Start 
        number = 0;
        TCNT1 = 0;                    
        TCCR1B = 0B00001101;  
        //TIMSK = 0B00010000;
        show_number();
        
    }else{
        state = 0;  //state: Stop
        TCCR1B = 0B00001000;       // Timer stopps here but it won't get cleared.

    }
}

interrupt [8] void int_timer1_COMPA (void){
    if (number<99){
        number++;
    }else{   
        number = 0;
    }
    show_number();
}


void main(void)
{
    DDRA = 0B00001111;
    DDRC = 0B00001111;
    DDRD = 0X00;
    PORTD = 0B00000100; //PULL-UP
    MCUCR = 0B00000010;
    GICR = 0B01000000;
    OCR1A = 976;        //In order to reach 1 sec delay    1000000 / 1024 = 976
    TCCR1A = 0B00000000;
    TCCR1B = 0B00001000;  
    TIMSK = 0B00010000;
    
    
    #asm("SEI")
    show_number();
    while (1)
    {
    // Please write your application code here      
        

    }
}
