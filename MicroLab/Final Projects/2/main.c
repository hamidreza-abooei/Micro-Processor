#include "stm32f4xx.h"
#include "delay.h"
//#include "HAL.h"

int main(void)
{
	unsigned int status;
	//Clock configuration:			RCC AHB1 peripheral clock enable register enable GPIOs
	RCC->AHB1ENR = 0x3FF;			

	// Enable USART6 
	RCC->APB2ENR |= 0x20;
	
	
	// GPIO configuration
	
	
	//GPIOA -> MODER &=0XFFFFFFFC;
	//GPIOG -> MODER = 0xD7FFFFFF; // PG13, PG14 -> OUTPUT
	GPIOC->MODER =  0xFFFFAFFF;		//Alternate function mode C6 and C7
	GPIOC->AFR[0] = 0x88000000;		//AF8  	USART6
	
	GPIOA->MODER = 0xFFFFFDFF; // General purpus Output for A4 (DAC output)
	
	//USART
	// USART configuration
	USART6->BRR |= 0x00000683;		//Baudrate register
	USART6->CR1 |= 0x00002004;		// USART enable	Recieve Enable
	
	

	while(1)
	{
			
			status = USART1->SR;	// read status register to find out that data has been recieved
			if(status & 0x00000010){	// if data receved, read and send data
				if (!(status & 0x0000000F)){ 	// determine Overrun error, Noise detected flag, Framing error, Parity error
					USART6->DR = USART1->DR;	//send recieved data
				}
			}
			//USART6->DR  |= 0x00000031;
			
		//delay_ms(100);
//		if (((GPIOA->IDR) & 1) == 1 ){
//			p = 1;
//		}
//		if (p == 1){			
////			GPIOG ->ODR = 0x2000; // PG13 IS ON
//			RCC->CR |= 0x01000000;
//			RCC->CFGR = 0XA;
//}
//		
////		delay_s(1);
		delay_ms(100);
//		GPIOG->ODR = 0X0000;
//		delay_s(1);
//		GPIOG->ODR = 0X2000;

	}
}


