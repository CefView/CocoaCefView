file(GLOB_RECURSE CocoaCefView_INCLUDE_HEADERS
  "${CMAKE_CURRENT_SOURCE_DIR}/../include/*.h"
)
source_group(
  TREE "${CMAKE_CURRENT_SOURCE_DIR}/../include"
  PREFIX Include 
  FILES ${CocoaCefView_INCLUDE_HEADERS}
)

file(GLOB_RECURSE CocoaCefView_SRC_FILES
  "${CMAKE_CURRENT_SOURCE_DIR}/*.h"
  "${CMAKE_CURRENT_SOURCE_DIR}/*.cpp"
  "${CMAKE_CURRENT_SOURCE_DIR}/*.mm"
)
source_group(
  TREE ${CMAKE_CURRENT_SOURCE_DIR} 
  PREFIX Source 
  FILES ${CocoaCefView_SRC_FILES})

set(CocoaCefView_INFO_PLIST_FILE 
  "${CMAKE_CURRENT_LIST_DIR}/Info.plist")

add_library(CocoaCefView SHARED
  ${CocoaCefView_INCLUDE_HEADERS}
  ${CocoaCefView_SRC_FILES}
  ${CocoaCefView_INFO_PLIST_FILE}
)

set_property(TARGET CocoaCefView 
  APPEND_STRING PROPERTY COMPILE_FLAGS "-fobjc-arc"
)

set_target_properties(CocoaCefView
  PROPERTIES
    FRAMEWORK TRUE
    PUBLIC_HEADER                                               "${CocoaCefView_INCLUDE_HEADERS}"
    MACOSX_FRAMEWORK_INFO_PLIST                                 "${CocoaCefView_INFO_PLIST_FILE}"
    MACOSX_FRAMEWORK_IDENTIFIER                                 "com.cocoacef.cocoacefview"
    CLANG_ENABLE_OBJC_ARC                                       "YES"
    XCODE_ATTRIBUTE_CLANG_CXX_LANGUAGE_STANDARD                 "gnu++11"   # -std=gnu++11
    XCODE_ATTRIBUTE_CLANG_LINK_OBJC_RUNTIME                     "NO"        # -fno-objc-link-runtime
    XCODE_ATTRIBUTE_COPY_PHASE_STRIP                            "NO"
    XCODE_ATTRIBUTE_DEAD_CODE_STRIPPING[variant=Release]        "YES"       # -Wl,-dead_strip
    XCODE_ATTRIBUTE_GCC_C_LANGUAGE_STANDARD                     "c99"       # -std=c99
    XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER                   "com.cefview.cocoacefview"
)

target_include_directories(CocoaCefView PRIVATE
  "${CMAKE_CURRENT_SOURCE_DIR}/../include"
  ${CefViewCore_EXPORT_INCLUDE_PATH}
)

add_dependencies(CocoaCefView
  CefViewCore
)

target_link_libraries(CocoaCefView 
  PRIVATE
    CefViewCore
)

add_custom_command(
  TARGET CocoaCefView
  PRE_BUILD

  #sign the cef framework
  COMMAND 
  codesign --force --sign - "$<TARGET_BUNDLE_DIR:CocoaCefView>/../Chromium Embedded Framework.framework"
  VERBATIM

  #copy the CefViewWing to resource directory
  COMMAND 
  ${CMAKE_COMMAND} -E copy_directory 
  "$<TARGET_BUNDLE_DIR:CefViewWing>" 
  "$<TARGET_FILE_DIR:CocoaCefView>/Resources/$<TARGET_NAME:CefViewWing>.app"
  VERBATIM

  #copy the cef framework to resource directory
  COMMAND 
  ${CMAKE_COMMAND} -E copy_directory 
  "$<TARGET_BUNDLE_DIR:CocoaCefView>/../Chromium Embedded Framework.framework"
  "$<TARGET_FILE_DIR:CocoaCefView>/Resources/Chromium Embedded Framework.framework"
  VERBATIM
)