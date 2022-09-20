/*
 * six.c
 *
 * Created: 5/8/2022 7:33:35 PM
 * Author: Hamidreza
 */

#include <io.h>

#define K1_key PINA.1
#define K2_key PINA.2
#define Pump PORTD.0
#define LED PORTD.1

char pump_status = 0;   // 0:Off    1:ON

char pump_ON_counter = 0;
char pump_OFF_counter = 0;
char start_flag = 0;

interrupt [8] void timer_interrupt(void){    //Every 1 seconds interrupt TIMER1 Compare Match
                            
    if(pump_status == 1){
       pump_ON_counter--;
       
       if(pump_ON_counter == 0){
            // Turn off procedure 
            pump_status = 0; 
            pump_OFF_counter = 2;
            Pump = 0;
            LED = 0;
       }else{
            LED = !LED;                      //Blink
       }
        
    }else{
       pump_OFF_counter--;  
       
       if(pump_OFF_counter == 0){
            // Turn ON procedure
            pump_status = 1;
            pump_ON_counter = 6;
            Pump = 1;
            LED = !LED;
       }
    }
}

void start_pump(void){
    pump_status = 1;
    TCNT1 = 0;                // reset timer    
    TCCR1B = 0B00001101;
    Pump = 1;
    pump_ON_counter = 6;
    LED = !LED;
}
void stop_pump(void){
    pump_status = 0; 
    TCCR1B = 0B00001000;
    Pump = 0; 
    LED = 0;
}

void main(void)
{
    DDRD.0 = 1;
    DDRD.1 = 1;
    //  PORTA Pull down by hardware
    

    OCR1A = 976;        //In order to reach 1 sec delay    1000000 / 1024 = 976
    TCCR1A = 0B00000000;
    TCCR1B = 0B00001000;   //timer stoped
    TIMSK = 0B00010000;

    #asm("SEI")
    
while (1)
    {
          if((K1_key == 1)&(start_flag == 0)){
                start_pump();
                start_flag = 1;      
          }
          if ((K2_key == 1) & (K1_key == 0) ){
                stop_pump();
                start_flag = 0;
                  
          }

    }
}
