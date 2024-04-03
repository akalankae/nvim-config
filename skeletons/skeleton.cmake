# Template for CMakeLists.txt
cmake_minimum_required(VERSION 3.28)

# PROJECT_NAME: cmake property that gets assigned to
project(PROJECT_NAME
    VERSION 0.1
    LANGUAGE C) # ? PROJECT_NAME

# executable name and source files required to compile it
add_executable(${PROJECT_NAME} main.c)

find_package(PkgConfig REQUIRED)
pkg_check_modules(XXX REQUIRED module_name) # ? XXX ? module_name

target_include_directories(${PROJECT_NAME} PUBLIC ${XXX_INCLUDE_DIRS}) # ? xxx
target_link_libraries(${PROJECT_NAME} ${XXX_LIBRARIES}) # ? xxx
