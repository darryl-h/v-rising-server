$InstallPath = "c:\vrisingserver3"
$GamePort = 1234    
    # Setup the VRisingServer Service with NSSM
    Write-Host "`t`t* Confiuring VRsingServer Service with NSSM"
    Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "remove VRisingServer-$GamePort confirm" -Wait
    Start-Sleep -Seconds 1.5
    Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "install VRisingServer-$GamePort VRisingServer" -Wait
    Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer-$GamePort Application  $InstallPath\steamapps\common\VRisingDedicatedServer\VRisingServer.exe" -Wait
    Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer-$GamePort AppParameters `"-persistentDataPath .\save-data`"" -Wait
    Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer-$GamePort AppEnvironmentExtra `":set SteamAppId=1604030`"" -Wait
    Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer-$GamePort AppDirectory $InstallPath\steamapps\common\VRisingDedicatedServer" -Wait
    Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer-$GamePort AppExit Default Restart" -Wait
    Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer-$GamePort AppStdout $InstallPath\steamapps\common\VRisingDedicatedServer\logs\VRisingServer.log" -Wait
    Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer-$GamePort AppStderr $InstallPath\steamapps\common\VRisingDedicatedServer\logs\VRisingServer.log" -Wait
    Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer-$GamePort AppStopMethodSkip 14" -Wait
    Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer-$GamePort AppKillProcessTree 0" -Wait
    Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer-$GamePort AppTimestampLog 1" -Wait
    Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer-$GamePort DisplayName VRisingServer" -Wait
    Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer-$GamePort ObjectName LocalSystem" -Wait
    Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer-$GamePort Start SERVICE_AUTO_START" -Wait
    Start-Process -FilePath "$InstallPath\nssm.exe" -ArgumentList "set VRisingServer-$GamePort Type SERVICE_WIN32_OWN_PROCESS" -Wait