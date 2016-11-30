#include "soc-hw.h"

uart_t  *uart0  = (uart_t *)   0x20000000;
timer_t *timer0 = (timer_t *)  0x30000000;
gpio_t  *gpio0  = (gpio_t *)   0x40000000;// se indica el puerto en donde funciona el GPIO, definido por system.v
spi_t   *spi0   = (spi_t *)    0x50000000;
i2c_t   *i2c0   = (i2c_t *)    0x60000000;
disp_t  *disp0  = (disp_t *)   0x70000000;
sound_t *sound0 = (sound_t *)  0x80000000;

isr_ptr_t isr_table[32];

/*void prueba()
{
	   uart0->rxtx=30;
	   timer0->tcr0 = 0xAA;
	   gpio0->ctrl=0x55;
	   spi0->rxtx=1;
	   spi0->nop1=2;
	   spi0->cs=3;
	   spi0->nop2=5;
	   spi0->divisor=4;
	   i2c0->rxtx=5;
	   i2c0->divisor=5;

}*/
void tic_isr();
/***************************************************************************
 * IRQ handling
 */
void isr_null()
{
}

void irq_handler(uint32_t pending)
{
	int i;

	for(i=0; i<32; i++) {
		if (pending & 0x01) (*isr_table[i])();
		pending >>= 1;
	}
}

void isr_init()
{
	int i;
	for(i=0; i<32; i++)
		isr_table[i] = &isr_null;
}

void isr_register(int irq, isr_ptr_t isr)
{
	isr_table[irq] = isr;
}

void isr_unregister(int irq)
{
	isr_table[irq] = &isr_null;
}

/***************************************************************************
 * TIMER Functions
 */
void msleep(uint32_t msec)
{
	uint32_t tcr;

	// Use timer0.1
	timer0->compare1 = (FCPU/1000)*msec;
	timer0->counter1 = 0;
	timer0->tcr1 = TIMER_EN;

	do {
		//halt();
 		tcr = timer0->tcr1;
 	} while ( ! (tcr & TIMER_TRIG) );
}

void nsleep(uint32_t nsec)
{
	uint32_t tcr;

	// Use timer0.1
	timer0->compare1 = (FCPU/1000000)*nsec;
	timer0->counter1 = 0;
	timer0->tcr1 = TIMER_EN;

	do {
		//halt();
 		tcr = timer0->tcr1;
 	} while ( ! (tcr & TIMER_TRIG) );
}


uint32_t tic_msec;

void tic_isr()
{
	tic_msec++;
	timer0->tcr0     = TIMER_EN | TIMER_AR | TIMER_IRQEN;
}

void tic_init()
{
	tic_msec = 0;

	// Setup timer0.0
	timer0->compare0 = (FCPU/10000);
	timer0->counter0 = 0;
	timer0->tcr0     = TIMER_EN | TIMER_AR | TIMER_IRQEN;

	isr_register(1, &tic_isr);
}


/***************************************************************************
 * UART Functions
 */
void uart_init()
{
	//uart0->ier = 0x00;  // Interrupt Enable Register
	//uart0->lcr = 0x03;  // Line Control Register:    8N1
	//uart0->mcr = 0x00;  // Modem Control Register

	// Setup Divisor register (Fclk / Baud)
	//uart0->div = (FCPU/(57600*16));
}

char uart_getchar()
{   
	while (! (uart0->ucr & UART_DR)) ;//espera un dato 
	return uart0->rxtx; // retorna un caracter
}

void uart_putchar(char c)
{
	while (uart0->ucr & UART_BUSY) ;// si esta ocupado no manda nada 
	uart0->rxtx = c;
}

void uart_putstr(char *str)
{
	char *c = str;
	while(*c) {
		uart_putchar(*c);
		c++;
	}
}
/***************************************************************************
  GPIO Functions*/
void gpio_init(uint32_t k)
{
	gpio0->dir=k; //todo lo que sea 0 es puerto lectura, 1 es puerto escritura o salida
}

uint32_t gpio_read()
{
	return gpio0->read;
}

void gpio_write(uint32_t k)
{
	gpio0->write=k;
}
/****************************************************************************
  I2C Functions */

void canal(char can)
{ 
        while((i2c0->busy)==0x01);
	i2c0->CAM=can;
	i2c0->CAL=0x83;
					
}

void direccion(char dir)
{
        while((i2c0->busy)==0x01);
	i2c0->AD1=dir;			
}

void direccion2(char dir2)
{
        while((i2c0->busy)==0x01);
	i2c0->AD2=dir2;
			
}

void direccion3(char dir3)
{
        while((i2c0->busy)==0x01);
	i2c0->AD3=dir3;			
}

void escribiri2c(char ctr)
{
        while((i2c0->busy)==0x01);
	i2c0->writei2c=ctr;			
}

void parari2c(char ctr2)
{
        while((i2c0->busy)==0x01);
	i2c0->stopi2c=ctr2;			
}

char byte1(){
	return i2c0->A0M;
}
char byte2()
{
	return i2c0->A0L;
}

/****************************************************************************
  Display Functions */



char byte10()
{
	return disp0->A0MR;
}

char byte20()
{
	return disp0->A0LR;
}


void primero (char lec1)
{
	disp0->A0MW=lec1;
}

void segundo (char lec2)
{
	disp0->A0LW=lec2;
}

/****************************************************************************
  SPI Functions */

char sbyte1()
{
	return spi0->BYTEM;
}

char sbyte2()
{
	return spi0->BYTEL;
}

void sdir1(char spi1)
{
        while((spi0->sbusy)==0x01);
	spi0->CDIR1=spi1;			
}

void sdir2(char spi2)
{
        while((spi0->sbusy)==0x01);
	spi0->CDIR2=spi2;			
}

void sdir3(char spi3)
{
        while((spi0->sbusy)==0x01);
	spi0->CDIR3=spi3;			
}

void sdir4(char spi4)
{
        while((spi0->sbusy)==0x01);
	spi0->CDIR4=spi4;			
}

void escribirspi(char ctrl1)
{
        while((spi0->sbusy)==0x01);
	spi0->writespi=ctrl1;			
}

void pararspi(char ctrl2)
{
        while((spi0->sbusy)==0x01);
	spi0->stopspi=ctrl2;			
}

/****************************************************************************
  Sound Functions */

void timbre(char tbr)
{
     
	sound0->SoundWrite=tbr;			
}









