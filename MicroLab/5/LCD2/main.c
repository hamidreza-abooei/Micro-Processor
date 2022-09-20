#include "stm32f4xx.h"
#include "delay.h"
#include "lcd_header.h"

unsigned int A;
int main(void)
{
	RCC->AHB1ENR = 0x3FF;
	GPIOA->MODER &= 0xFFFFFFFC;
	
	lcd_init();
	lcd_clear();
	lcd_gotoxy(0,0);
	
	lcd_print("mrezah");
	
	
	while(1)
	{
		A = (GPIOA->IDR)&0x1;
		if(A==0x1){
			lcd_shift_left(1);
			delay_ms(1000);
		}
	}
}