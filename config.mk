# Use command line to change prefix as: $> make PREFIX=/path/to/llvm/bin/prefix-
PREFIX    ?=
# y: verbose output, other: silent mode
VERBOSE   ?= n
# Project name
PRJ       := llvm-project
# Linker script in lib/*
LDSCRIPT  := link.ld
# Optimization level: 0, 1, 2, 3, fast, s, z, g
OPT_LEVEL := z
# Arch flags (translated to scripts/$(ARCH).mk)
ARCH      := cortex-m7
# C standard: c89, c99, c11
C_STD     := c11
# Debug level: 0, 1, 2, 3
DBG_LEVEL := 3
