#include "stm32f4xx.h"
#include "delay.h"


int main(void)
{
	unsigned int LED1 = 0xD;		// PG13
	unsigned int LED2 = 0xE;		// PG14
	unsigned char flag = 0;
	unsigned char status = 0; 	//0:no pll 16 MHz 	1:PLL 40Mhz
	unsigned long int i = 0;
	volatile uint32_t btn_val;
	RCC->AHB1ENR = 0x3FF;
	GPIOG->MODER = 0xD7FFFFFF;
	GPIOB->MODER = 0xD7FFFFFF;
	GPIOA->MODER &= 0xFFFFFFFC;							//push-button USER INPUT
	GPIOA->PUPDR &= 0xFFFFFFFE;							//Pull-Down Push-button
	GPIOA->PUPDR |= 0x2;
	
	GPIOG->ODR = 0x2000;	// LED1 ON
	GPIOG->ODR |= 0x1<<LED2;	// LED2 ON
	GPIOB->ODR |= 0x1<<LED2;	// LED2 ON
	RCC->PLLCFGR &= 0xF0BC8000;
	RCC->PLLCFGR |= 0x04012810;
	
	while(1)
	{
		GPIOG->ODR = 0x1<<LED2;
		GPIOB->ODR = 0x1<<LED2;
		delay_ms(2);
		GPIOG->ODR = 0x0;
		GPIOB->ODR = 0x0;
		delay_ms(10);
		
	}
}