#include "stm32f4xx.h"



int main(void)
{
	unsigned int LED1 = 0xD;		// PG13
	unsigned int LED2 = 0xE;		// PG14
	unsigned char flag = 0;
	unsigned char status = 0; 	//0:no pll 16 MHz 	1:PLL 40Mhz
	unsigned long int i = 0;
	volatile uint32_t btn_val;
//	unsigned int a = (0x1<<(LED1<<1)) | ( 0x1<<(LED2<<1));
//	GPIOG->MODER |= a;  	//LD3 OUTPUT   LD4 OUTPUT
	RCC->AHB1ENR = 0x3FF;
	GPIOG->MODER = 0xD7FFFFFF;
	GPIOA->MODER &= 0xFFFFFFFC;							//push-button USER INPUT
	GPIOA->PUPDR &= 0xFFFFFFFE;							//Pull-Down Push-button
	GPIOA->PUPDR |= 0x2;
	
	GPIOG->ODR = 0x2000;	// LED1 ON
	GPIOG->ODR |= 0x1<<LED2;	// LED2 ON
	RCC->PLLCFGR &= 0xF0BC8000;
	RCC->PLLCFGR |= 0x04012810;
	
	//RCC->CFGR &= 0xFFFFFFC;
	//RCC->CFGR |= 0X0000003;	//PLL
	
	//RCC->CFGR &= 0xFFFFFFC;
	//RCC->CFGR |= 0X0;	//HSI
	
	
	
	while(1)
	{
		//GPIOG->ODR = 0x2000;
		btn_val = GPIOA->IDR;
		if ((btn_val & 0x1) == 0x1 )
		{
			if (flag == 0){
				if (status == 0){
					status = 1;
					RCC->CR |= 0x1000000; 
					RCC->CFGR &= 0xFFFFFFC;
					RCC->CFGR |= 0X0000002;	//PLL
				}else{
					status = 0;
					RCC->CR &= 0xFEFFFFFF; 
					RCC->CFGR &= 0xFFFFFFC;
					RCC->CFGR |= 0X0;	//HSI
				}
			}
			flag = 1;
		}else{
			flag = 0;
		}
		GPIOG->ODR = 0x1<<LED2;
		
		for ( i=0; i<2000000;i++);
		
		//GPIOG->ODR = 0x0<<LED1;
		GPIOG->ODR = 0x0;
		
		for ( i=0; i<2000000;i++);
		
	}
}