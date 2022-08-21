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
    Version        : 1.521
    File Name      : autoinstall_vrising.ps1
    Author         : Darryl H (https://github.com/darryl-h/)
    Credits        : Port and JSON handling from lordfiSh (https://github.com/lordfiSh/)
                   : Suggestions / Beta Testing / Bug Reporting: Svedriall (https://github.com/svedriall/)
                   : Suggestions / Testing: Skytia#5097 on Discord
    Prerequisite   : PowerShell V2 Windows 2022
    GNU GPLv3
.LINK
    https://github.com/darryl-h/v-rising-server
.EXAMPLE
    Start an administrator command prompt
    run powershell
    powershell -ExecutionPolicy Bypass -File .\autoinstall_vrising.ps1 -action install -installpath C:\vrisingserver -gameport 1234 -queryport 4567 -rconport 8481


#>

# Assign the arguments from the user (This MUST be the first line after comments!)
Param(
    [string] $InstallPath,
    [int] $GamePort,
    [int] $QueryPort,
    [int] $RCONPort
)

if ($GamePort -eq "") {
    $GamePort = 9876
}
if ($QueryPort -eq "") {
    $QueryPort = 9877
}
if ($RCONPort -eq "") {
    $RCONPort = 25575
}
if ($InstallPath -eq "") {
    write-host "You must provide the installation directory! Exiting..." -ForegroundColor Red
    write-host "`nBasic Usage:"
    write-host "Syntax: powershell -ExecutionPolicy Bypass -File $PSCommandPath -installpath <your_install_path>" -ForegroundColor Yellow
    write-host "Example: powershell -ExecutionPolicy Bypass -File $PSCommandPath -installpath c:\vrisingserver" -ForegroundColor DarkYellow
    write-host "`nAdvanced Usage:"
    write-host "Syntax: powershell -ExecutionPolicy Bypass -File $PSCommandPath -installpath <your_install_path> -gameport <your_game_port> -queryport <your_query_port>" -ForegroundColor Yellow
    write-host "Example: powershell -ExecutionPolicy Bypass -File $PSCommandPath -installpath c:\vrisingserver -gameport 9876 -queryport 9877 -rconport 25575" -ForegroundColor DarkYellow
    EXIT
}

# Generate an 8 letter unique password
Add-Type -AssemblyName System.Web
$RCONPasswordTemp1 = [System.Web.Security.Membership]::GeneratePassword(20,2)
$RCONPasswordTemp2 = $RCONPasswordTemp1 -replace '[^a-zA-Z0-9]', ''
$RCONPassword = $RCONPasswordTemp2.substring(0, [System.Math]::Min(8, $RCONPasswordTemp2.Length))

function ResizeConsole {
    # Resize the console to 180
    $pshost = Get-Host              # Get the PowerShell Host.
    $pswindow = $pshost.UI.RawUI    # Get the PowerShell Host's UI.
    $newsize = $pswindow.BufferSize # Get the UI's current Buffer Size.
    $newsize.width = 180            # Set the new buffer's width to 150 columns.
    $pswindow.buffersize = $newsize # Set the new Buffer Size as active.
    $newsize = $pswindow.windowsize # Get the UI's current Window Size.
    $newsize.width = 180            # Set the new Window Width to 150 columns.
    $pswindow.windowsize = $newsize # Set the new Window Size as active.
}
function ValidatePorts {
    Write-Host "`n[Validation - Networking]" -ForegroundColor Cyan
    Write-Host "`tValidating user supplied game port (UDP: $GamePort)"
    $GamePortInUse = Get-NetUDPEndpoint | Where {$_.LocalAddress -eq "0.0.0.0"} | select LocalAddress,LocalPort,@{Name="Process";Expression={(Get-Process -Id $_.OwningProcess).ProcessName}} | where Localport -eq $GamePort
    if (!($GamePortInUse -eq $null)) {
        Write-Host "`t`t* UDP Game port appears to be in use, please choose another!" -ForegroundColor Red
        Write-Host ($GamePortInUse | Format-Table | Out-String)
        EXIT
    } Else {
        Write-Host "`t`t* RCON port looks OK" -ForegroundColor Green
    }
    
    Write-Host "`tValidating user supplied query port (UDP: $QueryPort)"
    $QueryPortInUse = Get-NetUDPEndpoint | Where {$_.LocalAddress -eq "0.0.0.0"} | select LocalAddress,LocalPort,@{Name="Process";Expression={(Get-Process -Id $_.OwningProcess).ProcessName}} | where Localport -eq $QueryPort
    if (!($QueryPortInUse -eq $null)) {
        Write-Host "`t`t* UDP Query port appears to be in use, please choose another!" -ForegroundColor Red
        Write-Host ($QueryPortInUse | Format-Table | Out-String)
        EXIT
    } Else {
        Write-Host "`t`t* Query port looks OK" -ForegroundColor Green
    }
    
    Write-Host "`tValidating user supplied RCON port (TCP: $RCONPort)"
    $RCONPortInUse = Get-NetTCPConnection | Where {$_.LocalAddress -eq "0.0.0.0"} | select LocalAddress,LocalPort,@{Name="Process";Expression={(Get-Process -Id $_.OwningProcess).ProcessName}} | where Localport -eq $RCONPort
    if (!($RCONPortInUse -eq $null)) {
        Write-Host "`t`t* TCP RCON port appears to be in use, please choose another!" -ForegroundColor Red
        Write-Host ($RCONPortInUse | Format-Table | Out-String)
        EXIT
    } Else {
        Write-Host "`t`t* RCON port looks OK" -ForegroundColor Green
    }
    
    Write-Host "`tValidating Routing"
    $TraceRoute = Test-NetConnection -ComputerName (Invoke-WebRequest -uri "http://ifconfig.me/ip" -UseBasicParsing).Content -TraceRoute | Select -ExpandProperty TraceRoute | Measure-Object | Select-Object -ExpandProperty Count
    If ($TraceRoute -gt 1){
        Write-Host "`t`t* WARNING: You appear to be behind a NAT of some sort!! You may not be able to host correctly on the internet!" -ForegroundColor Red
        Write-Host "`n`t`tTracerouting to your Public IP:"
        Test-NetConnection -ComputerName (Invoke-WebRequest -uri "http://ifconfig.me/ip" -UseBasicParsing).Content -TraceRoute | Select -ExpandProperty TraceRoute
    } ElseIf ($TraceRoute -eq 1 ) {
        Write-Host "`t`t* Routing looks OK" -ForegroundColor Green
    }
}
function DownloadAndExtractFromWeb {
    param
    (
      [string]$FriendlyName,
      [string]$DownloadURL,
      [string]$DownloadFilename
    )
    Write-Host "`tPreparing $FriendlyName" -ForegroundColor DarkCyan
    write-host "`t`t* Downloading $FriendlyName"
    Start-BitsTransfer -Source $DownloadURL -Destination $InstallPath\
    # Backup Method
    # Invoke-WebRequest -Uri "$DownloadURL" -OutFile $DownloadFilename -UserAgent [Microsoft.PowerShell.Commands.PSUserAgent]::FireFox
    # If the file failed to download, exit
    if(![System.IO.File]::Exists("$InstallPath\$DownloadFilename")) {
        write-host "`t`tFailed to download $DownloadFilename, rolling back, please retry after a few moments." -ForegroundColor Red
        Remove-Item "$InstallPath" -Recurse
        EXIT
    }
    $InstallerExtension = [IO.Path]::GetExtension("$InstallPath\$DownloadFilename")
    If ($InstallerExtension -eq ".zip" ) {
        Write-Host "`t`t* Extracting $DownloadFilename"
        Expand-Archive -Path "$InstallPath\$DownloadFilename" -DestinationPath $InstallPath
        Remove-Item -Recurse -Force "$InstallPath\$DownloadFilename"
    }
}
function ValidateInput {
    Write-Host "`n[Validation - Paths]" -ForegroundColor Cyan
    Write-Host "`tValidating user supplied path"
    #Ensure the directory doesn't already exist
    if (Test-Path -Path $InstallPath) {
        write-host "`t`t* The selected path ($InstallPath) already exists!" -ForegroundColor Red
        EXIT
    }

    # Ensure the parent directory exists (This should also validates that the user gave us a full path)
    $ParentDirectory = Split-Path -Path "$InstallPath"
    if ($ParentDirectory) {
        if (-not (Test-Path -Path $ParentDirectory)) {
            write-host "`t`t* The parent directory ($ParentDirectory) does not exist!" -ForegroundColor Red
            EXIT
        } 
    } else {
        write-host "`t`tYou must provide a full path to the server (IE: C:\v_rising_server)" -ForegroundColor Red
        EXIT
    }
    Write-Host "`t`t* User supplied path looks OK" -ForegroundColor Green
}
function AdviseUserBeforeFullInstall {
    write-host "`n[Prepare for full installation]" -ForegroundColor Cyan
    write-host "`tThis script will:" -ForegroundColor DarkCyan
    write-host "`t`t* Install the VRising Dedicated Server into $InstallPath with SteamCMD"
    write-host "`t`t* Configure the server to use the configurations in a custom directory that will survive a server update"
    write-host "`t`t* Create a custom update .bat file"
    write-host "`t`t* Install NSSM to manage the server which will:"
    write-host "`t`t`t> Start with Windows"
    write-host "`t`t`t> Restart the server if it crashes"
    write-host "`t`t`t> Add UTC timestamps to the logs"
    write-host "`t`t`t> Keep logs indefinatly"
    write-host "`t`t* Enable RCON"
    write-host "`t`t* Install an RCON client to broadcast the restart to the users on the server"
    write-host "`t`t* Open the Windows firewall for the VRising Server"
    write-host "`t`t* Schedule a restart daily at 09:00 to update the server automatically"
    Read-Host -Prompt "Press any key to continue or CTRL+C to quit"
}
function InstallNewServer {
    write-host "`n[Installing V Rising]" -ForegroundColor Cyan
    # Create the installation directory
    New-Item -ItemType Directory -Force -Path $InstallPath | Out-Null

    # Install NSSM
    #DownloadAndExtractFromWeb 'the Non Sucking Service Manager (NSSM)' 'https://nssm.cc/release/nssm-2.24.zip' 'nssm-2.24.zip'
    DownloadAndExtractFromWeb -FriendlyName 'the Non Sucking Service Manager (NSSM)' -DownloadURL 'https://nssm.cc/ci/nssm-2.24-101-g897c7ad.zip' -DownloadFilename 'nssm-2.24-101-g897c7ad.zip'
    write-host "`t`t* Moving the 64 bit version of NSSM"
    $NSSMExecutable = Get-ChildItem -Path "$InstallPath\nssm-*\win64\" -Filter "nssm.exe" -Recurse | Select-Object -ExpandProperty FullName
    $NSSMArchive = Get-ChildItem -Path "$InstallPath\nssm-*" | Select-Object -ExpandProperty FullName
    Move-Item -Path  "$NSSMExecutable"  -Destination "$InstallPath\nssm.exe"
    write-host "`t`t* Removing NSSM archive"
    Remove-Item -Recurse -Force "$NSSMArchive"

    # Install RCON
    DownloadAndExtractFromWeb -FriendlyName 'mcrcon' -DownloadURL 'https://github.com/Tiiffi/mcrcon/releases/download/v0.7.2/mcrcon-0.7.2-windows-x86-64.zip' -DownloadFilename 'mcrcon-0.7.2-windows-x86-64.zip'
    Remove-Item -Recurse -Force "$InstallPath\LICENSE"

    # Install SteamCMD
    DownloadAndExtractFromWeb -FriendlyName 'SteamCMD' -DownloadURL 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip' -DownloadFilename 'steamcmd.zip'

    # Install Vrising in .\steamapps\common\VRisingDedicatedServer
    Write-Host "`tInstalling VRising Dedicated Server" -ForegroundColor DarkCyan
    $SteamCMDArguments = "+force_install_dir $InstallPath +login anonymous +app_update 1829350 validate +quit"
    $proc = Start-Process -FilePath "$InstallPath\steamcmd.exe" -ArgumentList $SteamCMDArguments -Passthru
    do {start-sleep -Milliseconds 500}
    until ($proc.HasExited)
    write-host "`t`t* Validating installation"
    if(![System.IO.File]::Exists("$InstallPath\steamapps\common\VRisingDedicatedServer\VRisingServer.exe")) {
        throw (New-Object System.IO.FileNotFoundException("VRising Server failed to validate!"))
        Remove-Item "$InstallPath" -Recurse
        EXIT
    }

    write-host "`t`t* Creating logs directory"
    New-Item -ItemType Directory -Force -Path "$InstallPath\steamapps\common\VRisingDedicatedServer\logs" | Out-Null

    Write-Host "`tConfiguring Server" -ForegroundColor DarkCyan

    # Create custom server settings files that won't get overwritten on update
    Write-Host "`t`t* Configuring Game and Host Settings that won't get replaced on update"
    New-Item -ItemType Directory -Force -Path "$InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Settings" | Out-Null 
    Copy-Item "$InstallPath\steamapps\common\VRisingDedicatedServer\VRisingServer_Data\StreamingAssets\Settings\ServerGameSettings.json" -Destination "$InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Settings"
    Copy-Item "$InstallPath\steamapps\common\VRisingDedicatedServer\VRisingServer_Data\StreamingAssets\Settings\ServerHostSettings.json" -Destination "$InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Settings"

    # Configure RCON
    # https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/set-content?view=powershell-7.2
    Write-Host "`t`t* Enabling RCON with password: $RCONPassword"
    (Get-Content "$InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Settings\ServerHostSettings.json") -Replace '"Enabled": false,', '"Enabled": true,' | Set-Content "$InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Settings\ServerHostSettings.json"
    (Get-Content "$InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Settings\ServerHostSettings.json") -Replace '    "Password": ""', "    `"Password`": `"$RCONPassword`"" | Set-Content "$InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Settings\ServerHostSettings.json"
}
function PostConfigureServer {
    # ToDo: Only run the update if there is an update.
    # https://github.com/C0nw0nk/SteamCMD-AutoUpdate-Any-Gameserver/blob/master/steam-CURL.cmd

    # Setup the VRisingServer Service with NSSM
    Write-Host "`t`t* Confiuring VRsingServer Service with NSSM"
    Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "remove VRisingServer-$GamePort confirm"
    Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "install VRisingServer-$GamePort VRisingServer"
    Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer-$GamePort Application  $InstallPath\steamapps\common\VRisingDedicatedServer\VRisingServer.exe"
    Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer-$GamePort AppParameters `"-persistentDataPath .\save-data`""
    Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer-$GamePort AppEnvironmentExtra `":set SteamAppId=1604030`""
    Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer-$GamePort AppDirectory $InstallPath\steamapps\common\VRisingDedicatedServer"
    Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer-$GamePort AppExit Default Restart"
    Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer-$GamePort AppStdout $InstallPath\steamapps\common\VRisingDedicatedServer\logs\VRisingServer.log"
    Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer-$GamePort AppStderr $InstallPath\steamapps\common\VRisingDedicatedServer\logs\VRisingServer.log"
    Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer-$GamePort AppStopMethodSkip 14"
    Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer-$GamePort AppKillProcessTree 0"
    Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer-$GamePort AppTimestampLog 1"
    Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer-$GamePort DisplayName VRisingServer-$GamePort"
    Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer-$GamePort ObjectName LocalSystem"
    Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer-$GamePort Start SERVICE_AUTO_START"
    Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer-$GamePort Type SERVICE_WIN32_OWN_PROCESS"

    # Setup Windows to run the auto update daily at 09:00
    Write-Host "`t`t* Configuring Task Scheudler to reboot and update daily at 09:00AM"
    $action = New-ScheduledTaskAction -Execute "$InstallPath\steamapps\common\VRisingDedicatedServer\update_server.bat"
    $trigger = New-ScheduledTaskTrigger -Daily -At 9am
    $trigger.StartBoundary = [DateTime]::Parse($trigger.StartBoundary).ToLocalTime().ToString("s")
    Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "VRisingServerRestart-$GamePort" -Description "Restart VRising Server Daily" -Force  | Out-Null

    # Setup the Update.bat file
    Write-Host "`t`t* Creating daily update .bat file"
    Add-Content -Path "$InstallPath\steamapps\common\VRisingDedicatedServer\update_server.bat" -Value "@echo off"
    Add-Content -Path "$InstallPath\steamapps\common\VRisingDedicatedServer\update_server.bat" -Value "$InstallPath\steamcmd.exe +login anonymous +app_update 1829350 validate +quit"
    Add-Content -Path "$InstallPath\steamapps\common\VRisingDedicatedServer\update_server.bat" -Value "$InstallPath\mcrcon.exe -H 127.0.0.1 -P 25575 -p $RCONPassword `"announcerestart 10`""
    Add-Content -Path "$InstallPath\steamapps\common\VRisingDedicatedServer\update_server.bat" -Value "timeout 600"
    Add-Content -Path "$InstallPath\steamapps\common\VRisingDedicatedServer\update_server.bat" -Value "$InstallPath\nssm.exe stop VRisingServer-$GamePort"
    Add-Content -Path "$InstallPath\steamapps\common\VRisingDedicatedServer\update_server.bat" -Value "cd `"$InstallPath\steamapps\common\VRisingDedicatedServer\logs`""
    Add-Content -Path "$InstallPath\steamapps\common\VRisingDedicatedServer\update_server.bat" -Value "ren `"VRisingServer.log`" `"VRisingServer_%date:~10,4%-%date:~4,2%-%date:~7,2%T%time::=-%.log`""
    Add-Content -Path "$InstallPath\steamapps\common\VRisingDedicatedServer\update_server.bat" -Value "$InstallPath\nssm.exe start VRisingServer-$GamePort"

    # Open the windows firewall for vrising
    Write-Host "`t`t* Configuring Windows Firewall"
    New-NetFirewallRule -DisplayName "VRisingDedicatedServer" -Direction Inbound -Program "$InstallPath\steamapps\common\VRisingDedicatedServer\VRisingServer.exe" -Action Allow  | Out-Null

    # Start the service
    Write-Host "`t`t* Starting the VRising service"
    Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "start VRisingServer-$GamePort"
    Write-Host "`tAll Done!" -ForegroundColor Green
}
function AdviseUserAfterFullInstall {
    Write-Host "`n[IMPORTANT INFORMATION - READ THIS]" -ForegroundColor Red
    # Let the user know where files are
    Write-Host "`n`tManagement" -ForegroundColor DarkCyan
    # Write-Host "Your Startup .bat file is in $InstallPath\steamapps\common\VRisingDedicatedServer\start_server.bat"
    Write-Host "`t`t* Your Update .bat file is in $InstallPath\steamapps\common\VRisingDedicatedServer\update_server.bat"
    Write-Host "`t`t* Your can manage the service normally with 'services.msc' or with $InstallPath\nssm.exe [start|stop|restart|edit] VRisingServer-$GamePort"

    Write-Host "`n`tConfiguration Files" -ForegroundColor DarkCyan
    # Load the ServerHostSettings.json
    $ServerHostSettings = Get-Content "$InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Settings\ServerHostSettings.json" | Out-String | ConvertFrom-Json
    # Load some particulars
    $VRisingMaxConnectedUsers = $ServerHostSettings.MaxConnectedUsers
    $VRisingSavename = $ServerHostSettings.SaveName
    $VRisingAutoSaveCount = $ServerHostSettings.AutoSaveCount
    $VRisingAutoSaveInterval = $ServerHostSettings.AutoSaveInterval
    $VRisingGamePort = $ServerHostSettings.Port
    $VRisingQueryPort = $ServerHostSettings.QueryPort
    $VRisingName = $ServerHostSettings.Name
    $VRisingDescription = $ServerHostSettings.Description
    Write-Host "`t`tServerHostSettings" -ForegroundColor Yellow
    Write-Host "`n`t`tServerGameSettings" -ForegroundColor Yellow
    Write-Host "`t`t`tGame Name: $VRisingName"
    Write-Host "`t`t`tMaximum Connected Users: $VRisingMaxConnectedUsers"
    Write-Host "`t`t`tGame Port: $VRisingGamePort"
    Write-Host "`t`t`tQuery Port: $VRisingQueryPort"
    Write-Host "`t`t`tSaves: $InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Saves\v1\$VRisingSavename"
    Write-Host "`t`t`tTo migrate your existing world, issue the following command to open the save directory:" -ForegroundColor Magenta
    Write-Host "`t`t`tInvoke-Item $InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Saves\v1\$VRisingSavename\"  -ForegroundColor DarkMagenta 
    Write-Host "`t`t`tAuto Save Count: $VRisingAutoSaveCount"
    Write-Host "`t`t`tAuto Save Interval (In Seconds): $VRisingAutoSaveInterval"
    Write-Host "`t`t`tRCON Password: $RCONPassword"
    Write-Host "`t`t`tTo make changes to your ServerHostSettings file, please issue the following command:" -ForegroundColor Magenta
    Write-Host "`t`t`tInvoke-Item $InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Settings\ServerHostSettings.json" -ForegroundColor DarkMagenta

    # Load the ServerHostSettings.json
    $ServerGameSettings = Get-Content "$InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Settings\ServerGameSettings.json" | Out-String | ConvertFrom-Json
    $VRisingGameModeType = $ServerGameSettings.GameModeType
    $VRisingClanSize = $ServerGameSettings.ClanSize
    Write-Host "`t`t`tGame Description: $VRisingDescription"
    Write-Host "`t`t`tGame Mode Type: $VRisingGameModeType"
    Write-Host "`t`t`tGroup/Clan Size: $VRisingClanSize"
    Write-Host "`t`t`tSettings Descriptions and Min/Maxs: https://cdn.stunlock.com/blog/2022/05/25083113/Game-Server-Settings.pdf" -ForegroundColor DarkYellow
    Write-Host "`t`t`tTo make changes to your ServerGameSettings file, please issue the following command:" -ForegroundColor Magenta
    Write-Host "`t`t`tInvoke-Item $InstallPath\steamapps\common\VRisingDedicatedServer\save-data\Settings\ServerGameSettings.json"  -ForegroundColor DarkMagenta 

    Write-Host "`n`t`tAdminlist" -ForegroundColor Yellow
    Write-Host "`t`t`tTo modify the adminlist.txt, please issue the following command:" -ForegroundColor Magenta
    Write-Host "`t`t`tInvoke-Item $InstallPath\steamapps\common\VRisingDedicatedServer\VRisingServer_Data\StreamingAssets\Settings\adminlist.txt"  -ForegroundColor DarkMagenta 

    Write-Host "`n`t`tBanlist" -ForegroundColor Yellow
    Write-Host "`t`t`tTo modify the banlist.txt, please issue the following command:" -ForegroundColor Magenta
    Write-Host "`t`t`tInvoke-Item $InstallPath\steamapps\common\VRisingDedicatedServer\VRisingServer_Data\StreamingAssets\Settings\banlist.txt"  -ForegroundColor DarkMagenta 

    Write-Host "`n`tLogs" -ForegroundColor DarkCyan
    Write-Host "`t`tTo view your log file, please issue the following command:" -ForegroundColor Magenta
    Write-Host "`t`tInvoke-Item $InstallPath\steamapps\common\VRisingDedicatedServer\logs\VRisingServer.log" -ForegroundColor DarkMagenta 

    $ServerIPv4 = Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $(Get-NetConnectionProfile | Select-Object -ExpandProperty InterfaceIndex) | Select-Object -ExpandProperty IPAddress
    #$ServerIPv4 = (Get-NetIPAddress | Where-Object {$_.AddressState -eq "Preferred" -and $_.ValidLifetime -lt "24:00:00"}).IPAddress
    $ServerGateway = (Get-wmiObject Win32_networkAdapterConfiguration | ?{$_.IPEnabled}).DefaultIPGateway
    Write-Host "`n`tAction Plan" -ForegroundColor DarkCyan
    Write-Host "`t`t1) Test direct connect from a machine on this same network"
    Write-Host "`t`t`ta) Enter the game, and use Direct Connect, and connect to $ServerIPv4`:$VRisingGamePort"
    Write-Host "`t`t`tb) Do NOT select 'LAN Mode'"
    Write-Host "`t`t2) Configure your router at $ServerGateway and forward UDP port $VRisingGamePort and $VRisingQueryPort to this machine ($ServerIPv4)"
    Write-Host "`t`t`ta) Try http://portforward.com for information on how to port forward"
    Write-Host "`t`t3) If you have a hardware firewall, you will need to also allow the traffic to this machine ($ServerIPv4)"
    Write-Host "`t`t4) If you are behind a CGNAT or DS-Lite, you may not be able to host without a public IPv4 address"
    Write-Host "`t`t5) If you wish, you may change the daily restart and update time of the server from 09:00 local time to a more suitable time in Windows Task Scheduler"
}

ResizeConsole
ValidateInput
ValidatePorts
AdviseUserBeforeFullInstall
InstallNewServer
PostConfigureServer
AdviseUserAfterFullInstall











