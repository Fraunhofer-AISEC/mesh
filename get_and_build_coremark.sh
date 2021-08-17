#!/bin/bash

set -e

MY_PATH="$(cd "$(dirname "$0")" ; pwd -P)"

# get sources
git clone https://github.com/eembc/coremark
cd coremark
git checkout 7f420b6bdbff436810ef75381059944e2b0d79e8

# patch files
patch posix/core_portme.mak ../coremark_patch/core_portme.mak.patch

# build and run
CC=$MY_PATH/build_x86/build_llvm/bin/clang MESH_FLAGS="-fsanitize=mesh -flto" make

echo "Done."
