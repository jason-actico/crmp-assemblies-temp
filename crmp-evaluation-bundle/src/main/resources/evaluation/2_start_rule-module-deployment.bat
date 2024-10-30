@echo off
setlocal EnableDelayedExpansion

rem --- --------------------------------------------------------------
rem ---
rem --- If the initial setup was aborted or the server does not start
rem --- upon execution of this script, please remove the folder
rem --- 'actico-model-hub' below this script directory and restart
rem --- Model Hub and this script.
rem ---
rem --- --------------------------------------------------------------

rem --- Make sure correct code page is set in order to display special characters correctly
cmd.exe /c chcp 1252 >nul

set "SCRIPT_DIR=%~dp0"
rem set "JAVA_HOME=%SCRIPT_DIR%\java"
rem set "PATH=%JAVA_HOME%\bin;%PATH%"
set "ENVIRONMENT=spr-demo"
set "MODEL_HUB_URL=http://localhost:8080"
set "MODEL_HUB_CREDENTIALS=--model-hub-username admin --model-hub-password admin"

echo.
echo ------------------------------------------------------------------
echo    ACTICO CLI - Module Deployment
echo ------------------------------------------------------------------
echo.

pushd "%SCRIPT_DIR%"
echo %SCRIPT_DIR%
echo ls

echo Deploying rule modules to demo environment
echo.

rem deploy dependent workplace modules
java -jar lib\cli.jar deploy ^
	--module-id actico.workplace-modeling --version ${workplace.version}^
	--model-hub-url %MODEL_HUB_URL% %MODEL_HUB_CREDENTIALS%^
	--environment-id %ENVIRONMENT% --activate
	
java -jar lib\cli.jar deploy ^
	--module-id actico.workplace-commons --version ${workplace.version}^
	--model-hub-url %MODEL_HUB_URL% %MODEL_HUB_CREDENTIALS%^
	--environment-id %ENVIRONMENT% --activate	
	
java -jar lib\cli.jar deploy ^
	--module-id actico.workplace-standard --version ${workplace.version}^
	--model-hub-url %MODEL_HUB_URL% %MODEL_HUB_CREDENTIALS%^
	--environment-id %ENVIRONMENT% --activate		
	
rem deploy dependent financial spreading modules
rem correct version number first
set spr_version=${financial-spreading-rule-module.version}

java -jar lib\cli.jar deploy ^
	--module-id actico.spr.core --version %spr_version%^
	--model-hub-url %MODEL_HUB_URL% %MODEL_HUB_CREDENTIALS%^
	--environment-id %ENVIRONMENT% --activate	

set "MODULE="
set "MODULE_VERSION="

for %%i in (..\install\crmp-module-releases\*) do  (
	rem get module id from release file name
	for /f "tokens=1 delims=]" %%a in ("%%i") do (
		for /f "tokens=2 delims=[" %%m in ("%%a") do (
			set MODULE=%%m
		)	
	)
	
	rem get module version from release file name
	for /f "tokens=2 delims=]" %%b in ("%%i") do (
		for /f "tokens=1 delims=[" %%v in ("%%b") do (
			set MODULE_VERSION=%%v
		)	
	)
	rem deploy current module
	java -jar lib\cli.jar deploy ^
		--module-id !MODULE!  --version !MODULE_VERSION!^
		--model-hub-url %MODEL_HUB_URL% %MODEL_HUB_CREDENTIALS%^
		--environment-id %ENVIRONMENT% --activate
)

rem ---- START CRMP SPECIFIC -------
rem activate all modules
rem second loop after all modules have been deployed, as modules are not
rem activated in case dependencies cannot be deployed. This happens as the
rem rule modules are deployed in alphabetic order 
for %%i in (..\install\crmp-module-releases\*) do  (
	rem get module id from release file name
	for /f "tokens=1 delims=]" %%a in ("%%i") do (
		for /f "tokens=2 delims=[" %%m in ("%%a") do (
			set MODULE=%%m
		)	
	)
	
	rem get module version from release file name
	for /f "tokens=2 delims=]" %%b in ("%%i") do (
		for /f "tokens=1 delims=[" %%v in ("%%b") do (
			set MODULE_VERSION=%%v
		)	
	)
	rem activate all modules
	java -jar lib\cli.jar activate ^
		--module-id !MODULE!  --version !MODULE_VERSION!^
		--model-hub-url %MODEL_HUB_URL% %MODEL_HUB_CREDENTIALS%^
		--environment-id %ENVIRONMENT%	
)
rem ---- END CRMP SPECIFIC -------

popd
@echo on