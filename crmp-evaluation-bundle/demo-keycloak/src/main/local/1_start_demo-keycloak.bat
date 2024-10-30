@echo off
setlocal EnableDelayedExpansion

set "SCRIPT_DIR=%~dp0"
set "DEMO_KEYCLOAK_DIR=%SCRIPT_DIR%demo-keycloak"

set "KEYCLOAK_ADMIN=admin"
set "KEYCLOAK_ADMIN_PASSWORD=admin"
set "JAVA_HOME=%SCRIPT_DIR%\java"
set "PATH=%JAVA_HOME%\bin;%PATH%"

pushd "%DEMO_KEYCLOAK_DIR%"

if not exist "downloads/*.zip" (
    echo Keycloak download not found.
    echo Please download keycloak from https://github.com/keycloak/keycloak/releases/download/@keycloak-version@/keycloak-@keycloak-version@.zip
    echo and save it in the folder 'demo-keycloak\downloads' with the name 'keycloak-@keycloak-version@.zip'
    pause
    goto :end
)

java --version

if not exist "keycloak/" (
    echo Extracting Keycloak ZIP, please wait.
    mkdir keycloak
    pushd keycloak
    jar -xf ..\downloads\keycloak-@keycloak-version@.zip
    popd
)

SET KEYCLOAK_HOME=%DEMO_KEYCLOAK_DIR%\keycloak\keycloak-@keycloak-version@
SET KEYCLOAK_BIN=%KEYCLOAK_HOME%\bin

REM Keycloak Admin credentials
SET KEYCLOAK_ADMIN=admin
SET KEYCLOAK_ADMIN_PASSWORD=admin

SET "KEYCLOAK_CMD=CALL %KEYCLOAK_BIN%\kc.bat import --dir .\actico-realm --override false"

XCOPY %DEMO_KEYCLOAK_DIR%\actico-platform-theme %DEMO_KEYCLOAK_DIR%\keycloak\keycloak-@keycloak-version@\themes\actico-platform-theme\ /E /Y

SET "KEYCLOAK_CMD=%KEYCLOAK_CMD% & %KEYCLOAK_BIN%\kc.bat start-dev --http-port=7554"

start "Demo Keycloak" cmd.exe /K "color 9f & %KEYCLOAK_CMD%"

echo Launching Demo Keycloak... done!

goto end

:end
echo.
popd
@echo on
