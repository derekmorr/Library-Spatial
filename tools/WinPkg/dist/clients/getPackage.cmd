@echo off
setlocal

call :processArgs %*
if not "%ArgError%" == "" exit /b 1 

call :initToolkit

rem  If the directory where the package will be downloaded to doesn't exist,
rem  make it.
if not exist "%PackageDir%" (
  echo Making directory %PackageDir% ...
  mkdir "%PackageDir%"
)

rem  Download the package if it doesn't exist on the local filesystem.
if exist "%PackagePath%" (
  echo %PackagePath% already downloaded.
) else (
  echo Downloading %PackagePath% ...
  "%DownloadTool%" %PackageUrl% "%PackagePath%"
  call :checksum "%PackagePath%" %ExpectedSHA1%
  if errorlevel 1 goto :eof
)

rem  Unzip the package file if the sentinel file doesn't exist.
if exist "%PackageDir%\%UnpackedFile%" (
  echo %PackagePath% has already been unpacked.
) else (
  pushd "%PackageDir%"
  echo Unpacking %PackagePath% ...
  "%UnZipTool%" "%PackageName%"
  popd
)
goto :eof

rem -------------------------------------------------------------------------

:processArgs

set ArgError=

if "%~1" == "" (
  set ArgError=Missing PackageURL
  goto usageError
)
set PackageURL=%~1

if "%~2" == "" (
  set ArgError=Missing PackagePath
  goto usageError
)
set PackagePath=%~2
set PackageDir=%~dp2
set PackageName=%~nx2

if "%~3" == "" (
  set ArgError=Missing ExpectedSHA1
  goto usageError
)
set ExpectedSHA1=%~3

if "%~4" == "" (
  set ArgError=Missing UnpackedFile
  goto usageError
)
set UnpackedFile=%~4

goto :eof

rem -------------------------------------------------------------------------

:usageError

echo Error: %ArgError%
echo Usage: %~nx0 PackageURL PackagePath ExpectedSHA1 UnpackedFile

goto :eof

rem -------------------------------------------------------------------------

:initToolkit

rem  Initialize the toolkit if environment variables aren't set
set MissingVar=no
if "%WinPkgTools%"  == "" set MissingVar=yes
if "%DownloadTool%" == "" set MissingVar=yes
if "%ChecksumTool%" == "" set MissingVar=yes
if "%UnzipTool%"    == "" set MissingVar=yes

if "%MissingVar%" == "no" goto :eof

set ToolkitDir=%~dp0
rem  Remove trailing backslash
set ToolkitDir=%ToolkitDir:~0,-1%

call "%ToolkitDir%\initialize.cmd"
goto :eof

rem -------------------------------------------------------------------------

:checksum

set FileToCheck=%~1
set ExpectedChecksum=%~2

echo Verifying checksum of %FileToCheck% ...
"%ChecksumTool%" -a SHA1 -c %ExpectedSHA1% -q "%FileToCheck%"
if %ERRORLEVEL% == -1 (
  echo ERROR: Invalid checksum
  exit /b 1
)

goto :eof

rem -------------------------------------------------------------------------
