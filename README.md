# cortex-m-llvm

Cortex M3/M4 with LLVM toolkit.

Example firmware for cortex-M3/M4 using LLVM toolchain.

Tested well with LLVM/CLANG 6.0 or high from [LLVM download site](http://releases.llvm.org/download.html)

# Usage

This project provide a simple makefile set for working with LLVM/CLANG on cortex-m.
Due to configure your target you need:

 - Modify `config.mk` with preferred parameters for your project (self explained into file)
 - Ensure memory configuration is correct for your MCU (on `lib/mem.ld`)
 - Ensure linker script is correct (review `lib/link.ld`)
 - Add vendor dependent reset vectors to `src/start.c`

Next, add your sources to `src/*.c` or modify `Makefile` to include others directories

### Makefile targets
  - **all**: Compile and link all files. Produce **elf**, **bin**, list and map
  - **clean**: Remove compilation results
  - **size**: Print size of result binary
  - **list**: Create list file using objdump (llvm version)

# Required packages

  - clang 6.0 or higher
  - llvm 6.0 or higher
  - lld 6.0 or higher
