# 
# The main config file for CocoaCef
#
cmake_minimum_required(VERSION 3.19)
project(CocoaCefView)

# Only generate Debug and Release configuration types.
set(CMAKE_CONFIGURATION_TYPES Debug Release)

# Set proejct architecture
if ((NOT DEFINED TARGET_ARCH) OR (TARGET_ARCH STREQUAL "") OR (NOT ${TARGET_ARCH} MATCHES "(x86_64|arm64)"))
    message(FATAL_ERROR "++++++++++ INVALID FLAG TARGET_ARCH=" ${TARGET_ARCH} ", valid values:x86_64|arm64")
endif()
set(PROJECT_ARCH ${TARGET_ARCH})

# Use folders in the resulting project files.
set_property(GLOBAL PROPERTY OS_FOLDERS ON)

# C standard
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_STANDARD 11)

# C++ standard
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_OSX_DEPLOYMENT_TARGET 10.11)

# Config the CEF
###############################################################
# Disable the sandbox
if ((NOT DEFINED USE_SANDBOX) OR (USE_SANDBOX STREQUAL "") 
    OR (${USE_SANDBOX} MATCHES "(FALSE|false|0|OFF)"))
    option(USE_SANDBOX "Enable CEF Sandbox" OFF)
elseif(${USE_SANDBOX} MATCHES "(TRUE|true|1|null|ON)")
    option(USE_SANDBOX "Enable CEF Sandbox" ON)
    add_definitions(-DCEF_USE_SANDBOX)
else()
    message(FATAL_ERROR "++++++++++ INVALID FLAG USE_SANDBOX=" ${USE_SANDBOX}, ", valid values:FALSE|false|0|OFF|TRUE|true|1|null|ON")
endif()
###############################################################

set(CMAKE_SUPPRESS_REGENERATION TRUE)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/output/$<CONFIG>/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/output/$<CONFIG>/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/output/$<CONFIG>/lib)


# Include CefViewCore
add_subdirectory(CefViewCore)

# Config CocoaCefView target
###############################################################
add_subdirectory(src)

# Config the Demo project
###############################################################
if ((NOT DEFINED BUILD_DEMO) OR (BUILD_DEMO STREQUAL "") 
    OR (${BUILD_DEMO} MATCHES "(FALSE|false|0|OFF)"))
    option(BUILD_DEMO "Build the demo" OFF)
elseif(${BUILD_DEMO} MATCHES "(TRUE|true|1|null|ON)")
    option(BUILD_DEMO "Build the demo" ON)
else()
    message(FATAL_ERROR "++++++++++ INVALID FLAG BUILD_DEMO=" ${BUILD_DEMO})
endif()
if (BUILD_DEMO)
  add_subdirectory(demo/CocoaCefViewDemo)
endif() 
###############################################################