- [Resources](#resources)
- [Patch Notes](#patch-notes)
- [File Locations](#file-locations)
  - [Dedicated Server](#dedicated-server)
  - [Private Server](#private-server)
  - [Client](#client)
- [Dedicated Server](#dedicated-server-1)
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
      - [Problem Description: Can't keep VOIP enabled](#problem-description-cant-keep-voip-enabled)
      - [VOIP Logs](#voip-logs)
  - [Adding yourself to the adminlist.txt file](#adding-yourself-to-the-adminlisttxt-file)
  - [Configure your router to allow UDP ports to the server](#configure-your-router-to-allow-udp-ports-to-the-server)
- [General Instructions](#general-instructions)
  - [Enabling Console Access](#enabling-console-access)
  - [Direct Connect](#direct-connect)
- [Intresting Admin Console Commands](#intresting-admin-console-commands)
- [Troubleshooting The Server](#troubleshooting-the-server)
  - [Log Variables](#log-variables)
  - [Specific Troubleshooting Instructions](#specific-troubleshooting-instructions)
    - [Troubleshooting Direct Connection To the VRising Server](#troubleshooting-direct-connection-to-the-vrising-server)
      - [On the Internet](#on-the-internet)
    - [Server not listed on the server browser](#server-not-listed-on-the-server-browser)
  - [Log Examples](#log-examples)
    - [Incorrect Password](#incorrect-password)
    - [Closed Connection](#closed-connection)
    - [User Login](#user-login)
    - [Loading ServerHostSettings](#loading-serverhostsettings)
    - [Loading ServerGameSettings](#loading-servergamesettings)
    - [Loading adminlist](#loading-adminlist)
    - [Loading Banlist](#loading-banlist)
    - [Update Master Server](#update-master-server)
    - [Broadcasting public IP](#broadcasting-public-ip)
    - [Autosaves](#autosaves)
    - [Granting admin permissions from the console](#granting-admin-permissions-from-the-console)
    - [Give Item Event](#give-item-event)
    - [VOIP](#voip)
    - [Crashes](#crashes)
  - [Server Startup](#server-startup)
    - [Server Loading on 2020.3.31f1 (6b54b7616050)](#server-loading-on-2020331f1-6b54b7616050)

# Resources

## Official Guide <!-- omit in toc -->
I've tried to submit a pull request to this repository with some of the information here, but it doesn't look like they want the changes, thus, I've just update this page in hopes that it will help someone.
  * https://github.com/StunlockStudios/vrising-dedicated-server-instructions

## Offical Bug Tracker <!-- omit in toc -->
  * https://bugs.playvrising.com/

## Server Tester <!-- omit in toc -->
  * http://steam-portcheck.herokuapp.com/index.php

## BattleMetrics Server Listing <!-- omit in toc -->
  * https://www.battlemetrics.com/servers/vrising

## World Maps <!-- omit in toc -->
  * https://vrising-map.com/
  * https://v-rising.map.gd/a/

## Game statistics <!-- omit in toc -->
  * https://steamdb.info/app/1604030/graphs/

# Patch Notes
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

# File Locations
## Dedicated Server
### Dedicated Server - Configuration <!-- omit in toc -->
  - :stop_sign: These may get overwritten with each update (UNSAFE!)
    - **Startup .bat file:** `<VAR_SERVER_INSTALLATION_DIRECTORY>`\start_server_example.bat
    - **ServerHostSettings:** `<VAR_SERVER_INSTALLATION_DIRECTORY>`\VRisingServer_Data\StreamingAssets\Settings\ServerHostSettings.json
    - **ServerGameSettings:** `<VAR_SERVER_INSTALLATION_DIRECTORY>`\VRisingServer_Data\StreamingAssets\Settings\ServerGameSettings.json
  - :heavy_check_mark: These should survive server updates
    - **Startup .bat file:** `<VAR_SERVER_INSTALLATION_DIRECTORY>`\start_server.bat
    - **VOIP Configuration:** `<VAR_SERVER_INSTALLATION_DIRECTORY>`\VRisingServer_Data\StreamingAssets\Settings\ServerVoipSettings.json
    - **AdminList:** `<VAR_SERVER_INSTALLATION_DIRECTORY>`\VRisingServer_Data\StreamingAssets\Settings\adminlist.txt
    - **Banlist:** `<VAR_SERVER_INSTALLATION_DIRECTORY>`\VRisingServer_Data\StreamingAssets\Settings\banlist.txt
    - These rely on the `-persistentDataPath` being set when launching the game
      - **ServerHostSettings:** `<VAR_SERVER_INSTALLATION_DIRECTORY>`\\`<VAR_PERSISTENT_DATA_PATH>`\Settings\ServerHostSettings.json
      - **ServerGameSettings:** `<VAR_SERVER_INSTALLATION_DIRECTORY>`\\`<VAR_PERSISTENT_DATA_PATH>`\Settings\ServerGameSettings.json
### Dedicated Server - Save Games <!-- omit in toc -->
  - These rely on the `-persistentDataPath` being set when launching the game
    - `<VAR_SERVER_INSTALLATION_DIRECTORY>`\\`<VAR_PERSISTENT_DATA_PATH>`\Saves\v1\\`<VAR_WORLD_NAME>`\AutoSave_`NNNN`
### Dedicated Server - Logs <!-- omit in toc -->
  - These rely on the `-logFile` being set when launching the game
    - `<VAR_SERVER_INSTALLATION_DIRECTORY>`\logs\VRisingServer.log

## Private Server
### Private Server - Configuration <!-- omit in toc -->

### Private Server - Save Games <!-- omit in toc -->
- %USERPROFILE%\AppData\LocalLow\Stunlock Studios\VRising\Saves\v1\\`<VAR_SERVER_UUID>`\AutoSave_`NNNN`

### Private Server - Logs <!-- omit in toc -->
- %USERPROFILE%\AppData\LocalLow\Stunlock Studios\VRising\Player-server.log

## Client
### Configuration <!-- omit in toc -->
  - **Console Profile** : %USERPROFILE%\AppData\LocalLow\Stunlock Studios\VRising\ConsoleProfile\\`<VAR_MACHINE_NAME>`.prof
    * You should not modify this file directly!
### Client - Player Logs <!-- omit in toc -->
  * %USERPROFILE%\AppData\LocalLow\Stunlock Studios\VRising\Player.log

# Dedicated Server 
This section is related, and specific to the Dedicated Server that you would start from outside the game client.

- [Dedicated Server Installation](#dedicated-server-installation)
  - [Installation of the server using the AutoInstaller](#installation-of-the-server-using-the-autoinstaller-)
  - [Installation of the server using PowerShell and SteamPS](#installation-of-the-server-using-powershell-and-steamps)
- [Dedicated Server Configuration](#dedicated-server-configuration)
  - [Manual Configuration](#manual-configuration)
    - [Server StartUp Batch File](#server-startup-batch-file)
    - [Server Settings Files](#server-settings-files)
    - [Allow the vRising game through the windows firewall](#allow-the-vrising-game-through-the-windows-firewall)
    - [Server Startup, Log Timestamps, and Restarting on Failure](#server-startup-log-timestamps-and-restarting-on-failure)
    - [Server updates](#server-updates)
      - [With SteamPS](#with-steamps)
      - [With SteamCMD](#with-steamcmd)
      - [Automating updates with Windows Task Scheulder](#automating-updates-with-windows-task-scheulder)

## Dedicated Server Installation

### Installation of the server using the AutoInstaller <!-- omit in toc -->
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
  **NOTE**: Change `C:\vrisingserver` to the `full path` of the location where you want to install the server.  
  **NOTE**: You can also specify `-gameport <game_port_#>` , `-queryport <query_port_#>` and `-rconport <rcon_port_#>` if you wish. If you do not specify a different port, it will be installed using the default ports.

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

### Installation of the server using PowerShell and SteamPS <!-- omit in toc -->
We will assume that you want to install the server in `C:\servers\v_rising` (This will be <VAR_SERVER_INSTALLATION_DIRECTORY> in the rest of this document) if you do not, change the path in the following commands.

We will install the PowerShell module for SteamCLI to install and update the server.
```powershell
Install-Module -Name SteamPS
Install-SteamCMD
Update-SteamApp -ApplicationName 'V Rising Dedicated Server' -Path 'C:\servers\v_rising'
```
**NOTE:** Any questions should be answered with yes

## Dedicated Server Configuration

### Manual Configuration
If you want to manually setup everything instead of using the auto installer, you can follow these steps:

#### Server StartUp Batch File
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

#### Server Settings Files
1. Create the directory `<VAR_SERVER_INSTALLATION_DIRECTORY>\save-data\Settings`
2. Copy and paste `ServerHostSettings.json` and `ServerGameSettings.json` files from `<VAR_SERVER_INSTALLATION_DIRECTORY>/VRisingServer_Data/StreamingAssets/Settings/` into the directory you created in step 1

**NOTE:** If you elect to directly modify the configuration files in `<VAR_SERVER_INSTALLATION_DIRECTORY>\VRisingServer_Data\StreamingAssets\Settings\` you may loose your configuration changes with new updates, so you may want to consider backing them up.

#### Allow the vRising game through the windows firewall
You may need to allow the executable (VRisingServer.exe) through the windows firewall

#### Server Startup, Log Timestamps, and Restarting on Failure
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
    nssm.exe set VRisingServer-9876 AppStdout <VAR_SERVER_INSTALLATION_DIRECTORY>\logs\VRisingServer_Custom.log
    nssm.exe set VRisingServer-9876 AppStderr <VAR_SERVER_INSTALLATION_DIRECTORY>\logs\VRisingServer_Error.log
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
    nssm start VRisingServer
    ```

#### Server updates
We will place the `update.bat` file with the startup batch file in the `<VAR_SERVER_INSTALLATION_DIRECTORY>`, we will also announce to the players we are doing this with mcrcon (https://github.com/Tiiffi/mcrcon/releases/) which we will place in the server directory as well for ease of access. 

**NOTE**: In either case, you will need to update the path to the server by replacing any line with `C:\servers\v_rising` with the correct path for your server.

##### With SteamPS <!-- omit in toc -->
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

##### With SteamCMD <!-- omit in toc -->
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

##### Automating updates with Windows Task Scheulder <!-- omit in toc -->
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

# Post Configuration
Weather or not you are using the auto installer or the manual steps, the following final configuration steps may be required.

## ServerHostSettings.json

### Description <!-- omit in toc -->
In `Description` field, you can use line breaks using `\n`

### Address <!-- omit in toc -->
In the `Address` field, if you set this to a local address (192.168.1.X or 10.X.X.X) this will cause the server and RCON to only listen on this address. This is useful if you have more than one interface or are using a VPN and want to bind the server and RCON to a single IP.
:warning: If you set this address, you will need to adjust your RCON commands to use the server IP, rather than the local loopback address as it will not be listening on the loopback address anymore!

```
netstat -aon | find "19280"
  TCP    192.168.1.10:25575          0.0.0.0:0              LISTENING       19280
```

## ServerGameSettings.json
You can get more information (min/max) and descriptions on each setting using this PDF: https://cdn.stunlock.com/blog/2022/05/25083113/Game-Server-Settings.pdf

If you need assistnace with how these should be formatted, you can check `<VAR_SERVER_INSTALLATION_DIRECTORY>\VRisingServer_Data\StreamingAssets\GameSettingPresets` IE: `C:\vrisingserver\steamapps\common\VRisingDedicatedServer\VRisingServer_Data\StreamingAssets\GameSettingPresets` usually the `Level70PvE.json` or the `Level70PvP.json` files will have the syntax

### VBloodUnitSettings <!-- omit in toc -->
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

## ServerVoipSettings.json (VOIP Configuration)
Be advised this is 100% unsupported!

`https://discord.com/channels/803241158054510612/976404273015431168/980896456766533743` - VOIP setup (Also in the pinned messages)  

1) Create an account on the Vivox Developer Portal (https://developer.vivox.com/register)  
:radioactive: In the `Submission Type` section, there is no functional difference between a `Individual: Personal Account` and `Organization: Professional Account`. I would `strongly` recommend using an `Individual: Personal Account` unless you are representing an actual organization. I would also strongly recommend you use proper real information, rather than made up information.
2) Login to the Vivox Developer Portal 
3) Click on `Create New Application`
4) In Application or Game Name set the name to something like `VRising_Server`
5) In the `Game Genres` put a check in `Action`
6) Click `Continue`
7) In `What engine are you building your app with? Vivox provides out-of-the-box solutions for the engines listed below - select Vivox Core if yours is not listed.` select `Unity`
8) In `What platform(s) does your app support` select `Windows`
9) Click `Continue`
10) Click `Create App`
11) Create a new file called `<GAME_SERVER_DIRECTORY>\VRisingServer_Data\StreamingAssets\Settings\ServerVoipSettings.json`
12) Add the following content to the file
    ```json
    {
        "VOIPEnabled": true,
        "VOIPIssuer": "",
        "VOIPSecret": "",
        "VOIPAppUserId": "",
        "VOIPAppUserPwd": "",
        "VOIPVivoxDomain": "",
        "VOIPAPIEndpoint": "",
        "VOIPConversationalDistance": 14,
        "VOIPAudibleDistance": 40,
        "VOIPFadeIntensity": 2.0
    }
    ```
13) In the `ServerVoipSettings.json` set the `VOIPIssuer` to the value you see in Vivox portal under `Api Keys` called `Issuer`
14) In the `ServerVoipSettings.json` set the `VOIPSecret` to the value you see in the Vivox portal under `Api Keys` called `Secret Key`
15) In the `ServerVoipSettings.json` set the `VOIPAppUserId` to the value you see in the Vivox portal under `Api Keys` called `Admin User ID`
16) In the `ServerVoipSettings.json` set the `VOIPAppUserPwd` to the value you see in the Vivox portal under `Api Keys` called `Admin Password`
17) In the `ServerVoipSettings.json` set the `VOIPVivoxDomain` to the value you see in the Vivox portal under `Environment Details` called `Domain`
18) In the `ServerVoipSettings.json` set the `VOIPAPIEndpoint` to the value you see in the Vivox portal under `Environment Details` called `API End-Point`

:spiral_notepad: The main difference between a sandbox, and a production configuration is the sandbox can only maintain `100` concurrent connections, while a production configuration can mantain `5000`.

### VOIP Troubleshooting
#### Problem Description: Can't keep VOIP enabled
- Symptoms: 
  - The VOIP option (`Options` -> `Sound` -> `Use Voice Chat`) may be forced into an off state after you have set it it on
  - You see the message `Nearby players are only displayed when connected to voice chat` 
  - In the client logs you may see `<Login>b__0: vx_req_account_anonymous_login_t failed: VivoxUnity.VivoxApiException: Access Token Expired (20121)`
  * Unfortunatly the developer page isn't helpful here: https://docs.vivox.com/v5/general/unity/15_1_170000/en-us/Unity/developer-guide/error-codes.htm
  * https://support.vivox.com/hc/en-us/articles/360015368274-What-causes-VxAccessTokenExpired-20121-errors-
- Resolution
  - Time on the server must be sycned (This is NOT the same as the Time Zone!) even a few seconds drift can cause the problem to manifest. 
  - In general you should use `NTP` to sync time on the server and sync the server manually to start

#### VOIP Logs
Expected/Successful VOIP logs can be found in the [VOIP](#voip) log section.

## Adding yourself to the adminlist.txt file
In the logs, you should see the `adminlist.txt` and `banlist.txt` lists loaded, and thier path is `<VAR_SERVER_INSTALLATION_DIRECTORY>\VRisingServer_Data\StreamingAssets\Settings\`  
**NOTE:** This is the only valid place for these entires!

* You will need to restart the server to reload any changes to these files (They SHOULD get picked up automatically, but unclear)

## Configure your router to allow UDP ports to the server
If you wish your server to be listed on the in game server browser, and people to connect from the internet, you will need to open two UDP ports to the server. 
These ports are configured in the `<VAR_SERVER_INSTALLATION_DIRECTORY>\save-data\Settings\ServerHostSettings.json` file. 

```json
"Port": 9876,
"QueryPort": 9877,
```

**NOTE: ** This is beyond the scope of this document, as it is device specific, but you can try https://PortForward.com for help with your specific device/brand

# General Instructions

## Enabling Console Access
* To enable the console, go to `Options` -> `General` -> put a check in `Console Enabled`
* Press the backtick key (\`) or (`§`) depending on your keyboard layout
* Once you connect type `adminauth` to enable admin access

## Direct Connect
Start vRising -> `Play` -> `Online Play` -> `Find Servers` (bottom right) -> `Display All Servers & Settings` (Top) -> `Direct Connect` (Bottom Center) -> `<IP>:<Port from ServerHostSettings.json>` (This IP and Port is the same shown when your in the game and hit ESC on the bottom left like this `SteamIPv4://<IP>:<Port from ServerHostSettings.json>` -> Make sure `LAN Connect` is NOT selected. -> `Connect`

# Intresting Admin Console Commands
Your current binds can be found in: `%USERPROFILE%\AppData\LocalLow\Stunlock Studios\VRising\ConsoleProfile\<machine_name.prof>` (Do not modify this file directly!). You can list binds in game using `Console.ProfileInfo`

## Administrative Console Commands <!-- omit in toc -->
`Console.Bind F1 listusers` - You can bind a console command to a function key  
`toggleobserve 1` - Set yourself to observer mode, you will get damage immunity and a speed boost (You should remove your cloak for proper invisibility.)  
`changehealthclosesttomouse -5000` - Remove palisades or castle that may be blocking passage (You may want to `console.bind` this to a function key for easy access.)

### Teleportation Console Commands <!-- omit in toc -->
`copyPositionDump` - Will copy your current position to your clipboard (These are not very accurate!)  
`https://discord.com/channels/803241158054510612/976404273015431168/980326759293673472` - Teleport map  
`<CTRL> + <SHIFT> and clicking your map` - After opening the map, you will teleport to the location

## Troubleshooting Console Commands <!-- omit in toc -->
`ToggleDebugViewCategory All` - Turn on all reporting  
`ToggleDebugViewCategory Network` - Turn on network reporting (latency, FPS, users)

# Troubleshooting The Server
You should review the logs of the server to begin any troubleshooting session.

## Log Variables
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

## Specific Troubleshooting Instructions

### Troubleshooting Direct Connection To the VRising Server
The first step is to ensure that the game is accessible to machines on the same network as the server is running on.

1) On the server, find the PID of the `VRisingServer.exe` in `Task Manager` in the `Details` tab  
  
2) Check your server configuration file `ServerHostSettings.json` we are looking for `Port`, `QueryPort`, and optionally `Rcon/Port`  
**NOTE** If you are hosting a private server, check the `%USERPROFILE%\AppData\LocalLow\Stunlock Studios\VRising\Player-server.log` log for `Port` and `QueryPort` as shown below.
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
    * Find the PID of the `VRisingServer.exe` in `Task Manager` (`control` + `shift` + `esc`) in the `Details` tab
    * Run `cmd`  
    * Type `netstat -aon | find "<PID>"` where \<PID\> is the PID of the server
    * You will see some additional ports, this is OK)
      ```
        TCP    0.0.0.0:<Rcon/Port>    0.0.0.0:0                    LISTENING       <PID>
        TCP    127.0.0.1:55997        127.0.0.1:55998              ESTABLISHED     <PID>
        TCP    127.0.0.1:55998        127.0.0.1:55997              ESTABLISHED     <PID>
        TCP    <Server_IP>:55988      <P2P_STUN_ServerList>:27019  ESTABLISHED     <PID>
        TCP    <Server_IP>:56571      52.219.47.197:443            CLOSE_WAIT      <PID>
        TCP    <Server_IP>:56572      52.219.47.197:443            CLOSE_WAIT      <PID>
        UDP    0.0.0.0:<QueryPort>    *:*                                          <PID>
        UDP    0.0.0.0:<Port>         *:*                                          <PID>
        UDP    0.0.0.0:57628          *:*                                          <PID>
      ```
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

#### On the Internet

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
    **NOTE:** You can also use tools like [whatismyip.com](https://www.whatismyip.com/) to get your public IP, but this doesn't ensure the server is bound to this public IP, This is especially useful if you have a VPN or secondary internet provider.

6) Open your router and firewall to allow the `Port` and `QueryPort` configured in `ServerHostSettings.json` to forward to this machine (and TCP if you want RCON)
This is beyond the scope of this document, as it is device specific, but you can try https://PortForward.com

7) Validate with your internet provider if you are able to run servers (specifically game servers) from your purchased internet package. They may block this kind of traffic by blocking specific ports, or using packet inspection to determine the type of traffic. (This is beyond the scope of this document).  
If you check https://ipv6-test.com/ and the shown IP on that web page is different from your address shown in your router, your address may be translated and it may be impossible to host. Additionally some providers (namely in Germany) may use something like Carrier Grade NAT (CGNAT, with a router public IP range from 100.64.0.0 to 100.127.255.255) or DS-Lite which may prevent you from running a server. In these cases, you can try to contact your ISP and see if you are able to get an IPv4 address. You *may* be able to get away with something like Fast Reverse Proxy (https://gabrieltanner.org/blog/port-forwarding-frp) but this is again, outside the scope of this document.

### Server not listed on the server browser
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

## Log Examples

### Incorrect Password
```
NetConnection '{Steam 1945998476}' connection was denied. Message: 'Incorrect Password!' Version: 1 PlatformId: <VAR_PLAYER_STEAM_ID>
```

### Closed Connection
```
SteamLog [SDR k_ESteamNetworkingSocketsDebugOutputType_Msg] [#1945998476 UDP steamid:<VAR_PLAYER_STEAM_ID>@<VAR_PLAYER_PUBLIC_IP>:57886] closed by app, entering linger state (1017) Application closed connection
UnityEngine.Logger:Log(LogType, Object)
UnityEngine.Debug:Log(Object)
Stunlock.Network.Steam.Wrapper.SteamSocketNetworkingLogs:OnLog(LogSource, ESteamNetworkingSocketsDebugOutputType, IntPtr)
Steamworks.NativeMethods:ISteamNetworkingSockets_CloseConnection(IntPtr, HSteamNetConnection, Int32, UTF8StringHandle, Boolean)
Steamworks.SteamGameServerNetworkingSockets:CloseConnection(HSteamNetConnection, Int32, String, Boolean)
Stunlock.Network.Steam.ServerSteamTransportLayer:CloseConnection(ConnectionData, ConnectionStatusChangeReason, Boolean, String)
Stunlock.Network.Steam.ServerSteamTransportLayer:Disconnect(NetConnectionId, ConnectionStatusChangeReason, String)
Stunlock.Network.ServerNetworkLayer:Deny(NetConnectionId, ConnectionStatusChangeReason, String)
ProjectM.ServerBootstrapSystem:OnConnectionApproval(NetBufferIn&, NetConnectionId)
ProjectM.Scripting.OnDeathDelegate:Invoke(ServerGameManager&, SelfServer&)
Stunlock.Network.ServerNetworkLayer:OnDataReceived(NetBufferIn&, NetConnectionId)
ProjectM.Scripting.OnDeathDelegate:Invoke(ServerGameManager&, SelfServer&)
Stunlock.Network.Steam.ServerSteamTransportLayer:ProcessNewMessages()
Stunlock.Network.Steam.ServerSteamTransportLayer:Update(Double)
ProjectM.ServerBootstrapSystem:OnUpdate()
Unity.Entities.SystemBase:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
ProjectM.ServerSimulationSystemGroup:OnUpdate()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Jobs.LowLevel.Unsafe.PanicFunction_:Invoke()
```

### User Login

Relogin
```
SteamPlatformSystem - BeginAuthSession for SteamID: <VAR_PLAYER_STEAM_ID> Result: k_EBeginAuthSessionResultOK
UnityEngine.Logger:Log(LogType, Object)
UnityEngine.Debug:Log(Object)
ProjectM.Auth.SteamPlatformSystem:BeginAuthSession(Byte[], UInt16, UInt64)
ProjectM.ServerBootstrapSystem:OnConnectionApproval(NetBufferIn&, NetConnectionId)
ProjectM.Scripting.OnDeathDelegate:Invoke(ServerGameManager&, SelfServer&)
Stunlock.Network.ServerNetworkLayer:OnDataReceived(NetBufferIn&, NetConnectionId)
ProjectM.Scripting.OnDeathDelegate:Invoke(ServerGameManager&, SelfServer&)
Stunlock.Network.Steam.ServerSteamTransportLayer:ProcessNewMessages()
Stunlock.Network.Steam.ServerSteamTransportLayer:Update(Double)
ProjectM.ServerBootstrapSystem:OnUpdate()
Unity.Entities.SystemBase:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
ProjectM.ServerSimulationSystemGroup:OnUpdate()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Jobs.LowLevel.Unsafe.PanicFunction_:Invoke()

NetEndPoint '{Steam 3600223286}' reconnect was approved. approvedUserIndex: 0 HasLocalCharacter: True Hail Message Size: 339 Version: 1 PlatformId: <VAR_PLAYER_STEAM_ID> UserIndex: 30 ShouldCreateCharacter: False IsAdmin: False Length: 339
UnityEngine.Logger:Log(LogType, Object)
UnityEngine.Debug:Log(Object)
ProjectM.ServerBootstrapSystem:ApproveClient(NetConnectionId, Int32, UInt64, Boolean, Boolean, User&, Entity, ConnectAddress, ConnectAddress)
ProjectM.ServerBootstrapSystem:TryAuthenticate(NetConnectionId, Int32, UInt64)
ProjectM.ServerBootstrapSystem:OnConnectionApproval(NetBufferIn&, NetConnectionId)
ProjectM.Scripting.OnDeathDelegate:Invoke(ServerGameManager&, SelfServer&)
Stunlock.Network.ServerNetworkLayer:ApproveWaitingClients()
Stunlock.Network.ServerNetworkLayer:Update(Double)
ProjectM.ServerBootstrapSystem:OnUpdate()
Unity.Entities.SystemBase:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
ProjectM.ServerSimulationSystemGroup:OnUpdate()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Jobs.LowLevel.Unsafe.PanicFunction_:Invoke()

SteamPlatformSystem - OnValidateAuthTicketResponse for SteamID: <VAR_PLAYER_STEAM_ID>, Response: k_EAuthSessionResponseOK
UnityEngine.Logger:Log(LogType, Object)
UnityEngine.Debug:Log(Object)
ProjectM.Auth.SteamPlatformSystem:OnValidateAuthTicketResponse(ValidateAuthTicketResponse_t)
System.Action`1:Invoke(T)
Steamworks.Callback`1:OnRunCallback(IntPtr)
Steamworks.CallbackDispatcher:RunFrame(Boolean)
ProjectM.Auth.SteamPlatformSystem:OnUpdate()
Unity.Entities.SystemBase:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Jobs.LowLevel.Unsafe.PanicFunction_:Invoke()

SteamPlatformSystem - UserHasLicenseForApp for SteamID: <VAR_PLAYER_STEAM_ID>, Result: k_EUserHasLicenseResultHasLicense, UserContentFlags: None
UnityEngine.Logger:Log(LogType, Object)
UnityEngine.Debug:Log(Object)
ProjectM.Auth.SteamPlatformSystem:OnValidateAuthTicketResponse(ValidateAuthTicketResponse_t)
System.Action`1:Invoke(T)
Steamworks.Callback`1:OnRunCallback(IntPtr)
Steamworks.CallbackDispatcher:RunFrame(Boolean)
ProjectM.Auth.SteamPlatformSystem:OnUpdate()
Unity.Entities.SystemBase:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Jobs.LowLevel.Unsafe.PanicFunction_:Invoke()

User '{Steam 3600223286}' '<VAR_PLAYER_STEAM_ID>', approvedUserIndex: 2, Character: 'Raven' connected as ID '0,1', Entity '94090,1'.
UnityEngine.Logger:Log(LogType, Object)
UnityEngine.Debug:Log(Object)
ProjectM.ServerBootstrapSystem:OnUserConnected(NetConnectionId)
System.Xml.Schema.XdrBeginChildFunction:Invoke(XdrBuilder)
Stunlock.Network.ServerNetworkLayer:OnDataReceived(NetBufferIn&, NetConnectionId)
ProjectM.Scripting.OnDeathDelegate:Invoke(ServerGameManager&, SelfServer&)
Stunlock.Network.Steam.ServerSteamTransportLayer:ProcessNewMessages()
Stunlock.Network.Steam.ServerSteamTransportLayer:Update(Double)
ProjectM.ServerBootstrapSystem:OnUpdate()
Unity.Entities.SystemBase:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
ProjectM.ServerSimulationSystemGroup:OnUpdate()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Jobs.LowLevel.Unsafe.PanicFunction_:Invoke()
```

### Loading ServerHostSettings
This object is loaded from `<VAR_SERVER_INSTALLATION_DIRECTORY>\save-data\Settings\ServerHostSettings.json`

```
Loaded ServerHostSettings:
{
  "Name": "My Cool Server",
  "Description": "My\nCool\nDescription",
  "Port": 9876,
  "QueryPort": 9877,
  "Address": null,
  "MaxConnectedUsers": 10,
  "MaxConnectedAdmins": 4,
  "MinFreeSlotsNeededForNewUsers": 0,
  "ServerFps": 30,
  "AIUpdatesPerFrame": 200,
  "Password": "",
  "Secure": true,
  "ListOnMasterServer": true,
  "ServerBranch": "",
  "GameSettingsPreset": "",
  "SaveName": "world1",
  "AutoSaveCount": 50,
  "AutoSaveInterval": 600,
  "PersistenceDebuggingEnabled": false,
  "GiveStarterItems": false,
  "LogAllNetworkEvents": false,
  "LogAdminEvents": true,
  "LogDebugEvents": true,
  "AdminOnlyDebugEvents": true,
  "EveryoneIsAdmin": false,
  "DisableDebugEvents": false,
  "EnableDangerousDebugEvents": false,
  "TrackArchetypeCreationsOnStartup": false,
  "ServerStartTimeOffset": 0.0,
  "NetworkVersionOverride": -1,
  "PersistenceVersionOverride": -1,
  "UseTeleportPlayersOutOfCollisionFix": true,
  "DiscoveryResponseLevel": 0,
  "API": {
    "Enabled": false,
    "BindAddress": "*",
    "BindPort": 9090,
    "BasePath": "/",
    "AccessList": ""
  },
  "Rcon": {
    "Enabled": false,
    "Port": 25575,
    "Password": null,
    "TimeoutSeconds": 300,
    "MaxPasswordTries": 99,
    "BanMinutes": 0,
    "SendAuthImmediately": true,
    "MaxConnectionsPerIp": 20,
    "MaxConnections": 20
  }
}
```

### Loading ServerGameSettings

This object is loaded from `<VAR_SERVER_INSTALLATION_DIRECTORY>\save-data\Settings\ServerGameSettings.json`

```
Loaded ServerGameSettings:
{
  "GameModeType": 0,
  "CastleDamageMode": 0,
  "SiegeWeaponHealth": 2,
  "PlayerDamageMode": 0,
  "CastleHeartDamageMode": 0,
  "PvPProtectionMode": 3,
  "DeathContainerPermission": 1,
  "RelicSpawnType": 1,
  "CanLootEnemyContainers": false,
  "BloodBoundEquipment": true,
  "TeleportBoundItems": false,
  "AllowGlobalChat": true,
  "AllWaypointsUnlocked": false,
  "FreeCastleClaim": false,
  "FreeCastleDestroy": true,
  "InactivityKillEnabled": true,
  "InactivityKillTimeMin": 3600,
  "InactivityKillTimeMax": 604800,
  "InactivityKillSafeTimeAddition": 172800,
  "InactivityKillTimerMaxItemLevel": 84,
  "DisableDisconnectedDeadEnabled": true,
  "DisableDisconnectedDeadTimer": 60,
  "InventoryStacksModifier": 2.0,
  "DropTableModifier_General": 2.0,
  "DropTableModifier_Missions": 2.0,
  "MaterialYieldModifier_Global": 2.5,
  "BloodEssenceYieldModifier": 2.0,
  "JournalVBloodSourceUnitMaxDistance": 25.0,
  "PvPVampireRespawnModifier": 1.0,
  "CastleMinimumDistanceInFloors": 2,
  "ClanSize": 4,
  "BloodDrainModifier": 1.0,
  "DurabilityDrainModifier": 1.0,
  "GarlicAreaStrengthModifier": 1.0,
  "HolyAreaStrengthModifier": 1.0,
  "SilverStrengthModifier": 1.0,
  "SunDamageModifier": 1.0,
  "CastleDecayRateModifier": 1.0,
  "CastleBloodEssenceDrainModifier": 1.0,
  "CastleSiegeTimer": 420.0,
  "CastleUnderAttackTimer": 60.0,
  "AnnounceSiegeWeaponSpawn": true,
  "ShowSiegeWeaponMapIcon": true,
  "BuildCostModifier": 1.0,
  "RecipeCostModifier": 1.0,
  "CraftRateModifier": 1.0,
  "ResearchCostModifier": 1.0,
  "RefinementCostModifier": 1.0,
  "RefinementRateModifier": 1.0,
  "ResearchTimeModifier": 1.0,
  "DismantleResourceModifier": 1.0,
  "ServantConvertRateModifier": 1.0,
  "RepairCostModifier": 1.0,
  "Death_DurabilityFactorLoss": 0.25,
  "Death_DurabilityLossFactorAsResources": 1.0,
  "StarterEquipmentId": 0,
  "StarterResourcesId": 0,
  "VBloodUnitSettings": [],
  "UnlockedAchievements": [],
  "UnlockedResearchs": [],
  "GameTimeModifiers": {
    "DayDurationInSeconds": 1080.0,
    "DayStartHour": 9,
    "DayStartMinute": 0,
    "DayEndHour": 17,
    "DayEndMinute": 0,
    "BloodMoonFrequency_Min": 10,
    "BloodMoonFrequency_Max": 18,
    "BloodMoonBuff": 0.2
  },
  "VampireStatModifiers": {
    "MaxHealthModifier": 1.0,
    "MaxEnergyModifier": 1.0,
    "PhysicalPowerModifier": 1.0,
    "SpellPowerModifier": 1.0,
    "ResourcePowerModifier": 1.0,
    "SiegePowerModifier": 1.0,
    "DamageReceivedModifier": 1.0,
    "ReviveCancelDelay": 5.0
  },
  "UnitStatModifiers_Global": {
    "MaxHealthModifier": 1.0,
    "PowerModifier": 1.0
  },
  "UnitStatModifiers_VBlood": {
    "MaxHealthModifier": 1.0,
    "PowerModifier": 1.0
  },
  "EquipmentStatModifiers_Global": {
    "MaxEnergyModifier": 1.0,
    "MaxHealthModifier": 1.0,
    "ResourceYieldModifier": 1.0,
    "PhysicalPowerModifier": 1.0,
    "SpellPowerModifier": 1.0,
    "SiegePowerModifier": 1.0,
    "MovementSpeedModifier": 1.0
  },
  "CastleStatModifiers_Global": {
    "TickPeriod": 5.0,
    "DamageResistance": 0.0,
    "SafetyBoxLimit": 1,
    "TombLimit": 12,
    "VerminNestLimit": 4,
    "PylonPenalties": {
      "Range1": {
        "Percentage": 0.0,
        "Lower": 0,
        "Higher": 2
      },
      "Range2": {
        "Percentage": 0.0,
        "Lower": 3,
        "Higher": 3
      },
      "Range3": {
        "Percentage": 0.0,
        "Lower": 4,
        "Higher": 4
      },
      "Range4": {
        "Percentage": 0.0,
        "Lower": 5,
        "Higher": 5
      },
      "Range5": {
        "Percentage": 0.0,
        "Lower": 6,
        "Higher": 254
      }
    },
    "FloorPenalties": {
      "Range1": {
        "Percentage": 0.0,
        "Lower": 0,
        "Higher": 20
      },
      "Range2": {
        "Percentage": 0.0,
        "Lower": 21,
        "Higher": 50
      },
      "Range3": {
        "Percentage": 0.0,
        "Lower": 51,
        "Higher": 80
      },
      "Range4": {
        "Percentage": 0.0,
        "Lower": 81,
        "Higher": 160
      },
      "Range5": {
        "Percentage": 0.0,
        "Lower": 161,
        "Higher": 254
      }
    },
    "HeartLimits": {
      "Level1": {
        "Level": 1,
        "FloorLimit": 30,
        "ServantLimit": 3
      },
      "Level2": {
        "Level": 2,
        "FloorLimit": 80,
        "ServantLimit": 5
      },
      "Level3": {
        "Level": 3,
        "FloorLimit": 150,
        "ServantLimit": 7
      },
      "Level4": {
        "Level": 4,
        "FloorLimit": 250,
        "ServantLimit": 9
      }
    },
    "CastleLimit": 2
  },
  "PlayerInteractionSettings": {
    "TimeZone": 0,
    "VSPlayerWeekdayTime": {
      "StartHour": 17,
      "StartMinute": 0,
      "EndHour": 23,
      "EndMinute": 0
    },
    "VSPlayerWeekendTime": {
      "StartHour": 17,
      "StartMinute": 0,
      "EndHour": 23,
      "EndMinute": 0
    },
    "VSCastleWeekdayTime": {
      "StartHour": 17,
      "StartMinute": 0,
      "EndHour": 23,
      "EndMinute": 0
    },
    "VSCastleWeekendTime": {
      "StartHour": 17,
      "StartMinute": 0,
      "EndHour": 23,
      "EndMinute": 0
    }
  }
}
```

### Loading adminlist
```
Loaded FileUserList from: <VAR_SERVER_INSTALLATION_DIRECTORY>\VRisingServer_Data\StreamingAssets\Settings\adminlist.txt. Content:<VAR_PLAYER_STEAM_ID>
UnityEngine.Logger:Log(LogType, Object)
UnityEngine.Debug:Log(Object)
ProjectM.FileUserList:Refresh()
ProjectM.AdminAuthSystem:.ctor()
System.Reflection.MonoCMethod:InternalInvoke(Object, Object[])
System.Activator:CreateInstance(Type, Boolean)
Unity.Entities.World:AllocateSystemInternal(Type)
Unity.Entities.World:GetOrCreateSystemsAndLogException(IEnumerable`1, Int32)
ProjectM.CustomWorldSpawning:AddSystemsToWorld(World, WorldType, Type[], Type, Type, Type, CustomWorld)
ProjectM.CustomWorldSpawning:SetupWorldWithCustomRootGroups(World, World, WorldType, IEnumerable`1, Type, Type, Type)
ProjectM.ServerWorldManager:BeginCreateServerWorld(ServerRuntimeSettings)
ProjectM.GameBootstrap:Start()
```

### Loading Banlist
```
Loaded FileUserList from: <VAR_SERVER_INSTALLATION_DIRECTORY>\VRisingServer_Data\StreamingAssets\Settings\banlist.txt. Content:<VAR_PLAYER_STEAM_ID>
UnityEngine.Logger:Log(LogType, Object)
UnityEngine.Debug:Log(Object)
ProjectM.FileUserList:Refresh()
ProjectM.KickBanSystem_Server:.ctor()
System.Reflection.MonoCMethod:InternalInvoke(Object, Object[])
System.Activator:CreateInstance(Type, Boolean)
Unity.Entities.World:AllocateSystemInternal(Type)
Unity.Entities.World:GetOrCreateSystemsAndLogException(IEnumerable`1, Int32)
ProjectM.CustomWorldSpawning:AddSystemsToWorld(World, WorldType, Type[], Type, Type, Type, CustomWorld)
ProjectM.CustomWorldSpawning:SetupWorldWithCustomRootGroups(World, World, WorldType, IEnumerable`1, Type, Type, Type)
ProjectM.ServerWorldManager:BeginCreateServerWorld(ServerRuntimeSettings)
ProjectM.GameBootstrap:Start()
```

### Update Master Server

```
Loaded Official Servers List: 1042
UnityEngine.Logger:Log(LogType, Object)
UnityEngine.Debug:Log(Object)
ProjectM.Auth.SteamPlatformSystem:UpdateOfficialServersList()
ProjectM.Auth.SteamPlatformSystem:OnUpdate()
Unity.Entities.SystemBase:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Jobs.LowLevel.Unsafe.PanicFunction_:Invoke()
```

### Broadcasting public IP
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

### Autosaves
```
Triggering AutoSave 292!
UnityEngine.Logger:Log(LogType, Object)
UnityEngine.Debug:Log(Object)
ProjectM.TriggerPersistenceSaveSystem:OnUpdate()
Unity.Entities.SystemBase:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
ProjectM.ServerSimulationSystemGroup:OnUpdate()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Jobs.LowLevel.Unsafe.PanicFunction_:Invoke()

Internal: JobTempAlloc has allocations that are more than 4 frames old - this is not allowed and likely a leak
PersistenceV2 - Finished Saving to '.\save-data\Saves\v1\clever1\AutoSave_292'
Total Persistent ChunkCount 8256. Total Save Size: 66380201 Bytes.

Internal: deleting an allocation that is older than its permitted lifetime of 4 frames (age = 5)
Internal: deleting an allocation that is older than its permitted lifetime of 4 frames (age = 5)
Unity.Entities.ExecuteJobFunction:Invoke(JobChunkWrapper`1&, IntPtr, IntPtr, JobRanges&, Int32)

[ line 1280309096]
```

If your autosave's version is mismatched, you may see a line like this. You must use a save file that is compatible with the server version.

```
PersistenceV2 - Not loading save file at '<VAR_SERVER_INSTALLATION_DIRECTORY>\save-data\Saves\v1\vae_victis\AutoSave_9222'. Saved PersistenceVersion (0) of SaveFile does not match current current PersistenceVersion (1)
```

### Granting admin permissions from the console

```
Admin Auth request from User: <VAR_PLAYER_STEAM_ID>, Character: Raven
UnityEngine.Logger:Log(LogType, Object)
UnityEngine.Debug:Log(Object)
ProjectM.<>c__DisplayClass_OnUpdate_LambdaJob0:OriginalLambdaBody(Entity, AdminAuthEvent&, FromCharacter&)
ProjectM.<>c__DisplayClass_OnUpdate_LambdaJob0:PerformLambda(Void*, Void*, Entity)
Unity.Entities.CodeGeneratedJobForEach.PerformLambdaDelegate:Invoke(Void*, Void*, Entity)
Unity.Entities.CodeGeneratedJobForEach.StructuralChangeEntityProvider:IterateEntities(Void*, Void*, PerformLambdaDelegate)
ProjectM.<>c__DisplayClass_OnUpdate_LambdaJob0:Execute(ComponentSystemBase, EntityQuery)
ProjectM.AdminAuthSystem:OnUpdate()
Unity.Entities.SystemBase:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
ProjectM.ServerSimulationSystemGroup:OnUpdate()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Jobs.LowLevel.Unsafe.PanicFunction_:Invoke()

Saved FileUserList to: C:\servers\v_rising\VRisingServer_Data\StreamingAssets\Settings\adminlist.txt
UnityEngine.Logger:Log(LogType, Object)
UnityEngine.Debug:Log(Object)
ProjectM.FileUserList:Save()
ProjectM.AdminAuthSystem:OnUpdate()
Unity.Entities.SystemBase:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
ProjectM.ServerSimulationSystemGroup:OnUpdate()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Jobs.LowLevel.Unsafe.PanicFunction_:Invoke()
```

### Give Item Event
```
Got GiveDebugEvent debug event from user: 94090:1 (PlatformId: <VAR_PLAYER_STEAM_ID> CharacterName: Raven) Event: Entity(138972:174)  - Entity  - FromCharacter  - GiveDebugEvent  - HandleClientDebugEvent  - NetworkEventType  - ReceiveNetworkEventTag
UnityEngine.Logger:Log(LogType, Object)
UnityEngine.Debug:Log(Object)
ProjectM.<>c__DisplayClass_NetworkEventLogging:OriginalLambdaBody(Entity, NetworkEventType&, FromCharacter&)
ProjectM.<>c__DisplayClass_NetworkEventLogging:IterateEntities(ArchetypeChunk&, Runtimes&)
ProjectM.<>c__DisplayClass_NetworkEventLogging:Execute(ArchetypeChunk, Int32, Int32)
Unity.Entities.JobChunkExtensions:RunWithoutJobs(T&, ArchetypeChunkIterator&)
StunMetrics.Collections.RefActionDelegate`2:Invoke(TObj&, T1)
Unity.Entities.InternalCompilerInterface:RunJobChunk(T&, EntityQuery, JobChunkRunWithoutJobSystemDelegate)
ProjectM.ServerBootstrapSystem:NetworkEventLogging()
ProjectM.ServerBootstrapSystem:OnUpdate()
Unity.Entities.SystemBase:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
ProjectM.ServerSimulationSystemGroup:OnUpdate()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Jobs.LowLevel.Unsafe.PanicFunction_:Invoke()
```

### VOIP

If it cannot find the file:

```
ProjectM.ServerVoipSettings - Error while trying to load settings from file. File not Found! (<VAR_SERVER_INSTALLATION_DIRECTORY>/VRisingServer_Data/StreamingAssets\Settings\ServerVoipSettings.json)
```

If it can:

```

```

As it loads:

```
Vivox Request URI <VAR_VOIPAPIEndpoint>/viv_signin.php?userid=<VAR_VOIPAppUserId>&pwd=<VAR_VOIPAppUserPwd>
UnityEngine.Logger:Log(LogType, Object)
UnityEngine.Debug:Log(Object)
ProjectM.VivoxConnectionSystem:OnUpdate()
Unity.Entities.SystemBase:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
ProjectM.ServerSimulationSystemGroup:OnUpdate()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Jobs.LowLevel.Unsafe.PanicFunction_:Invoke()
```

```
Vivox - S2S Requested Auth Token
UnityEngine.Logger:Log(LogType, Object)
UnityEngine.Debug:Log(Object)
ProjectM.VivoxConnectionSystem:OnUpdate()
Unity.Entities.SystemBase:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
ProjectM.ServerSimulationSystemGroup:OnUpdate()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Jobs.LowLevel.Unsafe.PanicFunction_:Invoke()
```

```
Vivox - Req InProgress
UnityEngine.Logger:Log(LogType, Object)
UnityEngine.Debug:Log(Object)
ProjectM.VivoxConnectionSystem:OnUpdate()
Unity.Entities.SystemBase:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
ProjectM.ServerSimulationSystemGroup:OnUpdate()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Jobs.LowLevel.Unsafe.PanicFunction_:Invoke()
```

```
Vivox - XML Resp <VAR_VOIPAppUserId>:2345678901:fc12345b67890d123d123fff1234f1c1:10.22.3.233 | <VAR_VOIPAppUserId> | sip:<VAR_VOIPAppUserId>@<VAR_VOIPVivoxDomain> | sip:<VAR_VOIPAppUserId>@<VAR_VOIPVivoxDomain>
UnityEngine.Logger:Log(LogType, Object)
UnityEngine.Debug:Log(Object)
ProjectM.VivoxConnectionSystem:OnUpdate()
Unity.Entities.SystemBase:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
ProjectM.ServerSimulationSystemGroup:OnUpdate()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Jobs.LowLevel.Unsafe.PanicFunction_:Invoke()
```

```
Vivox - S2S Auth Token OK
UnityEngine.Logger:Log(LogType, Object)
UnityEngine.Debug:Log(Object)
ProjectM.VivoxConnectionSystem:OnUpdate()
Unity.Entities.SystemBase:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
ProjectM.ServerSimulationSystemGroup:OnUpdate()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Entities.ComponentSystemGroup:UpdateAllSystems()
Unity.Entities.ComponentSystem:Update()
Unity.Jobs.LowLevel.Unsafe.PanicFunction_:Invoke()
```

### Crashes

```
Crash!!!

SymInit: Symbol-SearchPath: '.;C:\Users\Administrator\Desktop\vrisingservers\duopvp\server;C:\Users\Administrator\Desktop\vrisingservers\duopvp\server;C:\Windows;C:\Windows\system32;SRV*C:\websymbols*http://msdl.microsoft.com/download/symbols;', symOptions: 534, UserName: 'Administrator'
OS-Version: 10.0.0

<snip>

========== OUTPUTTING STACK TRACE ==================

0x00007FFB3BEC7265 (UnityPlayer) UnityMain
0x00007FFB3BEC687C (UnityPlayer) UnityMain
0x00007FFB3B85D7C7 (UnityPlayer) UnityMain
0x00007FFB3B98DBE7 (UnityPlayer) UnityMain
0x00007FFB35D33415 (GameAssembly) WriteZStream
0x00007FFB3296E93C (GameAssembly) WriteZStream
0x00007FFB328D9B89 (GameAssembly) UnityPalGetTimeZoneDataForID
0x00007FFB3B8A6028 (UnityPlayer) UnityMain
0x00007FFB3B8A9092 (UnityPlayer) UnityMain
0x00007FFB3B8C6F4F (UnityPlayer) UnityMain
0x00007FFB3B8C6FDE (UnityPlayer) UnityMain
0x00007FFB3B8C615A (UnityPlayer) UnityMain
0x00007FFB3B627864 (UnityPlayer) UnityMain
0x00007FFB3B7596CA (UnityPlayer) UnityMain
0x00007FFB3B759770 (UnityPlayer) UnityMain
0x00007FFB3B75DA08 (UnityPlayer) UnityMain
  ERROR: SymGetSymFromAddr64, GetLastError: 'Attempt to access invalid address.' (Address: 00007FFB3B51DF8A)
0x00007FFB3B51DF8A (UnityPlayer) (function-name not available)
  ERROR: SymGetSymFromAddr64, GetLastError: 'Attempt to access invalid address.' (Address: 00007FFB3B51C44B)
0x00007FFB3B51C44B (UnityPlayer) (function-name not available)
  ERROR: SymGetSymFromAddr64, GetLastError: 'Attempt to access invalid address.' (Address: 00007FFB3B52143B)
0x00007FFB3B52143B (UnityPlayer) (function-name not available)
0x00007FFB3B52254B (UnityPlayer) UnityMain
  ERROR: SymGetSymFromAddr64, GetLastError: 'Attempt to access invalid address.' (Address: 00007FF765B411F2)
0x00007FF765B411F2 (VRisingServer) (function-name not available)
0x00007FFB7BC57974 (KERNEL32) BaseThreadInitThunk
0x00007FFB7EA6A2F1 (ntdll) RtlUserThreadStart

========== END OF STACKTRACE ===========

A crash has been intercepted by the crash handler. For call stack and other details, see the latest crash report generated in:
 * C:/Users/<USERNAME>/AppData/Local/Temp/2/Stunlock Studios/VRisingServer/Crashes

```

## Server Startup

### Server Loading on 2020.3.31f1 (6b54b7616050)

```
Initialize engine version: 2020.3.31f1 (6b54b7616050)

SLS_COLLECTIONS_CHECKS defined.

System Information:

Bootstrapping World: Default World

ProjectM.InputSettings - Error while trying to load settings from file. File not Found! (<VAR_SERVER_INSTALLATION_DIRECTORY>/VRisingServer_Data/StreamingAssets\Settings\InputSettings.json)

SteamPlatformSystem - Entering OnCreate!

Loaded VersionDataSettings:

PersistenceVersionOverride value found from VersionDataSettings: 1

Persistence Version initialized as: 1

Loading ServerHostSettings from: .\save-data\Saves\v1\clever1

Commandline Parameter ServerName: "<VAR_SERVERNAME>"

Loaded ServerHostSettings:

Setting breakpad minidump AppID = 1604030

SteamPlatformSystem -  Server App ID: 1604030

SteamPlatformSystem - Steam GameServer Initialized!

SteamLog [SDR k_ESteamNetworkingSocketsDebugOutputType_Msg] Got SDR network config.  Loaded revision 372 OK

SteamLog [SDR k_ESteamNetworkingSocketsDebugOutputType_Msg] Performing ping measurement

SteamLog [SDR k_ESteamNetworkingSocketsDebugOutputType_Msg] SDR RelayNetworkStatus:  avail=Attempting  config=OK  anyrelay=Attempting   (Performing ping measurement)

SteamLog [SDR k_ESteamNetworkingSocketsDebugOutputType_Msg] Relay lim#81 (190.217.33.50:27049) is going offline in 315 seconds

SteamLog [SDR k_ESteamNetworkingSocketsDebugOutputType_Msg] Gameserver logged on to Steam, assigned identity steamid:90111111101111111

SteamLog [SDR k_ESteamNetworkingSocketsDebugOutputType_Msg] AuthStatus (steamid:90111111101111111):  Attempting  (Requesting cert)

SteamLog [SDR k_ESteamNetworkingSocketsDebugOutputType_Msg] Set SteamNetworkingSockets P2P_STUN_ServerList to '162.254.192.87:3478' as per SteamNetworkingSocketsSerialized

SteamPlatformSystem - Server connected to Steam successfully!

SteamNetworking - Successfully logged in with the SteamGameServer API. SteamID: 90111111101111111

ProjectM.ClientSettings - Error while trying to load settings from file. File not Found! (<VAR_SERVER_INSTALLATION_DIRECTORY>/VRisingServer_Data/StreamingAssets\Settings\ClientSettings.json)

Loaded ClientSettings:

SteamLog [SDR k_ESteamNetworkingSocketsDebugOutputType_Msg] AuthStatus (steamid:90111111101111111):  OK  (OK)

SteamLog [SDR k_ESteamNetworkingSocketsDebugOutputType_Msg] Certificate expires in 48h00m at 1653976869 (current time 1653804069), will renew in 46h00m

SteamPlatformSystem - OnPolicyResponse - Game server SteamID: 90111111101111111

SteamPlatformSystem - OnPolicyResponse - Game Server VAC Secure!

SteamPlatformSystem - OnPolicyResponse - Public IP: <VAR_PUBLIC_IP>

ProjectM.GameDataSettings - Error while trying to load settings from file. File not Found! (<VAR_SERVER_INSTALLATION_DIRECTORY>/VRisingServer_Data/StreamingAssets\Settings\GameDataSettings.json)

Check Host Server - HostServer: False, DedicatedServer: True

BatchMode Host - CommandLine: VRisingServer.exe -persistentDataPath .\save-data -serverName "<VAR_SERVERNAME>" -saveName clever1 -logFile .\logs\VRisingServer.log

Server Host - SaveName: clever1

Attempting to load most recent save file for SaveDirectory: .\save-data\Saves\v1\clever1. SaveToLoad: <VAR_SERVER_INSTALLATION_DIRECTORY>\save-data\Saves\v1\clever1\AutoSave_633

CreateAndHostServer - SaveDirectory:.\save-data\Saves\v1\clever1, Loaded Save:<VAR_SERVER_INSTALLATION_DIRECTORY>\save-data\Saves\v1\clever1\AutoSave_633

Loaded FileUserList from: <VAR_SERVER_INSTALLATION_DIRECTORY>\VRisingServer_Data\StreamingAssets\Settings\adminlist.txt. Content:<VAR_PLAYER_STEAM_ID>

Loaded FileUserList from: <VAR_SERVER_INSTALLATION_DIRECTORY>\VRisingServer_Data\StreamingAssets\Settings\banlist.txt. Content:

---- OnCreate: ServerDebugSettingsSystem

ProjectM.ServerDebugSettings - Error while trying to load settings from file. File not Found! (<VAR_SERVER_INSTALLATION_DIRECTORY>/VRisingServer_Data/StreamingAssets\Settings\ServerDebugSettings.json)

[Debug] ServerGameSettingsSystem - OnCreate

[Debug] ServerGameSettingsSystem - OnCreate - Loading ServerGameSettings via Commandline Parameter (serverSaveName)!

[Debug] Loading ServerGameSettings from: .\save-data\Saves\v1\clever1

[Debug] ServerGameSettingsSystem - OnCreate - Loading ServerGameSettings via ServerRuntimeSettings settings!

[Debug] Loading ServerGameSettings from: .\save-data\Saves\v1\.\save-data\Saves\v1\clever1

ERROR: Shader GUI/Text Shader shader is not supported on this GPU (none of subshaders/fallbacks are suitable)

[rcon] Started listening on 0.0.0.0, Password is: "<VAR_RCON_PASSWORD>"

[Server] LoadSceneAsync Request 'WorldAssetSingleton', WaitForSceneLoad: True, SceneEntity: 532:1

Starting up ServerSteamTransportLayer. GameServer ID: 90111111101111111

Opening SteamIPv4 socket on port: 9876. Socket: 131073

Opening SteamSDR socket on virtual port: 0. Socket: 196610

```