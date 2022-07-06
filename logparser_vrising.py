#!/usr/bin/python3

import sys
from pathlib import Path
import argparse
import textwrap
import re

"""
Purpose: This will parse the logs for the server.
"""

__author__ = "Darryl Hing"
__copyright__ = "Darryl Hing"
__credits__ = ["Darryl Hing"]
__license__ = "Closed Source Software License"
__version__ = "0.0.9"
__maintainer__ = "Darryl Hing"
__email__ = "fidelite@gmail.com"
__status__ = "Production"

class set_colors:
    ResetAll   = "\033[0m"
    Bold       = "\033[1m"
    Dim        = "\033[2m"
    Underlined = "\033[4m"
    Blink      = "\033[5m"
    Reverse    = "\033[7m"
    Hidden     = "\033[8m"

    Default      = "\033[39m"
    Black        = "\033[30m"
    Red          = "\033[31m"
    Green        = "\033[32m"
    Yellow       = "\033[33m"
    Blue         = "\033[34m"
    Magenta      = "\033[35m"
    Cyan         = "\033[36m"
    LightGray    = "\033[37m"
    DarkGray     = "\033[90m"
    LightRed     = "\033[91m"
    LightGreen   = "\033[92m"
    LightYellow  = "\033[93m"
    LightBlue    = "\033[94m"
    LightMagenta = "\033[95m"
    LightCyan    = "\033[96m"
    White        = "\033[97m"    



# HELP AND ARGUMENT PARSING
## Create a new help class formatter with the column position at 45
nicer_formatter = lambda prog: argparse.RawDescriptionHelpFormatter(prog,max_help_position=45)
## Process arguments
parser = argparse.ArgumentParser(
    formatter_class=nicer_formatter,
    description=textwrap.dedent('''\
         Use a CSV provided by operations to update the configuration vertical field custom field
         '''))
parser.add_argument("-c", "--checktype", required=True, help="Set the type of check to do on the logs, this can be 'info', 'user', 'startup' or 'error'")
parser.add_argument("-i", "--inputfile", required=True, help="Specify the V Rising input filename")
args = parser.parse_args()

# Assign the input as a variable
check_type=args.checktype
input_file=args.inputfile
#print (input_file)

# Ensure that the log file exists, or exit
log_file = Path(input_file)
if not log_file.is_file():
    print ('Cannot find the file specified (' + str(input_file) + ')!')
    exit()
#print (log_file)

if check_type == 'info':
    with open(input_file) as file_handle:
        for num, line in enumerate(file_handle, 1):
            if "Initialize engine version: " in line:
                print ("====[ Game Version Information ]====")
                engine_version = line.split(' ')[3]
                engine_build = line.split(' ')[4]
                print ("Engine Version: " + engine_version + " " + engine_build, end="")
            elif "Bootstrap - Time:" in line:
                server_version = line.split(' ')[7]
                print ("Server Version: " + server_version)
            elif "processorFrequency:" in line:
                print ("====[ Server Hardware Information ]====")
                print (line, end="")
            elif "operatingSystem:" in line:
                print (line, end="")
            elif "processorType" in line:
                print (line, end="")
            elif "processorCount" in line:
                print (line, end="")
            elif "systemMemorySize" in line:
                print (line, end="")
                print ("====[ Game Information ]====")
            # Game Information
            #elif "Public IP:" in line:
            #    public_ip = line.split(' ')[6]
            #    print ("Public IP: " + autosave, end="")
            elif '"Name"' in line:
                print (line, end="")
            elif "GameSettingsPreset:" in line:
                print (line, end="")
            elif "AutoSaveCount" in line:
                print (line, end="")
            elif "AutoSaveInterval" in line:
                print (line, end="")
            elif "SteamPlatformSystem - OnPolicyResponse - Game server SteamID" in line:
                server_SteamID = line.split(' ')[7]
                print ("Server Steam ID: " + server_SteamID)
            elif "Attempting to load most recent save file for SaveDirectory" in line:
                autosave = line.split(' ')[11]
                print ("Loaded AutoSave: " + autosave, end="")
            elif "Loaded Save:" in line:
                print (set_colors.Magenta + line + set_colors.ResetAll, end="")
            elif "Check Host Server" in line:
                print (line, end="")
            elif "Public IP:" in line:
                print (line, end="")            
    print ("EOF")

if check_type == 'user':
    with open(input_file) as file_handle:
        for num, line in enumerate(file_handle, 1):
            # CLOSED CONNECTION
            if "Application closed connection" in line:
                print (set_colors.LightRed + line + set_colors.ResetAll, end="")
            elif "disconnected. approvedUserIndex" in line:
                print (set_colors.Red + line + set_colors.ResetAll, end="")
            # STARTED CONNECTION
            elif "SteamPlatformSystem - BeginAuthSession for SteamID" in line:
                print (set_colors.Green + " [RC1] " + line + set_colors.ResetAll, end="")
            elif "Hail Message" in line:
                print (set_colors.Green + " [RC2] " + line + set_colors.ResetAll, end="")
            elif "reconnect was approved. approvedUserIndex" in line:
                print (set_colors.Green +  " [RC2] "+ line + set_colors.ResetAll, end="")
            elif "OnValidateAuthTicketResponse for SteamID" in line:
                print (set_colors.Green + " [RC3] " + line + set_colors.ResetAll, end="")
            elif "UserHasLicenseForApp for SteamID" in line:
                print (set_colors.Green + " [RC4] " + line + set_colors.ResetAll, end="")
            elif "approvedUserIndex:" in line:
                print (set_colors.Green + " [RC5] " + line + set_colors.ResetAll, end="")
            elif "SendRevealedMapData:" in line:
                print (set_colors.Green + " [RC6] " + line + set_colors.ResetAll, end="")
            elif "SendDiscoveredMapZones:" in line:
                print (set_colors.Green + " [RC7] " + line + set_colors.ResetAll, end="")
            elif "SendClaimedAchievements:" in line:
                print (set_colors.Green + " [RC8] " + line + set_colors.ResetAll, end="")
            elif "SendInitialUnlockedProgressionEvent:" in line:
                print (set_colors.Green + " [RC9] " + line + set_colors.ResetAll, end="")
            # ADMIN EVENTS
            elif "admin event from user" in line:
                if "PlayerTeleportDebugEvent" in line:
                    print (set_colors.LightBlue + line + set_colors.ResetAll, end="")
                elif "ChangeHealthOfClosestToPositionDebugEvent" in line:
                    print (set_colors.Yellow + line + set_colors.ResetAll, end="")
                elif "GiveDebugEvent" in line:
                     print (set_colors.Yellow + line + set_colors.ResetAll, end="")
                else:
                    print (set_colors.Blue + line + set_colors.ResetAll, end="")

    print ("EOF")

if check_type == 'error':
    with open(input_file) as file_handle:
        for num, line in enumerate(file_handle, 1):
            if "Error" in line:
                if "InputSettings.json" in line:
                    print (set_colors.Green + line + set_colors.ResetAll, end="")
                elif "ClientSettings.json" in line:
                    print (set_colors.Green + line + set_colors.ResetAll, end="")
                elif "GameDataSettings.json" in line:
                    print (set_colors.Green + line + set_colors.ResetAll, end="")
                elif "ServerDebugSettings.json" in line:
                    print (set_colors.Green + line + set_colors.ResetAll, end="")
                elif "ServerVoipSettings.json" in line:
                    print (set_colors.Green + line + set_colors.ResetAll, end="")
                else:
                    print (set_colors.Red + line + set_colors.ResetAll, end="")
            elif "SaveFile does not match current current PersistenceVersion" in line:
                print (set_colors.Red + line + set_colors.ResetAll, end="")
            elif "Loading save at" in line:
                print (set_colors.Magenta + line + set_colors.ResetAll, end="")
            elif "Loaded Save:" in line:
                print (set_colors.Magenta + line + set_colors.ResetAll, end="")
            elif "PersistenceV2 - Finished Loading" in line:
                print (set_colors.Green + line + set_colors.ResetAll, end="")
            elif "ERROR:" in line:
                if "Shader GUI/Text Shader shader" in line:
                    print (set_colors.Green + line + set_colors.ResetAll, end="")
                else:
                    print (set_colors.Red + line + set_colors.ResetAll, end="")
            #elif "0x0000" in line:
            #    print (set_colors.Red + line + set_colors.ResetAll, end="")
            elif "JobTempAlloc has allocations"  in line:
                print (set_colors.Yellow + line + set_colors.ResetAll, end="")
            elif "Crash!!!" in line:
                print (set_colors.Red + line + set_colors.ResetAll, end="")
            elif "Exception" in line:
                if "Unity.Entities.World:GetOrCreateSystemsAndLogException(IEnumerable`1, Int32)" not in line:
                    if "JsonSerializationException" in line:
                        print (set_colors.Red + line + set_colors.ResetAll, end="")
                        print ("See: https://cdn.stunlock.com/blog/2022/05/25083113/Game-Server-Settings.pdf for limits")
                    else:
                        print (set_colors.Yellow + line + set_colors.ResetAll, end="")
            elif "Persistence" in line:
                print (set_colors.Cyan + line + set_colors.ResetAll, end="")
                
            
    print ("EOF")

if check_type == 'startup':
    # Set any lines that may repeat, so they dont
    server_list_found = False
    vivox_req_progress_found = False
    adminlist_found = False
    serverdebug_found = False
    with open(input_file) as file_handle:
        for num, line in enumerate(file_handle, 1):
            if "SteamPlatformSystem - BeginAuthSession for SteamID:" in line:
                print (line)
            elif "Initialize engine version: " in line:
                engine_version = line.split(' ')[3]
                engine_build = line.split(' ')[4]
                print (" [01] Engine Version: " + engine_version + " " + engine_build, end="")
            elif "Bootstrap - Time:" in line:
                print (" [02] " + line, end="")
            elif "SLS_COLLECTIONS_CHECKS defined." in line:
                print (" [03] " + line, end="")
            elif "System Information:" in line:
                print (" [04] " + line, end="")
            elif "ClientSettings.json" in line:
                print (" [05] " + line, end="")                
            elif "Loaded ClientSettings:" in line:
                print (" [06] " + line, end="")                
            elif "Actual System Memory:" in line:
                print (" [07] " + line, end="")                
            elif "Bootstrapping World:" in line:
                print (" [08] " + line, end="")
            elif "InputSettings.json" in line:
                print (" [09] " + line, end="")
            elif "SteamPlatformSystem - Entering OnCreate!" in line:
                print (" [10] " + line, end="")
            elif "Loaded VersionDataSettings:" in line:
                print (" [11] " + line, end="")
            elif "PersistenceVersionOverride value found from VersionDataSettings:" in line:
                print (" [12] " + line, end="")
            elif "Persistence Version initialized as:" in line:
                print (" [13] " + line, end="")                
            elif "Loading ServerHostSettings from:" in line:
                print (" [14] " + line, end="")                
            elif "Commandline Parameter ServerName:" in line:
                print (" [15] " + line, end="")                
            elif "Loaded ServerHostSettings:" in line:
                print (" [16] " + line, end="")                
            elif "Setting breakpad minidump AppID " in line:
                print (" [17] " + line, end="")                
            elif "SteamPlatformSystem -  Server App ID: " in line:
                print (" [18] " + line, end="")                
            elif "SteamPlatformSystem - Steam GameServer Initialized!" in line:
                print (" [19] " + line, end="")                
            elif "Got SDR network config.  Loaded revision" in line:
                print (" [20] " + line, end="")                
            elif "] Performing ping measurement" in line:
                print (" [21] " + line, end="")                
            elif "(Performing ping measurement)" in line:
                print (" [22] " + line, end="")                
            #elif "Relay lim" in line:
            #    print (" [--] " + line, end="")                
            elif "Gameserver logged on to Steam, assigned identity steamid" in line:
                print (" [23] " + line, end="")                
            elif "(Requesting cert)" in line:
                print (" [24] " + line, end="")                
            elif "Set SteamNetworkingSockets P2P_STUN_ServerList" in line:
                print (" [25] " + line, end="")                
            elif "Server connected to Steam successfully" in line:
                print (" [26] " + line, end="")                
            elif "Successfully logged in with the SteamGameServer API. SteamID" in line:
                print (" [27] " + line, end="")                
            elif "AuthStatus (steamid:" in line:
                print (" [28] " + line, end="")                
            elif "Certificate expires in 48h00m" in line:
                print (" [29] " + line, end="")                
            elif "GameDataSettings.json" in line:
                print (" [30] " + line, end="")                
            elif "Check Host Server - HostServer:" in line:
                print (" [31] " + line, end="")                
            elif "BatchMode Host - CommandLine:" in line:
                print (" [32] " + line, end="")                
            elif "Server Host - SaveName:" in line:
                print (" [33] " + line, end="")
            elif "Attempting to load most recent save file for SaveDirectory" in line:
                print (" [34] " + line, end="")
            elif "Loaded Save:" in line:
                print (" [35] " + line, end="")
            elif "adminlist.txt" in line:
                if adminlist_found == False:
                    print (" [36] " + line, end="")
                    adminlist_found = True
            elif "banlist.txt" in line:
                print (" [37] " + line, end="")
            elif "---- OnCreate: ServerDebugSettingsSystem" in line:
                print (" [38] " + line, end="")
            elif "ServerDebugSettings.json" in line:
                if serverdebug_found == False:
                    print (" [39] " + line, end="")
                    serverdebug_found = True
            elif "[Debug] ServerGameSettingsSystem - OnCreate" in line:
                print (" [40] " + line, end="")
            elif "ServerGameSettingsSystem - OnCreate - Loading ServerGameSettings via Commandline Parameter" in line:
                print (" [41] " + line, end="")
            elif " .\save-data\Saves\\v1/\\" in line:
                print (" [42] " + line, end="")
            elif "[Debug] ServerGameSettingsSystem - OnCreate - Loading ServerGameSettings via ServerRuntimeSettings settings!" in line:
                print (" [43] " + line, end="")
            elif "\.\save-data\Saves\\v1\\" in line:
                print (" [44] " + line, end="")
            elif "ERROR: Shader GUI/Text Shader shader is not supported on this GPU" in line:
                print (" [45] " + line, end="")
            elif "[rcon] Started listening on 0.0.0.0, Password is:" in line:
                print (" [46] " + line, end="")
            elif "[Server] LoadSceneAsync Request 'WorldAssetSingleton'," in line:
                print (" [47] " + line, end="")
            elif "Starting up ServerSteamTransportLayer. GameServer ID:" in line:
                print (" [48] " + line, end="")
            elif "Socket: " in line:
                print (" [49] " + line, end="")
            elif "[Server] LoadSceneAsync Request" in line:
                print (" [50] " + line, end="")
            elif "[Steam] FinalizeSetupServer - Setting Tags" in line:
                print (" [51] " + line, end="")
            elif "Server Settings hash:" in line:
                print (" [52] " + line, end="")
            elif "Size of ServerSettings: " in line:
                print (" [53] " + line, end="")
            elif "Server Setup Complete" in line:
                print (" [54] " + line, end="")
            elif "Vivox Request URI" in line:
                print (set_colors.Yellow + "[VO1] " + line + set_colors.ResetAll, end="")
            elif "Vivox - S2S Requested Auth Token" in line:
                print (set_colors.Yellow + "[VO2] " + line + set_colors.ResetAll, end="")
            elif "SteamPlatformSystem - OnPolicyResponse - Game server SteamID:" in line:
                print (" [55] " + line, end="")
            elif "SteamPlatformSystem - OnPolicyResponse - Game Server VAC Secure!" in line:
                print (" [56] " + line, end="")
            elif "SteamPlatformSystem - OnPolicyResponse - Public IP:" in line:
                print (" [57] " + line, end="")
            elif "[Server] World Asset Initialized" in line:
                print (" [58] " + line, end="")
            elif "SteamPlatformSystem - SetServerData - Init!" in line:
                print (" [59] " + line, end="")
            elif "Vivox - Req InProgress" in line:
                if vivox_req_progress_found == False:
                    print (set_colors.Yellow + "[VO3] " + line + set_colors.ResetAll, end="")
                    vivox_req_progress_found = True
            elif "Vivox - XML Resp " in line:
                print (set_colors.Yellow + "[VO4] " + line + set_colors.ResetAll, end="")
            elif "Vivox - S2S Auth Token OK" in line:
                print (set_colors.Yellow + "[VO5] " + line + set_colors.ResetAll, end="")
            elif "Loaded Official Servers List: 1042" in line:
                if server_list_found == False:
                    print (" [60] " + line, end="")
                    server_list_found = True
            elif " GameData Scenes Loaded." in line:
                print (" [61] " + line, end="")
            elif "Excluding all archetypes with" in line:
                print (" [62] " + line, end="")
            elif "PersistenceV2 - Successfully serialized Persistence Header" in line:
                print (" [63] " + line, end="")
            elif "PersistenceV2 - Deserialized Header. Persistent Component Types" in line:
                print (" [64] " + line, end="")
            elif "PersistenceV2 - Finished Loading " in line:
                print (" [65] " + line, end="")
            elif "Loaded ServerGameSettings:" in line:
                print (set_colors.Green + " [65] " + line + set_colors.ResetAll, end="")
            # elif "" in line:
            #     print (" [72] " + line, end="")



    print ("EOF")

            #num = str(num)
            #print line.split(',')[3] + '' + num