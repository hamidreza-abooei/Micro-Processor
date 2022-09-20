#include "delay.h"


void delay_us (int x){
	SysTick->CTRL |= 1;
	SysTick->LOAD = 2*x;
	while(SysTick->VAL);
	
}
void delay_ms (int x){
	SysTick->CTRL |= 1;
	SysTick->LOAD = 2000*x;
	while(SysTick->VAL);
}
void delay_s (int x){
	SysTick->CTRL |= 1;
	SysTick->LOAD = 2000000*x;
	while(SysTick->VAL);
}
