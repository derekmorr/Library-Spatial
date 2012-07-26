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

call :isFileCurrent %DownloadTool% ..\current\Landis.Tools.DownloadFile.exe
if "%IsFileCurrent%" == "no" (
  echo Copying DownloadFile tool to "%DownloadTool% ...
  copy /y ..\current\Landis.Tools.DownloadFile.exe %DownloadTool%
)

set ChecksumDir=..\..\external\checksum
call :isFileCurrent %ChecksumTool% %ChecksumDir%\checksum.exe
if "%IsFileCurrent%" == "no" (
  echo Copying checksum tool to "%ChecksumTool% ...
  copy /y %ChecksumDir%\checksum.exe %ChecksumTool%
)
call :isFileCurrent %ChecksumLicense% %ChecksumDir%\LICENSE.txt
if "%IsFileCurrent%" == "no" (
  echo Copying checksum license into "%ChecksumLicense%" ...
  copy /y %ChecksumDir%\LICENSE.txt %ChecksumLicense%
)

set InfoZipDir=..\..\external\Info-ZIP
call :isFileCurrent %UnzipTool% %InfoZipDir%\unzip.exe
if "%IsFileCurrent%" == "no" (
  echo Copying unzip tool to "%UnzipTool%" ...
  copy /y %InfoZipDir%\unzip.exe %UnzipTool%
)
call :isFileCurrent %InfoZipLicense% %InfoZipDir%\LICENSE.txt
if "%IsFileCurrent%" == "no" (
  echo Copying Info-ZIP license into "%InfoZipLicense%" ...
  copy /y %InfoZipDir%\LICENSE.txt %InfoZipLicense%
)

goto :eof

rem ------------------------------------------------------------

:isFileCurrent

set File=%1
set Source=%2

if not exist %File% goto notCurrent
fc /b %File% %Source% > nul
if errorlevel 1 goto notCurrent
set IsFileCurrent=yes
goto :eof

:notCurrent
set IsFileCurrent=no
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
