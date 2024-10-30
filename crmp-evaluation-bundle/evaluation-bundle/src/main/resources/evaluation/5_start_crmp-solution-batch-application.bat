@echo off
setlocal EnableDelayedExpansion

rem --- --------------------------------------------------------------
rem ---
rem --- If the initial setup was aborted or the server does not start
rem --- upon execution of this script, please remove the folder
rem --- 'crmp-solution-batch-application' below this script directory and re-
rem --- start the script.
rem ---
rem --- --------------------------------------------------------------

rem --- Make sure correct code page is set in order to display special characters correctly
cmd.exe /c chcp 1252 >nul

set "SCRIPT_DIR=%~dp0"
set "ORIG_PATH=%PATH%"
set "JAVA_HOME=%SCRIPT_DIR%\java"
set "PATH=%JAVA_HOME%\bin;%PATH%"

echo.
echo -----------------------------------------------------------------------------------
echo    ACTICO CRMP - Batch Application - Evaluation bundle start script
echo -----------------------------------------------------------------------------------
echo.

java --version

echo.

pushd "%SCRIPT_DIR%"

echo Starting evaluation bundle component: 'ACTICO CRMP Batch Application'
echo.

set ILLEGAL_PATH_CHARACTERS=" ","(",")"
set "ILLEGAL_CHARACTERS_USED="
(for %%I in (%ILLEGAL_PATH_CHARACTERS%) do (
   echo "%~dp0"| findstr /r /c:%%I > nul && set ILLEGAL_CHARACTERS_USED=!ILLEGAL_CHARACTERS_USED!%%I,
))
if defined ILLEGAL_CHARACTERS_USED goto errorPathSpecialCharacters
call :reset_errorlevel


if not exist "crmp-solution-batch-application" (
    echo Detected first start of CRMP evaluation; about to unzip and launch ACTICO CRMP Batch Application...
    echo.

    mkdir crmp-solution-batch-application
    pushd crmp-solution-batch-application
       jar --verbose --extract --file ..\..\install\financial-spreading-platform-batch-application*.zip
    echo.
    popd
)

echo Launching CRMP Solution Batch Application...

set "CRMP_BATCH_CMD=cd %SCRIPT_DIR%crmp-solution-batch-application\bin\windows"
set "CRMP_BATCH_CMD=%CRMP_BATCH_CMD% & start-app.bat"

start "CRMP Batch" cmd.exe /K "color 3f & %CRMP_BATCH_CMD%"

echo Launching CRMP Batch Application... done!

goto :end


:reset_errorlevel
exit /b 0


:errorPathSpecialCharacters
echo         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo         ~  ERROR - ACTICO Platform - CRMP Solution Batch - Evaluation bundle start script
echo         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo         ~  Error message : The path of the script directory contains illegal characters.
echo         ~                  The following characters may not be used:
(for %%I in (%ILLEGAL_PATH_CHARACTERS%) do (
   set I=%%I
   echo         ~                  !I:"='!
))
echo         ~                  Offending characters contained in your path:
(for %%I in (%ILLEGAL_CHARACTERS_USED:~0,-1%) do (
   set I=%%I
   echo         ~                  !I:"='!
))
echo         ~  Current path  : %~dp0
echo.
pause
goto :end


:end
echo.
popd
set "PATH=%ORIG_PATH%"
@echo on
