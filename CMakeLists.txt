cmake_minimum_required(VERSION 4.0)

project(mod-host)

find_package(PkgConfig REQUIRED) 


set(SRC_DIR ./src)

file(GLOB ALL_SRCS ${SRC_DIR}/*.c
        ${SRC_DIR}/dsp/compressor_core.c
        ${SRC_DIR}/dsp/compressor_core.c
        ${SRC_DIR}/monitor/monitor-client.c
        ${SRC_DIR}/sha1/sha1.c
        ${SRC_DIR}/rtmempool/rtmempool.c)

pkg_check_modules(LILV REQUIRED IMPORTED_TARGET GLOBAL lilv-0) 


add_definitions(-Werror -Wabi=98 -Wcast-qual -Wclobbered -Wdisabled-optimization)
add_definitions(-Wfloat-equal -Wlogical-op -Wpointer-arith)
add_definitions(-Wformat=2 -Woverlength-strings)
add_definitions(-Wstringop-overflow=4 -Wstringop-truncation)
add_definitions(-Wmissing-declarations -Wredundant-decls)
add_definitions(-Wshadow  -Wundef -Wuninitialized -Wunused)
add_definitions(-Wstrict-aliasing -fstrict-aliasing)
add_definitions(-Wstrict-overflow -fstrict-overflow)
add_definitions(-Wduplicated-branches -Wduplicated-cond -Wnull-dereference)
add_definitions(-Winit-self -Wjump-misses-init -Wmissing-prototypes -Wnested-externs -Wstrict-prototypes -Wwrite-strings)
#add_definitions(-Wno-error=deprecated-declarations)
add_definitions(-Wno-deprecated-declarations)
add_definitions(-Wno-error=float-equal)

add_definitions(-DHAVE_NEW_LILV)
add_definitions(-DHAVE_HAVE_JACK2)
add_definitions(-DHAVE_FFTW335)
add_definitions(-DHAVE_NEW_LILV)
add_definitions(-DHAVE_LV2_STATE_FREE_PATH)
add_definitions(-DHAVE_JACK2)
add_definitions(-DHAVE_JACK2_1_9_23)
add_definitions(-Wno-float-equal)

add_library(ALL_OBJS OBJECT ${ALL_SRCS})

add_compile_definitions(HAVE_LV2_STATE_FREE_PATH)

include_directories(ALL_OBJS PUBLIC ${LILV_INCLUDE_DIRS})

add_executable(mod-host ${ALL_SRCS})

target_link_libraries(mod-host jack readline ${LILV_LIBRARIES} m pthread rt  fftw3_threads fftw3f_threads fftw3 fftw3 fftw3f)
