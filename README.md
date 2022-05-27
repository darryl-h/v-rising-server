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

# Setup
We will assume that you want to install the server in `C:\servers\v_rising` if you do not, change the path in the following commands.

# Installation of the game
We will install the PowerShell module for SteamCLI to install and update the server.
```powershell
Install-Module -Name SteamPS
Install-SteamCMD
Update-SteamApp -ApplicationName 'V Rising Dedicated Server' -Path 'C:\servers\v_rising'
```
**NOTE:** Any questions should be answered with yes

# Server start file
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

# Server Settings Files
1. Create the directory `<server_directory>\save-data\Settings`
2. Copy and paste `ServerHostSettings.json` and `ServerGameSettings.json` files from `<server_directory>/VRisingServer_Data/StreamingAssets/Settings/` into the directory you created in step 1

You can see the effects of all the settings in this PDF: https://cdn.stunlock.com/blog/2022/05/25083113/Game-Server-Settings.pdf

**NOTE:** Within the `ServerHostSettings.json` file, in `Description` field, you can use line breaks using `\n`
**NOTE:** If you elect to directly modify the configuration files in `<server_directory>/VRisingServer_Data/StreamingAssets/Settings/` you may loose your configuration changes with new updates, so you may want to consider backing them up.

# Server updates
We can use the exact same command we used to install the game, to update it
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

# Server start with windows
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

# Allow the vRising game through the windows firewall
You may need to allow the executable (VRisingServer.exe) through the windows firewall

# Configure your router to allow UDP ports to the server
If you wish your server to be listed on the in game server browser, and people to connect from the internet, you will need to open two UDP ports to the server.
These ports are configured in the `ServerHostSettings.json` file
```json
"Port": 9876,
"QueryPort": 9877,
```

**NOTE** If your server is not listed on the server browser, check the SteamAPI by replacing the IP (`1.2.3.4`) with your public IP(http://whatismyip.com), if it showing up, you will have to wait for Steam to pickup the update.
```
https://api.steampowered.com/ISteamApps/GetServersAtAddress/v0001?addr=1.2.3.4
```

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

# Adding yourself to the adminlist.txt file
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

# Troubleshooting
You should review the logs of the server to begin any troubleshooting session.

## Dedciated Server
If you are hosting the game as a dedicated server, and you are using the batch file to start the game (as recommended) the logs should exist in <server_directory>\v_rising\logs\VRisingServer.log

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




## Private Server
If you elect to host the server from the game as a private server, then the server will place the logs in \steamapps\common\VRising\VRising_Server\logs


