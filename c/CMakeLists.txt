cmake_minimum_required(VERSION 3.10.0)
project(networktest VERSION 0.1.0 LANGUAGES C)


set(SRC_DIR ${CMAKE_SOURCE_DIR}/src)
set(INC_DIR ${CMAKE_SOURCE_DIR}/include)

file(GLOB SRC_FILES ${SRC_DIR}/*.c)
add_executable(${PROJECT_NAME} ${SRC_FILES})
target_include_directories(${PROJECT_NAME}
    PRIVATE ${INC_DIR}
)
find_package(PkgConfig REQUIRED)

pkg_search_module(NL3 REQUIRED libnl-3.0)
pkg_search_module(NLGENL REQUIRED libnl-genl-3.0)

target_link_libraries(scan
    PRIVATE
    ${NL3_LIBRARIES}
    ${NLGENL_LIBRARIES}
)
