@echo off
setlocal EnableDelayedExpansion

rem --- --------------------------------------------------------------
rem ---
rem --- If the initial setup was aborted or the server does not start
rem --- upon execution of this script, please remove the folder
rem --- 'crmp-solution-webapp-integrationtest' below this script directory and re-
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
echo ----------------------------------------------------------------------------------
echo    ACTICO CRMP - Solution Web Application - Evaluation bundle start script
echo ----------------------------------------------------------------------------------
echo.

java --version

echo.

pushd "%SCRIPT_DIR%"

echo Starting evaluation bundle component: 'ACTICO CRMP Solution Web Application'
echo.


rem --- illegal characters in path check
set ILLEGAL_PATH_CHARACTERS=" ","(",")"
set "ILLEGAL_CHARACTERS_USED="
(for %%I in (%ILLEGAL_PATH_CHARACTERS%) do (
   echo "%~dp0"| findstr /r /c:%%I > nul && set ILLEGAL_CHARACTERS_USED=!ILLEGAL_CHARACTERS_USED!%%I,
))
if defined ILLEGAL_CHARACTERS_USED goto errorPathContainsIllegalCharacters
call :reset_errorlevel


if not exist "crmp-solution-webapp-integrationtest" (
    echo Detected first start; about to unzip and launch ACTICO CRMP Solution Web Application...
    echo.

    mkdir crmp-solution-webapp-integrationtest
    pushd crmp-solution-webapp-integrationtest
       jar --verbose --extract --file ..\..\install\financial-spreading-platform-webapp*.zip
    echo.
    popd
    
    pushd crmp-solution-webapp-integrationtest\config\lib
       copy ..\..\..\..\misc\crmp-dbmodel-*.jar .
    popd

    mkdir crmp-solution-webapp-integrationtest\import
    pushd crmp-solution-webapp-integrationtest\import
       jar --verbose --extract --file ..\..\..\misc\crmp-add-ons*.zip
    popd
	
	pushd crmp-solution-webapp-integrationtest\import
       copy ..\..\..\install\crmp-module-releases\*.zip
    popd
)

echo Launching CRMP Solution Web Application...

set "CRMP_SOLUTION_WEBAPP_CMD=cd %SCRIPT_DIR%crmp-solution-webapp-integrationtest\bin\windows"
set "CRMP_SOLUTION_WEBAPP_CMD=%CRMP_SOLUTION_WEBAPP_CMD% & start-app.bat"

start "Workplace" cmd.exe /K "color 2f & %CRMP_SOLUTION_WEBAPP_CMD%"

echo Launching CRMP Solution Platform Web Application... done!

goto :end


:reset_errorlevel
exit /b 0


:errorPathContainsIllegalCharacters
echo         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo         ~  ERROR - ACTICO CRMP Solution - Evaluation bundle start script
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
