ENTRY(Reset_Handler)

SECTIONS {
	. = 0x08000000;

	.vectors : ALIGN(16) SUBALIGN(16) {
		KEEP(*(.vectors))
	}

	.text : ALIGN(4) SUBALIGN(4) {
		. = ALIGN(4);
		*(.text)
		*(.text.*)
		. = ALIGN(4);
		*(.rodata)
		*(.rodata.*)
		. = ALIGN(4);
		_etext = .;
	}

	. = 0x20000000;

	.data : AT( ADDR( .text ) + SIZEOF( .text ) ) {
		_data = .;
		*(.data)
		*(.data.*)
		. = ALIGN(4);
		_edata = .;
	}

	.bss : {
		_bstart = .;
		*(.bss)
		*(.bss.*)
		*(.COMMON)
		. = ALIGN(4);
		_bend = .;
		PROVIDE(_estack = _data + 128k);
	}
}
