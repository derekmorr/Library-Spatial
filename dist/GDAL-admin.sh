#! /bin/sh

# ----------------------------------------------------------------------------

function printUsage()
{
  cat <<EOT
Usage: $ScriptName [ACTION]
where ACTION is:
   get       -- download and unpack GDAL libraries and C# bindings
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
      get | help ) Action=$1;;
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
if [ "$Action" = "help" ] ; then
  printUsage
  exit 0
fi

#  Read GDAL version #
GdalVersion=`awk '{print $1}' $GdalAdmin_VersionFile`
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
if [ "$PackageSHA1" = "" ] ; then
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
fi

#  Download the binary package for the platform
PackageName=gdal-${GdalVersion//./-}-csharp-${Platform}.tgz
PackageUrl=${ProjectUrl}files/${PackageName}
PackagePath=$GdalAdmin_InstallDir/${PackageName}
if [ -f $PackagePath ] ; then
  echo $PackageName already downloaded.
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
