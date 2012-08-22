@echo off
setlocal

set Toolkit=dist\clients

set LibraryVer=0.84
set LibraryFileName=LSML-%LibraryVer%.zip
set LibraryURL=http://landis-spatial.googlecode.com/files/%LibraryFileName%

set ExpectedSHA1=4313ba2d477895803a84300f4d4a10a075f1e069
set TestDir=test output
set LibraryPackage=%TestDir%\%LibraryFileName%

set UnpackedItem=%TestDir%\contents\Landis.SpatialModeling.dll

:processArgs

if "%~1" == "" goto :getPkg
if "%~1" == "--clean-pkg" (
  call :cleanPkg
  shift
  goto :processArgs
)
if "%~1" == "--clean-dist" (
  call :cleanDist
  shift
  goto :processArgs
)

echo Error: Unknown argument: "%~1"
echo Usage: %~0 [--clean-dist] [--clean-pkg]
exit /b 1

rem  ------------------------------------------------------------------------

:getPkg

call %Toolkit%\getPackage.cmd %LibraryURL% "%LibraryPackage%" %ExpectedSHA1% "%UnpackedItem%"

goto :eof

rem  ------------------------------------------------------------------------

:cleanPkg

rem  Remove the test package that was downloaded and any unpacked files

if exist "%LibraryPackage%" (
  echo Deleting %LibraryPackage% ...
  del "%LibraryPackage%"
)
for %%F in ("%TestDir%\*") do (
  echo Deleting %%F ...
  del "%%F"
)
for /d %%D in ("%TestDir%\*") do (
  echo Deleting %%D\ ...
  rmdir /s /q "%%D"
)

goto :eof

rem  ------------------------------------------------------------------------

:cleanDist

rem  Remove the files that are downloaded during the toolkit's initialization.

call "%Toolkit%\clean.cmd"
goto :eof
