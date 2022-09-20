#include "stm32f4xx.h"
#include "delay.h"
#include "lcd_header.h"

int main(void)
{
	lcd_init();
	lcd_clear();
	lcd_gotoxy(0,0);

	lcd_print("9733005");
	lcd_gotoxy(1,0);
	lcd_putchar(0xF6);
	lcd_putchar(0xF7);
	
	
	while(1)
	{

		
	}
}