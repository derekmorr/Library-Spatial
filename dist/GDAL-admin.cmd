@echo off
setlocal enableDelayedExpansion

rem  Ensure all needed environment variables have been initialized.
set MissingVar=no
call :checkVar WinPkgTools
call :checkVar DownloadTool
call :checkVar GdalAdmin_VersionFile
call :checkVar GdalAdmin_InstallDir
if "%MissingVar%" == "yes" exit /b 1

set Script=%~nx0
call :processArgs %*
if "%Action%" == "error" goto :exitScript
if "%Action%" == "clean" (
  call :clean
  goto :exitScript
)
if "%Action%" == "help" (
  call :usage
  goto :exitScript
)
rem  Action == get or update

rem  Read GDAL version #
for /f %%v in (%GdalAdmin_VersionFile%) do set GdalVersion=%%v

rem  The list of packages available for the specified GDAL version
set ProjectUrl=http://landis-spatial.googlecode.com/
set PackageList=gdal-%GdalVersion%-csharp.txt

rem  Determine the platform (win32 or win64)
call :getPlatform
echo Platform = %Platform%

rem  The binary package for the platform
set PackageName=gdal-%GdalVersion:.=-%-csharp-%Platform%.zip
set PackagePath=%GdalAdmin_InstallDir%\%PackageName%

rem  Fetch the list of available packages
if not exist %PackageList% set GetPackageList=yes
if "%Action%" == "update" set GetPackageList=yes
if "%GetPackageList%" == "yes" call :getPkgList

rem  Search for the platform in the package list
set PackageSHA1=
for /f "tokens=1,2" %%x in (%PackageList%) do (
  if "%%x" == "%Platform%" set PackageSHA1=%%y
)
if "%PackageSHA1%" == "" goto :noPackage

rem  Fetch the binary package for the platform
set PackageUrl=%ProjectUrl%/files/%PackageName%
set DirInPkg=%GdalAdmin_InstallDir%\managed

call "%WinPkgTools%\getPackage" %PackageUrl% %PackagePath% %PackageSHA1% %DirInPkg%


:exitScript

if "%Action%" == "error" (
  set ExitCode=1
) else (
  set ExitCode=0
)
exit /b %ExitCode%

rem  ------------------------------------------------------------------------

:processArgs

set Action=
if "%~1" == "get"       set Action=get
if "%~1" == "update"    set Action=update
if "%~1" == "clean"     set Action=clean
if "%~1" == "help"      set Action=help
if "%~1" == ""          set Action=help

if "%Action%" == "" (
  call :error unknown action "%~1"
  goto :eof
)
if not "%~3" == "" (
  call :error extra arguments after "%~1" action: %2 ...
  goto :eof
)
if not "%~2" == "" (
  call :error extra argument after "%~1" action: %2
  goto :eof
)

goto :eof

rem  ------------------------------------------------------------------------

:error

echo Error: %*
call :usage
set Action=error
goto :eof

rem  ------------------------------------------------------------------------

:usage

echo Usage: %Script% [ACTION]
echo where ACTION is:
echo   get       -- download and unpack GDAL libraries and C# bindings
echo   update    -- update the local list of available GDAL packages with the
echo                current list in the svn repos, then do the "get" action
echo   clean     -- remove all unpacked files
echo   help      -- display this message (default)

goto :eof

rem  ------------------------------------------------------------------------

:checkVar

set VarName=%1
for /f %%V in ('echo %VarName%') do set VarValue=!%%V!
if "%VarValue%" == "" (
  echo Error: The environment variable %VarName% is not set.
  set MissingVar=yes
)
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
echo   A) obtain pre-compiled GDAL libraries and their C# bindings, or
echo   B) build the libraries and C# bindings manually.
echo.
echo In either case, the C# bindings must be in installed in this folder:
echo.
echo   %CD%\%GdalAdmin_InstallDir%\managed\

exit /b 1

rem  ------------------------------------------------------------------------

:clean

rem  Delete all the unpacked files

call :deleteFile %GdalAdmin_InstallDir%\README.txt
call :deleteDir  %GdalAdmin_InstallDir%\managed
call :deleteDir  %GdalAdmin_InstallDir%\native

goto :eof

rem  ------------------------------------------------------------------------

:deleteFile

if exist "%~1" (
  del "%~1"
  echo Deleted %~1
)
goto :eof

rem  ------------------------------------------------------------------------

:deleteDir

if exist "%~1" (
  rmdir /s /q "%~1"
  echo Deleted %~1\
)
goto :eof

rem  ------------------------------------------------------------------------
