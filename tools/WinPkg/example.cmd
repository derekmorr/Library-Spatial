@echo off
rem An example of how to retrieve and setup the tools.

rem The version of the tools to retrieve.
set ToolsVer=1.0

rem Folder for the retrieved tools.
set ToolsDir=download

.\get-WinPkgTools %ToolsVer% %ToolsDir%

rem Now use the tools...
rem
rem   set DownloadTool=%ToolsDir%\Landis.Tools.DownloadFile.exe
rem   set ChecksumTool=%ToolsDir%\checksum.exe
rem   set UnZipTool=%ToolsDir%\unzip.exe
rem
rem   echo Downloading a big file.zip ...
rem   %DownloadTool% http://www.example.com/some/big/file.zip big-file.zip
rem
rem   echo Verifying checksum ...
rem   set BigFileSHA1=0102030405060708090A0B0C0D0E0F0123456789
rem   %ChecksumTool% -a SHA1 -c %BigFileSHA1% -q big-file.zip
rem   if %ERRORLEVEL% == -1 goto :badChecksum
rem
rem   echo Unpacking file.zip ...
rem   %UnZipTool% OPTION ... big-file.zip FILE ...
