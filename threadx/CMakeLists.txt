cmake_minimum_required(VERSION 3.0.0 FATAL_ERROR)

# Set up the project
project(threadx
    LANGUAGES C ASM
)

set(CMAKE_INSTALL_PREFIX ${TOP_DIR}/install)

if(NOT DEFINED THREADX_ARCH)
    message(FATAL_ERROR "Error: THREADX_ARCH not defined")
endif()
if(NOT DEFINED THREADX_TOOLCHAIN)
    message(FATAL_ERROR "Error: THREADX_TOOLCHAIN not defined")
endif()
message(STATUS "THREADX_ARCH: ${THREADX_ARCH}")
message(STATUS "THREADX_TOOLCHAIN: ${THREADX_TOOLCHAIN}")

# Define our target library and an alias for consumers
add_library(${PROJECT_NAME})
add_library("azrtos::${PROJECT_NAME}" ALIAS ${PROJECT_NAME})

add_subdirectory(ports/${THREADX_ARCH}/${THREADX_TOOLCHAIN})
add_subdirectory(common)
add_subdirectory(utility)

# Define the FreeRTOS adaptation layer
add_library(freertos-threadx)
target_include_directories(freertos-threadx
    PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}/utility/rtos_compatibility_layers/FreeRTOS
)
target_sources(freertos-threadx
    PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/utility/rtos_compatibility_layers/FreeRTOS/tx_freertos.c
)
target_link_libraries(freertos-threadx PUBLIC threadx)

install(TARGETS ${PROJECT_NAME} DESTINATION lib)
install(TARGETS freertos-threadx DESTINATION lib)
