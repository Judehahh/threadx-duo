file(GLOB _HEADERS "${CMAKE_CURRENT_LIST_DIR}/rtos_compatibility_layers/FreeRTOS/*.h")
install(FILES ${_HEADERS} DESTINATION include/kernel)