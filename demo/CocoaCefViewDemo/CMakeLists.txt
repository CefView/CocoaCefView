cmake_minimum_required(VERSION 3.4.1)
project(CocoaCefViewDemo)

set(CMAKE_CXX_STANDARD 11)
set(CXX_STANDARD_REQUIRED)

file(GLOB_RECURSE CocoaCefViewDemo_SRC_FILES
  "Base.lproj/MainMenu.xib"
  "CocoaCefViewTestPage.html"
  "*.html"
  "*.h"
  "*.cpp"
  "*.m"
  "*.mm"
)
source_group(TREE ${CMAKE_CURRENT_SOURCE_DIR} PREFIX Source FILES ${CocoaCefViewDemo_SRC_FILES})

set_source_files_properties(
  "Base.lproj/MainMenu.xib" "CocoaCefViewTestPage.html"
  PROPERTIES
    MACOSX_PACKAGE_LOCATION Resources
)

set(CocoaCefViewDemo_INFO_PLIST_FILE "${CMAKE_CURRENT_LIST_DIR}/info.plist")

add_executable(${PROJECT_NAME} MACOSX_BUNDLE
  ${CocoaCefViewDemo_SRC_FILES}
)

set_property(TARGET ${PROJECT_NAME} 
  APPEND_STRING PROPERTY COMPILE_FLAGS "-fobjc-arc"
)

add_library(CocoaCefViewFramework ${COCOACEFVIEW_LIB_TYPE} IMPORTED)
set_target_properties(CocoaCefViewFramework
  PROPERTIES
    FRAMEWORK                 TRUE
    IMPORTED_LOCATION         "${CMAKE_BINARY_DIR}/output/Release/bin/CocoaCefView.framework"
    IMPORTED_LOCATION_DEBUG   "${CMAKE_BINARY_DIR}/output/Debug/bin/CocoaCefView.framework"
    IMPORTED_LOCATION_RELEASE "${CMAKE_BINARY_DIR}/output/Release/bin/CocoaCefView.framework"
)

set_target_properties(${PROJECT_NAME} 
  PROPERTIES
    FOLDER                                    example
    RUNTIME_OUTPUT_DIRECTORY                  ${CMAKE_CURRENT_BINARY_DIR}/output/$<CONFIG>/bin
    ARCHIVE_OUTPUT_DIRECTORY                  ${CMAKE_CURRENT_BINARY_DIR}/output/$<CONFIG>/lib
    LIBRARY_OUTPUT_DIRECTORY                  ${CMAKE_CURRENT_BINARY_DIR}/output/$<CONFIG>/lib

    CLANG_ENABLE_OBJC_ARC                     "YES"
    MACOSX_BUNDLE_INFO_PLIST                  "${CocoaCefViewDemo_INFO_PLIST_FILE}"
    XCODE_ATTRIBUTE_LD_RUNPATH_SEARCH_PATHS   "@executable_path/../Frameworks"
    XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER "com.cefview.cocoacefviewdemo"
    XCODE_ATTRIBUTE_FRAMEWORK_SEARCH_PATHS    "${CMAKE_BINARY_DIR}/output/$<CONFIG>/bin"
    OSX_ARCHITECTURES_DEBUG                   "${CMAKE_OSX_ARCHITECTURES}"
    OSX_ARCHITECTURES_RELEASE                 "${CMAKE_OSX_ARCHITECTURES}"

    # # the below two properties need CMake >= 3.20.0, we just copy the framework by post build command
    # XCODE_EMBED_FRAMEWORKS_CODE_SIGN_ON_COPY   "YES"
    # XCODE_EMBED_FRAMEWORKS                     "${CMAKE_BINARY_DIR}/output/${CMAKE_BUILD_TYPE}/bin/CocoaCefView.framework"
)

find_library(COCOA_FRAMEWORK Cocoa)
find_library(APPKIT_FRAMEWORK Appkit)
target_link_libraries(${PROJECT_NAME}
  PRIVATE
    ${COCOA_FRAMEWORK}
    ${APPKIT_FRAMEWORK}
    CocoaCefViewFramework
)

add_custom_command(TARGET ${PROJECT_NAME} 
  POST_BUILD

    # remove the old framework from the bundle if exists
    COMMAND rm -fr 
      "$<TARGET_BUNDLE_CONTENT_DIR:${PROJECT_NAME}>/Frameworks/CocoaCefView.framework"
    COMMAND ${CMAKE_COMMAND} -E copy_directory
      "$<TARGET_FILE:CocoaCefViewFramework>"
      "$<TARGET_BUNDLE_CONTENT_DIR:${PROJECT_NAME}>/Frameworks/CocoaCefView.framework"
    
    # copy the web resource to the bundle
    COMMAND ${CMAKE_COMMAND} -E copy_directory
      "${CMAKE_CURRENT_SOURCE_DIR}/webres"
      "$<TARGET_BUNDLE_CONTENT_DIR:${PROJECT_NAME}>/Resources/webres"
      VERBATIM
)
