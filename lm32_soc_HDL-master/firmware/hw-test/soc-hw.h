#ifndef SPIKEHW_H
#define SPIKEHW_H

#define PROMSTART 0x00000000
#define RAMSTART  0x00000800
#define RAMSIZE   0x400
#define RAMEND    (RAMSTART + RAMSIZE)

#define RAM_START 0x40000000
#define RAM_SIZE  0x04000000

#define FCPU      100000000

#define UART_RXBUFSIZE 32


/****************************************************************************
 * Types
 */
typedef unsigned int  uint32_t;    // 32 Bit
typedef signed   int   int32_t;    // 32 Bit

typedef unsigned char  uint8_t;    // 8 Bit
typedef signed   char   int8_t;    // 8 Bit

/****************************************************************************
 * Interrupt handling
 */
typedef void(*isr_ptr_t)(void);

void     irq_enable();
void     irq_disable();
void     irq_set_mask(uint32_t mask);
uint32_t irq_get_mak();

void     isr_init();
void     isr_register(int irq, isr_ptr_t isr);
void     isr_unregister(int irq);

/****************************************************************************
 * General Stuff
 */
void     halt();
void     jump(uint32_t addr);


/****************************************************************************
 * Timer
 */
#define TIMER_EN     0x08    // Enable Timer
#define TIMER_AR     0x04    // Auto-Reload
#define TIMER_IRQEN  0x02    // IRQ Enable
#define TIMER_TRIG   0x01    // Triggered (reset when writing to TCR)

typedef struct {
	volatile uint32_t tcr0;
	volatile uint32_t compare0;
	volatile uint32_t counter0;
	volatile uint32_t tcr1;
	volatile uint32_t compare1;
	volatile uint32_t counter1;
} timer_t;

void msleep(uint32_t msec);
void nsleep(uint32_t nsec);

void prueba();
void tic_init();


/***************************************************************************
 * GPIO0
 */

#define PIN1 0x01
#define PIN2 0x02
#define PIN3 0x04
#define PIN4 0x08
#define PIN5 0x10

typedef struct {
	volatile uint32_t read;
	volatile uint32_t write;
	volatile uint32_t dir;

} gpio_t;

void gpio_init();
uint32_t gpio_read();
void gpio_write();

void set_pin(uint8_t value, uint8_t npin);
void pin_inv(uint8_t npin);


/***************************************************************************
 * UART0
 */
#define UART_DR   0x01                    // RX Data Ready
#define UART_ERR  0x02                    // RX Error
#define UART_BUSY 0x10                    // TX Busy

typedef struct {
   volatile uint32_t ucr;
   volatile uint32_t rxtx;
} uart_t;

void uart_init();
void uart_putchar(char c);
void uart_putstr(char *str);
char uart_getchar();

/***************************************************************************
 * SPI0
 */

typedef struct {
   volatile uint32_t sbusy;
   volatile uint32_t BYTEM;
   volatile uint32_t BYTEL;
   volatile uint32_t CDIR1;
   volatile uint32_t CDIR2;
   volatile uint32_t CDIR3;
   volatile uint32_t CDIR4;
   volatile uint32_t writespi;
   volatile uint32_t stopspi;

 
} spi_t;

char sbyte1();
char sbyte2();
void sdir1(char spi1);
void sdir2(char spi2);
void sdir3(char spi3);
void sdir4(char spi4);
void escribirspi(char ctrl1);
void pararspi(char ctrl2);

/***************************************************************************
 * I2C0
 */

typedef struct {
   volatile uint32_t busy;
   volatile uint32_t A0M;
   volatile uint32_t A0L;
   volatile uint32_t CAM;
   volatile uint32_t CAL;
   volatile uint32_t AD1;
   volatile uint32_t AD2;
   volatile uint32_t AD3;
   volatile uint32_t writei2c;
   volatile uint32_t stopi2c; 
} i2c_t;

;
void canal (char can);
void direccion(char dir);
void direccion2(char dir2);
void direccion3(char dir3);
void escribiri2c(char ctr);
void parari2c(char ctr2);
char byte1();
char byte2();

/***************************************************************************
 * DISP0
 */

typedef struct {

   volatile uint32_t A0MR;
   volatile uint32_t A0LR; 
   volatile uint32_t A0MW;
   volatile uint32_t A0LW;
 

} disp_t;


char byte10();
char byte20();
void primero (char lec1);
void segundo (char lec2);


/***************************************************************************
 * SOUND
 */

typedef struct {
   
   volatile uint32_t SoundRead;
   volatile uint32_t SoundWrite;
} sound_t;

void timbre (char tbr);


/***************************************************************************
 * Pointer to actual components
 */
extern timer_t  *timer0;
extern uart_t   *uart0; 
extern gpio_t   *gpio0; 
extern uint32_t *sram0; 

#endif // SPIKEHW_H
