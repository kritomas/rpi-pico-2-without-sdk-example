// Constants from memory map
const unsigned int PAD_CTL = 0x40038000;
const unsigned int LED_PAD_OFFSET = 0x68;

const unsigned ISO_BIT = 1 << 8;
const unsigned IE_BIT = 1 << 6;
const unsigned PUP_BIT = 1 << 3;

const unsigned int IO_CTL = 0x40028000;
const unsigned int LED_IO_OFFSET = 0x0cc;

const unsigned char SIO_FUNC = 0x05;

const unsigned int SIO_BASE_ADDRESS = 0xd0000000;
const unsigned int SIO_GPIO_OUT_SET_OFFSET = 0x018; // GPIO 0-31
const unsigned int SIO_GPIO_OE_SET_OFFSET = 0x038; // GPIO 0-31

// The LED is on GPIO25
const unsigned int LED_PIN = 1 << 25;

const unsigned int GPIO_LOW_END = SIO_BASE_ADDRESS + SIO_GPIO_OUT_SET_OFFSET;
const unsigned int GPIO_LOW_END_OUTPUT_ENABLE = SIO_BASE_ADDRESS + SIO_GPIO_OE_SET_OFFSET;

const unsigned int LED_PAD_CTL = PAD_CTL + LED_PAD_OFFSET;
const unsigned int LED_IO_CTL = IO_CTL + LED_IO_OFFSET;

const unsigned int XOC_CTL = 0x40048000;
const unsigned int XOC_STATUS = XOC_CTL + 0x4;
const unsigned int XOC_STARTUP = XOC_CTL + 0xc;
const unsigned int SYS_CLOCK_CTL = XOC_CTL + 0x3c;

// A few handy offsets for register writing
#define WRITE_NORMAL 0x0000 // normal rw
#define WRITE_XOR 0x1000 // atomic XOR write
#define WRITE_SET 0x2000 // atomic bitmask set write
#define WRITE_CLR 0x3000 // atomic bitmask clear write

void init_clock()
{
	// Before a whole load of pico 2 features (including the GPIO) can be used, the system clock must be set up.
	// The system clock is rather flexible and can use a variety of sources. Here, we use the crystal oscillator.

	*(volatile unsigned int*)(XOC_CTL) = 0x00000aa0; // Oscillate within 1-15MHz
	//*(volatile unsigned int*)(XOC_STARTUP) = 0x000000c4; // Initial delay (50,000 cycles aprox., default)
	*(volatile unsigned int*)(XOC_CTL + 0x2000) |= 0x00fab000; // Enable oscillator
	while (!*(volatile unsigned int*)XOC_STATUS & (1 << 31)); // Wait for the oscillator to stabilise

	*(volatile unsigned int*)SYS_CLOCK_CTL = 0; // Lastly, set XOC as system clock
}

int main()
{
	init_clock();
	volatile unsigned int* gpio = (unsigned int*)GPIO_LOW_END;
	*(volatile unsigned int*)LED_IO_CTL = SIO_FUNC; // Hook LED pin into SIO
	*(volatile unsigned int*)(GPIO_LOW_END_OUTPUT_ENABLE + WRITE_SET) = LED_PIN; // Set LED pin as output
	*(volatile unsigned int*)(LED_PAD_CTL + WRITE_CLR) = 1 << 8; // Close connection (like releasing the handbrake or smth)
	*gpio |= LED_PIN; // Set the LED pin bit to 1, causing it to light up.
	return 0;
}