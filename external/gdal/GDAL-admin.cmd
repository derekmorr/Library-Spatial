@echo off
setlocal

call ..\..\tools\WinPkg\dist\clients\initialize.cmd

set GdalAdmin_VersionFile=version.txt
set GdalAdmin_InstallDir=libs
call ..\..\dist\GDAL-admin.cmd %*
