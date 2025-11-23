CROSS_COMPILER=arm-none-eabi-
UF2_CONVERTER=python3 bin2uf2.py

arm : main-arm.s
	$(CROSS_COMPILER)as -mcpu=cortex-m33 -mthumb main-arm.s -c -o start.o # Assemble assembly loader
	$(CROSS_COMPILER)gcc -mcpu=cortex-m33 -mthumb main.c -nostdlib -ffreestanding -fpic -c -o main.o # Compile C without linking
	$(CROSS_COMPILER)gcc -mcpu=cortex-m33 -mthumb -T link-arm.ld picobin.s start.o main.o -fpic -static -nostdlib -o arm.elf # Linking everything, producing an ELF
	$(CROSS_COMPILER)objcopy -O binary arm.elf arm.bin # Converting the ELF into a raw binary
	$(UF2_CONVERTER) arm.bin arm.uf2 0x10000000 # Converting the binary into a flashable