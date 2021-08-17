#!/usr/bin/env bash

set -e
 
MY_PATH="$(cd "$(dirname "$0")" ; pwd -P)"
BUILD_DIR=$MY_PATH/build_x86
mkdir -p $BUILD_DIR

BINUTILS_DIR="$BUILD_DIR/binutils-gdb/include"
SRC_DIR="$BUILD_DIR/mesh-llvm-project/llvm"
LLVM_BUILD_DIR="$BUILD_DIR/build_llvm"
LLVM_INSTALL_DIR="$LLVM_BUILD_DIR/install"

cd $BUILD_DIR

# get binutils
git clone git://sourceware.org/git/binutils-gdb.git
cd binutils-gdb
git checkout 0a4f5f8cae7ced715aca791bf4b212f43165119c
cd ..

# get MESH LLVM version
git clone https://github.com/Fraunhofer-AISEC/mesh-llvm-project.git

mkdir -p "$LLVM_BUILD_DIR"
cd "$LLVM_BUILD_DIR"

cmake -G Ninja "$SRC_DIR" \
  -DCMAKE_BUILD_TYPE="Debug" \
  -DCMAKE_C_COMPILER="clang" \
  -DCMAKE_CXX_COMPILER="clang++" \
  -DCMAKE_INSTALL_PREFIX="$LLVM_INSTALL_DIR" \
  -DLLVM_BINUTILS_INCDIR="$BINUTILS_DIR" \
  -DLLVM_ENABLE_PROJECTS="clang;compiler-rt;lld" \
  -DLLVM_OPTIMIZED_TABLEGEN=True \
  -DLLVM_TARGETS_TO_BUILD="X86"

ninja
