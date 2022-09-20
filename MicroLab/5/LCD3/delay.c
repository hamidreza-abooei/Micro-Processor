#include "stm32f4xx.h"

void delay_us( unsigned int  x){
	SysTick->CTRL |= 1;
	SysTick->LOAD = 2*x;
	while(SysTick->VAL);
	
}


void delay_ms( unsigned int x){
	SysTick->CTRL |= 1;
	SysTick->LOAD = 2000*x;
	while(SysTick->VAL);
	
	
}


void delay_s( unsigned int x){
	SysTick->CTRL |= 1;
	SysTick->LOAD = 2000000*x;
	while(SysTick->VAL);
		
	
}
