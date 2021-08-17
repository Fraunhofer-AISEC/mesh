#!/bin/bash

OK=0
NOK_COMPILE=0
NOK_RUN=0

MY_PATH="$(cd "$(dirname "$0")" ; pwd -P)"
CC=$MY_PATH/build_x86/build_llvm/bin/clang
CXX=$MY_PATH/build_x86/build_llvm/bin/clang++


for f in tests/positive/*.cpp; do
  [ -f "$f" ] || break
  echo "--------"
  echo "Compiling $f"
  if $CXX -fsanitize=mesh -flto -g $f -o output; then
    echo "Running $f"
    if ./output > /dev/null; then
      echo "Test $f passed"
      let OK++
    else
      let NOK_RUN++
      echo "Test $f failed"
    fi
    rm output
  else
    let NOK_COMPILE++
    echo "Building $f failed"
  fi
  echo "--------"
done

for f in tests/positive/*.c; do
  [ -f "$f" ] || break
  echo "--------"
  echo "Compiling $f"
  if $CC -fsanitize=mesh -flto -g $f -o output; then
    echo "Running $f"
    if ./output > /dev/null; then
      echo "Test $f passed"
      let OK++
    else
      let NOK_RUN++
      echo "Test $f failed"
    fi
    rm output
  else
    let NOK_COMPILE++
    echo "Building $f failed"
  fi
  echo "--------"
done


for f in tests/negative/*.cpp; do
  [ -f "$f" ] || break
  echo "--------"
  echo "Compiling $f"
  if $CXX -fsanitize=mesh -flto  -g $f -o output; then
    echo "Running $f"
    ./output > /dev/null
    ret=$?
    if [ $ret -eq 1 ]; then
      echo "Test $f failed to initialize"
      let NOK_RUN++
    else
      if [ $ret -eq 134 ]; then
        let OK++
        echo "Test $f passed"
      else
        echo "Test $f failed"
        let NOK_RUN++
      fi
    fi
    rm output
  else
    let NOK_COMPILE++
    echo "Building $f failed"
  fi
  echo "--------"
done

for f in tests/negative/*.c; do
  [ -f "$f" ] || break
  echo "--------"
  echo "Compiling $f"
  if $CC -fsanitize=mesh -flto -g $f -o output; then
    echo "Running $f"
    ./output > /dev/null
    ret=$?
    if [ $ret -eq 1 ]; then
      echo "Test $f failed to initialize"
      let NOK_RUN++
    else
      if [ $ret -eq 134 ]; then
        let OK++
        echo "Test $f passed"
      else
        echo "Test $f failed"
        let NOK_RUN++
      fi
    fi
    rm output
  else
    let NOK_COMPILE++
    echo "Building $f failed"
  fi
  echo "--------"
done

echo "Successful: $OK"
echo "Test failed: $NOK_RUN"
echo "Compilation failed: $NOK_COMPILE"
