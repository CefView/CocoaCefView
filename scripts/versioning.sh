#!/bin/sh

echo "setting version number..."
pushd .

echo "Set version for app project..."
xcrun agvtool new-marketing-version ${BK_CI_MAJOR_VERSION}.${BK_CI_MINOR_VERSION}.${BK_CI_BUILD_NO}
xcrun agvtool new-version -all ${BK_CI_MAJOR_VERSION}.${BK_CI_MINOR_VERSION}.${BK_CI_BUILD_NO}
popd