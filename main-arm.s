.syntax unified
.cpu cortex-m33
/*.thumb*/

.section .vector_table, "a"
.global _vector /*Expose _vector to linker script*/
_vector: /*Vector map*/
	.word __stack_top__
	.word _start
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0

.section .text
.global _start
.thumb_func
_start:
	ldr r0, =__stack_top__
	mov sp, r0 /*Set the stack pointer to the topr*/
	bl main
	b infinite_loop

.thumb_func
infinite_loop:
	b . /*Infinite loop that does nothing*/
