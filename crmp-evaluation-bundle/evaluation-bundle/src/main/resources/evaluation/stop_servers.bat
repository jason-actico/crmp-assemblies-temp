@echo off

rem --- Make sure correct code page is set in order to display special characters correctly
cmd.exe /c chcp 1252 >nul

set "SCRIPT_DIR=%~dp0"
set "ORIG_PATH=%PATH%"
set "JAVA_HOME=%SCRIPT_DIR%\java"
set "PATH=%JAVA_HOME%\bin;%PATH%"

echo.
echo ---------------------------------------------------------------------------------------------------------------
echo    ACTICO CRMP - Evaluation bundle stop script
echo ---------------------------------------------------------------------------------------------------------------
echo.

java --version

echo.

pushd "%SCRIPT_DIR%"

rem ------ START: Model Hub ------
if exist "actico-model-hub" (
    echo Stopping evaluation bundle component: 'ACTICO Model Hub'
    echo.

    echo Stopping Model Hub...

    start "Model Hub" cmd.exe /C "color 6f & cd %SCRIPT_DIR%actico-model-hub\bin\windows & stop-app.bat"

    echo Stopping Model Hub... done!
    echo.
)
rem ------ END: Model Hub ------

rem ------ START: CRMP Solution Platform Web Application ------
if exist "crmp-solution-webapp" (
    echo Stopping evaluation bundle component: 'ACTICO CRMP Solution Web Application'
    echo.

    echo Stopping CRMP Solution Web Application...

    start "CRMP Solution Web Application" cmd.exe /C "color 2f & cd %SCRIPT_DIR%crmp-solution-webapp\bin\windows & stop-app.bat"

    echo Stopping CRMP Solution Web Application... done!
    echo.
)
rem ------ END: CRMP Solution Web Application ------

rem ------ START: CRMP Solution Web Application Integrationtest------
if exist "crmp-solution-webapp-integrationtest" (
    echo Stopping evaluation bundle component: 'ACTICO CRMP Solution Web Application Integrationtests'
    echo.

    echo Stopping CRMP Solution Web Application Integrationtest...

    start "CRMP Solution Web Application Integrationtest" cmd.exe /C "color 2f & cd %SCRIPT_DIR%crmp-solution-webapp-integrationtest\bin\windows & stop-app.bat"

    echo Stopping CRMP Solution Web Application Integrationtest... done!
    echo.
)
rem ------ END: CRMP Solution Web Application ------

rem ------ START: CRMP Batch Application ------
if exist "crmp-solution-batch-application-integrationtest" (
    echo Stopping evaluation bundle component: 'ACTICO CRMP Batch Application'
    echo.

    echo Stopping CRMP Batch Application...

    start "CRMP Batch Application" cmd.exe /C "color 4f & cd %SCRIPT_DIR%crmp-solution-batch-application\bin\windows & stop-app.bat"

    echo Stopping CRMP Batch Application... done!
    echo.
)
rem ------ END: CRMP Batch Application ------

rem ------ START: CRMP Batch Application Integrationtest------
if exist "crmp-solution-batch-application" (
    echo Stopping evaluation bundle component: 'ACTICO CRMP Batch Application'
    echo.

    echo Stopping CRMP Batch Application Integrationtest...

    start "CRMP Batch Application Integrationtest" cmd.exe /C "color 4f & cd %SCRIPT_DIR%crmp-solution-batch-application\bin\windows & stop-app.bat"

    echo Stopping CRMP Batch Application Integrationtest... done!
    echo.
)
rem ------ END: CRMP Batch Application Integrationtest------

popd
set "PATH=%ORIG_PATH%"
@echo on
