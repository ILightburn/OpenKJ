#!/bin/bash

# do not build mac for PR
if [ "${TRAVIS_PULL_REQUEST}" != "false" ]; then
  exit 0
fi

#install Qt
which -s qmake
QT_INSTALLED=$?
QMAKE_VERSION=
if [[ $QT_INSTALLED == 0 ]]; then
  QMAKE_VERSION=$(qmake -query QT_VERSION)
fi

echo "QMAKE_VERSION $QMAKE_VERSION"
echo "QT_INSTALLED $QT_INSTALLED"
echo "QT_LONG_VERSION QT_LONG_VERSION"

if [[ "$QMAKE_VERSION" != "${QT_LONG_VERSION}" ]]; then
  rm -rf $QT_PATH
  echo "Downloading Qt"
  wget -c --no-check-certificate -nv https://download.qt.io/official_releases/qt/${QT_SHORT_VERSION}/${QT_LONG_VERSION}/${QT_INSTALLER_FILENAME}
  hdiutil mount ${QT_INSTALLER_FILENAME}
  cp -rf /Volumes/${QT_INSTALLER_ROOT}/${QT_INSTALLER_ROOT}.app $HOME/${QT_INSTALLER_ROOT}.app
  QT_INSTALLER_EXE=$HOME/${QT_INSTALLER_ROOT}.app/Contents/MacOS/${QT_INSTALLER_ROOT}

  echo "Installing Qt"
  ./travis/extract-qt-installer $QT_INSTALLER_EXE $QT_PATH
  rm -rf $HOME/${QT_INSTALLER_ROOT}.app
else
  echo "Qt ${QT_LONG_VERSION} already installed"
fi
