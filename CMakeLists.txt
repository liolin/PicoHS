cmake_minimum_required(VERSION 3.13)

set(PICO_SDK_FETCH_FROM_GIT on)
#set(PICO_SDK_PATH ../deps/pico-sdk)
set(MICROHS_FETCH_FROM_GIT on)
#set(MICROHS_PATH ../deps/MicroHs)
include(pico_sdk_import.cmake)
include(microhs_import.cmake)

project(pico-go
        LANGUAGES ASM C CXX
        VERSION 1.0
        DESCRIPTION "PicoGo"
)

set(FILE_ELF ${CMAKE_PROJECT_NAME}.elf)
set(FILE_HEX ${CMAKE_PROJECT_NAME}.hex)

pico_sdk_init()
# microhs_init()

add_executable(${CMAKE_PROJECT_NAME}
    ${MICROHS_PATH}/build/${CMAKE_PROJECT_NAME}.c
)
add_dependencies(${CMAKE_PROJECT_NAME} ${CMAKE_PROJECT_NAME}_comb.c)

# pico_generate_pio_header(${CMAKE_PROJECT_NAME}
#     ${CMAKE_CURRENT_LIST_DIR}/st7789_lcd.pio
# )

# pico_generate_pio_header(${CMAKE_PROJECT_NAME}
#     ${CMAKE_CURRENT_LIST_DIR}/spi.pio
# )

target_link_libraries(${CMAKE_PROJECT_NAME}
  pico_stdlib
  hardware_uart
  hardware_pio
  hardware_spi
  hardware_pwm
  # and more for other projects
)

pico_enable_stdio_usb(${CMAKE_PROJECT_NAME} 1)
pico_add_extra_outputs(${CMAKE_PROJECT_NAME})

add_custom_command(OUTPUT ${MICROHS_PATH}/bin/mhs
  COMMAND make bin/mhs
  WORKING_DIRECTORY ${MICROHS_PATH}
)
add_custom_target(mhs ALL DEPENDS ${MICROHS_PATH}/bin/mhs)

add_custom_command(OUTPUT ${MICROHS_PATH}/bin/cpphs
  COMMAND make bin/cpphs
  WORKING_DIRECTORY ${MICROHS_PATH}
)
add_custom_target(cpphs ALL DEPENDS ${MICROHS_PATH}/bin/cpphs)

add_custom_command(OUTPUT ${MICROHS_PATH}/build/${CMAKE_PROJECT_NAME}_comb.c
  COMMAND mkdir -p build
  COMMAND bin/mhs -i${CMAKE_CURRENT_SOURCE_DIR}/src Blinky -z -obuild/${CMAKE_PROJECT_NAME}_comb.c
  COMMAND sed -i s,mhsffi.h,\.\./src/runtime/mhsffi.h, build/${CMAKE_PROJECT_NAME}_comb.c
  COMMAND sed -i '/mhsffi.h/ a "#include \"../src/runtime/config-raspberry-pico.h\""' build/${CMAKE_PROJECT_NAME}_comb.c
  WORKING_DIRECTORY ${MICROHS_PATH}
  DEPENDS src/Blinky.hs ${MICROHS_PATH}/bin/mhs ${MICROHS_PATH}/bin/cpphs
)
add_custom_target(${CMAKE_PROJECT_NAME}_comb.c ALL DEPENDS ${MICROHS_PATH}/build/${CMAKE_PROJECT_NAME}_comb.c)

FILE(WRITE ${MICROHS_PATH}/build/${CMAKE_PROJECT_NAME}.c
"#include \"${CMAKE_PROJECT_NAME}_comb.c\"\n"
"#include \"../src/runtime/eval-raspberry-pico.c\"\n"
)
