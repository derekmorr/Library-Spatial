@echo off

rem  Run this script in its folder
pushd %~dp0

setlocal
set ScriptURL=$HeadURL$
rem  Remove leading and trailing delimiters of svn keyword from the URL
set ScriptURL=%ScriptURL:$HeadURL: =%
set ScriptURL=%ScriptURL: $=%

set ToolkitRootURL=%ScriptURL:/clients/get-tools.cmd=%
set DownloadURL=%ToolkitRootURL%/download

call :getFile checksum.exe
call :getFile checksum-LICENSE.txt
call :getFile unzip.exe
call :getFile Info-ZIP-LICENSE.txt

popd
goto :eof

rem  -------------------------------------------------------------------------

:getFile

set FileName=%1
if exist %FileName% (
  echo %FileName% already downloaded
  goto :eof
)
echo Downloading %FileName% ...
.\Landis.Tools.DownloadFile.exe %DownloadURL%/%FileName% %FileName%
goto :eof

rem  -------------------------------------------------------------------------
