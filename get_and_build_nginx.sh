#!/bin/bash

set -e

# get 1.18.0 sources
wget https://nginx.org/download/nginx-1.18.0.tar.gz
tar -xf nginx-1.18.0.tar.gz
rm nginx-1.18.0.tar.gz

cd nginx-1.18.0

# apply patches to fix the passing of MESH Heap objects to external code via
# global pointers, which is a known limitation (see README.md).
# the patches untag the pointers before they are assigned
patch src/core/nginx.c ../nginx_patch/nginx.c.patch
patch src/core/ngx_cycle.c ../nginx_patch/ngx_cycle.c.patch
patch src/os/unix/ngx_setproctitle.c ../nginx_patch/ngx_setproctitle.c.patch

# build
MY_PATH="$(cd "$(dirname "$0")" ; pwd -P)"

export CC=$MY_PATH/../build_x86/build_llvm/bin/clang
export CXX=$MY_PATH/../build_x86/build_llvm/bin/clang++
export LD=$MY_PATH/../build_x86/build_llvm/bin/lld

./configure \
  --without-http_gzip_module \
  --with-cc-opt="-flto \
                 -fsanitize=mesh \
                 -Wno-unused-command-line-argument" \
  --with-ld-opt="-flto \
                 -fsanitize=mesh" \
  --prefix=$MY_PATH/install_mesh
make -j

echo "Done."
