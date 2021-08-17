# MESH: A Memory-Efficient Safe Heap for C/C++

This project is not maintained. It has been published as part of the following ARES '21 conference paper:

> Emanuel Q. Vintila, Philipp Zieris, and Julian Horsch. 2021. MESH: A
> Memory-Efficient Safe Heap for C/C++. In The 16th International Conference
> on Availability, Reliability and Security (ARES 2021), August 17–20, 2021,
> Vienna, Austria. ACM, New York, NY, USA, 10 pages. https://doi.org/10.1145/3465481.3465760

Note that these repositories present a **prototype** implementation for MESH 
and are **not** to be used in production.

## Introduction
MESH is a memory-efficient solution for heap memory safety. It secures the heap from both
spatial and temporal memory bugs. To do this, MESH instruments the code at compile-time to add 
run-time checks for each heap access.

The proof-of-concept implementation does its instrumentation at the LLVM IR level, and it intercepts
libc heap memory functions using the compiler-rt. 

## Compatibility

### Supported Languages

C and C++ are supported.

### Supported Platforms

Only Linux is supported.

### Supported Architectures

The following architectures are supported by this proof-of-concept:

* AArch64
* x86-64 

Other architectures can be added, provided that they have enough unused bits in pointers.

## Known Limitations

- Assigning tagged pointers to external globals can lead to crashes if used in external code. The assigns have to be manually stripped.
- The MESH pass only works with `-flto` enabled, as the pass needs to check if function calls are external or internal.
- At the moment, MESH cannot be turned off when `-flto` is enabled.

## Building and Testing

Build MESH and run tests as follows. For detailed descriptions see below.

```console
$ ./build_x86.sh # build MESH compiler
$ sudo sysctl -w vm.mmap_min_addr="4096" # see below
$ ./run_tests_x86.sh
```

## Usage as Compiler

Pass `-fsanitize=mesh -flto` to clang/++ (and to the linker) to enable the MESH pass.
Note that, at the moment, passing `-flto` to our compiler only works with `-fsanitize=mesh`.

Before running the resulting binary, set the minimum address allocatable by `mmap()` to 4096, for example by running 
`sysctl -w vm.mmap_min_addr="4096"`, for MESH to allocate its custom heap.
This is needed because MESH checks each memory access to ensure that only tagged pointers can modify the protected heap.
In other words, pointers that are untagged are only allowed to access addresses outside the MESH heap, i.e., below the lower bound of
the MESH heap, or above its upper bound. To optimize this, MESH allocates its heap on the first available page and checks only against the upper bound.
This works if nothing besides the zero page is below it. Please check the paper for more details.

```console
$ sudo sysctl -w vm.mmap_min_addr="4096"
$ $CC -fsanitize=mesh -flto 1.c -o output
```

### Problems with setting vm.mmap_min_addr

If setting `mmap_min_addr` to 4096 did not work, the MESH runtime will fail with an error message simmilar to:
```
Failed to mmap at 0x000000001000. Actual value 0x000000010000.
```

In such cases, you should set the heap address to the lowest possible value (given by `sysctl vm.mmap_min_addr`, in this example `0x10000`) by setting the
enviroment variable `MESH_HEAP_ADDRESS` to the address in hexadecimal representation.

The following example compiles `1.c` with the MESH heap at address `0x10000` (i.e., 65536 in decimal):
```console
$ export MESH_HEAP_ADDRESS=0x10000
$ $CC -fsanitize=mesh -flto 1.c -o output
```

To then run the resulted binary, the `MESH_HEAP_ADDRESS` has to be set to the same value:
```console
$ MESH_HEAP_ADDRESS=0x10000 ./output
```
