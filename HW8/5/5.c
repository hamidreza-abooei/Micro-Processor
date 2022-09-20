#include <mega32.h>

unsigned char weight = 0,whigh,wlow ;
unsigned int temp ;



void display (void){
    whigh = weight / 10;
    PORTB = whigh;
    wlow = weight % 10;
    PORTC = (whigh * 0x10) | (wlow);

}
    
interrupt [17] void ADC_isr(void){
    
    //PORTB = ADCH;
    temp = ADCH;
    temp = (temp * 100)/256;
    weight = temp;  
    //PORTB = weight;
    display(); 
    PORTA.1=~PORTA.1;

}




void main(void){
    DDRA.0 = 0;
    DDRC = 0xFF;
    DDRA.1 = 1;
    DDRB = 0xff;

    ADMUX = (1<<REFS0) | (1<<ADLAR) ;
    ADCSRA = (1<<ADEN)| (1<<ADSC)| (1<<ADATE)| (1<<ADIE) | (1<<ADPS2) | (1<<ADPS1);
    
    #asm("SEI")
    while (1){
    
    }
}

