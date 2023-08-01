# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(frostdart_library VERSION 0.0.1 LANGUAGES C)

add_library(frostdart SHARED
  "frostdart.c"
)

set_target_properties(frostdart PROPERTIES
  PUBLIC_HEADER frostdart.h
  OUTPUT_NAME "frostdart"
)

target_compile_definitions(frostdart PUBLIC DART_SHARED_LIB)
