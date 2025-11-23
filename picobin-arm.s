.syntax unified
.cpu cortex-m33
.thumb

.section .picobin_block, "a"

/* The Pico 2 will refuse to load any image not containing this specific blob within the first 4kB. */
/* Information about this blob can be found in the RP2350 datasheet 5.9.5. */

.word 0xffffded3 /*PICOBIN_BLOCK_MARKER_START*/

/*TODO: This blob should vary based on board configuration. This is just a carbon copy of the datasheet example for ARM.*/

.word 0x10210142
.word 0x000001ff
.word 0x00000000

.word 0xab123579 /*PICOBIN_BLOCK_MARKER_END*/
