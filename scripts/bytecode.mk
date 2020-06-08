include scripts/$(ARCH).mk

OUT := out
CSRC:= $(wildcard src/*.c)
OBJ := $(addprefix $(OUT)/, $(CSRC:.c=.o))
BCO := $(addprefix $(OUT)/, $(CSRC:.c=.bc))

CC = $(PREFIX)clang -emit-llvm
BCLD = $(PREFIX)llvm-link
BC2OBJ = $(PREFIX)llc --filetype=obj
LD = $(PREFIX)ld.lld
SIZE = $(PREFIX)llvm-size
# LLVM PR35281
COPY = $(PREFIX)llvm-objcopy
DUMP = $(PREFIX)llvm-objdump
RM = $(PREFIX)rm -fr

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

ifeq ($(VERBOSE),n)
Q:=@
else
Q:=
endif

all: $(TARGET_BIN) $(TARGET_LST) size

$(OUT)/%.bc: %.c
	@echo CC $^
	@mkdir -p $(dir $@)
	$(Q)$(CC) -o $@ $(CFLAGS) -c $<

$(TARGET).bc: $(BCO)
	@echo BCLD $@
	$(Q)$(BCLD) -o=$@ $(BCO)

$(TARGET).o: $(TARGET).bc
	@echo BC to OBJ $<
	$(Q)$(BC2OBJ) -o=$@ $<

$(TARGET): $(TARGET).o
	@echo LD $@
	$(Q)$(LD) -o $@ $(LDFLAGS) $<

$(TARGET_LST): $(TARGET)
	@echo LIST on $@
	$(Q)$(DUMP) -x -s -S $< > $@

$(TARGET_BIN): $(TARGET)
	@echo COPY to $@
	$(Q)$(COPY) -O binary $< $@

size: $(TARGET)
	$(Q)$(SIZE) $<

clean:
	@echo CLEAN
	$(Q)$(RM) $(OUT)

rebuild: clean all

.PHONY: all clean list size rebuild
