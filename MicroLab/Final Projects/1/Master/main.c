#include "stm32f4xx.h"
#include "delay.h"

int main(void)
{
	unsigned int status;
	//Clock configuration:			RCC AHB1 peripheral clock enable register enable GPIOs
	RCC->AHB1ENR = 0x3FF;			

	// Enable USART1 and USART6 
	RCC->APB2ENR |= 0x30;
	
	
	// GPIO configuration
	
	
	//GPIOA -> MODER &=0XFFFFFFFC;
	//GPIOG -> MODER = 0xD7FFFFFF; // PG13, PG14 -> OUTPUT
	GPIOC->MODER =  0xFFFFAFFF;		//Alternate function mode C6 and C7
	GPIOC->AFR[0] = 0x88000000;		//AF8  	USART6
	GPIOA->MODER &= 0xFFEBFFFF;		//Alternate function mode A9 and A10
	GPIOA->AFR[1] = 0x00000770;		//AF7 	USART1
	
	//USART
	// USART configuration
	USART6->BRR |= 0x00000683;		//Baudrate register
	USART6->CR1 |= 0x00002008;		// USART enable	Transmit enable
	//USART6->DR  = 0x55;
	USART1->BRR |= 0x00000683;		//Baudrate register
	USART1->CR1 |= 0x00002004;		//Recive enable

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


