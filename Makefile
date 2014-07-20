TARGET=ex1.elf
SRC=main.c start.c
LDSCRIPT=link.ld

CC=clang
#LD=ld.mcld
LD=arm-none-eabi-ld
SIZE=llvm-size

CFLAGS=-c
CFLAGS+=--target=armv7m-none-eabi
CFLAGS+=-mcpu=cortex-m3
CFLAGS+=-mthumb
CFLAGS+=-integrated-as
CFLAGS+=-Os
CFLAGS+=-fno-builtin
CFLAGS+=-g3

#LDFLAGS+=-march=arm
#LDFLAGS+=-T=$(LDSCRIPT)
LDFLAGS+=-T$(LDSCRIPT)
#LDFLAGS+=-t

OBJ=$(SRC:.c=.o)

all: $(TARGET)

%.o: %.c
	@echo " CC $^"
	@$(CC) -o $@ $(CFLAGS) $^

$(TARGET): $(OBJ)
	@echo " LD $@"
	@$(LD) -o $@ $(LDFLAGS) $^
	@$(SIZE) $(TARGET)

.PHONY: all clean list

clean:
	@echo " CLEAN"
	@rm -fR $(OBJ) $(TARGET) $(TARGET).rd $(TARGET).lst

list:
	@echo " READ -> $(TARGET).rd"
	@arm-none-eabi-readelf -Wall $(TARGET) > $(TARGET).rd
	@echo " LIST -> $(TARGET).lst"
	@arm-none-eabi-objdump -axdDSstr $(TARGET) > $(TARGET).lst
