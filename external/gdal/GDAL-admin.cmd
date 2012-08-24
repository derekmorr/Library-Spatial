@echo off
setlocal

call ..\..\tools\WinPkg\dist\clients\initialize.cmd
call ..\..\dist\GDAL-admin.cmd %*
