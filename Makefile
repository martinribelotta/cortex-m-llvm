LLVM_SVN = /opt/llvm-svn/bin/
GCC_ARM = /data/download/gcc-arm-none-eabi-6-2017-q2-update/bin/arm-none-eabi-

PRJ = llvm-cortex-m7
SRC = main.c start.c
LDSCRIPT = link.ld

CC = $(LLVM_SVN)clang
LD = $(LLVM_SVN)ld.lld
SIZE = $(LLVM_SVN)llvm-size
COPY = $(GCC_ARM)objcopy
# LLVM PR35281
#COPY = $(LLVM_SVN)llvm-objcopy
DUMP = $(LLVM_SVN)llvm-objdump

CFLAGS = --target=thumbv7em-unknown-none-eabi
CFLAGS += -mthumb
CFLAGS += -march=armv7e-m
CFLAGS += -mcpu=cortex-m7
CFLAGS += -mfloat-abi=hard
CFLAGS += -mfpu=fpv5-sp-d16
CFLAGS += -ffreestanding
CFLAGS += -O3
CFLAGS += -std=c11
CFLAGS += -Wall

LDFLAGS = --Bstatic
LDFLAGS += --build-id
LDFLAGS += --gc-sections
LDFLAGS += --Map $(PRJ).map
LDFLAGS += --script $(LDSCRIPT)

OBJ = $(SRC:.c=.o)

all: $(PRJ).elf

%.o: %.c
	@echo " CC $^"
	$(CC) -o $@ $(CFLAGS) -c $^

$(PRJ).elf: $(OBJ)
	@echo " LD $@"
	$(LD) -o $@ $(LDFLAGS) $^
	@echo " LIST -> $(PRJ).lst"
	$(DUMP) -D $(PRJ).elf > $(PRJ).lst
	@echo " COPY -> $(PRJ).bin"
	$(COPY) -O binary $(PRJ).elf $(PRJ).bin
	$(SIZE) $(PRJ).elf

.PHONY: all clean list

clean:
	@echo " CLEAN"
	@rm -fR $(OBJ) $(PRJ).elf $(PRJ).map $(PRJ).lst $(PRJ).bin
