cortex-m-llvm
=============


Cortex M3/M4 with LLVM toolkit

Example firmware for cortex-M3/M4 using LLVM / C 

Use LLVM/CLANG from 4.0 release:

 - For linux, you need to compile the source until version 4.0 is release [using this instructions](http://clang.llvm.org/get_started.html)
 - For win32 using this [bledding edge build](https://sourceforge.net/projects/clangonwin/) or build it using [this tool](http://clangbuilder.net/)

Build tools (deprecated)
===========

Require git, gcc (build-essentials), cmake and autotools

Clone llvm-3.4/clang-3.4/mclinker:

```bash
  git clone http://llvm.org/git/llvm.git
  cd llvm
  git checkout release_34
  cd tools
  git clone http://llvm.org/git/clang.git
  git checkout release_34
  cd ../projects
  git clone http://llvm.org/git/compiler-rt.git
  cd ../
  git clone https://code.google.com/p/mclinker/
  git checkout release_26
```

Create llvm build directory and switch to it

```bash
  mkdir build && cd build
```

Run cmake

```bash
  cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/opt/llvm \
    -DLLVM_TARGETS_TO_BUILD="ARM;X86" \
    -DLLVM_ENABLE_PIC=ON ../llvm
```

Install llvm/clang with

```bash
  sudo make install
```

Build MCLinker

```bash
  cd ../mclinker
  export PATH=$PATH:/opt/llvm/bin
  ./configure --prefix=/opt/llvm
  make && sudo make install
```

At now, try to build example with make
