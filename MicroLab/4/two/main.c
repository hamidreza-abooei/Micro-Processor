#include "stm32f4xx.h"
#include "delay.h"
#include "math.h"

int main(void)
{

	int i;
	int data[6];

	//int p;
	//Clock configuration:
	RCC->AHB1ENR = 0x3FF;

	//RCC->CR |=0X00000003;
	//RCC->CFGR = 0;
	
	RCC->APB2ENR = 0x20;
	
	
	// GPIO configuration
	
	
	//GPIOA -> MODER &=0XFFFFFFFC;
	//GPIOG -> MODER = 0xD7FFFFFF; // PG13, PG14 -> OUTPUT
	
	//GPIOG->MODER = (1<<26) | (1<<28);
	//GPIOG->MODER
	GPIOC->MODER =  0xA000;
	GPIOC->AFR[0] = 0x88000000;
	
	//USART
	// USART configuration
	USART6->BRR = 0x00000683;
	USART6->CR1 = 0x00002008;
	//USART6->DR  = 0x55;
	
	// Generate Sin data

	
	while(1)
	{
		
		//delay_ms(100);
//		if (((GPIOA->IDR) & 1) == 1 ){
//			p = 1;
//		}
//		if (p == 1){			
			GPIOG ->ODR = 0x2000; // PG13 IS ON
//			RCC->CR |= 0x01000000;
//			RCC->CFGR = 0XA;
//}
//		
//		delay_s(1);
		delay_s(1);
		GPIOG->ODR = 0X0000;	
		delay_s(1);
		GPIOG->ODR = 0X4000;

	}
}


