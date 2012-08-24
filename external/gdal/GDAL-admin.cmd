@echo off
setlocal

call ..\..\tools\WinPkg\dist\clients\initialize.cmd

set GdalAdmin_VersionFile=version.txt
call ..\..\dist\GDAL-admin.cmd %*
