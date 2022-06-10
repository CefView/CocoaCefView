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

add_library(CocoaCefView ${COCOACEFVIEW_LIB_TYPE}
  ${CocoaCefView_INCLUDE_HEADERS}
  ${CocoaCefView_SRC_FILES}
  ${CocoaCefView_INFO_PLIST_FILE}
)

set_target_properties(CocoaCefView
  PROPERTIES
    FRAMEWORK TRUE

    CLANG_ENABLE_OBJC_ARC                                       "YES"
    COMPILE_FLAGS                                               "-fobjc-arc"

    PUBLIC_HEADER                                               "${CocoaCefView_INCLUDE_HEADERS}"
    MACOSX_FRAMEWORK_INFO_PLIST                                 "${CocoaCefView_INFO_PLIST_FILE}"
    XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER                   "com.cefview.cocoacefview"
    XCODE_ATTRIBUTE_CLANG_CXX_LANGUAGE_STANDARD                 "gnu++11"   # -std=gnu++11
    XCODE_ATTRIBUTE_CLANG_LINK_OBJC_RUNTIME                     "NO"        # -fno-objc-link-runtime
    XCODE_ATTRIBUTE_COPY_PHASE_STRIP                            "NO"
    XCODE_ATTRIBUTE_DEAD_CODE_STRIPPING[variant=Release]        "YES"       # -Wl,-dead_strip
    XCODE_ATTRIBUTE_GCC_C_LANGUAGE_STANDARD                     "c99"       # -std=c99
    OSX_ARCHITECTURES_DEBUG                                     "${CMAKE_OSX_ARCHITECTURES}"
    OSX_ARCHITECTURES_RELEASE                                   "${CMAKE_OSX_ARCHITECTURES}"
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

add_custom_command(TARGET CocoaCefView
  PRE_BUILD

    # create plugins directory
    COMMAND mkdir -p
      "$<TARGET_BUNDLE_DIR:CocoaCefView>/PlugIns/"

    #copy the CefViewCore binaries to resource directory
    COMMAND cp -a
      "$<TARGET_BUNDLE_DIR:CefViewWing>/../"
      "$<TARGET_BUNDLE_DIR:CocoaCefView>/PlugIns/"

    #sign the cef framework
    COMMAND codesign
      --force
      --sign - 
      "$<TARGET_BUNDLE_DIR:CocoaCefView>/PlugIns/Chromium Embedded Framework.framework"
)