# CocoaCefView

CocoaCefView provides a NSView based and CEF backed webview UI element for the consumers. 


 ## Build status
| triplets  | status  |
|---|---|
| macOS-arm64 | [![Build on macOS-arm64](https://github.com/CefView/CocoaCefView/actions/workflows/build-macos-arm64.yml/badge.svg)](https://github.com/CefView/CocoaCefView/actions/workflows/build-macos-arm64.yml) |
| macOS-x86_64 | [![Build on macOS-x86_64](https://github.com/CefView/CocoaCefView/actions/workflows/build-macos-x86_64.yml/badge.svg)](https://github.com/CefView/CocoaCefView/actions/workflows/build-macos-x86_64.yml) |


# Note For Debugging With xCode

if you want to debug the project with xCode, you need to take some action to make sure the demo project could load CocoaCefView at correct location.

1. Generate project with cmake
2. Build demo project with xcode, do not run (actually you will encounter errors if you run directly)
3. Go to the **Build Phases** for target CocoaCefViewDemo and perform the actions below
    - remove all items under **Target Dependencies**
    - remove all items under **Link Binary With Libraries**
4. Now you can debug demo project in xCode without errors

if you re-generated the project, please remember to re-do the instructions above again
