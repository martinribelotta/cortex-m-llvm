LLVM_SVN = /opt/llvm-svn/bin/
GCC_ARM = /data/download/gcc-arm-none-eabi-6-2017-q2-update/bin/

PRJ = llvm-cortex-m7
SRC = main.c start.c
LDSCRIPT = link.ld

CC = $(LLVM_SVN)clang
LD = $(LLVM_SVN)ld.lld
SIZE = $(LLVM_SVN)llvm-size
COPY = $(GCC_ARM)arm-none-eabi-objcopy
READ = $(GCC_ARM)arm-none-eabi-readelf
DUMP = $(GCC_ARM)arm-none-eabi-objdump

CFLAGS = -c
CFLAGS += --target=thumbv7em-unknown-none-eabi
CFLAGS += -mthumb
CFLAGS += -march=armv7e-m
CFLAGS += -mcpu=cortex-m7
CFLAGS += -mfloat-abi=hard
CFLAGS += -mfpu=fpv5-sp-d16
CFLAGS += -ffreestanding
CFLAGS += -O0
CFLAGS += -std=c11
CFLAGS += -Weverything

LDFLAGS = --Bstatic
LDFLAGS += --build-id
LDFLAGS += --gc-sections
LDFLAGS += --Map $(PRJ).map
LDFLAGS += --script $(LDSCRIPT)

OBJ = $(SRC:.c=.o)

all: $(PRJ).elf

%.o: %.c
	@echo " CC $^"
	@$(CC) -o $@ $(CFLAGS) $^

$(PRJ).elf: $(OBJ)
	@echo " LD $@"
	@$(LD) -o $@ $(LDFLAGS) $^
	@echo " READ -> $(PRJ).rd"
	@$(READ) -Wall $(PRJ).elf > $(PRJ).rd
	@echo " LIST -> $(PRJ).lst"
	@$(DUMP) -axdDSstr $(PRJ).elf > $(PRJ).lst
	@echo " COPY -> $(PRJ).bin"
	@$(COPY) -O binary $(PRJ).elf $(PRJ).bin
	@$(SIZE) $(PRJ).elf

.PHONY: all clean list

clean:
	@echo " CLEAN"
	@rm -fR $(OBJ) $(PRJ).elf $(PRJ).map $(PRJ).rd $(PRJ).lst $(PRJ).bin
