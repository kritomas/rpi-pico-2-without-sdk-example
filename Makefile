RISCV_CROSS_COMPILER = riscv64-unknown-elf-
ARM_CROSS_COMPILER = arm-none-eabi-
UF2_CONVERTER = python3 bin2uf2.py

CFLAGS = -nostdlib -ffreestanding
RISCV_CFLAGS = -march=rv32ima_zicsr_zifencei_zba_zbb_zbs_zbkb_zca_zcb_zcmp -mabi=ilp32
ARM_CFLAGS = -mcpu=cortex-m33 -mthumb

riscv : start-riscv.s
	$(RISCV_CROSS_COMPILER)gcc $(RISCV_CFLAGS) $(CFLAGS) start-riscv.s -c -o start.o # Assemble assembly loader
	$(RISCV_CROSS_COMPILER)gcc $(RISCV_CFLAGS) $(CFLAGS) main.c -c -o main.o # Compile C without linking
	$(RISCV_CROSS_COMPILER)gcc $(RISCV_CFLAGS) $(CFLAGS) picobin-riscv.s -c -o picobin.o # Assemble Pico 2 blob
	$(RISCV_CROSS_COMPILER)gcc $(RISCV_CFLAGS) $(CFLAGS) -T link-riscv.ld picobin.o start.o main.o -o riscv.elf # Linking everything, producing an ELF
	$(RISCV_CROSS_COMPILER)objcopy -O binary riscv.elf riscv.bin # Converting the ELF into a raw binary
	$(UF2_CONVERTER) riscv.bin riscv.uf2 0x10000000 riscv # Converting the binary into a flashable
arm : start-arm.s
	$(ARM_CROSS_COMPILER)gcc $(ARM_CFLAGS) $(CFLAGS) start-arm.s -c -o start.o # Assemble assembly loader
	$(ARM_CROSS_COMPILER)gcc $(ARM_CFLAGS) $(CFLAGS) main.c -c -o main.o # Compile C without linking
	$(ARM_CROSS_COMPILER)gcc $(ARM_CFLAGS) $(CFLAGS) picobin-arm.s -c -o picobin.o # Assemble Pico 2 blob
	$(ARM_CROSS_COMPILER)gcc $(ARM_CFLAGS) $(CFLAGS) -T link-arm.ld picobin.o start.o main.o -o arm.elf # Linking everything, producing an ELF
	$(ARM_CROSS_COMPILER)objcopy -O binary arm.elf arm.bin # Converting the ELF into a raw binary
	$(UF2_CONVERTER) arm.bin arm.uf2 0x10000000 arm # Converting the binary into a flashable