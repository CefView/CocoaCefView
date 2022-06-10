# 
# The main config file for CocoaCef
#
cmake_minimum_required(VERSION 3.19)
project(CocoaCefView)

option(BUILD_DEMO       "Build the demo"                          OFF)
option(BUILD_STATIC     "Build CocoaCefView as static library"    OFF)
option(USE_SANDBOX      "Enable CEF Sandbox"                      OFF)

# Only generate Debug and Release configuration types.
set(CMAKE_CONFIGURATION_TYPES Debug Release)
if (NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Debug")
endif()

# Set proejct architecture
set(OS_MACOS 1)
set(OS_POSIX 1)
add_definitions(-DOS_MACOS=1 -DOS_POSIX=1)


if(NOT DEFINED PROJECT_ARCH)
  if(CMAKE_SIZEOF_VOID_P MATCHES 8)
    set(PROJECT_ARCH "x86_64")
  else()
    set(PROJECT_ARCH "x86")
  endif()
endif()

# Target architecture.
if(PROJECT_ARCH STREQUAL "x86_64")
  set(CMAKE_OSX_ARCHITECTURES "x86_64")
elseif(PROJECT_ARCH STREQUAL "arm64")
  set(CMAKE_OSX_ARCHITECTURES "arm64")
else()
  set(CMAKE_OSX_ARCHITECTURES "i386")
endif()

# Use folders in the resulting project files.
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# C standard
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_STANDARD 11)

# C++ standard
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 14)

add_compile_options(
  "-g"
  "$<$<CONFIG:DEBUG>:-O0>"
  "$<$<CONFIG:RELEASE>:-O3>"
)
set(CMAKE_OSX_DEPLOYMENT_TARGET 10.11)

if (BUILD_STATIC)
  set(COCOACEFVIEW_LIB_TYPE STATIC)
else()
  set(COCOACEFVIEW_LIB_TYPE SHARED)
endif ()

set(CMAKE_SUPPRESS_REGENERATION TRUE)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/output/$<CONFIG>/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/output/$<CONFIG>/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/output/$<CONFIG>/lib)

# Include CefViewCore
add_subdirectory(CefViewCore)
set_target_properties(CefViewCore PROPERTIES FOLDER core)
foreach(CefViewWingTarget ${CefViewCore_HELPER_APP_TARGETS})
  set_target_properties(${CefViewWingTarget} PROPERTIES FOLDER core)  
endforeach(CefViewWingTarget)
set_target_properties(libcef_dll_wrapper PROPERTIES FOLDER core)

# Config CocoaCefView target
###############################################################
add_subdirectory(src)

# Config the Demo project
###############################################################
if (BUILD_DEMO)
  add_subdirectory(demo/CocoaCefViewDemo)
endif() 
###############################################################