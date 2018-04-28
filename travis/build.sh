#!/bin/bash

set -e

# do not build mac for PR
if [ "${TRAVIS_PULL_REQUEST}" != "false" ]; then
  exit 0
fi

ls /
ls /Library/Frameworks


$HOME/Qt/5.10.0/clang_64/bin/qmake

make -j2

