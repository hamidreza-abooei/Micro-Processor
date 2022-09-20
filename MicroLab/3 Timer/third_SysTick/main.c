#include "stm32f4xx.h"
#include "delay.h"

int main(void)
{
	int p;
	RCC->AHB1ENR = 0x3FF;
	GPIOA->MODER &=0XFFFFFFFC;
	GPIOG -> MODER = 0xD7FFFFFF; // PG13, PG14 -> OUTPUT
	RCC->PLLCFGR &= 0xF0BDA810;
	RCC->PLLCFGR |= 0x12810;
	
	RCC->CR |=0X00000003;
	RCC->CFGR = 0;
	while(1)
	{
		
		if (((GPIOA->IDR) & 1) == 1 ){
			p = 1;
		}
		if (p == 1){			
//			GPIOG ->ODR = 0x2000; // PG13 IS ON
			RCC->CR |= 0x01000000;
			RCC->CFGR = 0XA;
}
		
		delay_s(1);
		GPIOG->ODR = 0X0000;
		delay_s(1);
		GPIOG->ODR = 0X4000;

	}
}



//#include "stm32f4xx.h"

//int main(void){
//	
//	while(1){
//		
//	}
//	
//}
