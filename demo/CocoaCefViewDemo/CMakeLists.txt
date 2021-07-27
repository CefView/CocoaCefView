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

set_target_properties(${PROJECT_NAME} 
  PROPERTIES 
    ARCHIVE_OUTPUT_DIRECTORY                  "${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}/demo"
    LIBRARY_OUTPUT_DIRECTORY                  "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/demo"
    RUNTIME_OUTPUT_DIRECTORY                  "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/demo"
    CLANG_ENABLE_OBJC_ARC                     "YES"
    MACOSX_BUNDLE_INFO_PLIST                  "${CocoaCefViewDemo_INFO_PLIST_FILE}"
    XCODE_ATTRIBUTE_LD_RUNPATH_SEARCH_PATHS   "@executable_path/../Frameworks"
    XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER "com.cefview.cocoacefviewdemo"
    XCODE_LINK_BUILD_PHASE_MODE KNOWN_LOCATION
)

find_library(COCOA_FRAMEWORK Cocoa)
find_library(APPKIT_FRAMEWORK Appkit)
target_link_libraries(${PROJECT_NAME} PRIVATE
  $<TARGET_FILE:CocoaCefView>
  ${COCOA_FRAMEWORK}
  ${APPKIT_FRAMEWORK}
)

add_custom_command(
  TARGET ${PROJECT_NAME} POST_BUILD
  # remove the old framework from the bundle if exists
  COMMAND rm -fr "$<TARGET_BUNDLE_CONTENT_DIR:${PROJECT_NAME}>/Frameworks/CocoaCefView.framework"

  # copy the latest framework to the bundle
  COMMAND ${CMAKE_COMMAND} -E copy_directory
      "$<TARGET_BUNDLE_DIR:${PROJECT_NAME}>/../../CocoaCefView.framework"
      "$<TARGET_BUNDLE_CONTENT_DIR:${PROJECT_NAME}>/Frameworks/CocoaCefView.framework"
  
  # copy the web resource to the bundle
  COMMAND ${CMAKE_COMMAND} -E copy_directory
      "${CMAKE_CURRENT_SOURCE_DIR}/webres"
      "$<TARGET_BUNDLE_CONTENT_DIR:${PROJECT_NAME}>/Resources/webres"
  
  VERBATIM
)
