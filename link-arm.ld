OUTPUT_ARCH(arm)
MEMORY {
	XIP (rx) : ORIGIN =  0x10000000, LENGTH = 256K /*Define XIP*/
	RAM (rwx) : ORIGIN =  0x20000000, LENGTH = 256K /*Define RAM*/
}

__stack_top__ = ALIGN(8, ORIGIN(RAM) + LENGTH(RAM)); /*Set __stack_top__ to the end of RAM*/

SECTIONS
{
	. = ALIGN(4);
	.text :
	{
		_vector = .;
		KEEP(*(.vector_table))
		KEEP(*(.picobin_block))
		*(.text)
	} > XIP

	data :
	{
		*(.data*)
	} > RAM
}

ENTRY(_start)