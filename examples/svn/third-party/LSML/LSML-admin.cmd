@echo off

rem  Run this script in the directory where it's located
pushd %~dp0
setlocal

set Script=%~nx0
call :processArgs %*
if "%Action%" == "error" goto :exitScript
if "%Action%" == "help" (
  call :usage
  goto :exitScript
)

rem  Read LSML version # and the SHA1 checksum for that version
for /f "tokens=1,2" %%i in (version.txt) do (
  set LibraryVer=%%i
  set LibrarySHA1=%%j
)

rem  Download the specific library version
set LibraryFileName=LSML-%LibraryVer%.zip
set LibraryURL=http://landis-spatial.googlecode.com/files/%LibraryFileName%
set DownloadDir=download
set LibraryPackage=%DownloadDir%\%LibraryFileName%

set FileInPkg=Landis.SpatialModeling.dll

call WinPkgTools\getPackage.cmd %LibraryUrl% %LibraryPackage% %LibrarySHA1% %FileInPkg%


:exitScript

popd

set ExitCode=0
if "%Action%" == "error" (
  set ExitCode=1
) else (
  set ExitCode=0
)
exit /b %ExitCode%

rem  ------------------------------------------------------------------------

:processArgs

set Action=
if "%~1" == "get"  set Action=get
if "%~1" == "help" set Action=help
if "%~1" == ""     set Action=help

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
echo   get  -- download and unpack LSML
echo   help -- display this message (default)

goto :eof

rem  ------------------------------------------------------------------------
