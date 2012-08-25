#! /bin/sh

# ----------------------------------------------------------------------------

function printUsage()
{
  cat <<EOT
Usage: $ScriptName [ACTION]
where ACTION is:
   get       -- download and unpack GDAL libraries and C# bindings
   update    -- update the local list of available GDAL packages with the
                current list in the svn repos, then do the "get" action
   clean     -- remove all unpacked files
   help      -- display this message (default)
EOT
}

# ----------------------------------------------------------------------------

function processArgs()
{
  Action=
  if [ "$1" = "" ] ; then
    Action=help
  else
    case $1 in
      get | update | clean | help ) Action=$1;;
      *) usageError "unknown action \"$1\"";;
    esac
  fi
  if [ "$3" != "" ] ; then
    usageError "extra arguments after \"$1\" action: $2 ..."
  fi
  if [ "$2" != "" ] ; then
    usageError "extra argument after \"$1\" action: $2"
  fi
}

# ----------------------------------------------------------------------------

function usageError()
{
  printf "Error: $1\n"
  printUsage
  exit 1
}

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

function getPkgList()
{
  SvnPath=svn/trunk/external/gdal/packages/${PackageList}
  PackageListUrl=${ProjectUrl}${SvnPath}
  downloadFile $PackageListUrl $PackageList
}

#-----------------------------------------------------------------------------

function getPlatform()
{
  if [ "$GdalAdmin_Platform" != "" ] ; then
    Platform=$GdalAdmin_Platform
  else
    Platform=`uname -s`
  fi
}

#-----------------------------------------------------------------------------

function noPackage()
{
  cat <<-HERE
	No GDAL package for platform "$Platform" is available at the web site:

	   $ProjectUrl

	You must either:

	   A) obtain pre-compiled GDAL libraries and their C# bindings, or
	   B) build the libraries and C# bindings manually.

	In either case, the C# bindings must be installed in this folder:

	  `pwd`/$GdalAdmin_InstallDir/managed/
	HERE
  exit 1
}

#-----------------------------------------------------------------------------

# Remove all files that are unpacked from the GDAL package

function cleanFiles()
{
  deleteFile $GdalAdmin_InstallDir/README.txt
  deleteDir  $GdalAdmin_InstallDir/managed
  deleteDir  $GdalAdmin_InstallDir/native
}

#-----------------------------------------------------------------------------

function deleteFile()
{
  if [ -f $1 ] ; then
    rm -f $1
    echo Deleted $1
  fi
}

#-----------------------------------------------------------------------------

function deleteDir()
{
  if [ -d $1 ] ; then
    rm -fR $1
    echo Deleted $1/
  fi
}

#-----------------------------------------------------------------------------

MissingVar=no
for VarName in GdalAdmin_VersionFile GdalAdmin_InstallDir ; do
  if [ "${!VarName}" = "" ] ; then
    printf "Error: The environment variable $VarName is not set.\n"
    MissingVar=yes
  fi
done
if [ "$MissingVar" = "yes" ] ; then
  exit 1
fi

ScriptName=`basename $0`
processArgs $*
case $Action in
  clean)  cleanFiles ; exit 0 ;;
  help)   printUsage ; exit 0 ;;
esac
#  $Action == get or update

#  Read GDAL version #
GdalVersion=`awk '{print $1}' $GdalAdmin_VersionFile`
echo This version of LSML uses GDAL ${GdalVersion}

#  The list of packages available for the specified GDAL version
ProjectUrl=http://landis-spatial.googlecode.com/
PackageList=gdal-${GdalVersion}-csharp.txt

#  Determine the platform
getPlatform
echo Platform = ${Platform}

#  The binary package for the platform
PackageName=gdal-${GdalVersion//./-}-csharp-${Platform}.tgz
PackagePath=$GdalAdmin_InstallDir/${PackageName}

#  Fetch the list of available packages
GetPackageList=no
if [ ! -f $PackageList ] ; then
  GetPackageList=yes
fi
if [ "$Action" = "update" ]  ; then
  GetPackageList=yes
fi
if [ "${GetPackageList}" = "yes" ] ; then
  getPkgList
fi

#  Search for the platform in the package list
PackageSHA1=`fgrep $Platform $PackageList | awk '{print $2}' `
if [ "$PackageSHA1" = "" ] ; then
  noPackage  # exits script with code 1
fi

#  Download the binary package for the platform
PackageUrl=${ProjectUrl}files/${PackageName}
if [ -f $PackagePath ] ; then
  echo $PackagePath already downloaded.
else
  if [ ! -d $GdalAdmin_InstallDir ] ; then
    mkdir $GdalAdmin_InstallDir
    echo Created directory $GdalAdmin_InstallDir/
  fi
  downloadFile $PackageUrl $PackagePath
  echo Verifying checksum of $PackagePath ...
  if [ `uname` = Darwin ] ; then
    ComputedSHA1=`openssl sha1 $PackagePath | sed 's/^.*= //' `
  else
    ComputedSHA1=`sha1sum $PackagePath | sed 's/ .*//' `
  fi
  if [ "$ComputedSHA1" != "$PackageSHA1" ] ; then
    echo ERROR: Invalid checksum
    echo Expected SHA1 = $PackageSHA1
    echo Computed SHA1 = $ComputedSHA1
    exit 1
  fi
fi

#  Unpack the package if not done already
if [ -d $GdalAdmin_InstallDir/managed ] ; then
  printf "GDAL libraries and C# bindings have already been unpacked.\n"
else
  echo Unpacking $PackagePath ...
  tar -xv -C $GdalAdmin_InstallDir -zf $PackagePath
fi

exit 0
