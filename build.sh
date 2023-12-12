#!/bin/bash
set -e

TOP_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
TOOLCHAIN_FILE_PATH=$TOP_DIR/scripts/toolchain-riscv64-elf.cmake
BUILD_FREERTOS_PATH=$TOP_DIR/build
BUILD_ENV_PATH=$BUILD_PATH
INSTALL_PATH=$TOP_DIR/install

RUN_TYPE=CVIRTOS
RUN_CHIP=cv180x
RUN_ARCH=riscv64

THREADX_ARCH=risc-v64
THREADX_TOOLCHAIN=gnu

if [ ! -e $BUILD_FREERTOS_PATH/arch ]; then
    mkdir -p $BUILD_FREERTOS_PATH/arch
fi
pushd $BUILD_FREERTOS_PATH/arch
cmake -G Ninja -DCHIP=$RUN_CHIP  \
    -DTOP_DIR=$TOP_DIR \
    -DRUN_TYPE=$RUN_TYPE \
    -DRUN_ARCH=$RUN_ARCH \
    -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN_FILE_PATH \
    $TOP_DIR/arch
cmake --build . --target install -- -v
popd

if [ ! -e $BUILD_FREERTOS_PATH/threadx ]; then
    mkdir -p $BUILD_FREERTOS_PATH/threadx
fi
pushd $BUILD_FREERTOS_PATH/threadx
cmake -G Ninja \
    -DTHREADX_ARCH=$THREADX_ARCH \
    -DTHREADX_TOOLCHAIN=$THREADX_TOOLCHAIN \
    -DTOP_DIR=$TOP_DIR \
    -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN_FILE_PATH \
    $TOP_DIR/threadx
cmake --build . --target install -- -v
popd

if [ ! -e $BUILD_FREERTOS_PATH/samples ]; then
    mkdir -p $BUILD_FREERTOS_PATH/samples
fi
pushd $BUILD_FREERTOS_PATH/samples
cmake -G Ninja -DCHIP=$RUN_CHIP  \
    -DRUN_ARCH=$RUN_ARCH \
    -DRUN_TYPE=$RUN_TYPE \
    -DTOP_DIR=$TOP_DIR \
    -DBUILD_ENV_PATH=$BUILD_ENV_PATH \
    -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN_FILE_PATH \
    $TOP_DIR/samples
cmake --build . --target install -- -v
cmake --build . --target cvirtos.bin -- -v