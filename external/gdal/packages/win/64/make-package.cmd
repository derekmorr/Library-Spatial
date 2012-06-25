@echo off

setlocal
set GdalPackageSite=http://www.gisinternals.com/sdk
set GdalPackageName=release-1500-x64-gdal-1-9-0-mapserver-6-0-1.zip
set GdalPackageUrl=%GdalPackageSite%/Download.aspx?file=%GdalPackageName%
set DownloadDir=download
set DownloadedPackage=%DownloadDir%\%GdalPackageName%
set DistributionDir=dist
set ZipFile=gdal-1-9-0-csharp-win64.zip
set InfoZipDir=..\..\..\..\Info-ZIP
set UnzipTool=%InfoZipDir%\unzip.exe

call :download
call :extract
call :copySelect
call :zipfile

goto :eof

rem --------------------------------------------------------------------------

:download
if exist %DownloadedPackage% (
  echo GDAL package already downloaded to:
  echo   %DownloadedPackage%
  goto :eof
)

if not exist %DownloadDir% (
  echo Making directory "%DownloadDir%" ...
  mkdir %DownloadDir%
)

echo Downloading %GdalPackageName% ...
set DownloadTool=..\..\..\..\..\tools\current\Landis.Tools.DownloadFile.exe
%DownloadTool% %GdalPackageUrl% %DownloadedPackage%
goto :eof

rem --------------------------------------------------------------------------

:extract

if not exist %DownloadedPackage% (
  echo Error: Missing GDAL package:
  echo   %DownloadedPackage%
  exit /b 1
)

if exist %DownloadDir%\bin (
  echo GDAL files already extracted from downloaded package.
  goto :eof
)

echo Extracting files from GDAL package ...
%UnzipTool% %DownloadedPackage% -d %DownloadDir%
goto :eof

rem --------------------------------------------------------------------------

:copySelect

if not exist %DistributionDir% (
  echo Making directory "%DistributionDir%" ...
  mkdir %DistributionDir%
)

set NativeLibsDir=%DistributionDir%\native
if not exist %NativeLibsDir% (
  echo Making directory "%NativeLibsDir%" ...
  mkdir %NativeLibsDir%
)

set NativeLibsCopied=no
for %%I in (%DownloadDir%\bin\*.dll) do (
  if not exist %NativeLibsDir%\%%~nxI (
    echo Copying %%I to %NativeLibsDir%\ ...
    copy %%I %NativeLibsDir%\%%~nxI
    set NativeLibsCopied=yes
  )
)
if "%NativeLibsCopied%" == "no" (
  echo GDAL libraries have already been copied to %NativeLibsDir% folder. 
)

set CSharpDir=%DownloadDir%\bin\gdal\csharp
if exist %DistributionDir%\gdal_csharp.dll (
  echo C# bindings have already been copied to %DistributionDir% folder. 
) else (
  echo Copying C# bindings to %DistributionDir%\ ...
  xcopy %CSharpDir%\*_csharp.dll %DistributionDir%
  xcopy %CSharpDir%\*_wrap.dll %NativeLibsDir%
)

set VC90CrtDir=%NativeLibsDir%\Microsoft.VC90.CRT
if not exist %VC90CrtDir% (
  echo Making directory "%VC90CrtDir%" ...
  mkdir %VC90CrtDir%
)
set VC90CrtZip=Microsoft.VC90.CRT.zip
if exist %VC90CrtDir%\msvcr90.dll (
  echo %VC90CrtZip% already unpacked into %NativeLibsDir% folder.
) else (
  echo Extracting %VC90CrtZip% into %NativeLibsDir%\ ...
  %UnzipTool% %VC90CrtZip% -d %NativeLibsDir%
)

goto :eof

rem --------------------------------------------------------------------------

:zipfile

set ZipTool=%InfoZipDir%\zip.exe
if exist %ZipFile% (
  echo %ZipFile% already exists.
) else (
  echo Creating %ZipFile% ...
  pushd %DistributionDir%
  ..\%ZipTool% -r ..\%ZipFile% .
  popd
)

goto :eof

rem --------------------------------------------------------------------------
