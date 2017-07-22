TARGET=ex1.elf
SRC=main.c start.c
LDSCRIPT=link.ld

CC=clang
LD=ld.lld
SIZE=llvm-size
COPY=arm-none-eabi-objcopy
READ=arm-none-eabi-readelf
DUMP=arm-none-eabi-objdump

CFLAGS=-c
CFLAGS+=--target=thumbv7em-unknown-none-eabi
CFLAGS+=-mthumb
CFLAGS+=-march=armv7e-m
CFLAGS+=-mcpu=cortex-m7
CFLAGS+=-mfloat-abi=hard
CFLAGS+=-mfpu=fpv5-sp-d16
CFLAGS+=-ffreestanding
# CFLAGS+=-fno-builtin
# CFLAGS+=-nostdlib
# CFLAGS+=-integrated-as
CFLAGS+=-Og
CFLAGS+=-g3
CFLAGS+=-ggdb
CFLAGS+=-std=c11
# CFLAGS+=-Weverything

LDFLAGS+=--script $(LDSCRIPT)

OBJ=$(SRC:.c=.o)

all: $(TARGET)

%.o: %.c
	@echo " CC $^"
	@$(CC) -o $@ $(CFLAGS) $^

$(TARGET): $(OBJ)
	@echo " LD $@"
	@$(LD) -o $@ $(LDFLAGS) $^
	@echo " READ -> $(TARGET).rd"
	@$(READ) -Wall $(TARGET) > $(TARGET).rd
	@echo " LIST -> $(TARGET).lst"
	@$(DUMP) -axdDSstr $(TARGET) > $(TARGET).lst
	@echo " COPY -> $(TARGET).bin"
	@$(COPY) -O binary $(TARGET) $(TARGET).bin
	@$(SIZE) $(TARGET)

.PHONY: all clean list

clean:
	@echo " CLEAN"
	@rm -fR $(OBJ) $(TARGET) $(TARGET).rd $(TARGET).lst $(TARGET).bin
