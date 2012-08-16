@echo off

setlocal
set Bits=%1

rem Assume working directory is {ProjectRoot}\external\gdal\packages\win\{#ofBits}
set ExternalDir=..\..\..\..
set InfoZipDir=%ExternalDir%\Info-ZIP
set ProjectRoot=%ExternalDir%\..

set GdalPackageSite=http://www.gisinternals.com/sdk
if %Bits% == 32 set PackageBitId=
if %Bits% == 64 set PackageBitId=-x64
set GdalPackageName=release-1500%PackageBitId%-gdal-1-9-0-mapserver-6-0-1.zip
set GdalPackageUrl=%GdalPackageSite%/Download.aspx?file=%GdalPackageName%
set DownloadDir=download
set DownloadedPackage=%DownloadDir%\%GdalPackageName%

set DistributionDir=dist
set ZipFile=gdal-1-9-0-csharp-win%Bits%.zip

set DownloadTool=%ProjectRoot%\tools\current\Landis.Tools.DownloadFile.exe
set UnzipTool=%InfoZipDir%\unzip.exe
set ZipTool=%InfoZipDir%\zip.exe

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

set ManagedLibsDir=%DistributionDir%\managed
if not exist %ManagedLibsDir% (
  echo Making directory "%ManagedLibsDir%" ...
  mkdir %ManagedLibsDir%
)

set CSharpDir=%DownloadDir%\bin\gdal\csharp
if exist %ManagedLibsDir%\gdal_csharp.dll (
  echo C# bindings have already been copied to %DistributionDir% folder. 
) else (
  echo Copying managed libs of C# bindings to %ManagedLibsDir%\ ...
  xcopy %CSharpDir%\*_csharp.dll %ManagedLibsDir%
  echo Copying native libs of C# bindings to %NativeLibsDir%\ ...
  xcopy %CSharpDir%\*_wrap.dll %NativeLibsDir%
)

set VC90CrtDir=%ManagedLibsDir%\Microsoft.VC90.CRT
if not exist %VC90CrtDir% (
  echo Making directory "%VC90CrtDir%" ...
  mkdir %VC90CrtDir%
)
set VC90CrtZip=Microsoft.VC90.CRT.zip
if exist %VC90CrtDir%\msvcr90.dll (
  echo %VC90CrtZip% already unpacked into %ManagedLibsDir% folder.
) else (
  echo Extracting %VC90CrtZip% into %ManagedLibsDir%\ ...
  %UnzipTool% %VC90CrtZip% -d %ManagedLibsDir%
)

goto :eof

rem --------------------------------------------------------------------------

:zipfile

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
