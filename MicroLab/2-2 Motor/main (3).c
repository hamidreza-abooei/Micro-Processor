#include "stm32f4xx.h"
int i;
int main(void)
{

	//unsigned int step[4] = {0x00009000,0x0000A000,0x000006000,0x00005000};

	RCC->AHB1ENR = 0x3FF;

	unsigned int step[4] = {0x0000A000,0x00006000,0x000005000,0x00009000};
	// MOTOR B12-B14
	GPIOB->MODER |= 0x55000000;
	
	

	int order = 0;
	while(1)
	{

		GPIOB->ODR =step[order];
		order++;
		if (order==4){
			order = 0;
		}
		for (i = 0;i<5000;i++);	//delay
		
//		GPIOB->ODR = 0x0000A000;
//		for(i=0;i<5000;i++);
//		GPIOB->ODR = 0x00006000;
//		for(i=0;i<5000;i++);
//		GPIOB->ODR = 0x00005000;
//		for(i=0;i<5000;i++);
//		GPIOB->ODR = 0x00009000;
//		for(i=0;i<5000;i++);
	}
}