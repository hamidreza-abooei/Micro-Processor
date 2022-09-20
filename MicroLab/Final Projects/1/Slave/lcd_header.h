/*
                         \\\|///
                       \\  - -  //
                        (  @ @  )
+---------------------oOOo-(_)-oOOo-----------------------+
|                                                         |
Interfacing Lcd in 4bit mode with STM32F429

mail : aghaeifar@bioemm.com
	   s.rafieivand@gmail.com
			 1391/04/10 -> revision1: 1395/06/10
						   revision2: 1397/07/30
|                          Oooo                           |
+-------------------oooO--(   )---------------------------+
                   (    ) )  /
                    \  (  (_/
                     \_)     
*/


//change these for your desired config
#define PORT_DATA 		GPIOC
#define DATA_OFFSET		0      

#define PIN_RS				0
#define PORT_RS				GPIOB
#define PIN_RW				1
#define PORT_RW				GPIOB
#define PIN_EN				2
#define PORT_EN				GPIOB



#define LCD_RS(x) ((x)?(PORT_RS->BSRR=1<<PIN_RS):(PORT_RS->BSRR=1<<(PIN_RS+16))); /*lcd_rs(x) if x=1 will set the lcd_rs pin will clear if x=0*/
#define LCD_RW(x) ((x)?(PORT_RW->BSRR=1<<PIN_RW):(PORT_RW->BSRR=1<<(PIN_RW+16)));
#define LCD_EN(x) ((x)?(PORT_EN->BSRR=1<<PIN_EN):(PORT_EN->BSRR=1<<(PIN_EN+16)));

#define DATA_OUT(x) PORT_DATA->ODR = (PORT_DATA->ODR & ~(0x0F<<DATA_OFFSET)) | (x<<DATA_OFFSET);
#define DATA_IN 		((PORT_DATA->IDR>>DATA_OFFSET) & 0x0F)

#define LCD_DIR_DATA_OUT	PORT_DATA->MODER = (PORT_DATA->MODER & ~(0xFF<<(DATA_OFFSET*2))) | (0x55<<(DATA_OFFSET*2));
#define LCD_DIR_DATA_IN 	PORT_DATA->MODER &= ~(0xFF<<(DATA_OFFSET*2));

#define delay_2n 6

//=============================================================
static void delay(uint32_t cnt)
{
	cnt <<= delay_2n;
	while(cnt--);
}
//=============================================================
static unsigned char busy_wait()
{
unsigned char status;
do
{
	LCD_DIR_DATA_IN;
	delay(10);
	LCD_RS(0);
	delay(10);
	LCD_RW(1);
	delay(10);
	LCD_EN(1);
	delay(10);
	status = (DATA_IN << 4) & (0xF0);
	LCD_EN(0);
	delay(10);
	LCD_EN(1);
	delay(10);
	status |= DATA_IN;
	LCD_EN(0);
	delay(10);
	LCD_DIR_DATA_OUT;
	delay(10);
}
while(status & 0x80);
return (status);
}
//=============================================================
void lcd_write_4bit(unsigned char c)
{
	c &= 0x0F;
	LCD_RW(0);
	delay(10);
	LCD_EN(1);
	delay(10);
	DATA_OUT(c);
	delay(10);
	LCD_EN(0);
	delay(10);
}
//=============================================================
void lcd_cmd_write(unsigned char c)
{
	busy_wait();
	LCD_RS(0);
	delay(10);
	lcd_write_4bit(c >> 4);
	lcd_write_4bit(c);
}
//=============================================================
static void lcd_data_write(unsigned char c)
{
	busy_wait();
	LCD_RS(1);
	delay(10);
	lcd_write_4bit(c >> 4);
	lcd_write_4bit(c);
}
//=============================================================
void lcd_putchar(char c)
{
	lcd_data_write(c);
}
//=============================================================
void lcd_init()
{
	RCC->AHB1ENR = 0x7F;
	
	PORT_RS->MODER = (PORT_RS->MODER & ~(0x03<<(PIN_RS*2))) | (1<<(PIN_RS*2));
	PORT_RW->MODER = (PORT_RW->MODER & ~(0x03<<(PIN_RW*2))) | (1<<(PIN_RW*2));
	PORT_EN->MODER = (PORT_EN->MODER & ~(0x03<<(PIN_EN*2))) | (1<<(PIN_EN*2));
	
	LCD_DIR_DATA_OUT;
		
	delay(1000);

	
	LCD_RS(0);	
	lcd_write_4bit(0x3);	//return home
	delay(100);
	lcd_write_4bit(0x3);
	delay(10);
	lcd_write_4bit(0x3);
	
	lcd_write_4bit(0x2); 
	
	lcd_cmd_write(0x28);	// lcd 2*16 4bit 5*8
	lcd_cmd_write(0x0C); 
	lcd_cmd_write(0x06); 
}
//=============================================================
int lcd_gotoxy( unsigned int x, unsigned int y)
{
	int retval = 0;
	if( (x > 1) && (y > 15) )
	{
		retval = -1;
	} 
	else 
	{
		if( x == 0 )
		{
			lcd_cmd_write( 0x80 + y ); /* command - position cursor at 0x00 (0x80 + 0x00 ) */
		} 
		else if(x == 1)
		{
			lcd_cmd_write( 0xC0 + y ); /* command - position cursor at 0x40 (0x80 + 0x00 ) */
		}
	}
return retval;
}
//=============================================================
void lcd_clear()
{
	lcd_cmd_write(0x01);
	lcd_gotoxy(0,0);
}
//=============================================================
void lcd_print(unsigned char const *str)
{
	while(*str)
	{
		lcd_putchar(*str++);
	}
}

//============================================================
void lcd_shift_left(char n)   //Scrol n of characters Right
{
   char i;
   for (i = 0 ; i < n ; i++)
   {
      lcd_cmd_write(0x1E);
      delay (1500);
   }
}
//=============================================================
void lcd_shift_right(char n)   //Scrol n of characters Left
{
   char i;
   for (i = 0 ; i < n ; i++)
   {
      lcd_cmd_write(0x18);
      delay (1500);
   }
}
//=============================================================
void lcd_define_char(const unsigned char *pc,char char_code)
{
   char a , i;
   a = ((char_code<<3)|0x40) & 0xff;
   for (i = 0; i < 8 ;i++)
   {
      lcd_cmd_write(a++);
      delay (1500);
      lcd_putchar(pc[i]);
      delay (1500);
   }
}
//=============================================================
void lcd_display_off(void)
{
   lcd_cmd_write (0x08);
   delay (1500);
}
//=============================================================
void lcd_display_on(void)
{
   lcd_cmd_write (0x0C);
   delay (1500);
}
//=============================================================
void lcd_cursor_off(void)
{
   lcd_cmd_write (0x0C);
   delay (1500);
}
//=============================================================
void lcd_cursor_on(void)
{
   lcd_cmd_write (0x0E);
   delay (1500);
}
//=============================================================
void lcd_cursor_blink(void)
{
   lcd_cmd_write (0x0F);
   delay (1500);
}
//=============================================================
