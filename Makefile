CROSS_COMPILER = arm-none-eabi-
UF2_CONVERTER = python3 bin2uf2.py

CFLAGS = -mcpu=cortex-m33 -mthumb -nostdlib -ffreestanding

arm : start-arm.s
	$(CROSS_COMPILER)gcc $(CFLAGS) start-arm.s -c -o start.o # Assemble assembly loader
	$(CROSS_COMPILER)gcc $(CFLAGS) main.c -c -o main.o # Compile C without linking
	$(CROSS_COMPILER)gcc $(CFLAGS) picobin.s -c -o picobin.o # Assemble Pico 2 blob
	$(CROSS_COMPILER)gcc $(CFLAGS) -T link-arm.ld picobin.o start.o main.o -o arm.elf # Linking everything, producing an ELF
	$(CROSS_COMPILER)objcopy -O binary arm.elf arm.bin # Converting the ELF into a raw binary
	$(UF2_CONVERTER) arm.bin arm.uf2 0x10000000 # Converting the binary into a flashable