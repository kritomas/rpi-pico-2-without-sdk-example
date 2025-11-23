.section .vector_table, "a"
.global _vector /*Expose _vector to linker script*/
_vector: /*Vector map*/
	j _start

.section .text
.global _start
_start:
	la  sp, __stack_top__
	call main
	j infinite_loop

infinite_loop:
	j infinite_loop /*Infinite loop that does nothing*/
