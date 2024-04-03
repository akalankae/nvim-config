# Template for CMakeLists.txt
cmake_minimum_required(VERSION 3.16..3.28)
project(PROJECT_NAME C) # ? PROJECT_NAME
add_executable(${PROJECT_NAME} main.c)

find_package(PkgConfig REQUIRED)
pkg_check_modules(XXX REQUIRED module_name) # ? XXX ? module_name

target_include_directories(${PROJECT_NAME} PUBLIC ${XXX_INCLUDE_DIRS}) # ? xxx
target_link_libraries(${PROJECT_NAME} ${XXX_LIBRARIES}) # ? xxx
