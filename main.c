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

int main()
{
	volatile unsigned int* ledpadctl = (unsigned int*)LED_PAD_CTL;
	volatile unsigned int* ledioctl = (unsigned int*)LED_IO_CTL;
	volatile unsigned int* gpioctl = (unsigned int*)GPIO_LOW_END_OUTPUT_ENABLE;
	volatile unsigned int* gpio = (unsigned int*)GPIO_LOW_END;
	*(ledioctl + 0x2000/4) = SIO_FUNC;
	*gpioctl = LED_PIN;
	*(ledpadctl + 0x3000/4) = 1 << 8;
	*gpio = LED_PIN;
	while (1)
	{
		*gpio = LED_PIN;
	}
}