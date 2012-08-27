@echo off
setlocal

rem  Run this script in the directory where it's located
pushd %~dp0

call ..\..\tools\WinPkg\dist\clients\initialize.cmd

set GdalAdmin_VersionFile=version.txt
set GdalAdmin_InstallDir=libs
call ..\..\dist\GDAL-admin.cmd %*

popd
