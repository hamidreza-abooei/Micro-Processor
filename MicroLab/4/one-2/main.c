#include "stm32f4xx.h"
#include "delay.h"
#include "math.h"

int main(void)
{
	int j;
	int i;
	int SinData[100];
	int squareData[100];
	int btn_val=0;
	int status=0;
	int data =0;
	//int p;
	//Clock configuration:
	RCC->AHB1ENR = 0x3FF;

	//RCC->CR |=0X00000003;
	//RCC->CFGR = 0;
	
	RCC->APB2ENR = 0x20;
	
	
	// GPIO configuration
	
	
	//GPIOA -> MODER &=0XFFFFFFFC;
//	GPIOG -> MODER = 0xD7FFFFFF; // PG13, PG14 -> OUTPUT
	
	GPIOG->MODER = (1<<26) | (1<<28);

	GPIOC->MODER =  0xA000;
	GPIOC->AFR[0] = 0x88000000;
	
	//USART
	// USART configuration
	USART6->BRR = 0x00000683;
	USART6->CR1 = 0x00002008;
	//USART6->DR  = 0x55;
	
	// Generate Sin data
	for(i=0;i<100;i++)
	{
		SinData[i]=(100*sin(i*2*3.14159*0.01))+100;
	}
	
	// Generate square data
	for(i=0;i<100;i++)
	{
		if (i<33)
			squareData[i]=0;
		if ((i<66) && (i>=33))
			squareData[i] = 200;
		if (i>=66)
			squareData[i]=0;
	}
	
	while(1)
	{
		btn_val = GPIOA->IDR & 0x1;
		if (btn_val == 1){
			status = ~status ;

		}

		if(status == 0){
				for(j=0;j<100;j++)
					{
						USART6->DR = SinData[j];	//sin 
						while(!((USART6->SR) & (1<<6)));
					}
		}
		else{
				for(j=0;j<100;j++)
					{
						USART6->DR = squareData[j];	//square
						while(!((USART6->SR) & (1<<6)));
					}
					
			
		}
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
//		delay_s(1);
		delay_s(1);
//		GPIOG->ODR = 0X0000;
//		delay_s(1);
//		GPIOG->ODR = 0X2000;

	}
}


