#!/bin/bash

set -e

# do not build mac for PR
if [ "${TRAVIS_PULL_REQUEST}" != "false" ]; then
  exit 0
fi

BundlePath=$PWD/OpenKJ/OpenKJ.app

$HOME/Qt/5.10.0/clang_64/bin/qmake

make -j4

ls -R

$HOME/Qt/5.10.0/clang_64/bin/macdeployqt ${BundlePath}/OpenKJ.app
echo "Removing unneeded and non-appstore compliant plugins"
rm -f ${BundlePath}/Contents/PlugIns/sqldrivers/libqsqlmysql.dylib
rm -f ${BundlePath}/Contents/PlugIns/sqldrivers/libqsqlodbc.dylib
rm -f ${BundlePath}/Contents/PlugIns/sqldrivers/libqsqlpsql.dylib
echo "Copying GStreamer framework to package dir"
cp -pR /Library/Frameworks/GStreamer.framework.deploy ${BundlePath}/Contents/Frameworks/GStreamer.framework
echo "Fixing directory structure in the GStreamer framework"
rm -f ${BundlePath}/Contents/Frameworks/GStreamer.framework/Versions/Current
cd ${BundlePath}/Contents/Frameworks/GStreamer.framework/Versions
ln -s 1.0 Current
cd -
echo "Modifying linker path info for GStreamer library to app bundle pathing"
osxrelocator ${BundlePath}/Contents/Frameworks/GStreamer.framework/Versions/Current/lib /Library/Frameworks/GStreamer.framework/ /Applications/OpenKJ.app/Contents/Frameworks/GStreamer.framework/ -r &>/dev/null
osxrelocator ${BundlePath}/Contents/Frameworks/GStreamer.framework/Versions/Current/libexec /Library/Frameworks/GStreamer.framework/ /Applications/OpenKJ.app/Contents/Frameworks/GStreamer.framework -r &>/dev/null
osxrelocator ${BundlePath}/Contents/Frameworks/GStreamer.framework/Versions/Current/bin /Library/Frameworks/GStreamer.framework/ /Applications/OpenKJ.app/Contents/Frameworks/GStreamer.framework/ -r &>/dev/null
osxrelocator ${BundlePath}/Contents/MacOS /Library/Frameworks/GStreamer.framework/ /Applications/OpenKJ.app/Contents/Frameworks/GStreamer.framework/ -r &>/dev/null

#echo "Signing code"
#codesign -s "Application: Isaac Lightburn (47W8CPBS5A)" --deep ${BundlePath}
echo "Creating installer"
mkdir ~/installers
appdmg ~/travis/openkjdmg.json /Users/lightburnisaac/installers/openkj.dmg
#echo "Signing installer"
#codesign -s "Application: Isaac Lightburn (47W8CPBS5A)" /Users/lightburnisaac/installers/${INSTALLERFN}
