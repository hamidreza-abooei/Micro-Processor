#include "stm32f4xx.h"                  // Device header

int i = 0;

int main(void)
{
	RCC->AHB1ENR = 0x3FF;
	
	GPIOG->MODER = (1<<26) | (1<<28);
	
	while(1)
	{
		GPIOB->ODR = (1<<13);
		for(i=0; i<99999; i++);
		GPIOB->ODR = (1<<14);
		for(i=0; i<99999; i++);
	}
}