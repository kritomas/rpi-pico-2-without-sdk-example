# Raspberry Pi Pico 2 Without Pico SDK Example

This project demosntrates how to program a RPI Pico 2 without using the SDK. This example is very short, for a quick start.

# Overview

+	`bin2uf2.py`: A python script, that turns a .bin binary into something the pico will accept.
+	`link-arm`: Linker script for ARM, linking everything together, as well as defining the RAM and the entry point.
+	`link-riscv`: Same, but for RISC-V.
+	`main.c`: Our C code. It takes a lot of work just to light up the LED.
+	`Makefile`: Builds everything.
+	`start-arm.s`: Short ARM assembly code, which initialises the CPU, and then invokes `main()` from `main.c`.
+	`start-riscv.s`: Same, but for RISC-V.
+	`picobin-arm.s`: A little blob that's apparently needed in every ARM image flashed onto the board.
+	`picobin-riscv.s`: Same, but for RISC-V.

# Usage

Firstly, install everything necessary, most notably an ARM/RISC-V cross compiler.

Then, you can compile everything by running `make arm`/`make riscv`, which will produce `arm.uf2`/`riscv.uf2`.

Lastly, flash the example by putting the pico into bootloader mode and just dragging `arm.uf2`/`riscv.uf2` over.

If everything is working correctly, the pico should disconnect itself, and the LED should light up.