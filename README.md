- [Global Banlist](#global-banlist)
- [Official Guide](#official-guide)
- [Installation of the game using PowerShell and SteamPS](#installation-of-the-game-using-powershell-and-steamps)
- [Configuration](#configuration)
  - [Server StartUp](#server-startup)
  - [Server Settings Files](#server-settings-files)
  - [Adding yourself to the adminlist.txt file](#adding-yourself-to-the-adminlisttxt-file)
  - [Allow the vRising game through the windows firewall](#allow-the-vrising-game-through-the-windows-firewall)
  - [Configure your router to allow UDP ports to the server](#configure-your-router-to-allow-udp-ports-to-the-server)
  - [Server start with windows](#server-start-with-windows)
- [Server updates](#server-updates)
  - [In Windows Task Scheulder](#in-windows-task-scheulder)
- [Intresting Admin Console Commands](#intresting-admin-console-commands)
- [Troubleshooting](#troubleshooting)
  - [Dedicated Server](#dedicated-server)
  - [Private Server](#private-server)
  - [Log Variables](#log-variables)
  - [Server Loading](#server-loading)
  - [Specific Troubleshooting Instructions](#specific-troubleshooting-instructions)
    - [Server isn't visible on server browser](#server-isnt-visible-on-server-browser)
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

## Server StartUp
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

## Adding yourself to the adminlist.txt file
In the logs, you should see the `adminlist.txt` and `banlist.txt` lists loaded, and thier path is `<VAR_SERVER_INSTALLATION_DIRECTORY>\VRisingServer_Data\StreamingAssets\Settings\`  
**NOTE:** This is the only valid place for these entires!

* You will need to add your 64-bit SteamID which can be found using this resource(https://steamdb.info/calculator/), or, after you connect in the server logs.
* In the general settings of the game, you must enable the console (Options -> General -> Console Enabled)
* Once you connect type `adminauth` to enable admin access
* You will need to restart the server to reload any changes to these files

## Allow the vRising game through the windows firewall
You may need to allow the executable (VRisingServer.exe) through the windows firewall

## Configure your router to allow UDP ports to the server
If you wish your server to be listed on the in game server browser, and people to connect from the internet, you will need to open two UDP ports to the server.
These ports are configured in the `<VAR_SERVER_INSTALLATION_DIRECTORY>\save-data\Settings\ServerHostSettings.json` file
```json
"Port": 9876,
"QueryPort": 9877,
```

## Server start with windows
* Create a `Basic Task`
* Name it `Start V-Rising Server on boot`
* Click `Next`
* In the `When do you want the task to start` radio box, select `When the computer starts`
* Click `Next`
* In the `What action do you want the task to perform` radio box, select `Start a program`
* Click `Next`
* Beside the `Program/Script:` field, click `Browse`
* Select the the `start_server.bat` we created earlier
* Click `Next`
* Click `Finish`

# Server updates
We can use the exact same command we used to install the game, to update the game, however, since we need to enter "Y" to start the update, we will wrap it in a batch file, and place it with the startup batch file in the `<VAR_SERVER_INSTALLATION_DIRECTORY>`

`update.bat`
```dos
ECHO Y | powershell Update-SteamApp -ApplicationName 'V Rising Dedicated Server' -Path 'C:\servers\v_rising'
```

## In Windows Task Scheulder
* Create a `Basic Task`
* Name it `Update V-Rising Server`
* Click `Next`
* In the `When do you want the task to start` radio box, select `Daily`
* Click `Next`
* Beside the `Start:` Field, select todays date, and a time when you want the update to happen (Usually a low user time, like 09:00 AM EST))
* Ensure that the `Recur Every` is set to `1`
* Click `Next`
* In the `What action do you want the task to perform` radio box, select `Start a program`
* Click `Next`
* Beside the `Program/Script:` field, type `powershell`
* In the `Add Arguments` field, enter `update.bat`
* Click `Next`
* Click `Finish`

# Intresting Admin Console Commands
`copyPositionDump` - Will copy your current position to your clipboard (These are not very accurate!)  
`toggleobserve` - Set yourself to observer mode, you will get damage immunity and a speed boost  
`https://discord.com/channels/803241158054510612/976404273015431168/980326759293673472` - Teleport map  
`https://discord.com/channels/803241158054510612/976404273015431168/980896456766533743` - VOIP setup  

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

### Server isn't visible on server browser
You should check the logs to ensure that the server is indeed trying to reach out to the master server

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

If you have more than one public IP (VPN, Dual ISPs etc) you should ensure that the game is reporting the expected public IP `<VAR_PUBLIC_IP>`

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

* You can validate your public IP by checking a tool like http://whatismyip.com
* You can check tools like this that should query the UDP ports to retrieve data https://southnode.net/steamquery.php
* You can test to see if the SteamAPI is reporting the game data back using this URL (Replace 1.2.3.4 with your public IP) https://api.steampowered.com/ISteamApps/GetServersAtAddress/v0001?addr=1.2.3.4
  ```json
  {
    "response": {
      "success": true,
      "servers": [
        {
          "addr": "1.2.3.4:9877",
          "gmsindex": -1,
          "steamid": "90159453801734145",
          "appid": 1604030,
          "gamedir": "V Rising",
          "region": -1,
          "secure": true,
          "lan": false,
          "gameport": 9876,
          "specport": 0
        }
      ]
    }
  }
  ```
* You can directly check the official server list by checking this URL: https://vrising-client.s3.eu-central-1.amazonaws.com/vrising/live-adcd966f-655a-4dfa-af15-a3069cc6b221/official.txt (This URL can be found in the logs in the `OfficialServersURL` field)
  ```
  Loaded ClientSettings:
  {
    "General": {
      "ServerPath": "VRising.exe",
      "PlatformNotificationPosition": 2,
      "NewsURL": "",
      "OfficialServersURL": "https://vrising-client.s3.eu-central-1.amazonaws.com/vrising/live-adcd966f-655a-4dfa-af15-a3069cc6b221/official.txt",
      "ServerPartnerURL": "https://www.g-portal.com/vrising",
      "ServerInstuctionsURL": "https://github.com/StunlockStudios/vrising-dedicated-server-instructions",
      "BranchOverride": "",
      "EnableConsole": false
    },
  ```

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