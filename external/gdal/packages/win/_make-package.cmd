@echo off

setlocal
if "%~1" == "" (
  echo Error: The script %~nx0 called without bits argument
  exit /b 1
)
set Bits=%1

rem Assume working directory is {ProjectRoot}\external\gdal\packages\win\{#ofBits}
set GdalDir=..\..\..
set ExternalDir=%GdalDir%\..
set InfoZipDir=%ExternalDir%\Info-ZIP
set ProjectRoot=%ExternalDir%\..

rem Get GDAL version in "#-#-#" format
for /f %%v in (%GdalDir%\version.txt) do set GdalVersion=%%v
set GdalVersion=%GdalVersion:.=-%
echo GDAL version %GdalVersion%

rem Get the MapServer version that's distributed with that GDAL version
rem at www.gisinternals.com
for /f "tokens=1,2" %%g in (..\gdal-mapserver-versions.txt) do (
  if "%%g" == "%GdalVersion%" set MapServerVersion=%%h
)
if "%MapServerVersion%" == "" (
  echo Error: No MapServer version associated with that GDAL version
  exit /b 1
)
set MapServerVersion=%MapServerVersion:.=-%
echo MapServer version %MapServerVersion%

set GdalPackageSite=http://www.gisinternals.com/sdk
if %Bits% == 32 set PackageBitId=
if %Bits% == 64 set PackageBitId=-x64
set GdalPackageName=release-1500%PackageBitId%-gdal-%GdalVersion%-mapserver-%MapServerVersion%.zip
set GdalPackageUrl=%GdalPackageSite%/Download.aspx?file=%GdalPackageName%
set DownloadDir=download
set DownloadedPackage=%DownloadDir%\%GdalPackageName%

set DistributionDir=dist
set ZipFile=gdal-%GdalVersion%-csharp-win%Bits%.zip

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

set ReadMe=%DistributionDir%\README.txt
set ReadMeTemplate=%GdalDir%\packages\README-template.txt
if exist %ReadMe% goto :nativeLibs

echo Creating %ReadMe% ...
for /f "tokens=*" %%L in (%ReadMeTemplate%) do (
  if "%%L" == "GDAL @VERSION@" (
    rem Blank line in template is ignored by "for" command, so add it back in
    echo. >> %ReadMe%
  )
  call :templateLine "%%L" %ReadMe%
)

:nativeLibs

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

:templateLine

set TemplateLine=%~1
set OutputFile=%2

for /f "tokens=1,2* delims=@" %%x in ("%TemplateLine%") do (
  set BeforeVar=%%x
  set VarName=%%y
  set AfterVar=%%z
)

rem By default, output the template line as is (for the cases where there is
rem no variable name or the name is unknown)
set OutputLine=%TemplateLine%

if "%VarName%" == "VERSION"  set VarValue=%GdalVersion:-=.%
if "%VarName%" == "PLATFORM" set VarValue=%Bits%-bit Windows
if "%VarName%" == "COMPILER" set VarValue=MSVC 2008

if not "%VarValue%" == "" set OutputLine=%BeforeVar%%VarValue%%AfterVar%

echo %OutputLine% >> %OutputFile%

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
