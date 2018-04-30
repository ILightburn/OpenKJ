#!/bin/bash

# do not build mac for PR
if [ "${TRAVIS_PULL_REQUEST}" != "false" ]; then
  exit 0
fi

echo "Setting up signing environment"
security create-keychain -p $keychainPass build.keychain
security default-keychain -s build.keychain
security unlock-keychain -p $keychainPass build.keychain

wget -c --no-check-certificate -nv -Ocscrt.zip https://cloud.hm.hozed.net/index.php/s/MwRE20VHSLCShRj/download

unzip -P$cscrtPass cscrt.zip

security import applekey.p12 -k build.keychain -P $p12Pass -T /usr/bin/codesign

security find-identity -v

echo "Installing osxrelocator"
pip2 install osxrelocator

echo "Installing appdmg"
npm install -g appdmg

if [ -d "Qt" ]; then
  echo "Cached copy of Qt already exists, skipping install"
else
  #install gstreamer#install Qt
  echo "Downloading Qt"
  wget -c --no-check-certificate -nv -Oqt.tar.bz2 https://cloud.hm.hozed.net/index.php/s/3lyFyolHbBdMx8o/download
  echo "Extracting Qt"
  bunzip2 qt.tar.bz2
  tar -xf qt.tar
  echo "Moving Qt to proper location"
  mv Qt $HOME/Qt
fi

if [ -d "/Library/Frameworks/GStreamer.framework" ]; then
  echo "Cached copy of gstreamer already exists, skipping installation"
else
  echo "gstreamer install"
  echo "Downloading gstreamer runtime package"
  wget -c --no-check-certificate -nv -Ogstreamer.pkg https://cloud.hm.hozed.net/index.php/s/MmEJPabg9FPnuCL/download
  echo "Downloading gstreamer devel package"
  wget -c --no-check-certificate -nv -Ogstreamer-dev.pkg https://cloud.hm.hozed.net/index.php/s/r41LnQOTjf1WG17/download
  echo "Installing gstreamer runtime package"
  sudo installer -package gstreamer.pkg -target /;
  echo "Making a deployment copy of the runtime"
  sudo cp -R /Library/Frameworks/GStreamer.framework /Library/Frameworks/GStreamer.framework.deploy
  echo "Installing gstreamer devel package"
  sudo installer -package gstreamer-dev.pkg -target /;
  sudo ln -s /Users/travis /Users/lightburnisaac
  echo "gstreamer install done"
fi


