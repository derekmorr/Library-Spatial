@echo off

if "%~1" == "" (
  echo Error: The script %Script% called without bits argument
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

set ZipFile=gdal-%GdalVersion%-csharp-win%Bits%.zip

set UnzipTool=%InfoZipDir%\unzip.exe
