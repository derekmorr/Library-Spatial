@echo off
setlocal

set Toolkit=dist\clients

set LibraryVer=0.84
set LibraryFileName=LSML-%LibraryVer%.zip
set LibraryURL=http://landis-spatial.googlecode.com/files/%LibraryFileName%

set ExpectedSHA1=4313ba2d477895803a84300f4d4a10a075f1e069
set TestDir=test output
set LibraryPackage=%TestDir%\%LibraryFileName%

set UnpackedItem=Landis.SpatialModeling.dll

if "%~1" == "--clean-pkg"  call :cleanPkg
if "%~1" == "--clean-dist" call :cleanDist

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

goto :eof

rem  ------------------------------------------------------------------------

:cleanDist

rem  Remove the files that are downloaded during the toolkit's initialization.

for %%F in ("%Toolkit%\*.txt") do (
  echo Deleting %%F ...
  del "%%F"
)
for %%F in ("%Toolkit%\*.exe") do (
  if not "%%~nF" == "Landis.Tools.DownloadFile" (
    echo Deleting %%F ...
    del "%%F"
  )
)

goto :eof
