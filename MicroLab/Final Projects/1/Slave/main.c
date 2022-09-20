#include "stm32f4xx.h"
#include "delay.h"
#include "lcd_header.h"

int main(void)
{
	unsigned int status,data;
	//Clock configuration:			RCC AHB1 peripheral clock enable register enable GPIOs
	RCC->AHB1ENR = 0x3FF;			

	// Enable USART6 
	RCC->APB2ENR |= 0x20;
	
	
	// GPIO configuration
	
	
	//GPIOA -> MODER &=0XFFFFFFFC;
	//GPIOG -> MODER = 0xD7FFFFFF; // PG13, PG14 -> OUTPUT
	GPIOC->MODER =  0xFFFFAFFF;		//Alternate function mode C6 and C7
	GPIOC->AFR[0] = 0x88000000;		//AF8  	USART6
	
	//USART
	// USART configuration
	USART6->BRR |= 0x00000683;		//Baudrate register
	USART6->CR1 |= 0x00002004;		// USART enable Recive Enable
	
	// lcd 
	lcd_init();
	lcd_clear();
	lcd_gotoxy(0,0);

	lcd_print("9733002");

	while(1)
	{
			
			status = USART6->SR;	// read status register to find out that data has been recieved
			if(status & 0x00000010){	// if data receved, read and send data
				if (!(status & 0x0000000F)){ 	// determine Overrun error, Noise detected flag, Framing error, Parity error
					data = USART6->DR;
					if (data=='a'){	//send recieved data
							lcd_clear();
							lcd_gotoxy(0,0);
							lcd_print("AMIRKABIR");
					}else if(data=='b'){
							lcd_clear();
							lcd_gotoxy(0,0);
							lcd_print("Hamidreza");	
					}else if(data=='c'){
							lcd_clear();
							lcd_gotoxy(0,0);
							lcd_print("Abooei");
				}
			}
		delay_ms(200);
	}
}


