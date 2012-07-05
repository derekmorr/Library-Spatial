@echo off

setlocal
set DistributionDir=dist
set ClientsDir=%DistributionDir%\clients
set DownloadTool=%ClientsDir%\Landis.Tools.DownloadFile.exe

set DownloadDir=%DistributionDir%\download
set ChecksumTool=%DownloadDir%\checksum.exe
set ChecksumLicense=%DownloadDir%\checksum-LICENSE.txt
set UnzipTool=%DownloadDir%\unzip.exe
set InfoZipLicense=%DownloadDir%\Info-ZIP-LICENSE.txt

if "%1" == "" goto copyFiles
if "%1" == "clean" goto :clean
if "%1" == "help" goto :help
if "%1" == "/?" goto :help

echo Error: Unknown argument "%1"

:help
echo Usage: %~nx0
echo        %~nx0 clean
goto :eof

rem ------------------------------------------------------------

:copyFiles

if not exist %DownloadTool% (
  echo Copying DownloadFile tool to "%DownloadTool% ...
  copy ..\current\Landis.Tools.DownloadFile.exe %DownloadTool%
)

set ChecksumDir=..\..\external\checksum
if not exist %ChecksumTool% (
  echo Copying checksum tool to "%ChecksumTool% ...
  copy %ChecksumDir%\checksum.exe %ChecksumTool%
)
if not exist %ChecksumLicense% (
  echo Copying checksum license into "%ChecksumLicense%" ...
  copy %ChecksumDir%\LICENSE.txt %ChecksumLicense%
)

set InfoZipDir=..\..\external\Info-ZIP
if not exist %UnzipTool% (
  echo Copying unzip tool to "%UnzipTool%" ...
  copy %InfoZipDir%\unzip.exe %UnzipTool%
)
if not exist %InfoZipLicense% (
  echo Copying Info-ZIP license into "%InfoZipLicense%" ...
  copy %InfoZipDir%\LICENSE.txt %InfoZipLicense%
)

goto :eof

rem ------------------------------------------------------------

:clean

set FilesDeleted=no
call :deleteIfExists %DownloadTool%
call :deleteIfExists %ChecksumTool%
call :deleteIfExists %ChecksumLicense%
call :deleteIfExists %UnzipTool%
call :deleteIfExists %InfoZipLicense%
if "%FilesDeleted%" == "no" (
  echo No files to be deleted
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
