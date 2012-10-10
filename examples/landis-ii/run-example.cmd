@echo off

setlocal
set SCRIPT_DIR=%~dp0
set PROJECT_ROOT=%SCRIPT_DIR:\examples\landis-ii\=%

if "%1" == "debug" goto checkEnvVar
if "%1" == "release" goto checkEnvVar
if "%1" == "" (
  echo Error: No configuration specified
) else (
  echo Error: Unknown configuration: %1
)
echo Usage: %0 debug^|release
goto :eof

rem -----------------------------------------------------------------

:checkEnvVar
if not "%GDAL_BIN_DIR%" == "" goto envVarSet
set GDAL_BIN_DIR=%PROJECT_ROOT%\external\gdal\libs\native
echo GDAL_BIN_DIR environment variable is not set; using default:
echo    %GDAL_BIN_DIR%

:envVarSet
if not exist "%GDAL_BIN_DIR%" (
  echo Error: GDAL_BIN_DIR environment variable refers to non-existant directory
  goto :eof
)
if not exist "%GDAL_BIN_DIR%"\ (
  echo Error: GDAL_BIN_DIR environment variable refers to a file
  goto :eof
)

echo Adding GDAL_BIN_DIR to PATH...
echo.
set PATH_SAVE=%PATH%
PATH %GDAL_BIN_DIR%;%PATH%

set CONFIG_DIR=%PROJECT_ROOT%\build\%~1
set EXE_PATH=%CONFIG_DIR%\LandisII.Examples.Console.exe
"%EXE_PATH%"

echo.
echo Restoring PATH...
PATH %PATH_SAVE%
