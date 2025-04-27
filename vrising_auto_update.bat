@echo off
setlocal enabledelayedexpansion

REM Configuration
set APP_ID=1829350
set STEAMCMD=steamcmd.exe
set LOGFILE=update_log.txt
set BUILD_FILE=current_buildid.txt

cd /d "%~dp0"

REM Initialize build ID if needed
if not exist "%BUILD_FILE%" (
    for /f "tokens=2 delims==" %%A in ('%STEAMCMD% +login anonymous +app_info_update 1 +app_info_print %APP_ID% +quit ^| findstr /c:"buildid"') do (
        set CURRENT_BUILD=%%~A
        set CURRENT_BUILD=!CURRENT_BUILD: =!
    )
    echo !CURRENT_BUILD! > "%BUILD_FILE%"
    echo [%date% %time%] Initialized build ID: !CURRENT_BUILD!>> "%LOGFILE%"
    exit /b
)

REM Read current known build
set /p CURRENT_BUILD=<"%BUILD_FILE%"
set CURRENT_BUILD=%CURRENT_BUILD: =%

REM Fetch latest build ID from Steam
set LATEST_BUILD=
for /f "tokens=2 delims==" %%A in ('%STEAMCMD% +login anonymous +app_info_update 1 +app_info_print %APP_ID% +quit ^| findstr /c:"buildid"') do (
    set LATEST_BUILD=%%~A
    set LATEST_BUILD=!LATEST_BUILD: =!
    goto after_fetch
)
:after_fetch

if "%LATEST_BUILD%"=="" (
    echo [%date% %time%] ERROR: Unable to fetch build ID.>> "%LOGFILE%"
    exit /b
)

REM Update if build changed
if not "%CURRENT_BUILD%"=="%LATEST_BUILD%" (
    echo [%date% %time%] Updating from %CURRENT_BUILD% to %LATEST_BUILD%>> "%LOGFILE%"
    %STEAMCMD% +login anonymous +app_update %APP_ID% validate +quit
    echo %LATEST_BUILD% > "%BUILD_FILE%"
    echo [%date% %time%] Update completed.>> "%LOGFILE%"
) else (
    echo [%date% %time%] No update detected.>> "%LOGFILE%"
)
