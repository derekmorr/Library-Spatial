@echo off

setlocal
set BuildDir=build
set ZipFile=%BuildDir%\tools.zip
set ChecksumLicense=%BuildDir%\checksum-LICENSE.txt
set InfoZipLicense=%BuildDir%\Info-ZIP-LICENSE.txt

set DistributionDir=dist
set SelfExtractingExe=%DistributionDir%\WinPkgTools-setup.exe

if "%1" == "" goto makeExe
if "%1" == "zip" goto makeZip
if "%1" == "clean" goto :clean
if "%1" == "help" goto :help
if "%1" == "/?" goto :help

echo Error: Unknown argument "%1"

:help
echo Usage: %~nx0
echo        %~nx0 zip
echo        %~nx0 clean
goto :eof

rem ------------------------------------------------------------

:makeZip

call :makeDir %BuildDir%

set ChecksumDir=..\..\external\checksum
if not exist %ChecksumLicense% (
  echo Copying checksum license into "%ChecksumLicense%" ...
  copy %ChecksumDir%\LICENSE.txt %ChecksumLicense%
)

set InfoZipDir=..\..\external\Info-ZIP
if not exist %InfoZipLicense% (
  echo Copying Info-ZIP license into "%InfoZipLicense%" ...
  copy %InfoZipDir%\LICENSE.txt %InfoZipLicense%
)

set ZipExe=%InfoZipDir%\zip.exe
set UnZipExe=%InfoZipDir%\unzip.exe
set UnZipSFX=%InfoZipDir%\unzipsfx.exe
set DownloadTool=..\current\Landis.Tools.DownloadFile.exe
set ChecksumExe=%ChecksumDir%\checksum.exe

if exist %ZipFile% (
  echo %ZipFile% already exists
  goto :eof
)
echo Packaging tools into "%ZipFile%" ...
%ZipExe% -j -9 %ZipFile% README.txt %DownloadTool% %UnZipExe% %ChecksumExe% %InfoZipLicense% %ChecksumLicense%

goto :eof

rem ------------------------------------------------------------

:makeExe

if exist %SelfExtractingExe% (
  echo %SelfExtractingExe% already exists
  goto :eof
)

if not exist %ZipFile% call :makeZip
call :makeDir %DistributionDir%

echo Making self-extracting executable "%SelfExtractingExe%" ...
copy /b %UnZipSFX%+%ZipFile% %SelfExtractingExe%

rem %ZipExe% -A %SelfExtractingExe%
rem -------------------------------
rem The line above is commented out because it reports an error:
rem
rem   zip warning: central dir not where expected - could not adjust offsets
rem   zip warning: (try -FF)
rem
rem zip error: Zip file structure invalid 
rem
rem Following the advice of using -FF unfortunately strips off unzipsfx.exe
rem from the file.  But the self-extracting executable without adjusted
rem offsets works fine.

goto :eof

rem ------------------------------------------------------------

:clean

set FilesDeleted=no
call :deleteIfExists %ChecksumLicense%
call :deleteIfExists %InfoZipLicense%
call :deleteIfExists %ZipFile%
call :deleteIfExists %SelfExtractingExe%
if "%FilesDeleted%" == "no" (
  echo No files to be deleted
)
goto :eof

rem ------------------------------------------------------------
rem Make a directory if it doesn't exist

:makeDir

if not exist %1 (
  echo Making directory "%1" ...
  mkdir %1
)
goto :eof

rem ------------------------------------------------------------
rem Delete a file if it exists.  Sets FilesDeleted=yes if the
rem is deleted.

:deleteIfExists

if exist %1 (
  echo Deleting "%1" ...
  del %1
  set FilesDeleted=yes
)
goto :eof

rem ------------------------------------------------------------
