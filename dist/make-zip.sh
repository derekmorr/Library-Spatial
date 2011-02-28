#! /bin/sh

BUILD_DIR=../src/CoreServices/bin/Release
zip -u -j LSML-0.81.zip README.txt \
                        ${BUILD_DIR}/Landis.SpatialModeling.dll \
                        ${BUILD_DIR}/Landis.SpatialModeling.CoreServices.dll
