@echo off

setlocal enabledelayedexpansion
set version_file=VRisingServerVersion.txt
set log_file=VRisingServerVersion.log

REM Step 1: Check if VRisingServerVersion.txt file exists, if not, create it and populate it with the current version.
if not exist %version_file% (
    for /f "tokens=1,* delims=:" %%A in ('steamcmd.exe +login anonymous +app_info_print 1829350 +quit') do (
        set /a counter+=1
        REM echo Debug: Checking line !counter!: "%%A"
        if !counter! gtr 7 (
            set "version=%%A"
            set "version=!version:"=!"
            set "version=!version: =!"
            echo !version! > %version_file%
            echo [%DATE% %TIME%] Missing version file, creating new version file with version !version! >> %log_file%
            goto :exitloop
        )
    )
) else (
    REM Step 2: Compare version with VRisingServerVersion.txt file
    for /f "usebackq delims=" %%A in ("%version_file%") do set "current_version=%%A"
    set "current_version=!current_version:~0,-1!"
    for /f "tokens=1,* delims=:" %%A in ('steamcmd.exe +login anonymous +app_info_print 1829350 +quit') do (
        set /a counter+=1
        if !counter! equ 8 (
            set "version=%%A"
            set "version=!version:"=!"
            set "version=!version: =!"
            if "!version!"=="!current_version!" (
                echo Debug: Same version found: "!version!"
                echo [%DATE% %TIME%] Server is running the latest version: !version! >> %log_file%
            ) else (
                echo [%DATE% %TIME%] New Version Detected: !version! >> %log_file%
				C:\vrisingserver6\steamcmd.exe +login anonymous +app_update 1829350 validate +quit
				C:\vrisingserver6\mcrcon.exe -H 127.0.0.1 -P 25575 -p GbSJxzKG "announcerestart 10"
				timeout 600
				C:\vrisingserver6\nssm.exe stop VRisingServer-98766
				cd "C:\vrisingserver6\steamapps\common\VRisingDedicatedServer\logs"
				ren "VRisingServer.log" "VRisingServer_%date:~10,4%-%date:~4,2%-%date:~7,2%T%time::=-%.log"
				C:\vrisingserver6\nssm.exe start VRisingServer-98766
                echo !version! > %version_file%
            )
            goto :exitloop
        )
    )
)

:exitloop
