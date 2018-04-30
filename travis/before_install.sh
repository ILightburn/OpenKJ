#!/bin/bash

export PATH=$PATH:$QT_MACOS/bin
if [ "${TRAVIS_BRANCH}" == "release" ]; then
  $BRANCH="release"
else
  $BRANCH="unstable"
fi
export INSTALLERFN="OpenKJ-${OKJVER}-${BRANCH}-osx-installer.dmg"
echo "Creating installer: $INSTALLERFN"


chmod 755 ./travis/install.sh
chmod 755 ./travis/build.sh
