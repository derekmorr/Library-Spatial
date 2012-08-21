@echo off
setlocal

call ..\..\tools\WinPkg\dist\clients\initialize.cmd
call ..\..\dist\get-GDAL-Csharp.cmd %*
