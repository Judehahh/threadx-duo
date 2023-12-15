cmake_minimum_required(VERSION 3.16.5)

project(arch C ASM)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)

set(CMAKE_INSTALL_PREFIX ${TOP_DIR}/install)
set(CMAKE_INSTALL_INC_PREFIX ${TOP_DIR}/install/include)

set(SAFETY_FLAGS "-Wall -Wextra -fno-strict-aliasing")
#set(SAFETY_FLAGS "-Werror -Wall -Wextra -fno-strict-aliasing")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${SAFETY_FLAGS}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${SAFETY_FLAGS}")

if (ARCH STREQUAL "")
    message(*** Please set ARCH in scripts/*cmake. ***)
    exit()
endif()

add_compile_definitions(__CV180X__)

file(GLOB _SOURCES	"src/${RUN_ARCH}/*.c"
					"src/${RUN_ARCH}/riscv_optimized/*.S"
)
file(GLOB _HEADERS	"include/${RUN_ARCH}/*.h"
					"include/interdrv/common/*.h"
					"include/interdrv/chip/${RUN_ARCH}/*.h"
					"include/interdrv/chip/${RUN_ARCH}/isp/*.h"
)
file(GLOB _HEADERS_LINUX "include/${RUN_ARCH}/linux/*.h")

include_directories(include/${RUN_ARCH})
include_directories(include/interdrv/common)
include_directories(include/interdrv/chip/${RUN_ARCH})

install(FILES ${_HEADERS_LINUX} DESTINATION include/common/linux)

include_directories(${CMAKE_INSTALL_INC_PREFIX}/arch)
include_directories(${CMAKE_INSTALL_INC_PREFIX}/kernel)

add_library(common STATIC ${_SOURCES})

install(TARGETS common DESTINATION lib)
install(FILES ${_HEADERS} DESTINATION include/common)
