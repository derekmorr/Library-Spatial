@echo off
setlocal

rem  Ensure WinPkgTools have been initialized before calling this script.
if "%WinPkgTools%" == "" (
  call :varError WinPkgTools
  exit /b 1
)
if "%DownloadTool%" == "" (
  call :varError DownloadTool
  exit /b 1
)

rem  Read GDAL version #
for /f %%v in (version.txt) do set GdalVersion=%%v

rem  The list of packages available for the specified GDAL version
set ProjectUrl=http://landis-spatial.googlecode.com/
set PackageList=gdal-%GdalVersion%-csharp.txt
if not exist %PackageList% set GetPackageList=yes
if "%~1" == "--update-pkg-list" set GetPackageList=yes
if "%GetPackageList%" == "yes" call :getPkgList

rem  Determine the platform (win32 or win64)
call :getPlatform
echo Platform = %Platform%

rem  Search for the platform in the package list
set PackageSHA1=
for /f "tokens=1,2" %%x in (%PackageList%) do (
  if "%%x" == "%Platform%" set PackageSHA1=%%y
)
if "%PackageSHA1%" == "" goto :noPackage

rem  Fetch the binary package for the platform
set PackageName=gdal-%GdalVersion:.=-%-csharp-%Platform%.zip
set PackageUrl=%ProjectUrl%/files/%PackageName%
set PackagePath=GDAL\%PackageName%
set DirInPkg=GDAL\managed

call "%WinPkgTools%\getPackage" %PackageUrl% %PackagePath% %PackageSHA1% %DirInPkg%

goto :eof

rem  ------------------------------------------------------------------------

:checkVar

echo Error: The environment variable %1 is not set.
echo        The WinPkgTools\initialize.cmd script must be called first.
goto :eof

rem  ------------------------------------------------------------------------

:getPkgList

set SvnPath=svn/trunk/external/gdal/packages/%PackageList%
set PackageListUrl=%ProjectUrl%/%SvnPath%
echo Downloading %PackageList% ...
"%DownloadTool%" %PackageListUrl% %PackageList%

goto :eof

rem  ------------------------------------------------------------------------

:getPlatform

rem  Based on this blog post:
rem  http://blogs.msdn.com/b/david.wang/archive/2006/03/26/howto-detect-process-bitness.aspx
if "%PROCESSOR_ARCHITECTURE%,%PROCESSOR_ARCHITEW6432%" == "x86," (
  set Platform=win32
) else (
  set Platform=win64
)
goto :eof

rem  ------------------------------------------------------------------------

:noPackage

echo No GDAL package for platform "%Platform%" is available at the web site:
echo.
echo   %ProjectUrl%
echo.
echo You must either:
echo.
echo   A) install pre-compiled GDAL libraries and their C# bindings, or
echo   B) build the libraries and C# bindings manually.

exit /b 1

rem  ------------------------------------------------------------------------
