#! /bin/sh

#-----------------------------------------------------------------------------

# A function for downloading a file from a URL to a local path

function downloadFile()
{
  echo Downloading $2 ...
  curl --progress-bar --fail --show-error --url $1 -o $2
  if [ $? -ne 0 ] ; then 
    curlExitCode=$?
    printf "  URL = $1\n"
    exit $curlExitCode
  fi
}

#-----------------------------------------------------------------------------

#  Run this script in the directory where it's located
scriptDir=`dirname $0`
cd $scriptDir
echo pwd = `pwd`

#  Read GDAL version #
GdalVersion=`awk '{print $1}' version.txt`
echo This version of LSML uses GDAL ${GdalVersion}

#  The list of packages available for the specified GDAL version
ProjectUrl=http://landis-spatial.googlecode.com/
PackageList=gdal-${GdalVersion}-csharp.txt
GetPackageList=no
if [ ! -f $PackageList ] ; then
  GetPackageList=yes
fi
if [ "$1" = "--update-pkg-list" ]  ; then
  GetPackageList=yes
fi
if [ "${GetPackageList}" = "yes" ] ; then
  SvnPath=svn/trunk/external/gdal/packages/${PackageList}
  PackageListUrl=${ProjectUrl}${SvnPath}
  downloadFile $PackageListUrl $PackageList
fi

#  Determine the platform (win32 or win64)
Platform=`uname -s`
echo Platform = ${Platform}

#  Search for the platform in the package list
PackageSHA1=`fgrep $Platform $PackageList | awk '{print $2}' `
PackageSHA1=foo
if [ "$PackageSHA1" = "" ] ; then
  cat <<-HERE
	No GDAL package for platform "$Platform" is available at the web site:

	   $ProjectUrl

	You must either:

	   A) install pre-compiled GDAL libraries and their C# bindings, or
	   B) build the libraries and C# bindings manually.
	HERE
  exit 1
fi

#  Download the binary package for the platform
PackageName=gdal-${GdalVersion/./-}-csharp-${Platform}.tgz
PackageUrl=${ProjectUrl}files/${PackageName}
PackagePath=GDAL/${PackageName}
if [ -f $PackageName ] ; then
  echo $PackageName already downloaded.
else
  downloadFile $PackageUrl $PackageName
  echo Verifying checksum of $PackageName ...
  if [ `uname` = Darwin ] ; then
    ComputedSHA1=`openssl sha1 $PackageName | sed 's/^.*= //' `
  else
    ComputedSHA1=`sha1sum $PackageName | sed 's/ .*//' `
  fi
  if [ "$ComputedSHA1" != "$PackageSHA1" ] ; then
    echo ERROR: Invalid checksum
    echo Expected SHA1 = $PackageSHA1
    echo Computed SHA1 = $ComputedSHA1
    exit 1
  fi
fi

#  Unpack the package if not done already
if [ -f managed/gdal_csharp.dll ] ; then
  printf "GDAL libraries and C# bindings have already been unpacked.\n"
else
  echo Unpacking $PackageName ...
  tar -xvzf $PackageName
fi

exit 0
