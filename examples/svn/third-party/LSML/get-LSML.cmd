@echo off

rem  Run this script in the directory where it's located
pushd %~dp0
setlocal

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
