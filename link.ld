/* 20170723 ld.lld 5.0.0 segfault */
/* MEMORY {                                         */
/* 	FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 1M   */
/* 	RAM  (rwx) : ORIGIN = 0x20000000, LENGTH = 112K */
/* }                                                */

FLASH_ORIGIN = 0x08000000;
FLASH_LENGTH = 1M;
RAM_ORIGIN = 0x20000000;
RAM_LENGTH = 320K;

ENTRY(Reset_Handler)

SECTIONS
{
	. = FLASH_ORIGIN;
	.text : {
		KEEP(*(.isr_vector))
		*(.text*)
		KEEP(*(.init))
		KEEP(*(.fini))
		*crtbegin.o(.ctors)
		*crtbegin?.o(.ctors)
		*(EXCLUDE_FILE(*crtend?.o *crtend.o) .ctors)
		*(SORT(.ctors.*))
		*(.ctors)
 		*crtbegin.o(.dtors)
 		*crtbegin?.o(.dtors)
 		*(EXCLUDE_FILE(*crtend?.o *crtend.o) .dtors)
 		*(SORT(.dtors.*))
 		*(.dtors)
		*(.rodata*)
		KEEP(*(.eh_frame*))
	}

	.ARM.extab : {
		*(.ARM.extab* .gnu.linkonce.armextab.*)
	}

	__exidx_start = .;

	.ARM.exidx : {
		*(.ARM.exidx* .gnu.linkonce.armexidx.*)
	}

	__exidx_end = .;
	__etext = .;

	. = RAM_ORIGIN;

	.data : AT (__etext)
	{
		__data_start__ = .;
		*(vtable)
		*(.data*)
		. = ALIGN(4);
		PROVIDE_HIDDEN (__preinit_array_start = .);
		KEEP(*(.preinit_array))
		PROVIDE_HIDDEN (__preinit_array_end = .);

		. = ALIGN(4);
		/* init data */
		PROVIDE_HIDDEN (__init_array_start = .);
		KEEP(*(SORT(.init_array.*)))
		KEEP(*(.init_array))
		PROVIDE_HIDDEN (__init_array_end = .);


		. = ALIGN(4);
		/* finit data */
		PROVIDE_HIDDEN (__fini_array_start = .);
		KEEP(*(SORT(.fini_array.*)))
		KEEP(*(.fini_array))
		PROVIDE_HIDDEN (__fini_array_end = .);

		KEEP(*(.jcr*))
		. = ALIGN(4);
		/* All data end */
		__data_end__ = .;

	}

	.bss :
	{
		. = ALIGN(4);
		__bss_start__ = .;
		*(.bss*)
		*(COMMON)
		. = ALIGN(4);
		__bss_end__ = .;
	}
	
	.heap :
	{
		__end__ = .;
		end = __end__;
		*(.heap*)
		__HeapLimit = .;
	}

	/* .stack_dummy section doesn't contains any symbols. It is only
	 * used for linker to calculate size of stack sections, and assign
	 * values to stack symbols later */
	.stack_dummy :
	{
		*(.stack*)
	}

	/* Set stack top to end of RAM, and stack limit move down by
	 * size of stack_dummy section */
	__StackTop = RAM_ORIGIN + RAM_LENGTH;
	__StackLimit = __StackTop - SIZEOF(.stack_dummy);
	PROVIDE(__stack = __StackTop);
	
	/* Check if data + heap + stack exceeds RAM limit */
	ASSERT(__StackLimit >= __HeapLimit, "region RAM overflowed with stack")
}
