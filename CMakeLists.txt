cmake_minimum_required(VERSION 3.12)

project(mod-host)

find_package(PkgConfig REQUIRED)

include(${PROJECT_SOURCE_DIR}/cmake/build_opts.cmake)

set(SRC_DIR ./src)

file(GLOB ALL_SRCS ${SRC_DIR}/*.c
        ${CMAKE_CURRENT_BINARY_DIR}/info.h
        ${SRC_DIR}/dsp/compressor_core.c
        ${SRC_DIR}/dsp/compressor_core.c
        ${SRC_DIR}/monitor/monitor-client.c
        ${SRC_DIR}/sha1/sha1.c
        ${SRC_DIR}/rtmempool/rtmempool.c)

set_source_files_properties(${CMAKE_CURRENT_BINARY_DIR}/info.h PROPERTIES GENERATED 1)

pkg_check_modules(LILV REQUIRED IMPORTED_TARGET GLOBAL lilv-0)
pkg_check_modules(JACK REQUIRED IMPORTED_TARGET GLOBAL jack)
add_compile_definitions(HAVE_LV2_STATE_FREE_PATH)
include_directories(ALL_OBJS PUBLIC ${LILV_INCLUDE_DIRS} ${CMAKE_CURRENT_BINARY_DIR})


# BUILD OBJECTS
add_library(ALL_OBJS OBJECT ${ALL_SRCS})

# Generate info.h
add_dependencies(ALL_OBJS infogen)

add_custom_target(infogen
        DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/info.h)

add_custom_command(
        OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/info.h
        COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/utils/infogen ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR}/info.h
        DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/README.md
)

# Single Executable file.
add_executable(mod-host ${ALL_SRCS})
target_link_libraries(mod-host jack readline systemd ${LILV_LIBRARIES} m pthread rt  fftw3_threads fftw3f_threads fftw3 fftw3 fftw3f)


# Lmod-host.so
add_library(mod-host-lib SHARED ${ALL_SRCS})
set_property(TARGET mod-host-lib PROPERTY OUTPUT_NAME mod-host)
set_target_properties(mod-host-lib PROPERTIES PREFIX "")

# mod-monitor.so
add_library(mod-monitor SHARED ${SRC_DIR}/monitor/monitor-client.c ${SRC_DIR}/dsp/compressor_core.c)
target_compile_definitions(mod-monitor PUBLIC STANDALONE_MONITOR_CLIENT)
set_target_properties(mod-monitor PROPERTIES PREFIX "")


# fake-input.so
add_library(fake-input SHARED ${SRC_DIR}/fake-input/fake-input.c)
set_target_properties(fake-input PROPERTIES PREFIX "")


include(GNUInstallDirs)

# Installation
install(
        TARGETS mod-host
        DESTINATION ${CMAKE_INSTALL_BINDIR}
)

# Install Libraries..
install(
        TARGETS mod-host-lib mod-monitor fake-input
        LIBRARY DESTINATION ${JACK_LIBRARY_DIRS}/jack
)


# CPack Generator
set(CPACK_PACKAGE_NAME ${PROJECT_NAME}
        CACHE STRING "ModHost"
)
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY " LV2 host for JACK, controllable via socket or command line"
        CACHE STRING "mod-host is an LV2 host for JACK, controllable via socket or command line"
)
set(CPACK_PACKAGE_VENDOR "N/A")
set(CPACK_VERBATIM_VARIABLES YES)
set(CPACK_PACKAGE_INSTALL_DIRECTORY ${CPACK_PACKAGE_NAME})
SET(CPACK_OUTPUT_FILE_PREFIX "${CMAKE_SOURCE_DIR}/debs")
set(CPACK_PACKAGING_INSTALL_PREFIX "/usr")
set(CPACK_PACKAGE_VERSION_MAJOR 0)
set(CPACK_PACKAGE_VERSION_MINOR 10)
set(CPACK_PACKAGE_VERSION_PATCH 11)
set(CPACK_PACKAGE_CONTACT "euikook@gmail.com")
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "euikook")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/COPYING")
set(CPACK_RESOURCE_FILE_README "${CMAKE_CURRENT_SOURCE_DIR}/README.md")
set(CPACK_DEBIAN_FILE_NAME DEB-DEFAULT)
set(CPACK_COMPONENTS_GROUPING ALL_COMPONENTS_IN_ONE)#ONE_PER_GROUP)
set(CPACK_DEB_COMPONENT_INSTALL YES)

include(CPack)