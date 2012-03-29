@echo off

set SCRIPT_DIR=%~dp0

set MSI_FILE=MSBuild.Community.Tasks.msi
set MSI_PATH=%SCRIPT_DIR%%MSI_FILE%
if not exist "%MSI_PATH%" goto no_msi

set MSI_DIR_NAME=%MSI_FILE:.msi=%
set MSI_DIR_PATH=%SCRIPT_DIR%%MSI_DIR_NAME%
if exist "%MSI_DIR_PATH%" (
  echo "%MSI_FILE%" already unpacked into "%MSI_DIR_NAME%/"
) else (
  echo Unpacking "%MSI_FILE%" into "%MSI_DIR_NAME%/" ...
  cd "%SCRIPT_DIR%"
  msiexec /qb /a %MSI_FILE% TARGETDIR=%MSI_DIR_PATH%
)

set MSI_DLL_FOLDER=%MSI_DIR_NAME%\MSBuild\MSBuildCommunityTasks
echo.
echo MSI_DLL_FOLDER = %MSI_DLL_FOLDER%

call :copy_file MSBuild.Community.Tasks.dll
call :copy_file ICSharpCode.SharpZipLib.dll

goto :script_end

::-------------------------------------------------------------------

:: Copy the file named %1 from the folder with *.dll files from .msi
:: file (%MSI_DLL_FOLDER%) into folder with this script if the named
:: file does not exist already, or if its contents are different.
:copy_file
set FILE_NAME=%1
set TARGET_PATH=%SCRIPT_DIR%%FILE_NAME%
set SOURCE_PATH=%SCRIPT_DIR%%MSI_DLL_FOLDER%\%FILE_NAME%
set COPY_FILE=no
echo.
if not exist "%TARGET_PATH%" (
  echo "%FILE_NAME%" does not exist
  set COPY_FILE=yes
) else (
  echo Comparing "%FILE_NAME%" with file in MSI_DLL_FOLDER\ ...
  fc /b %TARGET_PATH% %SOURCE_PATH% > nul
  if errorlevel 1 (
    echo ... files differ
    set COPY_FILE=yes
  ) else (
    echo ... files are the same
  )
)
if "%COPY_FILE%" == "yes" (
  echo Copying "%FILE_NAME%" from MSI_DLL_FOLDER\ ...
  copy /y /b %SOURCE_PATH% %TARGET_PATH%
)
goto :eof

::-------------------------------------------------------------------

:no_msi
echo Error: There is no file named "%MSI_FILE%" in the
echo        folder "%SCRIPT_DIR%".
goto :script_end

::-------------------------------------------------------------------

:script_end
echo.
pause
