cortex-m-llvm
=============

Cortex M3/M4 with LLVM toolkit

Example firmware for cortex-M3/M4 using LLVM / C 

Build tools
===========

Require git, gcc (build-essentials), cmake and autotools

Clone llvm-3.4/clang-3.4/mclinker:

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

Create llvm build directory and switch to it

  mkdir build && cd build

Run cmake

  cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/opt/llvm -DLLVM_TARGETS_TO_BUILD="ARM;X86" -DLLVM_ENABLE_PIC=ON ../llvm

Install llvm/clang with

  sudo make install

Build MCLinker

  cd ../mclinker
  export PATH=$PATH:/opt/llvm/bin
  ./configure --prefix=/opt/llvm
  make && sudo make install

At now, try to build example with make
