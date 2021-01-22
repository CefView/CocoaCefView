#!/bin/sh

##########################################################################################
codesign \
    --force \
    --sign 620f6d9a115baa1ca292d044f75037200250d832 \
    "${WORKSPACE}/output/Release/CocoaCef.framework/Resources/Chromium Embedded Framework.framework"

codesign \
    --force \
    --sign 620f6d9a115baa1ca292d044f75037200250d832 \
    "${WORKSPACE}/output/Release/CocoaCef.framework/Resources/CocoaCefWing.app"

codesign \
    --force \
    --sign 620f6d9a115baa1ca292d044f75037200250d832 \
    "${WORKSPACE}/output/Release/CocoaCef.framework/Resources/CocoaCefWing (Renderer).app"

codesign \
    --force \
    --sign 620f6d9a115baa1ca292d044f75037200250d832 \
    "${WORKSPACE}/output/Release/CocoaCef.framework/Resources/CocoaCefWing (GPU).app"

codesign \
    --force \
    --sign 620f6d9a115baa1ca292d044f75037200250d832 \
    "${WORKSPACE}/output/Release/CocoaCef.framework/Resources/CocoaCefWing (Plugin).app"

codesign \
    --force \
    --sign 620f6d9a115baa1ca292d044f75037200250d832 \
    "${WORKSPACE}/output/Release/CocoaCef.framework"

##########################################################################################

codesign \
    --force \
    --sign 620f6d9a115baa1ca292d044f75037200250d832 \
    "${WORKSPACE}/output/Release/CocoaCefDemo.app/Contents/Frameworks/CocoaCef.framework/Resources/Chromium Embedded Framework.framework"

codesign \
    --force \
    --sign 620f6d9a115baa1ca292d044f75037200250d832 \
    "${WORKSPACE}/output/Release/CocoaCefDemo.app/Contents/Frameworks/CocoaCef.framework/Resources/CocoaCefWing.app"

codesign \
    --force \
    --sign 620f6d9a115baa1ca292d044f75037200250d832 \
    "${WORKSPACE}/output/Release/CocoaCefDemo.app/Contents/Frameworks/CocoaCef.framework/Resources/CocoaCefWing (Renderer).app"

codesign \
    --force \
    --sign 620f6d9a115baa1ca292d044f75037200250d832 \
    "${WORKSPACE}/output/Release/CocoaCefDemo.app/Contents/Frameworks/CocoaCef.framework/Resources/CocoaCefWing (GPU).app"

codesign \
    --force \
    --sign 620f6d9a115baa1ca292d044f75037200250d832 \
    "${WORKSPACE}/output/Release/CocoaCefDemo.app/Contents/Frameworks/CocoaCef.framework/Resources/CocoaCefWing (Plugin).app"

codesign \
    --force \
    --sign 620f6d9a115baa1ca292d044f75037200250d832 \
    "${WORKSPACE}/output/Release/CocoaCefDemo.app/Contents/Frameworks/CocoaCef.framework"