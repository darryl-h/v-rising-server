#Requires -Version 5
#Requires -RunAsAdministrator

<#
.SYNOPSIS
    This will install the VRising Server
.DESCRIPTION
    This will install the VRising Server and some additional tools like an RCON Client and NSSM for managing the service
    this will also configure the windows firewall to allow the program to operate.
    The user input is expected to be the full path
.NOTES
    Version        : 1.104
    File Name      : autoinstall_vrising.ps1
    Author         : Darryl H (https://github.com/darryl-h/)
    Credits        : Port and JSON handling from lordfiSh (https://github.com/lordfiSh/)
                   : Suggestions / Beta Testing / Bug Reporting: Svedriall (https://github.com/svedriall/)
    Prerequisite   : PowerShell V2 Windows 2022
    GNU GPLv3
.LINK
    https://github.com/darryl-h/v-rising-server
.EXAMPLE
    Start an administrator command prompt
    run powershell
    powershell -ExecutionPolicy Bypass -File .\autoinstall_vrising.ps1 C:\vrisingserver


#>

# Ensure that a path was provided by the user
Param(
    [string] $InstallPath
)
$NumOfParams = 1
If (($PSBoundParameters.values | Measure-Object | Select-Object -ExpandProperty Count) -lt $NumOfParams){
    write-host "You must provide the full path to install to, exiting..."
    EXIT
}

#Ensure the directory doesn't already exist
if (Test-Path -Path $InstallPath) {
    write-host "The selected path ($InstallPath) already exists!"
    EXIT
}

# Ensure the parent directory exists (This should also validates that the user gave us a full path)
$ParentDirectory = Split-Path -Path "$InstallPath"
if ($ParentDirectory) {
    if (-not (Test-Path -Path $ParentDirectory)) {
        write-host "The parent directory ($ParentDirectory) does not exist!"
        EXIT
    } 
} else {
    write-host "You must provide a full path to the server (IE: C:\v_rising_server)"
    EXIT
}

write-host "This script will:" -ForegroundColor Cyan
write-host "`t* Install the VRising Dedicated Server into $InstallPath with SteamCMD"
write-host "`t* Configure the server to use the configurations in a custom directory that will survive a server update"
write-host "`t* Create a custom update .bat file"
write-host "`t* Install NSSM to manage the server which will:"
write-host "`t`t> Start with Windows"
write-host "`t`t> Restart the server if it crashes"
write-host "`t`t> Add UTC timestamps to the logs"
write-host "`t`t> Keep logs indefinatly"
write-host "`t* Enable RCON"
write-host "`t* Install an RCON client to broadcast the restart to the users on the server"
write-host "`t* Open the Windows firewall for the VRising Server"
write-host "`t* Schedule a restart daily at 09:00 to update the server automatically"
Read-Host -Prompt "Press any key to continue or CTRL+C to quit"

function DownloadAndExtractFromWeb
{
    $FriendlyName = $args[0]
    $DownloadURL = $args[1]
    $DownloadFilename = $args[2]
    Write-Host "Preparing $FriendlyName" -ForegroundColor Cyan
    write-host "`tDownloading $FriendlyName"
    Start-BitsTransfer -Source $DownloadURL -Destination $InstallPath\ | Out-Null
    # Backup Method
    # Invoke-WebRequest -Uri "$DownloadURL" -OutFile $DownloadFilename -UserAgent [Microsoft.PowerShell.Commands.PSUserAgent]::FireFox
    # If the file failed to download, exit
    if(![System.IO.File]::Exists("$InstallPath\$DownloadFilename")) {
        throw (New-Object System.IO.FileNotFoundException("File failed to download!"))
        Remove-Item "$InstallPath" -Recurse
        EXIT
    }
    $InstallerExtension = [IO.Path]::GetExtension("$InstallPath\$DownloadFilename")
    If ($InstallerExtension -eq ".zip" ) {
        Write-Host "`tExtracting $DownloadFilename"
        Expand-Archive -Path "$InstallPath\$DownloadFilename" -DestinationPath $InstallPath
        Remove-Item -Recurse -Force "$InstallPath\$DownloadFilename"
    }
}

# Create the installation directory
New-Item -ItemType Directory -Force -Path $InstallPath | Out-Null

# Install NSSM
#DownloadAndExtractFromWeb 'the Non Sucking Service Manager (NSSM)' 'https://nssm.cc/release/nssm-2.24.zip' 'nssm-2.24.zip'
DownloadAndExtractFromWeb 'the Non Sucking Service Manager (NSSM)' 'https://nssm.cc/ci/nssm-2.24-101-g897c7ad.zip' 'nssm-2.24-101-g897c7ad.zip'
write-host "`tMoving the 64 bit version of NSSM"
$NSSMExecutable = Get-ChildItem -Path "$InstallPath\nssm-*\win64\" -Filter "nssm.exe" -Recurse | Select-Object -ExpandProperty FullName
$NSSMArchive = Get-ChildItem -Path "$InstallPath\nssm-*" | Select-Object -ExpandProperty FullName
Move-Item -Path  "$NSSMExecutable"  -Destination "$InstallPath\nssm.exe"
write-host "`tRemoving NSSM archive"
Remove-Item -Recurse -Force "$NSSMArchive"

# Install RCON
DownloadAndExtractFromWeb 'mcrcon' 'https://github.com/Tiiffi/mcrcon/releases/download/v0.7.2/mcrcon-0.7.2-windows-x86-64.zip' 'mcrcon-0.7.2-windows-x86-64.zip'
Remove-Item -Recurse -Force "$InstallPath\LICENSE"

# Install SteamCMD
DownloadAndExtractFromWeb 'SteamCMD' 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip' 'steamcmd.zip'

# Install Vrising in .\steamapps\common\VRisingDedicatedServer
Write-Host "Installing VRising Dedicated Server" -ForegroundColor Cyan
$SteamCMDArguments = "+force_install_dir $InstallPath +login anonymous +app_update 1829350 validate +quit"
$proc = Start-Process -FilePath "$InstallPath\steamcmd.exe" -ArgumentList $SteamCMDArguments -Passthru
do {start-sleep -Milliseconds 500}
until ($proc.HasExited)
write-host "`tValidating installation"
if(![System.IO.File]::Exists("$InstallPath\steamapps\common\VRisingDedicatedServer\VRisingServer.exe")) {
    throw (New-Object System.IO.FileNotFoundException("VRising Server failed to validate!"))
    Remove-Item "$InstallPath" -Recurse
    EXIT
}

write-host "`tCreating logs directory"
New-Item -ItemType Directory -Force -Path "$InstallPath\steamapps\common\VRisingDedicatedServer\logs" | Out-Null

Write-Host "Configuring Server" -ForegroundColor Cyan

# Configure the startup .bat file
# Write-Host "`tConfiguring Startup Batch File"
# Copy-Item "$InstallPath\steamapps\common\VRisingDedicatedServer\start_server_example.bat" -Destination "$InstallPath\steamapps\common\VRisingDedicatedServer\start_server.bat"
# (Get-Content "$InstallPath\steamapps\common\VRisingDedicatedServer\start_server.bat") -Replace '-logFile ".\\logs\\VRisingServer.log"', '' | Set-Content "$InstallPath\steamapps\common\VRisingDedicatedServer\start_server.bat"

# $VRisingStartupBat = Get-Content "$InstallPath\steamapps\common\VRisingDedicatedServer\start_server.bat"
# $VRisingStartupBat -replace '-logFile ".\logs\VRisingServer.log"',''

# Create custom server settings files that won't get overwritten on update
Write-Host "`tConfiguring Game and Host Settings that won't get replaced on update"
New-Item -ItemType Directory -Force -Path "$InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Settings" | Out-Null 
Copy-Item "$InstallPath\steamapps\common\VRisingDedicatedServer\VRisingServer_Data\StreamingAssets\Settings\ServerGameSettings.json" -Destination "$InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Settings"
Copy-Item "$InstallPath\steamapps\common\VRisingDedicatedServer\VRisingServer_Data\StreamingAssets\Settings\ServerHostSettings.json" -Destination "$InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Settings"

# Configure RCON
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/set-content?view=powershell-7.2
# Generate an 8 letter unique password
Add-Type -AssemblyName System.Web
$RCONPasswordTemp1 = [System.Web.Security.Membership]::GeneratePassword(20,2)
$RCONPasswordTemp2 = $RCONPasswordTemp1 -replace '[^a-zA-Z0-9]', ''
$RCONPassword = $RCONPasswordTemp2.substring(0, [System.Math]::Min(8, $RCONPasswordTemp2.Length))
Write-Host "`tEnabling RCON with password: $RCONPassword"
(Get-Content "$InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Settings\ServerHostSettings.json") -Replace '"Enabled": false,', '"Enabled": true,' | Set-Content "$InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Settings\ServerHostSettings.json"
(Get-Content "$InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Settings\ServerHostSettings.json") -Replace '    "Password": ""', "    `"Password`": `"$RCONPassword`"" | Set-Content "$InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Settings\ServerHostSettings.json"

# ToDo: Only run the update if there is an update.
# https://github.com/C0nw0nk/SteamCMD-AutoUpdate-Any-Gameserver/blob/master/steam-CURL.cmd

# Setup the VRisingServer Service with NSSM
Write-Host "`tConfiuring VRsingServer Service with NSSM"
Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "remove VRisingServer confirm"
Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "install VRisingServer VRisingServer"
Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer Application  $InstallPath\steamapps\common\VRisingDedicatedServer\VRisingServer.exe"
Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer AppParameters `"-persistentDataPath .\save-data`""
Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer AppEnvironmentExtra `":set SteamAppId=1604030`""
#Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer Application  $InstallPath\steamapps\common\VRisingDedicatedServer\start_server.bat"
Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer AppDirectory $InstallPath\steamapps\common\VRisingDedicatedServer"
Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer AppExit Default Restart"
Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer AppStdout $InstallPath\steamapps\common\VRisingDedicatedServer\logs\VRisingServer.log"
Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer AppStderr $InstallPath\steamapps\common\VRisingDedicatedServer\logs\VRisingServer.log"
Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer AppStopMethodSkip 14"
Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer AppKillProcessTree 0"
#Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer AppRotateFiles 1"
#Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer AppRotateOnline 1"
#Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer AppRotateBytes 1000000"
#Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer AppRotateSeconds 86400"
Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer AppTimestampLog 1"
Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer DisplayName VRisingServer"
Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer ObjectName LocalSystem"
Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer Start SERVICE_AUTO_START"
Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer Type SERVICE_WIN32_OWN_PROCESS"

# Setup Windows to run the auto update daily at 09:00
Write-Host "`tConfiguring Task Scheudler to reboot and update daily at 09:00AM"
$action = New-ScheduledTaskAction -Execute "$InstallPath\steamapps\common\VRisingDedicatedServer\update_server.bat"
$trigger = New-ScheduledTaskTrigger -Daily -At 9am
$trigger.StartBoundary = [DateTime]::Parse($trigger.StartBoundary).ToLocalTime().ToString("s")
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "VRisingServerRestart" -Description "Restart VRising Server Daily" -Force  | Out-Null

# Setup the Update.bat file
Write-Host "`tCreating daily update .bat file"
Add-Content -Path "$InstallPath\steamapps\common\VRisingDedicatedServer\update_server.bat" -Value "@echo off"
Add-Content -Path "$InstallPath\steamapps\common\VRisingDedicatedServer\update_server.bat" -Value "$InstallPath\steamcmd.exe +login anonymous +app_update 1829350 validate +quit"
Add-Content -Path "$InstallPath\steamapps\common\VRisingDedicatedServer\update_server.bat" -Value "$InstallPath\mcrcon.exe -H 127.0.0.1 -P 25575 -p $RCONPassword 'announcerestart 10'"
Add-Content -Path "$InstallPath\steamapps\common\VRisingDedicatedServer\update_server.bat" -Value "timeout 600"
Add-Content -Path "$InstallPath\steamapps\common\VRisingDedicatedServer\update_server.bat" -Value "$InstallPath\nssm.exe restart VRisingServer"

# Open the windows firewall for vrising
Write-Host "`tConfiguring Windows Firewall"
New-NetFirewallRule -DisplayName "VRisingDedicatedServer" -Direction Inbound -Program "$InstallPath\steamapps\common\VRisingDedicatedServer\VRisingServer.exe" -Action Allow  | Out-Null

# Start the service
Write-Host "`tStarting the VRising service"
Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "start VRisingServer"
Write-Host "All Done!" -ForegroundColor Green


# Let the user know where files are
Write-Host "`nManagement" -ForegroundColor Cyan
# Write-Host "Your Startup .bat file is in $InstallPath\steamapps\common\VRisingDedicatedServer\start_server.bat"
Write-Host "Your Update .bat file is in $InstallPath\steamapps\common\VRisingDedicatedServer\update_server.bat"
Write-Host "Your can manage the service with $InstallPath\nssm.exe [start|stop|restart|edit] VRisingServer"
Write-Host "Your pseudo unique RCON password is $RCONPassword"

Write-Host "`nConfiguration Files" -ForegroundColor Cyan
# Load the ServerHostSettings.json
$ServerHostSettings = Get-Content "$InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Settings\ServerHostSettings.json" | Out-String | ConvertFrom-Json
# Load some particulars
$VRisingMaxConnectedUsers = $ServerHostSettings.MaxConnectedUsers
$VRisingSavename = $ServerHostSettings.SaveName
$VRisingAutoSaveCount = $ServerHostSettings.AutoSaveCount
$VRisingAutoSaveInterval = $ServerHostSettings.AutoSaveInterval
$VRisingGamePort = $ServerHostSettings.Port
$VRisingQueryPort = $ServerHostSettings.QueryPort
Write-Host "$InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Settings\ServerHostSettings.json" -ForegroundColor Yellow
Write-Host "`tMaximum Connected Users: $VRisingMaxConnectedUsers"
Write-Host "`tGame Port: $VRisingGamePort"
Write-Host "`tQuery Port: $VRisingQueryPort"
Write-Host "`tSaves: $InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Saves\v1\$VRisingSavename"
Write-Host "`tAuto Save Count: $VRisingAutoSaveCount"
Write-Host "`tAuto Save Interval (In Seconds): $VRisingAutoSaveInterval"
Write-Host "`tRCON Password: $RCONPassword"
# Load the ServerHostSettings.json
$ServerGameSettings = Get-Content "$InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Settings\ServerGameSettings.json" | Out-String | ConvertFrom-Json
$VRisingGameModeType = $ServerGameSettings.GameModeType
$VRisingClanSize = $ServerGameSettings.ClanSize
$VRisingName = $ServerGameSettings.Name
$VRisingDescription = $ServerGameSettings.Description
Write-Host "$InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Settings\ServerGameSettings.json" -ForegroundColor Yellow
Write-Host "`tGame Name: $VRisingName"
Write-Host "`tGame Description: $VRisingDescription"
Write-Host "`tGame Mode Type: $VRisingGameModeType"
Write-Host "`tGroup/Clan Size: $VRisingClanSize"
Write-Host "Settings Descriptions and Min/Maxs: https://cdn.stunlock.com/blog/2022/05/25083113/Game-Server-Settings.pdf" -ForegroundColor DarkYellow

Write-Host "`nLogs" -ForegroundColor Cyan
Write-Host "Your server logs are in $InstallPath\steamapps\common\VRisingDedicatedServer\logs\VRisingServer.log"

$ServerIPv4 = (Get-NetIPAddress | Where-Object {$_.AddressState -eq "Preferred" -and $_.ValidLifetime -lt "24:00:00"}).IPAddress
$ServerGateway = (Get-wmiObject Win32_networkAdapterConfiguration | ?{$_.IPEnabled}).DefaultIPGateway
Write-Host "`nAction Plan" -ForegroundColor Cyan
Write-Host "1) Test direct connect from a machine on this same network"
Write-Host "`tEnter the game, and use Direct Connect, and connect to $ServerIPv4`:$VRisingGamePort"
Write-Host "`tDo NOT select 'LAN Mode'"
Write-Host "2) Configure your router at $ServerGateway and forward UDP port $VRisingGamePort and $VRisingQueryPort to this machine ($ServerIPv4)"
Write-Host "`tTry http://portforward.com for information on how to port forward"
Write-Host "3) If you have a hardware firewall, you will need to also allow the traffic to this machine ($ServerIPv4)"
Write-Host "4) If you are behind a CGNAT or DS-Lite, you may not be able to host without a public IPv4 address"
Write-Host "5) If you wish, you may change the daily restart time from 09:00 local time to a more suitable time Task Scheduler"