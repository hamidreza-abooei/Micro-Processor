#include "stm32f4xx.h"

int i;

int main(void)
{
	RCC->AHB1ENR = 0x3FF;
	
	GPIOB->MODER = 0x55000000;
	while(1)
	{
//		GPIOB->ODR = 0x00009000;
//		for(i=0;i<5000;i++);
//		GPIOB->ODR = 0x00005000;
//		for(i=0;i<5000;i++);
//		GPIOB->ODR = 0x00006000;
//		for(i=0;i<5000;i++);
//		GPIOB->ODR = 0x0000A000;
//		for(i=0;i<5000;i++);		
		
		GPIOB->ODR = 0x0000A000;
		for(i=0;i<5000;i++);
		GPIOB->ODR = 0x00006000;
		for(i=0;i<5000;i++);
		GPIOB->ODR = 0x00005000;
		for(i=0;i<5000;i++);
		GPIOB->ODR = 0x00009000;
		for(i=0;i<5000;i++);
		
//		GPIOB->ODR = 0x00003000;
//		for(i=0;i<10000;i++);
//		GPIOB->ODR = 0x00006000;
//		for(i=0;i<10000;i++);
//		GPIOB->ODR = 0x0000C000;
//		for(i=0;i<10000;i++);
//		GPIOB->ODR = 0x00009000;
//		for(i=0;i<10000;i++);

	}
	
	
}