// Constants from memory map
const unsigned int SIO_BASE_ADDRESS = 0xD0000000;
const unsigned int SIO_GPIO_OUT_OFFSET = 0x010; // GPIO 0-31
const unsigned int SIO_GPIO_OE_OFFSET = 0x030; // GPIO 0-31

// The LED is on GPIO25
const unsigned int LED_PIN = 1 << 25;


const unsigned int GPIO_LOW_END = SIO_BASE_ADDRESS + SIO_GPIO_OUT_OFFSET;
const unsigned int GPIO_LOW_END_OUTPUT_ENABLE = SIO_BASE_ADDRESS + SIO_GPIO_OE_OFFSET;

int main()
{
	volatile unsigned int* gpioctl = (unsigned int*)GPIO_LOW_END_OUTPUT_ENABLE;
	volatile unsigned int* gpio = (unsigned int*)GPIO_LOW_END;
	*gpioctl |= LED_PIN;
	*gpio |= LED_PIN;
}