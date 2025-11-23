.syntax unified
.cpu cortex-m33
/*.thumb*/

.section .vector_table, "a"
.global _vector /*Expose _vector to linker script*/
_vector: /*Vector map*/
	.word __stack_top__ /*Stack pointer*/
	.word _start /*Reset*/
	.word infinite_loop
	.word infinite_loop
	.word infinite_loop
	.word infinite_loop
	.word infinite_loop
	.word 0
	.word 0
	.word 0
	.word 0
	.word infinite_loop
	.word infinite_loop
	.word 0
	.word infinite_loop
	.word infinite_loop
	.word infinite_loop
	.word infinite_loop

.section .text
.global _start
.thumb_func
_start:
	bl main
	b infinite_loop

.thumb_func
infinite_loop:
	b . /*Infinite loop that does nothing*/
