include config.mk
include scripts/$(ARCH).mk

OUT := out
CSRC:= $(wildcard src/*.c)
OBJ := $(addprefix $(OUT)/, $(CSRC:.c=.o))

CC = $(PREFIX)clang
LD = $(PREFIX)ld.lld
SIZE = $(PREFIX)llvm-size
# LLVM PR35281
COPY = $(PREFIX)llvm-objcopy
DUMP = $(PREFIX)llvm-objdump

TARGET:=$(OUT)/$(PRJ).elf
TARGET_LST:=$(OUT)/$(PRJ).lst
TARGET_BIN:=$(OUT)/$(PRJ).bin
TARGET_MAP:=$(OUT)/$(PRJ).map

CFLAGS := $(ARCH_FLAGS)
CFLAGS += -ffreestanding
CFLAGS += -O$(OPT_LEVEL)
CFLAGS += -std=$(C_STD)
CFLAGS += -Wall
CFLAGS += -g$(DBG_LEVEL)

LDFLAGS := --Bstatic
LDFLAGS += --build-id
LDFLAGS += --gc-sections
LDFLAGS += --Map $(TARGET_MAP)
LDFLAGS += --script $(LDSCRIPT)
LDFLAGS += -Llib

ifeq ($(VERBOSE),y)
Q:=
else
Q:=@
endif

all: $(TARGET_BIN) $(TARGET_LST) size

$(OUT)/%.o: %.c
	@echo CC $^
	@mkdir -p $(dir $@)
	$(Q)$(CC) -o $@ $(CFLAGS) -c $<

$(TARGET): $(OBJ)
	@echo LD $@
	$(Q)$(LD) -o $@ $(LDFLAGS) $(OBJ)

$(TARGET_LST): $(TARGET)
	@echo LIST on $@
	$(Q)$(DUMP) -D $< > $@

$(TARGET_BIN): $(TARGET)
	@echo COPY to $@
	$(Q)$(COPY) -O binary $< $@

size: $(TARGET)
	$(Q)$(SIZE) $<

clean:
	@echo CLEAN
	@rm -fR $(OUT)

rebuild: clean all

.PHONY: all clean list size rebuild
