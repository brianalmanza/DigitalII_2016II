/**
 * 
 */
#include "soc-hw.h"



int main()
{
gpio_init(0xFF);

while(1)
{
/*
a = gpio_read();
b = a >> 4;
gpio_write(b);	 
uart_putchar(0x01);
*/	
      
 	/*canal(0xE3);
	direccion(0x48);
	direccion2(0x01);
	direccion3(0x00);
	escribiri2c(0x01);
	parari2c(0x00);
	char a = byte1();
	char b = byte2();
	primero(a);
	segundo(b);
	gpio_write(a);
	//uart_putchar(a);
	*/
	sdir1(0x80);
	sdir2(0xE6);
	sdir3(0x01);
	sdir4(0x02);
	escribirspi(0x01);
	pararspi(0x00);
	char a = sbyte1();
	gpio_write(a);
	primero(a);
	
	if ((a) >= 0x10)
	{
	timbre(0x00);
	gpio_write(a);
	primero(a);
	}
	else 
	{
	timbre(0x01);
	gpio_write(a);
	primero(a);
	}

}
}





