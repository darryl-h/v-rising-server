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
  - [Dedciated Server](#dedciated-server)
  - [Private Server](#private-server)
  - [Log Variables](#log-variables)
  - [Specific Troubleshooting Instructions](#specific-troubleshooting-instructions)
    - [Server isn't visible on server browser](#server-isnt-visible-on-server-browser)
    - [Loading adminlist](#loading-adminlist)
    - [Loading Banlist](#loading-banlist)
    - [Update Master Server](#update-master-server)
    - [Broadcasting public IP](#broadcasting-public-ip)
    - [Autosaves](#autosaves)
    - [Granting admin permissions from the console](#granting-admin-permissions-from-the-console)
    - [Give Item Event](#give-item-event)
    - [VOIP](#voip)

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
We will assume that you want to install the server in `C:\servers\v_rising` if you do not, change the path in the following commands.

We will install the PowerShell module for SteamCLI to install and update the server.
```powershell
Install-Module -Name SteamPS
Install-SteamCMD
Update-SteamApp -ApplicationName 'V Rising Dedicated Server' -Path 'C:\servers\v_rising'
```
**NOTE:** Any questions should be answered with yes

# Configuration

## Server StartUp
* Copy the <server_directory>\start_server_example.bat to a new file (I called mine start_server.bat)
Inside the file, change the serverName (My Cool Server) and the -saveName (coolServer1)

  ```batch
  @echo off
  REM Copy this script to your own file and modify to your content. This file can be overwritten when updating.
  set SteamAppId=1604030
  echo "Starting V Rising Dedicated Server - PRESS CTRL-C to exit"

  @echo on
  VRisingServer.exe -persistentDataPath .\save-data -serverName "My Cool Server" -saveName "coolServer1" -logFile ".\logs\VRisingServer.log"
  ```

## Server Settings Files
1. Create the directory `<server_directory>\save-data\Settings`
2. Copy and paste `ServerHostSettings.json` and `ServerGameSettings.json` files from `<server_directory>/VRisingServer_Data/StreamingAssets/Settings/` into the directory you created in step 1

You can see the effects of all the settings in this PDF: https://cdn.stunlock.com/blog/2022/05/25083113/Game-Server-Settings.pdf

**NOTE:** Within the `ServerHostSettings.json` file, in `Description` field, you can use line breaks using `\n`
**NOTE:** If you elect to directly modify the configuration files in `<server_directory>/VRisingServer_Data/StreamingAssets/Settings/` you may loose your configuration changes with new updates, so you may want to consider backing them up.

## Adding yourself to the adminlist.txt file
In the logs, you should see the `adminlist.txt` and `banlist.txt` lists loaded, and thier path is <server_directory>\VRisingServer_Data\StreamingAssets\Settings\
**NOTE:** This is the only valid place for these entires!

Example:
```
Loaded FileUserList from: C:\servers\v_rising\VRisingServer_Data\StreamingAssets\Settings\banlist.txt. Content:
Loaded FileUse@winrList from: C:\servers\v_rising\VRisingServer_Data\StreamingAssets\Settings\adminlist.txt. Content:
```

* You will need to add your 64-bit SteamID which can be found using this resource(https://steamdb.info/calculator/), or, after you connect in the server logs.
* In the general settings of the game, you must enable the console (Options -> General -> Console Enabled)
* Once you connect type `adminauth` to enable admin access
* You will need to restart the server to reload any changes to these files

## Allow the vRising game through the windows firewall
You may need to allow the executable (VRisingServer.exe) through the windows firewall

## Configure your router to allow UDP ports to the server
If you wish your server to be listed on the in game server browser, and people to connect from the internet, you will need to open two UDP ports to the server.
These ports are configured in the `ServerHostSettings.json` file
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
We can use the exact same command we used to install the game, to update the game.
```powershell
Update-SteamApp -ApplicationName 'V Rising Dedicated Server' -Path 'C:\servers\v_rising'
```
Ideally, we should be able to setup a scheudled task to also update the server on a daily basis automatically, but **since the update is interactive, this will not work.**  

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
* In the `Add Arguments` field, enter `Update-SteamApp -ApplicationName 'V Rising Dedicated Server' -Path 'C:\servers\v_rising'`
* Click `Next`
* Click `Finish`

# Intresting Admin Console Commands
`copyPositionDump` - Will copy your current position to your clipboard (These are not very accurate!)

# Troubleshooting
You should review the logs of the server to begin any troubleshooting session.

## Dedciated Server
If you are hosting the game as a dedicated server, and you are using the batch file to start the game (as recommended) the logs should exist in `<server_directory>\v_rising\logs\VRisingServer.log`

## Private Server
If you elect to host the server from the game as a private server, then the server will place the main server engine logs in `%USERPROFILE%\AppData\LocalLow\Stunlock Studios\VRising\Player-server.log` (the previous run will be stored in `%USERPROFILE%\AppData\LocalLow\Stunlock Studios\VRising\Player-prev.log` and some supplimentry logs in `\steamapps\common\VRising\VRising_Server\logs`

## Log Variables
<VAR_PLAYER_STEAM_ID> - Steam Player ID  
<VAR_PUBLIC_IP> - Server Public IP  
<VAR_VOIPAPIEndpoint> - The `VOIPAPIEndpoint` from your ServerVoipSettings.json file  
<VAR_VOIPAppUserId> - The `VOIPAppUserId` from your ServerVoipSettings.json file  
<VAR_VOIPAppUserPwd> - The `VOIPAppUserPwd` from your ServerVoipSettings.json file  

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

### Loading adminlist
```
Loaded FileUserList from: C:\servers\v_rising\VRisingServer_Data\StreamingAssets\Settings\adminlist.txt. Content:<VAR_PLAYER_STEAM_ID>
76561197961155759
76561197961821588
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