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
    Version        : 1.002
    File Name      : autoinstall_vrising.ps1
    Author         : Darryl H (https://github.com/darryl-h/)
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

# Configure the startup .bat file
Write-Host "Configuring Startup Batch File" -ForegroundColor Cyan
Copy-Item "$InstallPath\steamapps\common\VRisingDedicatedServer\start_server_example.bat" -Destination "$InstallPath\steamapps\common\VRisingDedicatedServer\start_server.bat"
(Get-Content "$InstallPath\steamapps\common\VRisingDedicatedServer\start_server.bat") -Replace '-logFile ".\\logs\\VRisingServer.log"', '' | Set-Content "$InstallPath\steamapps\common\VRisingDedicatedServer\start_server.bat"

# $VRisingStartupBat = Get-Content "$InstallPath\steamapps\common\VRisingDedicatedServer\start_server.bat"
# $VRisingStartupBat -replace '-logFile ".\logs\VRisingServer.log"',''

# Create custom server settings files that won't get overwritten on update
Write-Host "Preparing custom server configurations that won't get replaced on update" -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path "$InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Settings" | Out-Null 
Copy-Item "$InstallPath\steamapps\common\VRisingDedicatedServer\VRisingServer_Data\StreamingAssets\Settings\ServerGameSettings.json" -Destination "$InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Settings"
Copy-Item "$InstallPath\steamapps\common\VRisingDedicatedServer\VRisingServer_Data\StreamingAssets\Settings\ServerHostSettings.json" -Destination "$InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Settings"

# Configure RCON
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/set-content?view=powershell-7.2
Write-Host "Enabling RCON with password: $RCONPassword" -ForegroundColor Cyan
(Get-Content "$InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Settings\ServerHostSettings.json") -Replace '"Enabled": false,', '"Enabled": true,' | Set-Content "$InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Settings\ServerHostSettings.json"
Add-Type -AssemblyName System.Web
$RCONPasswordTemp = [System.Web.Security.Membership]::GeneratePassword(10,2)
$RCONPassword = $RCONPasswordTemp -replace '[^a-zA-Z0-9]', ''
#$RCONPassword = Regex.Replace($RCONPassword, @"[^a-zA-Z0-9]", m => "9" );
(Get-Content "$InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Settings\ServerHostSettings.json") -Replace '    "Password": ""', "    `"Password`": `"$RCONPassword`"" | Set-Content "$InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Settings\ServerHostSettings.json"

#$VRisingServerHostSettings = Get-Content "$InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Settings\ServerHostSettings.json"
#$VRisingStartupBat -replace '"Enabled": false,','"Enabled": true,'

# ToDo: Only run the update if there is an update.
# https://github.com/C0nw0nk/SteamCMD-AutoUpdate-Any-Gameserver/blob/master/steam-CURL.cmd

# Setup the VRisingServer Service with NSSM
Write-Host "Setting up NSSM Service" -ForegroundColor Cyan
Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "remove VRisingServer confirm"
Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "install VRisingServer $InstallPath\steamapps\common\VRisingDedicatedServer\start_server.bat"
Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer Application  $InstallPath\steamapps\common\VRisingDedicatedServer\start_server.bat"
Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer AppDirectory $InstallPath\steamapps\common\VRisingDedicatedServer"
Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer AppExit Default Restart"
Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer AppStdout $InstallPath\steamapps\common\VRisingDedicatedServer\logs\VRisingServer.log"
Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer AppStderr $InstallPath\steamapps\common\VRisingDedicatedServer\logs\VRisingServer.log"
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
Write-Host "Setting up Task Schduler to update daily" -ForegroundColor Cyan
$action = New-ScheduledTaskAction -Execute "$InstallPath\steamapps\common\VRisingDedicatedServer\update_server.bat"
$trigger = New-ScheduledTaskTrigger -Daily -At 9am
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "VRisingServerRestart" -Description "Restart VRising Server Daily" -Force

# $Trigger= New-ScheduledTaskTrigger –Daily -At 9am  # Specify the trigger settings
# $User= "NT AUTHORITY\SYSTEM" # Specify the account to run the script
# $Action= New-ScheduledTaskAction -Execute "$InstallPath\steamapps\common\VRisingDedicatedServer\update_server.bat" # Specify what program to run and with its parameters
# Register-ScheduledTask -TaskName "VRisingServerRestart" -Trigger $Trigger -User $User -Action $Action -RunLevel Highest –Force # Specify the name of the task

# Setup the Update.bat file
Write-Host "Creating daily update .bat file" -ForegroundColor Cyan
Add-Content -Path "$InstallPath\steamapps\common\VRisingDedicatedServer\update_server.bat" -Value "@echo off"
Add-Content -Path "$InstallPath\steamapps\common\VRisingDedicatedServer\update_server.bat" -Value "$InstallPath\steamcmd.exe +login anonymous +app_update 1829350 validate +quit"
Add-Content -Path "$InstallPath\steamapps\common\VRisingDedicatedServer\update_server.bat" -Value "$InstallPath\mcrcon.exe -H 127.0.0.1 -P 25575 -p $RCONPassword 'announcerestart 10'"
Add-Content -Path "$InstallPath\steamapps\common\VRisingDedicatedServer\update_server.bat" -Value "timeout 600"
Add-Content -Path "$InstallPath\steamapps\common\VRisingDedicatedServer\update_server.bat" -Value "$InstallPath\nssm.exe restart VRisingServer"

# Open the windows firewall for vrising
Write-Host "Configuring Windows Firewall" -ForegroundColor Cyan
New-NetFirewallRule -DisplayName "VRisingDedicatedServer" -Direction Inbound -Program "$InstallPath\steamapps\common\VRisingDedicatedServer\VRisingServer.exe" -Action Allow

# Start the service
Write-Host "Starting the VRising service" -ForegroundColor Cyan
Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "start VRisingServer"

# Let the user know where files are
Write-Host "All Done!" -ForegroundColor Green

Write-Host "`nManagement" -ForegroundColor Cyan
Write-Host "Your Startup .bat file is in $InstallPath\steamapps\common\VRisingDedicatedServer\start_server.bat"
Write-Host "Your Update .bat file is in $InstallPath\steamapps\common\VRisingDedicatedServer\update_server.bat"
Write-Host "Your can manage the service with $InstallPath\nssm.exe [start|stop|restart|edit] VRisingServer"
Write-Host "Your pseudo unique RCON password is $RCONPassword"

Write-Host "`nConfiguration Files" -ForegroundColor Cyan
Write-Host "Your ServerHostSettings.json is in $InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Settings\ServerHostSettings.json"
Write-Host "Your ServerGameSettings.json is in $InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Settings\ServerGameSettings.json"
Write-Host "You can learn more about each of the ServerGameSettings at https://cdn.stunlock.com/blog/2022/05/25083113/Game-Server-Settings.pdf" -ForegroundColor Red

Write-Host "`nLogs" -ForegroundColor Cyan
Write-Host "Your server logs are in $InstallPath\steamapps\common\VRisingDedicatedServer\logs\VRisingServer.log"

$ServerIPv4 = (Get-NetIPAddress | Where-Object {$_.AddressState -eq "Preferred" -and $_.ValidLifetime -lt "24:00:00"}).IPAddress
$ServerGateway = (Get-wmiObject Win32_networkAdapterConfiguration | ?{$_.IPEnabled}).DefaultIPGateway
$ServerHostSettings = Get-Content "$InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Settings\ServerHostSettings.json" | Out-String | ConvertFrom-Json
$VRisingGamePort = $ServerHostSettings.Port
$VRisingQueryPort = $ServerHostSettings.QueryPort
Write-Host "`nAction Plan" -ForegroundColor Cyan
Write-Host "1) Test direct connect from a machine on this same network"
Write-Host "`tEnter the game, and use Direct Connect, and connect to $ServerIPv4\:$VRisingGamePort"
Write-Host "`tDo NOT select 'LAN Mode'"
Write-Host "2) Configure your router at $ServerGateway and forward UDP port $VRisingGamePort and $VRisingQueryPort this machine ($ServerIPv4)"
Write-Host "`tTry http://portforward.com for information on how to port forward"
Write-Host "3) If you have a hardware firewall, you will need to also allow the traffic to this machine ($ServerIPv4)"
Write-Host "4) If you are behind a CGNAT or DS-Lite, you may not be able to host without a public IPv4 address"
Write-Host "5) If you wish, you may change the daily restart time from 09:00 local time to a more suitable time"