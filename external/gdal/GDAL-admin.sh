#! /bin/sh

# Run this script in the directory where it's located
scriptDir=`dirname $0`
if [ "$scriptDir" != "." ] ; then
  originalDir=`pwd`
  cd $scriptDir
  echo cd $scriptDir
fi

export GdalAdmin_VersionFile=version.txt
export GdalAdmin_InstallDir=libs
../../dist/GDAL-admin.sh $*

if [ "$originalDir" != "" ] ; then
  cd $originalDir
fi
