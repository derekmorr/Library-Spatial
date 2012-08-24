@echo off

setlocal
set Script=%~nx0
call %~dp0\_package-util.cmd %*
if errorlevel 1 exit /b 1

if not exist %ZipFile% (
  echo Error: The file %ZipFile% does not exist; run make-package.cmd first.
  exit /b 1
)

rem  Get the name of installation dir used in the GDAL-admin.cmd script
set GdalAdmin=%GdalDir%\GDAL-admin.cmd
for /f "tokens=2 delims==" %%D in ('find "GdalAdmin_InstallDir" %GdalAdmin%') do (
  set GdalAdmin_InstallDir=%%D
)
set InstallDir=%GdalDir%\%GdalAdmin_InstallDir%

if exist %InstallDir%\managed (
  echo GDAL libraries and C# bindings are already installed in %InstallDir%\
  goto :eof
)

if not exist %InstallDir% (
  echo Making directory %InstallDir%\
  mkdir %InstallDir%
)
echo Unzipping %ZipFile% into %InstallDir%
%UnzipTool% %ZipFile% -d%InstallDir%

goto :eof
