cmake_minimum_required(VERSION 3.16.5)

project(driver C)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)

set(KERNEL_SOURCE ${TOP_DIR}/../Source)

set(CMAKE_INSTALL_PREFIX ${TOP_DIR}/install)
set(CMAKE_INSTALL_INC_PREFIX ${TOP_DIR}/install/include)
set(CMAKE_DRIVER_DIR ${TOP_DIR}/driver)

set(SAFETY_FLAGS "-Wall -Wextra -fno-strict-aliasing")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${SAFETY_FLAGS}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${SAFETY_FLAGS}")

set(DRIVER_UART_DIR ${CMAKE_DRIVER_DIR}/uart)
set(DRIVER_GPIO_DIR ${CMAKE_DRIVER_DIR}/gpio)
set(DRIVER_I2C_DIR ${CMAKE_DRIVER_DIR}/i2c)

add_compile_definitions(__CV180X__)

# add driver folder here
set(DRIVER_UART_DIR ${CMAKE_DRIVER_DIR}/uart)
set(DRIVER_SPINLOCK_DIR ${CMAKE_DRIVER_DIR}/spinlock)
set(DRIVER_RTOS_CMDQU_DIR ${CMAKE_DRIVER_DIR}/rtos_cmdqu)

set(driver_list
	common
	pinmux
	uart
	spinlock
	gpio
	rtos_cmdqu
)

add_library(driver STATIC dummy.c)
foreach(build_drv ${driver_list})
	add_subdirectory(${build_drv})
endforeach()

target_link_libraries(driver ${driver_list})
install(TARGETS driver DESTINATION lib)
