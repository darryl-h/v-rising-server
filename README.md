- [Global Banlist](#global-banlist)
- [Official Guide](#official-guide)
- [Installation of the game using PowerShell and SteamPS](#installation-of-the-game-using-powershell-and-steamps)
- [Configuration](#configuration)
  - [Server StartUp Batch File](#server-startup-batch-file)
  - [Server Settings Files](#server-settings-files)
  - [Server Startup, and Restarting on Failure](#server-startup-and-restarting-on-failure)
  - [Enabling Console Access](#enabling-console-access)
  - [Adding yourself to the adminlist.txt file](#adding-yourself-to-the-adminlisttxt-file)
  - [Allow the vRising game through the windows firewall](#allow-the-vrising-game-through-the-windows-firewall)
  - [Configure your router to allow UDP ports to the server](#configure-your-router-to-allow-udp-ports-to-the-server)
- [Server updates](#server-updates)
  - [In Windows Task Scheulder](#in-windows-task-scheulder)
- [Intresting Admin Console Commands](#intresting-admin-console-commands)
- [Troubleshooting](#troubleshooting)
  - [Dedicated Server](#dedicated-server)
  - [Private Server](#private-server)
  - [Log Variables](#log-variables)
  - [Server Loading](#server-loading)
  - [Specific Troubleshooting Instructions](#specific-troubleshooting-instructions)
    - [Troubleshooting Networking In Windows](#troubleshooting-networking-in-windows)
    - [Server not listed on the server browser](#server-not-listed-on-the-server-browser)
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

# Global Banlist
The `banlist.txt` file in this repository will contain a list of Steam IDs who have griefed.  
If your ID is on this list, it will not be removed and **there is no arbitration**.  
As a server opreator, you may elect to add these IDs to your server, or not.  
If you wish to add to this list:
* Create a new issue
* Add the evidence (screen shot of the grief, and the steam ID)

Griefing is defined as:
* Cheating
* Blocking entrances to anothers castle

# Official Guide
https://github.com/StunlockStudios/vrising-dedicated-server-instructions

# Installation of the game using PowerShell and SteamPS
We will assume that you want to install the server in `C:\servers\v_rising` (This will be <VAR_SERVER_INSTALLATION_DIRECTORY> in the rest of this document) if you do not, change the path in the following commands.

We will install the PowerShell module for SteamCLI to install and update the server.
```powershell
Install-Module -Name SteamPS
Install-SteamCMD
Update-SteamApp -ApplicationName 'V Rising Dedicated Server' -Path 'C:\servers\v_rising'
```
**NOTE:** Any questions should be answered with yes

# Configuration

## Server StartUp Batch File
* Copy the `<VAR_SERVER_INSTALLATION_DIRECTORY>\start_server_example.bat` to a new file (I called mine `<VAR_SERVER_INSTALLATION_DIRECTORY>\start_server.bat`)
Inside the file, change the serverName (`My Cool Server`) and the -saveName (`coolServer1`)

  ```batch
  @echo off
  REM Copy this script to your own file and modify to your content. This file can be overwritten when updating.
  set SteamAppId=1604030
  echo "Starting V Rising Dedicated Server - PRESS CTRL-C to exit"

  @echo on
  VRisingServer.exe -persistentDataPath .\save-data -serverName "My Cool Server" -saveName "coolServer1" -logFile ".\logs\VRisingServer.log"
  ```

## Server Settings Files
1. Create the directory `<VAR_SERVER_INSTALLATION_DIRECTORY>\save-data\Settings`
2. Copy and paste `ServerHostSettings.json` and `ServerGameSettings.json` files from `<VAR_SERVER_INSTALLATION_DIRECTORY>/VRisingServer_Data/StreamingAssets/Settings/` into the directory you created in step 1

You can see the effects of all the settings in this PDF: https://cdn.stunlock.com/blog/2022/05/25083113/Game-Server-Settings.pdf

**NOTE:** Within the `<VAR_SERVER_INSTALLATION_DIRECTORY>\save-data\Settings\ServerHostSettings.json` file, in `Description` field, you can use line breaks using `\n`  

**NOTE:** If you elect to directly modify the configuration files in `<VAR_SERVER_INSTALLATION_DIRECTORY>\VRisingServer_Data\StreamingAssets\Settings\` you may loose your configuration changes with new updates, so you may want to consider backing them up.

## Server Startup, and Restarting on Failure
This will restart the service if crashes, and sets up the server to start the service when the machine starts up.

In this example, we will setup the server with NSSM (Non Sucking Service Manager)

1) Download the NSSM archive from the nssm webpage (https://nssm.cc/download)
2) Extract the NSSM program, and place `nssm.exe` into a the game directory
3) Drop to a `cmd` prompt (`Start` -> `Run` -> `cmd`)
4) Enter the NSSM directory and create the service.
    ```dos
    cd <VAR_SERVER_INSTALLATION_DIRECTORY>
    nssm install VRisingServer
    ```
5) Click on `...` beside `Path` and locate to the `.bat` file used to start the server, created previously
6) Click `Install Service`
7) Click `OK`
8) Drop to a `cmd` prompt (`Start` -> `Run` -> `cmd`)
9) Start the service now
    ```dos
    cd <VAR_SERVER_INSTALLATION_DIRECTORY>
    nssm start VRisingServer
    ```

## Enabling Console Access
* To enable the console, go to `Options` -> `General` -> put a check in `Console Enabled`
* Press the backtick key (\`) or (`§`) depending on your keyboard layout
* Once you connect type `adminauth` to enable admin access

## Adding yourself to the adminlist.txt file
In the logs, you should see the `adminlist.txt` and `banlist.txt` lists loaded, and thier path is `<VAR_SERVER_INSTALLATION_DIRECTORY>\VRisingServer_Data\StreamingAssets\Settings\`  
**NOTE:** This is the only valid place for these entires!

* You will need to restart the server to reload any changes to these files (They SHOULD get picked up automatically, but unclear)

## Allow the vRising game through the windows firewall
You may need to allow the executable (VRisingServer.exe) through the windows firewall

## Configure your router to allow UDP ports to the server
If you wish your server to be listed on the in game server browser, and people to connect from the internet, you will need to open two UDP ports to the server.
These ports are configured in the `<VAR_SERVER_INSTALLATION_DIRECTORY>\save-data\Settings\ServerHostSettings.json` file
```json
"Port": 9876,
"QueryPort": 9877,
```

# Server updates
We can use the exact same command we used to install the game, to update the game, however, since we need to enter "Y" to start the update, we will wrap it in a batch file, and place it with the startup batch file in the `<VAR_SERVER_INSTALLATION_DIRECTORY>`, we will also announce to the players we are doing this with mcrcon (https://github.com/Tiiffi/mcrcon/releases/) which we will place in the server directory as well for ease of access. For the update itself, you can replace the powershell command with steamcmd (assuming you also place it in the server directory) if you wish using `steamcmd.exe +login anonymous +app_update 1829350 validate +quit`  

**NOTE**: In either case, you will need to update the path to the server by replacing any line with `C:\servers\v_rising` with the correct path for your server.

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

## In Windows Task Scheulder
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
* Beside the `Program/Script:` field, type `powershell`
* In the `Add Arguments` field, enter `update.bat`
* Click `Next`
* Click `Finish`

# Intresting Admin Console Commands
Your current binds can be found in: `%USERPROFILE%\AppData\LocalLow\Stunlock Studios\VRising\ConsoleProfile\<machine_name.prof>`  

You can bind a command to a function key from the console like this:
`Console.Bind F1 listusers`


`copyPositionDump` - Will copy your current position to your clipboard (These are not very accurate!)  
`https://discord.com/channels/803241158054510612/976404273015431168/980326759293673472` - Teleport map  
`toggleobserve` - Set yourself to observer mode, you will get damage immunity and a speed boost  
`https://discord.com/channels/803241158054510612/976404273015431168/980896456766533743` - VOIP setup (Also in the pinned messages)  
`ToggleDebugViewCategory Network` - Turn on network reporting (latency, FPS, users)
`changehealthclosesttomouse -5000` - Remove palisades or castle that may be blocking passage (You may want to `console.bind` this to a function key for easy access.)


# Troubleshooting
You should review the logs of the server to begin any troubleshooting session.

## Dedicated Server
If you are hosting the game as a dedicated server, and you are using the batch file to start the game (as recommended) the logs should exist in `<VAR_SERVER_INSTALLATION_DIRECTORY>\logs\VRisingServer.log`

## Private Server
If you elect to host the server from the game as a private server, then the server will place the main server engine logs in `%USERPROFILE%\AppData\LocalLow\Stunlock Studios\VRising\Player-server.log` and some supplimentry logs in `\steamapps\common\VRising\VRising_Server\logs`

There are also user client logs in in `%USERPROFILE%\AppData\LocalLow\Stunlock Studios\VRising\Player-prev.log` 

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

## Server Loading
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

## Specific Troubleshooting Instructions

### Troubleshooting Networking In Windows
1) Find the PID of the `VRisingServer.exe` in `Task Manager` in the `Details` tab
2) Check your server configuration file `ServerHostSettings.json` we are looking for `Port`, `QueryPort`, and optionally `Rcon/Port`
3) run `cmd`
4) type in `netstat -aon | find "<PID>"` where PID is the PID of the server you found in step 1
5) You should see something like this
    ```
      TCP    0.0.0.0:<Rcon/Port>           0.0.0.0:0              LISTENING       <PID>
      UDP    0.0.0.0:<Port>                *:*                                    <PID>
      UDP    0.0.0.0:<QueryPort>           *:*                                    <PID>
    ```

6) Ensure that the game is allowed through the Windows Firewall, if you have added the executable to the windows firewall (rather than just the ports), then you can do this from the command prompt:

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

7) Open your router and firewall ports to allow the UDP connections (and TCP if you want RCON)
This is beyond the scope of this document, as it is device specific, but you can try https://PortForward.com

8) Validate with your internet provider if you are able to run a servers (specifically game servers) from your purchased internet package. They may block this kind of traffic by blocking specific ports, or using packet inspection to determine the type of traffic. (This is beyond the scope of this document).  
If you check https://ipv6-test.com/ and the shown IP on that web page is different from your address shown in your router, your address may be translated and it may be impossible to host. Additionally some providers (namely in Germany) may use something like Carrier Grade NAT (CGNAT) or DS-Lite which may prevent you from running a server. In these cases, you can try to contact your ISP and see if you are able to get an IPv4 address. You *may* be able to get away with something like Fast Reverse Proxy (https://gabrieltanner.org/blog/port-forwarding-frp) but this is again, outside the scope of this document.

### Server not listed on the server browser
1) Ensure that your `ServerHostSettings.json` configuration file has `ListOnMasterServer` set to `true`  
   
2) Within the `ServerHostSettings.json` configuration file, ensure your `Port` and `QueryPort` are configured in the Windows Firewall to allow UDP traffic OR allow the `VRisingServer.exe` through the firewall  

3) Ensure that you see the server listed on the output from `netstat -aon` the output should look something like this (You should see additional ports listed for the PID, but these are the ones we are concerned with):
    ```
    UDP    0.0.0.0:<Port>                *:*                                    <PID>
    UDP    0.0.0.0:<QueryPort>           *:*                                    <PID>
    ```
4) Configure your router to allow both ports in step 2 to be forwarded to the server (You can refer to https://portforward.com for assistance, but this is device specific, and beyond the scope of this document)  
**NOTE:** Since these are UDP ports, there is no good/easy way to test them remotely other than with a game client.

5) Check your `VRisingServer.log` server logs inside the appropriate directory for the public IP, the logs should look like this: `SteamPlatformSystem - OnPolicyResponse - Public IP: <VAR_PUBLIC_IP>` and ensure this is the public IP you expect it to be (This is especially useful if you have a VPN or secondary internet provider)
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

6) Test that your server is able to be queried by the SteamAPI by entering your public IP on this tool  https://southnode.net/steamquery.php , and/or using https://api.steampowered.com/ISteamApps/GetServersAtAddress/v0001?addr=1.2.3.4 (Replace 1.2.3.4 with your public IP)

7) BE PATIENT! The listing process can take time, it appears that you have done everything you can to ensure that your server is able to be queried.  
**NOTE:** SOME users have found that changing both ports to something else, and back have forced the server to be listed. This is VERY anecdotal, and may infact increase the waiting process.

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
Loaded FileUserList from: C:\servers\v_rising\VRisingServer_Data\StreamingAssets\Settings\adminlist.txt. Content:<VAR_PLAYER_STEAM_ID>
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
Loaded FileUserList from: C:\servers\v_rising\VRisingServer_Data\StreamingAssets\Settings\banlist.txt. Content:<VAR_PLAYER_STEAM_ID>
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