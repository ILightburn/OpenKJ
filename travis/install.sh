#!/bin/bash

# do not build mac for PR
if [ "${TRAVIS_PULL_REQUEST}" != "false" ]; then
  exit 0
fi



#install gstreamer#install Qt
echo "Downloading Qt"
wget -c --no-check-certificate -nv -Oqt.tbz2 https://cloud.hm.hozed.net/index.php/s/3lyFyolHbBdMx8o
echo "Extracting Qt"
tar -xf qt.tbz2
echo "Moving Qt to proper location"
mv Qt $HOME/Qt

echo "gstreamer install"
echo "Downloading gstreamer runtime package"
wget -c --no-check-certificate -nv https://gstreamer.freedesktop.org/data/pkg/osx/1.11.2/gstreamer-1.0-1.11.2-x86_64.pkg
echo "Downloading gstreamer devel package"
wget -c --no-check-certificate -nv https://gstreamer.freedesktop.org/data/pkg/osx/1.11.2/gstreamer-1.0-devel-1.11.2-x86_64.pkg
echo "Installing gstreamer runtime package"
sudo installer -package gstreamer-1.0-1.11.2-x86_64.pkg -target /;
echo "Installing gstreamer devel package"
sudo installer -package gstreamer-1.0-devel-1.11.2-x86_64.pkg -target /;
echo "gstreamer install done"



