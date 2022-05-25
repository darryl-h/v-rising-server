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
1. Create the directory <server_directory>\save-data\Settings
2. Copy and paste the settings files from <server_directory>/VRisingServer_Data/StreamingAssets/Settings/ (ServerHostSettings.json, ServerGameSettings.json, adminlist.txt and banlist.txt) into the directory you created in step 1

You can see the effects of all the settings in this PDF: https://cdn.stunlock.com/blog/2022/05/25083113/Game-Server-Settings.pdf

**NOTE: **If you elect to directly modify the configuration files in <server_directory>/VRisingServer_Data/StreamingAssets/Settings/ you may loose your configuration changes with new updates, so you may want to consider backing them up.

# Server updates
We can setup a scheudled task to also update the server on a daily basis automatically

## In Windows Task Scheulder
* Create basic Task
* Name it "Update Steam Server"
* Set it to run at a low user time (09:00 AM EST)
* Action : Start a program
* Program/Script: powershell
* Add Arguments: "Update-SteamApp -ApplicationName 'V Rising Dedicated Server' -Path 'C:\servers\v_rising'"
**Note** I need to figure out a way to auto answer yes here.

# Server start with windows
* Create basic Task
* Name it "Start V-Rising Steam Server"
* Set it to start with the computer
* Action : Start a program
* Program/Script: point it at the start_server.bat we created earlier

# Allow the vRising game through the windows firewall
You may need to allow the executable () through the windows firewall

# Configure your router to allow UDP ports to the server
If you wish your server to be listed on the in game server browser, and people to connect from the internet, you will need to open two UDP ports to the server.
These ports are configured in the ServerHostSettings.json file
```json
"Port": 9876,
"QueryPort": 9877,
```

**NOTE** If your server is not listed on the server browser, check the SteamAPI by replacing the IP (1.2.3.4) with your IP, if it showing up, you will have to wait for Steam to pickup the update.
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
* You will add your SteamID which can be found using this resource(https://steamdb.info/calculator/), or, after you connect in the server logs.
* In the general settings of the game, you should enable the console
* Once you connect type `adminauth` to enable admin access


