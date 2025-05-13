- [VRising Server Manager](#vrising-server-manager)
  - [🖥️ Features](#️-features)
  - [💾 Download](#-download)
  - [📝 User Guide](#-user-guide)
- [📂 File Locations](#-file-locations)
  - [Dedicated Server](#dedicated-server)
  - [Private Server](#private-server)
  - [Client](#client)
- [🖥️ Server Management](#️-server-management)
  - [Installing the dedicated server using SteamCMD](#installing-the-dedicated-server-using-steamcmd)
    - [Dedicated Server Installation](#dedicated-server-installation)
    - [Dedicated Server Configuration](#dedicated-server-configuration)
      - [Manual Configuration](#manual-configuration)
        - [Server StartUp Batch File](#server-startup-batch-file)
        - [Server Settings Files](#server-settings-files)
        - [Allow the vRising game through the windows firewall](#allow-the-vrising-game-through-the-windows-firewall)
        - [Server Startup, Log Timestamps, and Restarting on Failure](#server-startup-log-timestamps-and-restarting-on-failure)
        - [Server updates](#server-updates)
  - [Post Configuration](#post-configuration)
    - [ServerHostSettings.json](#serverhostsettingsjson)
    - [ServerGameSettings.json](#servergamesettingsjson)
    - [ServerVoipSettings.json (VOIP Configuration)](#servervoipsettingsjson-voip-configuration)
      - [VOIP Troubleshooting](#voip-troubleshooting)
    - [Adding yourself to the adminlist.txt file](#adding-yourself-to-the-adminlisttxt-file)
    - [Configure your router to allow UDP ports to the server](#configure-your-router-to-allow-udp-ports-to-the-server)
  - [Troubleshooting](#troubleshooting)
    - [Log Variables](#log-variables)
    - [Specific Troubleshooting Instructions](#specific-troubleshooting-instructions)
      - [Troubleshooting Crashes due to JSON issues (out of range)](#troubleshooting-crashes-due-to-json-issues-out-of-range)
      - [Troubleshooting Direct Connection To the VRising Server](#troubleshooting-direct-connection-to-the-vrising-server)
        - [On the Internet](#on-the-internet)
      - [Server not listed on the server browser](#server-not-listed-on-the-server-browser)
- [General Instructions](#general-instructions)
  - [Enabling Console Access](#enabling-console-access)
  - [Direct Connect](#direct-connect)
  - [Intresting Admin Console Commands](#intresting-admin-console-commands)
- [Resources](#resources)
- [Patch Notes](#patch-notes)

# VRising Server Manager
I created a lightweight Windows GUI for installing, configuring and running your V Rising dedicated server, do note this is NOT endorsed by the studio, but after moderating the offical VRising discord, I tried to address some of the very common issues I've seen in my time volunteering there.

## 🖥️ Features

- **1 Click Install using SteamCMD**  
- **Service Management**  
  - Start service
  - Stop service
  - Edit NSSM-managed service
  - Direct access to Windows Task Manager
  - Direct access to Windows Firewall
- **Log Viewer**  
  - Highlights `ERROR` in red and `WARN` in orange  
  - Regex filter, `Pause Logs` toggle  
  - Configurable buffer (last N lines) & poll interval  
- **Gameplay Settings**
  - Host Settings
  - Game Settings
  - Quick links to official docs & PDF guides
  - VOIP Settings with built in template (`ServerVoipSettings.json`)
  - Adminlist (`adminlist.txt`)
  - Banlist (`banlist.txt`)
- **World Management**  
  - Show `/Saves/v4` folder  
  - Backup & Restore entire `save-data` directory as timestamped ZIP  
- **RCON**  
  - Launch `mcrcon.exe` with credentials read straight from your HostSettings JSON.
- **Network Verification**  
  - Jump to [portcheck.onrender.com](https://portcheck.onrender.com/) to confirm port forwarding.

## 💾 Download
Head over to Releases -- https://github.com/darryl-h/v-rising-server/releases

## 📝 User Guide
### Main Window: <!-- omit in toc -->
Within the Main UI, the main window is comprised of a server log viewer. This is a read-only, syntax-highlighted pane showing the last configurable N lines of the `VRisingServer.log` file.

These events are color coated:
* Red colored lines are for JSON parsing errors, error or fatal events, SaveOnExit events, GameBootstrap events or unsuccessful setting loads.
* Dark Orange colored lines are for warnings, ServerHostSettings, Final ServerGameSettings Values or bootstrap and server-creation events.
* Purple colored lines are for boot time, create or host server calls, file-user list or networking info.
* Cyan colored lines are for save related messages.
* Gray are for routine noise (PhysX, Entities, Debug, etc.)

Just above the log viewer is a log filter where you can type any regular expression to filter the displayed logs within the log view. 

Beside the regex filter there is a pause button which can be used to suspend the updating of the live log window which is helpful for copying the logs out, this button will change to "unpause logs" when the logs have been paused.

### Application Menu <!-- omit in toc -->
#### Configuration <!-- omit in toc -->
* Base Directory: where your VRising server lives (default C:\vrisingserver)
* Service Name: your NSSM service identifier (default VRisingServer-9876)
* Log Buffer Size: how many lines to show in the log window
* Log Poll Interval: how often (ms) to refresh logs
* Service Poll Interval: how often (ms) to check service status
* Update .bat Path: full path to your nightly update script
* Launcher .bat Path: path to a custom start script (if not using NSSM)
Click Save then OK. All values are written to vrising_manager_config.json.

### World Menu <!-- omit in toc -->
* Show Saves – opens …\Saves\v4
* Backup Saves – ZIP up your entire save-data folder
* Restore Saves – choose a ZIP, wipes & extracts, then restarts server

### Server Menu <!-- omit in toc -->
* Start/Stop Service – NSSM-managed Windows service
* Edit Service – invoke nssm.exe edit <service>
* Ban/Admin List – one-click open of banlist.txt & adminlist.txt
* Update – run your configured update_server.bat
* Start Standalone – run a custom launcher script if set
* RCON – launches mcrcon.exe with credentials from HostSettings
* Verify Network – opens [portcheck.onrender.com](https://portcheck.onrender.com/)
* Install – downloads & elevates the PowerShell installer from GitHub

### Common Workflows <!-- omit in toc -->
#### Fresh Server Install <!-- omit in toc -->
1) Click on Server
2) Click on Install
3) Choose install directory & (optional) ports.
4) Accept UAC prompt
5) Wait for SteamCMD to complete
6) Click on Application
7) Click on Configuration
8) Ensure that the Service Name is correct (Validate the service name in `services.msc`).
IF you used the installer, it will name the server `VRisingServer-[GAMEPORT]` IE: VRisingServer-9876.
9) Click on Server
10) Click on Start Service

#### Configuring VOIP <!-- omit in toc -->
* Server Configuration → VOIP Settings.
* If missing, the app creates ServerVoipSettings.json with a template.
* It then opens in Notepad—enter your credentials and save.

#### Backing Up & Restoring Worlds <!-- omit in toc -->
* Backup Saves:
* Creates YYYY-MM-DDTHHMM.zip in your Base Directory.

#### Restore Saves: <!-- omit in toc -->
* Stops service → choose a ZIP → wipes save-data → extracts → restarts service.

## ⚙️ Quick Start <!-- omit in toc -->

1. **Configure** your Base Directory & Service Name under **Application → Configuration**.  
2. **Install** the game server by clicking **Server → Install**, choosing an install path and (optionally) ports.  
3. **Start Service** under **Server**.  
4. Watch **Logs** stream in real time; filter, pause, or jump to bottom.  
5. Edit any JSON settings via the **Server Configuration** menu.  
6. Backup & restore worlds via **World**.

---
## 🎓 Tips & Troubleshooting <!-- omit in toc -->
- You do NOT need to have this application running all the time, in fact, you can discontinue it's use whenever you want.

- “Access Denied” when starting/stopping service?

The app will automatically prompt for UAC elevation only as needed.

- Logs not updating?

Increase LogPollInterval or check your PowerShell execution policy.

- Missing JSON templates?

The app will auto-generate Host, Game & VOIP JSON on first open.

# 📂 File Locations
## Dedicated Server
### Dedicated Server - Configuration <!-- omit in toc -->
  - :stop_sign: These may get overwritten with each update (UNSAFE!)
    - **Startup .bat file:** `<VAR_SERVER_INSTALLATION_DIRECTORY>`\steamapps\common\VRisingDedicatedServer\start_server_example.bat
    - **ServerHostSettings:** `<VAR_SERVER_INSTALLATION_DIRECTORY>`\VRisingServer_Data\StreamingAssets\Settings\ServerHostSettings.json
    - **ServerGameSettings:** `<VAR_SERVER_INSTALLATION_DIRECTORY>`\VRisingServer_Data\StreamingAssets\Settings\ServerGameSettings.json
  
  - :heavy_check_mark: These should survive server updates and rely on the `-persistentDataPath` parameter being set to `.\save-data` when launching the game
    - **Startup .bat file:** `.\vrisingserver\steamapps\common\VRisingDedicatedServer\start_server.bat`
    - **VOIP Configuration:** `.\vrisingserver\steamapps\common\VRisingDedicatedServer\save-data\Settings\ServerVoipSettings.json`
    - **AdminList:** `.\vrisingserver\steamapps\common\VRisingDedicatedServer\save-data\Settings\adminlist.txt`
    - **Banlist:** ``.\vrisingserver\steamapps\common\VRisingDedicatedServer\save-data\Settings\banlist.txt`
### Dedicated Server - Save Games <!-- omit in toc -->
  - These rely on the `-persistentDataPath` parameter being set to `.\save-data` when launching the game
  - These rely on the `-saveName` parameter being set to `world1` when launching the game
    - `.\vrisingserver\steamapps\common\VRisingDedicatedServer\save-data\Saves\v4\world1\AutoSave_NNNN.save.gz`
### Dedicated Server - Logs <!-- omit in toc -->
  - These rely on the `-logFile` parameter being set to `.\logs\VRisingServer.log` when launching the game
    - `.\vrisingserver\steamapps\common\VRisingDedicatedServer\logs\VRisingServer.log`

## Private Server
### Private Server - Configuration <!-- omit in toc -->
* If you do not have cloud saves enabled, it should live in:
`%USERPROFILE%\AppData\LocalLow\Stunlock Studios\VRising\Saves\v4\<GAME_UUID>`

* If you do have cloud saves enabled, it should live in:
`%USERPROFILE%\AppData\LocalLow\Stunlock Studios\VRising\CloudSaves\<STEAM_PLAYER_ID>\v4\<GAME_UUID>`
  
:spiral_notepad: You can see what's in your steam saves, by opening the following URL: https://store.steampowered.com/account/remotestorageapp/?appid=1604030

### Private Server - Save Games <!-- omit in toc -->
* If you do not have cloud saves enabled, it should live in:
%USERPROFILE%\AppData\LocalLow\Stunlock Studios\VRising\Saves\v4\<GAME_UUID>\AutoSave_NNNN.save.gz

* If you do have cloud saves enabled, it should live in:
%USERPROFILE%\AppData\LocalLow\Stunlock Studios\VRising\CloudSaves\<STEAM_PLAYER_ID>\v4\<GAME_UUID>\AutoSave_NNNN.save.gz
  
:spiral_notepad: You can see what's in your steam saves, by opening the following URL: https://store.steampowered.com/account/remotestorageapp/?appid=1604030

### Private Server - Logs <!-- omit in toc -->
- %USERPROFILE%\AppData\LocalLow\Stunlock Studios\VRising\Player-server.log

## Client
### Configuration <!-- omit in toc -->
  - **Console Profile** : %USERPROFILE%\AppData\LocalLow\Stunlock Studios\VRising\ConsoleProfile\`<VAR_MACHINE_NAME>`.prof
    * You should not modify this file directly!
### Client - Player Logs <!-- omit in toc -->
  * %USERPROFILE%\AppData\LocalLow\Stunlock Studios\VRising\Player.log
### Client - Settings <!-- omit in toc -->
  * %USERPROFILE%\AppData\LocalLow\Stunlock Studios\VRising\Settings\ClientSettings.json

# 🖥️ Server Management
## Installing the dedicated server using SteamCMD
This section is related, and specific to the Dedicated Server that you would start from outside the game client.

- [VRising Server Manager](#vrising-server-manager)
  - [🖥️ Features](#️-features)
  - [💾 Download](#-download)
  - [📝 User Guide](#-user-guide)
- [📂 File Locations](#-file-locations)
  - [Dedicated Server](#dedicated-server)
  - [Private Server](#private-server)
  - [Client](#client)
- [🖥️ Server Management](#️-server-management)
  - [Installing the dedicated server using SteamCMD](#installing-the-dedicated-server-using-steamcmd)
    - [Dedicated Server Installation](#dedicated-server-installation)
    - [Dedicated Server Configuration](#dedicated-server-configuration)
      - [Manual Configuration](#manual-configuration)
        - [Server StartUp Batch File](#server-startup-batch-file)
        - [Server Settings Files](#server-settings-files)
        - [Allow the vRising game through the windows firewall](#allow-the-vrising-game-through-the-windows-firewall)
        - [Server Startup, Log Timestamps, and Restarting on Failure](#server-startup-log-timestamps-and-restarting-on-failure)
        - [Server updates](#server-updates)
  - [Post Configuration](#post-configuration)
    - [ServerHostSettings.json](#serverhostsettingsjson)
    - [ServerGameSettings.json](#servergamesettingsjson)
    - [ServerVoipSettings.json (VOIP Configuration)](#servervoipsettingsjson-voip-configuration)
      - [VOIP Troubleshooting](#voip-troubleshooting)
    - [Adding yourself to the adminlist.txt file](#adding-yourself-to-the-adminlisttxt-file)
    - [Configure your router to allow UDP ports to the server](#configure-your-router-to-allow-udp-ports-to-the-server)
  - [Troubleshooting](#troubleshooting)
    - [Log Variables](#log-variables)
    - [Specific Troubleshooting Instructions](#specific-troubleshooting-instructions)
      - [Troubleshooting Crashes due to JSON issues (out of range)](#troubleshooting-crashes-due-to-json-issues-out-of-range)
      - [Troubleshooting Direct Connection To the VRising Server](#troubleshooting-direct-connection-to-the-vrising-server)
        - [On the Internet](#on-the-internet)
      - [Server not listed on the server browser](#server-not-listed-on-the-server-browser)
- [General Instructions](#general-instructions)
  - [Enabling Console Access](#enabling-console-access)
  - [Direct Connect](#direct-connect)
  - [Intresting Admin Console Commands](#intresting-admin-console-commands)
- [Resources](#resources)
- [Patch Notes](#patch-notes)

### Dedicated Server Installation

#### Installation of the server using the AutoInstaller <!-- omit in toc -->
I created a quick PowerShell script that will automate the installation of the V Rising Server, and configuration of the service. This can be found in this repository called `autoinstall_vrising.ps1`

This will attempt to:
* Validate that the requested ports are not in use
* Validate your network to see if you can host properly
* Validate the installation path
* Download SteamCMD
* Download the Non Sucking Service Manager (NSSM)
* Install the VRising Dedicated Server into a path you desire with SteamCMD
* Configure the server to use the configurations in a custom directory that will survive a server update
* Create a custom update .bat file
* Use NSSM to manage the server, which will create a VRising service, keep logs indefinatly, add timestamps to the logs, and restart the server if it crashes
* Enable RCON
* Install an RCON client to broadcast the restart to the users on the server
* Open the Windows firewall for the VRising Server
* Schedule a restart daily at 09:00 to update the server automatically

If this sounds like something you would like, and you have [PowerShell v5](https://docs.microsoft.com/en-us/powershell/scripting/windows-powershell/install/windows-powershell-system-requirements?view=powershell-7.2#windows-powershell-51) you can install it using these `4` steps:

1. Start an `administrator` command prompt (`cmd`)
2. type `powershell`
3. type `Invoke-WebRequest -Uri https://raw.githubusercontent.com/darryl-h/v-rising-server/main/autoinstall_vrising.ps1 -OutFile .\autoinstall_vrising.ps1`
4. type `powershell -ExecutionPolicy Bypass -File .\autoinstall_vrising.ps1 C:\vrisingserver`  
  :spiral_notepad: Change `C:\vrisingserver` to the `full path` of the location where you want to install the server.  
  :spiral_notepad: You can also specify `-gameport <game_port_#>` , `-queryport <query_port_#>` and `-rconport <rcon_port_#>` if you wish. If you do not specify a different port, it will be installed using the default ports.

Before installation, the user is provided a message of what **should** happen:  
```
[Validation - Paths]
        Validating user supplied path
                * User supplied path looks OK

[Validation - Networking]
        Validating user supplied game port (UDP: 9876)
                * RCON port looks OK
        Validating user supplied query port (UDP: 9877)
                * Query port looks OK
        Validating user supplied RCON port (TCP: 25575)
                * RCON port looks OK
        Validating Routing
                * Routing looks OK

[Prepare for full installation]
        This script will:
                * Install the VRising Dedicated Server into c:\vrisingserver with SteamCMD
                * Configure the server to use the configurations in a custom directory that will survive a server update
                * Create a custom update .bat file
                * Install NSSM to manage the server which will:
                        > Start with Windows
                        > Restart the server if it crashes
                        > Add UTC timestamps to the logs
                        > Keep logs indefinatly
                * Enable RCON
                * Install an RCON client to broadcast the restart to the users on the server
                * Open the Windows firewall for the VRising Server
                * Schedule a restart daily at 09:00 to update the server automatically
Press any key to continue or CTRL+C to quit:
```

During installation, each step is documented
```
[Installing V Rising]
        Preparing the Non Sucking Service Manager (NSSM)
                * Downloading the Non Sucking Service Manager (NSSM)
                * Extracting nssm-2.24-101-g897c7ad.zip
                * Moving the 64 bit version of NSSM
                * Removing NSSM archive
        Preparing mcrcon
                * Downloading mcrcon
                * Extracting mcrcon-0.7.2-windows-x86-64.zip
        Preparing SteamCMD
                * Downloading SteamCMD
                * Extracting steamcmd.zip
        Installing VRising Dedicated Server
                * Validating installation
                * Creating logs directory
        Configuring Server
                * Configuring Game and Host Settings that won't get replaced on update
                * Enabling RCON with password: KgsYy3q2
                * Confiuring VRsingServer Service with NSSM
                * Configuring Task Scheudler to reboot and update daily at 09:00AM
                * Creating daily update .bat file
                * Configuring Windows Firewall
                * Starting the VRising service
        All Done!
```

After installation, the user is provided with all the information to manage the service
```
[IMPORTANT INFORMATION - READ THIS]

        Management
                * Your Update .bat file is in c:\vrisingserver\steamapps\common\VRisingDedicatedServer\update_server.bat
                * Your can manage the service normally with 'services.msc' or with c:\vrisingserver\nssm.exe [start|stop|restart|edit] VRisingServer-9876

        Configuration Files
                ServerHostSettings

                ServerGameSettings
                        Game Name: V Rising Server
                        Maximum Connected Users: 40
                        Game Port: 9876
                        Query Port: 9877
                        Saves: c:\vrisingserver\steamapps\common\VRisingDedicatedServer\save-data\Saves\v1\world1
                        To migrate your existing world, issue the following command to open the save directory:
                        Invoke-Item c:\vrisingserver6\steamapps\common\VRisingDedicatedServer\save-data\Saves\v1\world1\
                        Auto Save Count: 50
                        Auto Save Interval (In Seconds): 600
                        RCON Password: KgsYy3q2
                        To make changes to your ServerHostSettings file, please issue the following command:
                        Invoke-Item c:\vrisingserver6\steamapps\common\VRisingDedicatedServer\save-data\Settings\ServerHostSettings.json
                        Game Description:
                        Game Mode Type: PvP
                        Group/Clan Size: 4
                        Settings Descriptions and Min/Maxs: https://cdn.stunlock.com/blog/2022/05/25083113/Game-Server-Settings.pdf
                        To make changes to your ServerGameSettings file, please issue the following command:
                        Invoke-Item c:\vrisingserver\steamapps\common\VRisingDedicatedServer\save-data\Settings\ServerGameSettings.json

                Adminlist
                        To modify the adminlist.txt, please issue the following command:
                        Invoke-Item c:\vrisingserver\steamapps\common\VRisingDedicatedServer\VRisingServer_Data\StreamingAssets\Settings\adminlist.txt

                Banlist
                        To modify the banlist.txt, please issue the following command:
                        Invoke-Item c:\vrisingserver\steamapps\common\VRisingDedicatedServer\VRisingServer_Data\StreamingAssets\Settings\banlist.txt

        Logs
                To view your log file, please issue the following command:
                Invoke-Item c:\vrisingserver\steamapps\common\VRisingDedicatedServer\logs\VRisingServer.log

        Action Plan
                1) Test direct connect from a machine on this same network
                        a) Enter the game, and use Direct Connect, and connect to 192.168.1.10:9876
                        b) Do NOT select 'LAN Mode'
                2) Configure your router at 192.168.1.254 and forward UDP port 9876 and 9877 to this machine (192.168.1.10)
                        a) Try http://portforward.com for information on how to port forward
                3) If you have a hardware firewall, you will need to also allow the traffic to this machine (192.168.1.10)
                4) If you are behind a CGNAT or DS-Lite, you may not be able to host without a public IPv4 address
                5) If you wish, you may change the daily restart and update time of the server from 09:00 local time to a more suitable time in Windows Task Scheduler
```
Once complete, you can skip to the [Post Configuration](#post-configuration) of the server

#### Installation of the server using PowerShell and SteamPS <!-- omit in toc -->
We will assume that you want to install the server in `C:\servers\v_rising` (This will be <VAR_SERVER_INSTALLATION_DIRECTORY> in the rest of this document) if you do not, change the path in the following commands.

We will install the PowerShell module for SteamCLI to install and update the server.
```powershell
Install-Module -Name SteamPS
Install-SteamCMD
Update-SteamApp -ApplicationName 'V Rising Dedicated Server' -Path 'C:\servers\v_rising'
```  
:spiral_notepad: Any questions should be answered with yes

### Dedicated Server Configuration

#### Manual Configuration
If you want to manually setup everything instead of using the auto installer, you can follow these steps:

##### Server StartUp Batch File
* Copy the `<VAR_SERVER_INSTALLATION_DIRECTORY>\start_server_example.bat` to a new file (I called mine `<VAR_SERVER_INSTALLATION_DIRECTORY>\start_server.bat`)
Inside the file, change the serverName (`My Cool Server`) and the -saveName (`coolServer1`)

  ```batch
  @echo off
  REM Copy this script to your own file and modify to your content. This file can be overwritten when updating.
  set SteamAppId=1604030
  echo "Starting V Rising Dedicated Server - PRESS CTRL-C to exit"

  @echo on
  VRisingServer.exe -persistentDataPath .\save-data -serverName "My Cool Server" -saveName "coolServer1"
  ```
In this case, we are removing the `-logFile ".\logs\VRisingServer.log` line from the logs, we will use this later with NSSM to give us timestamps and log file rotation. Huzzah!

##### Server Settings Files
1. Create the directory `<VAR_SERVER_INSTALLATION_DIRECTORY>\save-data\Settings`
2. Copy and paste `ServerHostSettings.json` and `ServerGameSettings.json` files from `<VAR_SERVER_INSTALLATION_DIRECTORY>/VRisingServer_Data/StreamingAssets/Settings/` into the directory you created in step 1
  
:spiral_notepad: If you elect to directly modify the configuration files in `<VAR_SERVER_INSTALLATION_DIRECTORY>\VRisingServer_Data\StreamingAssets\Settings\` you may loose your configuration changes with new updates, so you may want to consider backing them up.

##### Allow the vRising game through the windows firewall
You may need to allow the executable (VRisingServer.exe) through the windows firewall

##### Server Startup, Log Timestamps, and Restarting on Failure
This will add timestamps, restart the service if crashes, and sets up the server to start the service when the machine starts up, oh my!

In this example, we will setup the server with NSSM (Non Sucking Service Manager)

1) Download the NSSM archive from the nssm webpage (https://nssm.cc/download)
2) Extract the NSSM program, and place `nssm.exe` into a the game directory
3) Drop to a `cmd` prompt (`Start` -> `Run` -> `cmd`)
4) Enter the NSSM directory and create the service.
    ```dos
    cd <VAR_SERVER_INSTALLATION_DIRECTORY>
    nssm.exe removeVRisingServer-9876 confirm
    nssm.exe install VRisingServer-9876 VRisingServer-9876
    nssm.exe set VRisingServer-9876 Application <VAR_SERVER_INSTALLATION_DIRECTORY>\start_server.bat
    nssm.exe set VRisingServer-9876 AppDirectory <VAR_SERVER_INSTALLATION_DIRECTORY>
    nssm.exe set VRisingServer-9876 AppExit Default Restart
    nssm.exe set VRisingServer-9876 AppStdout <VAR_SERVER_INSTALLATION_DIRECTORY>\logs\VRisingServer.log
    nssm.exe set VRisingServer-9876 AppStderr <VAR_SERVER_INSTALLATION_DIRECTORY>\logs\VRisingServer.log
    nssm.exe set VRisingServer-9876 AppStopMethodSkip 14
    nssm.exe set VRisingServer-9876 AppKillProcessTree 0
    nssm.exe set VRisingServer-9876 AppTimestampLog 1
    nssm.exe set VRisingServer-9876 DisplayName VRisingServer-9876
    nssm.exe set VRisingServer-9876 ObjectName LocalSystem
    nssm.exe set VRisingServer-9876 Start SERVICE_AUTO_START
    nssm.exe set VRisingServer-9876 Type SERVICE_WIN32_OWN_PROCESS
    ```
    or you can tell NSSM to call the `VRisingServer.exe` directly:
    ```dos
    cd <VAR_SERVER_INSTALLATION_DIRECTORY>
    nssm.exe remove VRisingServer-9876 confirm
    nssm.exe install VRisingServer-9876 VRisingServer-9876
    nssm.exe set VRisingServer-9876 Application <VAR_SERVER_INSTALLATION_DIRECTORY>\VRisingServer.exe
    nssm.exe set VRisingServer-9876 AppParameters "-persistentDataPath .\save-data"
    nssm.exe set VRisingServer-9876 AppDirectory <VAR_SERVER_INSTALLATION_DIRECTORY>
    nssm.exe set VRisingServer-9876 AppExit Default Restart
    nssm.exe set VRisingServer-9876 AppEnvironmentExtra ":set SteamAppId=1604030"
    nssm.exe set VRisingServer-9876 AppStdout <VAR_SERVER_INSTALLATION_DIRECTORY>\logs\VRisingServer.log
    nssm.exe set VRisingServer-9876 AppStderr <VAR_SERVER_INSTALLATION_DIRECTORY>\logs\VRisingServer.log
    nssm.exe set VRisingServer-9876 AppStopMethodSkip 14
    nssm.exe set VRisingServer-9876 AppKillProcessTree 0
    nssm.exe set VRisingServer-9876 AppTimestampLog 1
    nssm.exe set VRisingServer-9876 DisplayName VRisingServer-9876
    nssm.exe set VRisingServer-9876 ObjectName LocalSystem
    nssm.exe set VRisingServer-9876 Start SERVICE_AUTO_START
    nssm.exe set VRisingServer-9876 Type SERVICE_WIN32_OWN_PROCESS
    ```

5) Start the service now
    ```dos
    cd <VAR_SERVER_INSTALLATION_DIRECTORY>
    nssm start VRisingServer-9876
    ```

##### Server updates
We will place the `update.bat` file with the startup batch file in the `<VAR_SERVER_INSTALLATION_DIRECTORY>`, we will also announce to the players we are doing this with mcrcon (https://github.com/Tiiffi/mcrcon/releases/) which we will place in the server directory as well for ease of access. 

:spiral_notepad: In either case, you will need to update the path to the server by replacing any line with `C:\servers\v_rising` with the correct path for your server.

###### With SteamPS <!-- omit in toc -->
`update.bat`
```dos
@echo off
echo "Sending message to the server, restart will occur in 10 minutes"
mcrcon.exe -H 127.0.0.1 -P <RCON_PORT> -p <RCON_PASSWORD> "announcerestart 10"
timeout 600
echo "Stopping the VRising server"
C:\servers\v_rising\nssm.exe stop vrisingserver
echo "Waiting for 60 seconds for the server to go down"
timeout 60
echo "Updating the server (if needed)"
ECHO Y | powershell Update-SteamApp -ApplicationName 'V Rising Dedicated Server' -Path 'C:\servers\v_rising'
echo "Waiting for the update to complete (5 minutes)"
timeout 600
echo "Starting the server"
C:\servers\v_rising\nssm.exe start vrisingserver
```

###### With SteamCMD <!-- omit in toc -->
`update.bat`
```dos
@echo off
echo "Sending message to the server, restart will occur in 10 minutes"
mcrcon.exe -H 127.0.0.1 -P <RCON_PORT> -p <RCON_PASSWORD> "announcerestart 10"
timeout 600
echo "Stopping the VRising server"
C:\servers\v_rising\nssm.exe stop vrisingserver
echo "Waiting for 60 seconds for the server to go down"
timeout 60
echo "Updating the server (if needed)"
steamcmd.exe +login anonymous +app_update 1829350 validate +quit
echo "Waiting for the update to complete (5 minutes)"
timeout 600
echo "Starting the server"
C:\servers\v_rising\nssm.exe start vrisingserver
```
You can also add `+force_install_dir "C:\Path\To\v_rising_server\"` to the `SteamCMD` executable.

###### Automating updates with Windows Task Scheulder <!-- omit in toc -->
* Create a `Basic Task`
* Name it `Update V-Rising Server`
* Click `Next`
* In the `When do you want the task to start` radio box, select `Daily`
* Click `Next`
* Beside the `Start:` Field, select todays date, and a time when you want the update to happen (Usually a time when users may not be playing, like 09:00 AM EST))
* Ensure that the `Recur Every` is set to `1`
* Click `Next`
* In the `What action do you want the task to perform` radio box, select `Start a program`
* Click `Next`
* Beside the `Program/Script:` field, click `Browse...` and find the customized `update.bat` we created earlier
* Click `Next`
* Click `Finish`

## Post Configuration
Weather or not you are using the auto installer or the manual steps, the following final configuration steps may be required.

### ServerHostSettings.json

#### Description <!-- omit in toc -->
In `Description` field, you can use line breaks using `\n`

#### Address <!-- omit in toc -->
In the `Address` field, if you set this to a local address (192.168.1.X or 10.X.X.X) this will cause the server and RCON to only listen on this address. This is useful if you have more than one interface or are using a VPN and want to bind the server and RCON to a single IP.
:warning: If you set this address, you will need to adjust your RCON commands to use the server IP, rather than the local loopback address as it will not be listening on the loopback address anymore!

```
netstat -aon | find "19280"
  TCP    192.168.1.10:25575          0.0.0.0:0              LISTENING       19280
```

### ServerGameSettings.json
You can get more information (min/max) and descriptions on each setting using this PDF: https://cdn.stunlock.com/blog/2022/05/25083113/Game-Server-Settings.pdf

If you need assistnace with how these should be formatted, you can check `<VAR_SERVER_INSTALLATION_DIRECTORY>\VRisingServer_Data\StreamingAssets\GameSettingPresets` IE: `C:\vrisingserver\steamapps\common\VRisingDedicatedServer\VRisingServer_Data\StreamingAssets\GameSettingPresets` usually the `Level70PvE.json` or the `Level70PvP.json` files will have the syntax

#### VBloodUnitSettings <!-- omit in toc -->
There is some confusion about configuring the `VBloodUnitSettings` this is an example:

```json
"VBloodUnitSettings": [
    {
      "UnitId": -1905691330,
      "UnitLevel": 16,
      "DefaultUnlocked": true
    },
    {
      "UnitId": 1124739990,
      "UnitLevel": 20,
      "DefaultUnlocked": true
    }
]
```

### ServerVoipSettings.json (VOIP Configuration)
Be advised this is 100% unsupported!
Version 1.1

1)	Create an account on Unity at [https://dashboard.unity.com/](https://cloud.unity.com/home/login)
2)	Click on `Create account`
3)	Create your account
4)	In the left hand menu under `My Organizations` click `Create`
5)	Click `+ Create`
6)	Set the `Organization name` to something meaningful, like `Darryls V Rising Voice Services` (This needs to be globally unique!)
7)	Set the `Industry` to `Gaming`
8)	Click `Create`
9)	Click on the new organization
10)	In the left menu, click on `Project integrations`
11)	Set the `Project name` to something meaningful, like `Server 01 - Voice Services`
12)	Click `Create`
13)	Scroll down, and beside `Vivox Voice and Text Chat` click `Launch`
14)	Click on `Launch` in the top right
15)	Click `Next`
16)	Click `Next`
17)	Click `Next`
18)	Click `Finsh`
19)	In the second left menu, under `Voice and Text Chat` click on `Credentials`
20)	Find the 4 bits of the credentials we need which are:  
`Server` -> `VOIPAPIEndpoint`  
`Domain` -> `VOIPVivoxDomain`  
`Token Issuer` -> `VOIPIssuer`  
`Token Key` -> `VOIPSecret`  
21)	Use these to 4 pieces to generate your own `\VRisingDedicatedServer\save-data\Settings\ServerVoipSettings.json` file (You can copy and paste this, just change the values. These credentials will not work.)
```json
{
    "VOIPEnabled": true,
  	"VOIPAPIEndpoint": "https://mtu1xp-mad.vivox.com",
    "VOIPVivoxDomain": "mtu1xp.vivox.com",
    "VOIPIssuer": "35740-v_ris-20710-udash",
    "VOIPSecret": "hT2XIhzCEBBApkLFxyMTN4UqerdCfi1N",
    "VOIPConversationalDistance": 14,
    "VOIPAudibleDistance": 40,
    "VOIPFadeIntensity": 2.0
}
```

#### VOIP Troubleshooting
##### Problem Description: Can't keep VOIP enabled <!-- omit in toc -->
- Symptoms: 
  - The VOIP option (`Options` -> `Sound` -> `Use Voice Chat`) may be forced into an off state after you have set it it on
  - You see the message `Nearby players are only displayed when connected to voice chat` 
  - In the client logs you may see `<Login>b__0: vx_req_account_anonymous_login_t failed: VivoxUnity.VivoxApiException: Access Token Expired (20121)`
  * Unfortunatly the developer page isn't helpful here: https://docs.vivox.com/v5/general/unity/15_1_170000/en-us/Unity/developer-guide/error-codes.htm
  * https://support.vivox.com/hc/en-us/articles/360015368274-What-causes-VxAccessTokenExpired-20121-errors-
- Resolution
  - Time on the server must be sycned (This is NOT the same as the Time Zone!) even a few seconds drift can cause the problem to manifest. 
  - In general you should use `NTP` to sync time on the server and sync the server manually to start

##### Problem Description: Can't keep VOIP enabled <!-- omit in toc -->
- Symptoms: 
  - The VOIP option (`Options` -> `Sound` -> `Use Voice Chat`) may be forced into an off state after you have set it it on
  - In the client logs you may see `LoginSession: Invalid State - must be logged out to perform this operation.`
- Resolution
  - The Vivox account is not functioning correctly. You may want to create a new project.

##### VOIP Logs <!-- omit in toc -->
Expected/Successful VOIP logs can be found in the [VOIP](#voip) log section.

### Adding yourself to the adminlist.txt file
In the logs, you should see the `adminlist.txt` and `banlist.txt` lists loaded, and thier path is `<VAR_SERVER_INSTALLATION_DIRECTORY>\VRisingServer_Data\StreamingAssets\Settings\`  
:spiral_notepad: This is the only valid place for these entires!

* You will need to restart the server to reload any changes to these files (They SHOULD get picked up automatically, but unclear)

### Configure your router to allow UDP ports to the server
If you wish your server to be listed on the in game server browser, and people to connect from the internet, you will need to open two UDP ports to the server. 
These ports are configured in the `<VAR_SERVER_INSTALLATION_DIRECTORY>\save-data\Settings\ServerHostSettings.json` file. 

```json
"Port": 9876,
"QueryPort": 9877,
```
  
:spiral_notepad: This is beyond the scope of this document, as it is device specific, but you can try https://PortForward.com for help with your specific device/brand

## Troubleshooting
You should review the logs of the server to begin any troubleshooting session.

### Log Variables
<VAR_SERVER_INSTALLATION_DIRECTORY> - The directory where the game is installed
<VAR_PLAYER_STEAM_ID> - Steam Player ID  
<VAR_PUBLIC_IP> - Server Public IP  
<VAR_SERVERNAME> - The name of the server
<VAR_VOIPAPIEndpoint> - The `VOIPAPIEndpoint` from your ServerVoipSettings.json file  
<VAR_VOIPAppUserId> - The `VOIPAppUserId` from your ServerVoipSettings.json file  
<VAR_VOIPAppUserPwd> - The `VOIPAppUserPwd` from your ServerVoipSettings.json file  
<VAR_VOIPVivoxDomain> - The `VOIPVivoxDomain` from your ServerVoipSettings.json file  
<VAR_PLAYER_PUBLIC_IP> - The public IP of the player  
<VAR_RCON_PASSWORD> - The RCON password

### Specific Troubleshooting Instructions

#### Troubleshooting Crashes due to JSON issues (out of range)
In the logs you may see something similar to this:
```
OverflowException: Value was either too large or too small for an unsigned byte.
  at System.Convert.ToByte (System.Int32 value) [0x00000] in <00000000000000000000000000000000>:0 
  at System.Convert.ChangeType (System.Object value, System.Type conversionType, System.IFormatProvider provider) [0x00000] in <00000000000000000000000000000000>:0 
  at Newtonsoft.Json.Serialization.JsonSerializerInternalReader.EnsureType (Newtonsoft.Json.JsonReader reader, System.Object value, System.Globalization.CultureInfo culture,
```

If you go futher down, you will see this (Look for `JsonSerializationException`):
```
Rethrow as JsonSerializationException: Error converting value 350 to type 'System.Byte'. Path 'CastleStatModifiers_Global.HeartLimits.Level4.FloorLimit', line 177, position 25.
```


#### Troubleshooting Direct Connection To the VRising Server
The first step is to ensure that the game is accessible to machines on the same network as the server is running on.

1) On the server, find the PID of the `VRisingServer.exe` in `Task Manager` in the `Details` tab  
  
2) Check your server configuration file `ServerHostSettings.json` we are looking for `Port`, `QueryPort`, and optionally `Rcon/Port`  
:spiral_notepad: If you are hosting a private server, check the `%USERPROFILE%\AppData\LocalLow\Stunlock Studios\VRising\Player-server.log` log for `Port` and `QueryPort` as shown below.
```json
Loaded ServerHostSettings:
{
  "Name": "My Awesome World",
  "Description": "",
  "Port": 9876,
  "QueryPort": 9877
}
```
3) Check to ensure the server is listening on the expected ports:
  * With CMD
    * Run Start -> Run -> `cmd`
    * Type `tasklist /fi "imagename eq VRisingServer.exe"`
      ```
      > tasklist /fi "imagename eq VRisingServer.exe"
      Image Name                     PID Session Name        Session#    Mem Usage
      ========================= ======== ================ =========== ============
      VRisingServer.exe            21744 Services                   0    810,836 K
      ```
      In the example above, we see that the PID is 21744, we will use that in the following command.
        * You can also find the PID of the `VRisingServer.exe` in `Task Manager` (`control` + `shift` + `esc`) in the `Details` tab
    * Type `netstat -aon | find "<PID>"` where \<PID\> is the PID of the server
    * You will see some additional ports, this is OK)
      ```
      > netstat -aon | find "21744"
      TCP    0.0.0.0:9090           0.0.0.0:0              LISTENING       21744
      TCP    0.0.0.0:25575          0.0.0.0:0              LISTENING       21744
      TCP    127.0.0.1:9090         127.0.0.1:25001        ESTABLISHED     21744
      TCP    127.0.0.1:21525        0.0.0.0:0              LISTENING       21744
      TCP    127.0.0.1:21539        127.0.0.1:21540        ESTABLISHED     21744
      TCP    127.0.0.1:21540        127.0.0.1:21539        ESTABLISHED     21744
      TCP    192.168.1.10:21531     162.254.193.103:27018  ESTABLISHED     21744
      TCP    192.168.1.10:24984     34.149.140.203:443     ESTABLISHED     21744
      UDP    0.0.0.0:9876           *:*                                    21744
      UDP    0.0.0.0:9877           *:*                                    21744
      UDP    0.0.0.0:63326          *:*                                    21744
      ```
      In the example above, we see that the game is running on port 9876 and the query port is running on port 9877 (b/c UDP), we also see that RCON is running on 9090 (b/c TCP)

  * With PowerShell
    * run `cmd`
    * run `powershell`
    * Issue the command `(Get-NetTCPConnection)+(Get-NetUDPEndpoint) | Where {$_.LocalAddress -eq "0.0.0.0"} | select LocalAddress,LocalPort,@{Name="Process";Expression={(Get-Process -Id $_.OwningProcess).ProcessName}} | Where-Object {$_.Process -Match 'VRisingServer'}`
    * You will see some additional ports, this is OK)
      ```
        LocalAddress LocalPort Process
        ------------ --------- -------
        0.0.0.0          56584 VRisingServer
        0.0.0.0          56583 VRisingServer
        0.0.0.0          55998 VRisingServer
        0.0.0.0          55988 VRisingServer
        0.0.0.0           9876 VRisingServer
        0.0.0.0          57628 VRisingServer
        0.0.0.0           9877 VRisingServer
        0.0.0.0           9876 VRisingServer
        ```

3) Ensure that the game is allowed through the Windows Firewall, if you have added the executable to the windows firewall (rather than just the `Port` and `QueryPort` configured in `ServerHostSettings.json`), then you can run `powershell Get-NetFirewallRule -DisplayName VRisingServer` at the command prompt to validate:

    ```
    powershell Get-NetFirewallRule -DisplayName VRisingServer

    Name                          : {45A9AE05-8C9A-4B70-8A16-78A46AE136CB}
    DisplayName                   : VRisingServer
    Description                   :
    DisplayGroup                  :
    Group                         :
    Enabled                       : True
    Profile                       : Public
    Platform                      : {}
    Direction                     : Inbound
    Action                        : Allow
    EdgeTraversalPolicy           : Block
    LooseSourceMapping            : False
    LocalOnlyMapping              : False
    Owner                         :
    PrimaryStatus                 : OK
    Status                        : The rule was parsed successfully from the store. (65536)
    EnforcementStatus             : NotApplicable
    PolicyStoreSource             : PersistentStore
    PolicyStoreSourceType         : Local
    RemoteDynamicKeywordAddresses : {}

    Name                          : {3763C3ED-0116-4831-94D7-9496A597A395}
    DisplayName                   : VRisingServer
    Description                   :
    DisplayGroup                  :
    Group                         :
    Enabled                       : True
    Profile                       : Public
    Platform                      : {}
    Direction                     : Inbound
    Action                        : Allow
    EdgeTraversalPolicy           : Block
    LooseSourceMapping            : False
    LocalOnlyMapping              : False
    Owner                         :
    PrimaryStatus                 : OK
    Status                        : The rule was parsed successfully from the store. (65536)
    EnforcementStatus             : NotApplicable
    PolicyStoreSource             : PersistentStore
    PolicyStoreSourceType         : Local
    RemoteDynamicKeywordAddresses : {}

    Name                          : {1258BCC4-EDA6-4BA7-B14B-20C46AC0B2ED}
    DisplayName                   : VRisingServer
    Description                   :
    DisplayGroup                  :
    Group                         :
    Enabled                       : False
    Profile                       : Domain
    Platform                      : {}
    Direction                     : Inbound
    Action                        : Allow
    EdgeTraversalPolicy           : Block
    LooseSourceMapping            : False
    LocalOnlyMapping              : False
    Owner                         :
    PrimaryStatus                 : OK
    Status                        : The rule was parsed successfully from the store. (65536)
    EnforcementStatus             : NotApplicable
    PolicyStoreSource             : PersistentStore
    PolicyStoreSourceType         : Local
    RemoteDynamicKeywordAddresses : {}

    Name                          : {3CBD268D-F077-4549-81BA-375C35A8D2AD}
    DisplayName                   : VRisingServer
    Description                   :
    DisplayGroup                  :
    Group                         :
    Enabled                       : False
    Profile                       : Domain
    Platform                      : {}
    Direction                     : Inbound
    Action                        : Allow
    EdgeTraversalPolicy           : Block
    LooseSourceMapping            : False
    LocalOnlyMapping              : False
    Owner                         :
    PrimaryStatus                 : OK
    Status                        : The rule was parsed successfully from the store. (65536)
    EnforcementStatus             : NotApplicable
    PolicyStoreSource             : PersistentStore
    PolicyStoreSourceType         : Local
    RemoteDynamicKeywordAddresses : {}
    ```
    **NOTE:** As a troubleshooting step, you may disable the Windows Firewall, but turn it back on when you are done, and correctly configure it if it is the problem.

4) [Direct Connect](#direct-connect) to the game on the `Port` configured in `ServerHostSettings.json` (Not the `QueryPort` port! -- IE: 192.168.1.10:9876)

##### On the Internet

5) Check your `VRisingServer.log` server logs inside the appropriate directory for the public IP, the logs should look like this: `SteamPlatformSystem - OnPolicyResponse - Public IP: <VAR_PUBLIC_IP>` and ensure this is the public IP you expect it to be 
    ```
    SteamPlatformSystem - OnPolicyResponse - Public IP: <VAR_PUBLIC_IP>
    UnityEngine.Logger:Log(LogType, Object)
    UnityEngine.Debug:Log(Object)
    ProjectM.Auth.SteamPlatformSystem:OnPolicyResponse(GSPolicyResponse_t)
    Steamworks.DispatchDelegate:Invoke(T)
    Steamworks.Callback`1:OnRunCallback(IntPtr)
    Steamworks.CallbackDispatcher:RunFrame(Boolean)
    ProjectM.Auth.SteamPlatformSystem:OnUpdate()
    Unity.Entities.SystemBase:Update()
    Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
    Unity.Entities.ComponentSystem:Update()
    Unity.Jobs.LowLevel.Unsafe.PanicFunction_:Invoke()
    ```  
    :spiral_notepad: You can also use tools like [whatismyip.com](https://www.whatismyip.com/) to get your public IP, but this doesn't ensure the server is bound to this public IP, This is especially useful if you have a VPN or secondary internet provider.

6) Open your router and firewall to allow the `Port` and `QueryPort` configured in `ServerHostSettings.json` to forward to this machine (and TCP if you want RCON)
This is beyond the scope of this document, as it is device specific, but you can try https://PortForward.com

7) Validate with your internet provider if you are able to run servers (specifically game servers) from your purchased internet package. They may block this kind of traffic by blocking specific ports, or using packet inspection to determine the type of traffic. (This is beyond the scope of this document).  
If you check https://ipv6-test.com/ and the shown IP on that web page is different from your address shown in your router, your address may be translated and it may be impossible to host. Additionally some providers (namely in Germany) may use something like Carrier Grade NAT (CGNAT, with a router public IP range from 100.64.0.0 to 100.127.255.255) or DS-Lite which may prevent you from running a server. In these cases, you can try to contact your ISP and see if you are able to get an IPv4 address. You *may* be able to get away with something like Fast Reverse Proxy (https://gabrieltanner.org/blog/port-forwarding-frp) but this is again, outside the scope of this document.

#### Server not listed on the server browser
1) Check `https://www.battlemetrics.com/servers/vrising` and see if your server is listed there, if so, your setup appears to be configured correctly, the only thing left to do is to BE PATIENT! The listing process can take time, it appears that you have done everything you can to ensure that your server is able to be queried.

2) Ensure that your `ServerHostSettings.json` configuration file has `ListOnMasterServer` set to `true`  
   
3) Within the `ServerHostSettings.json` configuration file, ensure your `Port` and `QueryPort` are configured in the Windows Firewall to allow UDP traffic OR allow the `VRisingServer.exe` through the firewall  
:spiral_notepad: If you are using a dedicated game hosting provider this *should* be done automatically for you

4) Ensure that you see the server listed on the output from `netstat -aon` the output should look something like this (You should see additional ports listed for the PID, but these are the ones we are concerned with):
    ```
    UDP    0.0.0.0:<Port>                *:*                                    <PID>
    UDP    0.0.0.0:<QueryPort>           *:*                                    <PID>
    ```  
    :spiral_notepad: If you are using a dedicated game hosting provider and you do not have access to the OS (Windows) this step may not be possible.

5) Configure your router to allow both ports in step 2 to be forwarded to the server (You can refer to https://portforward.com for assistance, but this is device specific, and beyond the scope of this document)  
:warning: Since these are UDP ports, there is no good/easy way to test them remotely other than with a game client.  
:spiral_notepad: If you are using a dedicated game hosting provider this *should* be done automatically for you

6) Check your `VRisingServer.log` server logs inside the appropriate directory for the public IP, the logs should look like this: `SteamPlatformSystem - OnPolicyResponse - Public IP: <VAR_PUBLIC_IP>` and ensure this is the public IP you expect it to be (This is especially useful if you have a VPN or secondary internet provider)
    ```
    SteamPlatformSystem - OnPolicyResponse - Public IP: <VAR_PUBLIC_IP>
    UnityEngine.Logger:Log(LogType, Object)
    UnityEngine.Debug:Log(Object)
    ProjectM.Auth.SteamPlatformSystem:OnPolicyResponse(GSPolicyResponse_t)
    Steamworks.DispatchDelegate:Invoke(T)
    Steamworks.Callback`1:OnRunCallback(IntPtr)
    Steamworks.CallbackDispatcher:RunFrame(Boolean)
    ProjectM.Auth.SteamPlatformSystem:OnUpdate()
    Unity.Entities.SystemBase:Update()
    Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
    Unity.Entities.ComponentSystem:Update()
    Unity.Jobs.LowLevel.Unsafe.PanicFunction_:Invoke()
    ```

7) Validate that on server startup, your server is sending data to Steam by entering your public IP on this tool  https://southnode.net/steamquery.php , and/or using https://api.steampowered.com/ISteamApps/GetServersAtAddress/v0001?addr=1.2.3.4 (Replace 1.2.3.4 with your public IP)  
:warning: This does NOT mean that your ports are actually open, just that as the game starts up, the game was correctly advertised to Steam.

8) Validate your ports are open using http://steam-portcheck.herokuapp.com/index.php

9) BE PATIENT! The listing process can take time, it appears that you have done everything you can to ensure that your server is able to be queried.  
:radioactive: SOME users have found that changing both ports to something else, and back have forced the server to be listed. This is VERY anecdotal, and may infact increase the waiting process.

# General Instructions

## Enabling Console Access
* To enable the console, go to `Options` -> `General` -> put a check in `Console Enabled`
* Press the backtick key (\`) or (`§`) depending on your keyboard layout
* Once you connect type `adminauth` to enable admin access

## Direct Connect
Start vRising -> `Play` -> `Online Play` -> `Find Servers` (bottom right) -> `Display All Servers & Settings` (Top) -> `Direct Connect` (Bottom Center) -> `<IP>:<Port from ServerHostSettings.json>` (This IP and Port is the same shown when your in the game and hit ESC on the bottom left like this `SteamIPv4://<IP>:<Port from ServerHostSettings.json>` -> Make sure `LAN Connect` is NOT selected. -> `Connect`

## Intresting Admin Console Commands
Your current binds can be found in: `%USERPROFILE%\AppData\LocalLow\Stunlock Studios\VRising\ConsoleProfile\<machine_name.prof>` (Do not modify this file directly!). You can list binds in game using `Console.ProfileInfo`

### Administrative Console Commands <!-- omit in toc -->
`Console.Bind F1 listusers` - You can bind a console command to a function key  
`toggleobserve 1` - Set yourself to observer mode, you will get damage immunity and a speed boost (You should remove your cloak for proper invisibility.)  
`changehealthclosesttomouse -5000` - Remove palisades or castle that may be blocking passage (You may want to `console.bind` this to a function key for easy access.)

#### Teleportation Console Commands <!-- omit in toc -->
`copyPositionDump` - Will copy your current position to your clipboard (These are not very accurate!)  
`https://discord.com/channels/803241158054510612/976404273015431168/980326759293673472` - Teleport map  
`<CTRL> + <SHIFT> and clicking your map` - After opening the map, you will teleport to the location

### Troubleshooting Console Commands <!-- omit in toc -->
`ToggleDebugViewCategory All` - Turn on all reporting  
`ToggleDebugViewCategory Network` - Turn on network reporting (latency, FPS, users)

# Resources
### DirectX Error Mappings <!-- omit in toc -->
https://learn.microsoft.com/en-us/windows/win32/direct3ddxgi/dxgi-error
```
d3d11: failed to create staging 2D texture w=320 h=320 d3dfmt=61 [887a0005]
d3d11: failed to create staging 2D texture w=256 h=256 d3dfmt=61 [887a0005]
d3d11: failed to create buffer (target 0x21 mode 0 size 17152) [0x887A0005]
d3d11: failed to create buffer (target 0x200 mode 1 size 288) [0x887A0005]
d3d11: failed to create buffer (target 0x200 mode 1 size 288) [0x887A0005]
```
DXGI_ERROR_DEVICE_REMOVED - 0x887A0005
The video card has been physically removed from the system, or a driver upgrade for the video card has occurred. The application should destroy and recreate the device. For help debugging the problem, call ID3D10Device::GetDeviceRemovedReason.

## Prefab Listing
  * https://wiki.vrisingmods.com/prefabs/All

### Official Guide <!-- omit in toc -->
  * https://github.com/StunlockStudios/vrising-dedicated-server-instructions

### Offical Bug Tracker <!-- omit in toc -->
  * https://bugs.playvrising.com/

### Server Tester <!-- omit in toc -->
  * https://portcheck.onrender.com/

### BattleMetrics Server Listing <!-- omit in toc -->
  * https://www.battlemetrics.com/servers/vrising

### World Maps <!-- omit in toc -->
  * https://vrising-map.com/

### Game statistics <!-- omit in toc -->
  * https://steamdb.info/app/1604030/graphs/

# Patch Notes
* https://store.steampowered.com/news/app/1604030
* [Patch 0.5.42584 | Patch Notes | Hotfix 9 -- Server Version: v0.5.42600 (2022-07-08 08:30 UTC)](https://store.steampowered.com/news/app/1604030?emclan=103582791469988961&emgid=3320858336357099261)
  * Disabled LowerFPSWhenEmpty due to unexpected side effects
  * Fixed DLCs not working in LAN mode under certain conditions.
* [Patch 0.5.42553 | Patch Notes | Hotfix 8 -- Server Version: v0.5.42562 (2022-07-06 10:15 UTC)](https://steamstore-a.akamaihd.net/news/externalpost/steam_community_announcements/4474904295776381022)
  * Server Wipes
    * Severs that support Scheduled Wipes will have an icon in the server list
    * Server with Scheduled Wipes will display the number of days remaining until the next planned wipe.
    * This appears to be set in `ServerHostSettings.json` using `ResetDaysInterval` which is a number of days to reset, and `DayOfReset` which can be `Any` , `Monday` , `Tuesday` , `Wednesday` , `Thursday` , `Friday` , `Saturday` or `Sunday`
      * C/O Ersan : https://discord.com/channels/803241158054510612/976404273015431168/994194443961909381
  * Added new ServerHostSettings for lowering FPS on servers when they are empty: `-LowerFPSWhenEmpty` and `-LowerFPSWhenEmptyValue`. The default is `true` and with a value of `1`.
  * Official PvP Presets now uses `1.25` `BloodDrainModifier` instead of `1.0`
  * DLCs now work in LAN Mode.
  * The initial Server List request will now prioritize servers with players, to increase the speed at which servers are fetched.
  * Replaced `Days Played` with `Days Running` in the Server Details.
  * `Days Played` previously displayed the number of in-game days since server start, `Days Running` will now instead display the number of real-time days since server start.
* [Patch 0.5.42405 | Patch Notes | Hotfix 7 -- Server Version: v0.5.42405 (2022-06-29 15:34 UTC)](https://steamstore-a.akamaihd.net/news/externalpost/steam_community_announcements/4474904295754340476)
  * We added Steam Cloud support for Private Game saves. This allows playing your saves on different computers.
  * All new Private Games hosted will now be saved on Steam Cloud by default.
  * You can move saves to/from Steam Cloud Saving.
* [Patch 0.5.42236 | Patch Notes | Hotfix 6 -- Server Version: v0.5.42236 (2022-06-22 17:00 UTC)](https://steamstore-a.akamaihd.net/news/externalpost/steam_community_announcements/4474904295728853576)
  * Added a new admin command `decayusercastles <playername>` that puts all the castles owned by a target player in decay.
  * The `adminlist.txt` and `banlist.txt` files are now loaded from both the default Settings folder as well as from the local override Settings folder. These files always save to the local override folder now.
  * The RCON socket now binds to the bind address if specified. There is also a specific RCON Bind Address to override the default one.
  * Lumber, Stone, and Plant Fibre no longer block players from using waygates or bat form.
* [Patch 0.5.42050 / 2022-06-16 -- Server Version: v0.5.42023 (2022-06-15 00:18 UTC)](https://steamcommunity.com/games/1604030/announcements/detail/4822806821988384687)
  * Players can now dismantle floors and borders that are next to walls/pillars without having to dismantle any wall/pillar first, as long as this does not leave any wall/pillar without a floor connection (#305517).
  * Improved error handling and error feedback when the server saves the game world (related to #304262 and #304381 but is not expected to solve all reported cases).
  * Added more validation and safety checks to catch more types of rare errors while saving.
  * If the server fails to save, all active players on the server now get a chat notification containing basic information about the type of error that was encountered.
  * The server no longer uses the Windows temp folder while saving the world. It instead saves the temporary files to a neighboring folder to the target save path.
  * Fixed an issue where territory and buildings had a chance of not getting destroyed with their castle if they were constructed at a large enough distance from the Castle Heart (#306085, #305657).
* [Patch 0.5.41821 / 2022-06-09 -- Server Version: v0.5.41821 (2022-06-09 01:17 UTC)](https://steamstore-a.akamaihd.net/news/externalpost/steam_community_announcements/4480532526716778038)
  * Server optimizations for servers with long up times and/or a lot of players.
  * Optimized the map and minimap on servers with a lot of castles.
  * Updated the Social Panel: Now it displays all players connected to the server and their SteamID. We also added text chat muting functionality. Muting is persistent between sessions now. 
  * The Blood Essence Drain Modifier setting should now work properly.
* [Patch 0.5.41669 / 2022-05-31 -- Server Version: v0.5.41669 (2022-05-30 23:21 UTC)](https://steamcommunity.com/games/1604030/announcements/detail/3294958655399932646)
  * Maximum clan size has been increased to 50
  * `Server Details` will now show the amount of in-game days the server has been running for.
  * Altering the ‘Refinement Cost’ and ‘Refinement Rate’ server settings no longer affects the blood essence consumption rate of the Castle Heart.
  * Occurrences of multiple spawns of the same V Blood units will now be repaired upon server restart.
  * Optimized server memory by removing data from disconnected users.
* [Patch 0.5.41591 / 2022-05-30 -- Server Version: UNKNOWN](https://steamcommunity.com/games/1604030/announcements/detail/3294958655395719328)
* [Patch 0.5.41448 / 2022-05-25 -- Server Version: v0.5.41471 (2022-05-25 08:56 UTC)](https://steamcommunity.com/games/1604030/announcements/detail/3294958655377836606)
  * Added changehealthofclosesttomouse to console
  * Added changedurability to console
  * Added addtime to console
  * Added LAN/Offline mode
* [Patch 0.5.41237 / 2022-05-19 -- Server Version: v0.5.41258 (2022-05-19 12:26 UTC)](https://steamcommunity.com/games/1604030/announcements/detail/3218396837686301548)
