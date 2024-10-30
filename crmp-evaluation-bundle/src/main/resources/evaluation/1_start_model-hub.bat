@echo off
setlocal EnableDelayedExpansion

rem --- --------------------------------------------------------------
rem ---
rem --- If the initial setup was aborted or the server does not start
rem --- upon execution of this script, please remove the folder
rem --- 'actico-model-hub' below this script directory and restart the
rem --- script.
rem ---
rem --- --------------------------------------------------------------

rem --- Make sure correct code page is set in order to display special characters correctly
cmd.exe /c chcp 1252 >nul

set "SCRIPT_DIR=%~dp0"
set "DISTRO_DIR=%SCRIPT_DIR%.."
set "ORIG_PATH=%PATH%"
set "JAVA_HOME=%SCRIPT_DIR%\java"
set "PATH=%JAVA_HOME%\bin;%PATH%"

set SPRING_APPLICATION_JSON_MODEL_HUB={ ^
  "actico.deployment.initial-environment.spr-demo.apiKey": "RW52aXJvbm1lbnQtc3ByLWRlbW9+Y2Y0OTNjNDg4YTU4ZGI1YzMyNTkxODdjNDNiMWI4ZTMyOTdkZGFiNzdmZmU0MDE0MThhMDE1OTZhYzBiYzZmYg==", ^
  "actico.deployment.initial-environment.spr-demo.label": "Financial Spreading Demo", ^
  "actico.deployment.initial-environment.spr-demo.color": "#562f70", ^
  "actico.deployment.initial-environment.spr-demo.revisionSafe": false, ^
  "actico.deployment.initial-environment.spr-demo.position": 1, ^
  "actico.purpose-of-usage.label": "Evaluation", ^
  "actico.purpose-of-usage.color": "#2777dc", ^
  "spring.h2.console.enabled": "true"}

echo.
echo ------------------------------------------------------------------
echo    ACTICO Platform - Model Hub - Evaluation bundle start script
echo ------------------------------------------------------------------
echo.

java --version

echo.

pushd "%SCRIPT_DIR%"

echo Starting evaluation bundle component: 'ACTICO Model Hub'
echo.


rem --- illegal characters in path check
set ILLEGAL_PATH_CHARACTERS=" ","(",")"
set "ILLEGAL_CHARACTERS_USED="
(for %%I in (%ILLEGAL_PATH_CHARACTERS%) do (
   echo "%~dp0"| findstr /r /c:%%I > nul && set ILLEGAL_CHARACTERS_USED=!ILLEGAL_CHARACTERS_USED!%%I,
))
if defined ILLEGAL_CHARACTERS_USED goto errorPathContainsIllegalCharacters
call :reset_errorlevel


if not exist "actico-model-hub" (
    echo Detected first start of Model Hub evaluation; about to unzip and launch ACTICO Model Hub...
    echo.

    mkdir actico-model-hub
    pushd actico-model-hub

    jar --verbose --extract --file ..\..\install\model-hub*.zip

    echo.
    popd
)

rem --- Copy Rules module releases to model-hub import folder
rem --- Only copy files which were not imported yet, which have a .imported suffix

echo Copying Rules releases to Model Hub import folder...
echo.
for /R %DISTRO_DIR%\install\rules-module-releases\ %%i in (*.zip) do (
    if not exist %SCRIPT_DIR%actico-model-hub\import\releases\%%~nxi.imported (
        echo Copying Rules release %%~nxi
        copy /Y %DISTRO_DIR%\install\rules-module-releases\%%~nxi %SCRIPT_DIR%actico-model-hub\import\releases\%%~nxi
        echo.
    ) else (
        echo Rules release %%~nxi was already imported
    )
)
echo.


rem --- Copy Workplace module releases to model-hub import folder
rem --- Only copy files which were not imported yet, which have a .imported suffix

echo Copying Workplace releases to Model Hub import folder...
echo.
for /R %DISTRO_DIR%\install\workplace-module-releases\ %%i in (*.zip) do (
    if not exist %SCRIPT_DIR%actico-model-hub\import\releases\%%~nxi.imported (
        echo Copying Workplace release %%~nxi
        copy /Y %DISTRO_DIR%\install\workplace-module-releases\%%~nxi %SCRIPT_DIR%actico-model-hub\import\releases\%%~nxi
        echo.
    ) else (
        echo Workplace release %%~nxi was already imported
    )
)
echo.

rem --- Copy Financial Spreading module releases to model-hub import folder
rem --- Only copy files which were not imported yet, which have a .imported suffix

echo Copying Financial Spreading releases to Model Hub import folder...
echo.
for /R %DISTRO_DIR%\install\spr-module-releases\ %%i in (*.zip) do (
    if not exist %SCRIPT_DIR%actico-model-hub\import\releases\%%~nxi.imported (
        echo Copying Financial Spreading release %%~nxi
        copy /Y %DISTRO_DIR%\install\spr-module-releases\%%~nxi %SCRIPT_DIR%actico-model-hub\import\releases\%%~nxi
        echo.
    ) else (
        echo Financial Spreadingbetsch01 release %%~nxi was already imported
    )
)
echo.

rem --- Copy CRMP module releases to model-hub import folder
rem --- Only copy files which were not imported yet, which have a .imported suffix

echo Copying CRMP releases to Model Hub import folder...
echo.
 for /R %DISTRO_DIR%\install\crmp-module-releases\ %%i in (*.zip) do (
     if not exist %SCRIPT_DIR%actico-model-hub\import\releases\%%~nxi.imported (
         echo Copying CRMP release %%~nxi
         copy /Y %DISTRO_DIR%\install\crmp-module-releases\%%~nxi %SCRIPT_DIR%actico-model-hub\import\releases\%%~nxi
         echo.
     ) else (
         echo CRMP release %%~nxi was already imported
     )
 )
echo.

echo Launching Model Hub...

set "MODEL_HUB_CMD=cd %SCRIPT_DIR%actico-model-hub\bin\windows"
set "MODEL_HUB_CMD=%MODEL_HUB_CMD% & set SPRING_APPLICATION_JSON=%SPRING_APPLICATION_JSON_MODEL_HUB%"
set "MODEL_HUB_CMD=%MODEL_HUB_CMD% & start-app.bat"

start "Model Hub" cmd.exe /K "color 6f & %MODEL_HUB_CMD%"

echo Launching Model Hub... done!

goto :end


:reset_errorlevel
exit /b 0


:errorPathContainsIllegalCharacters
echo         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo         ~  ERROR - ACTICO Platform - Model Hub - Evaluation bundle start script
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
