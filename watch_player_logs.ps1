
# run with PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File watch_player_logs.ps1
$logPath = Join-Path $env:USERPROFILE "AppData\LocalLow\Stunlock Studios\VRising\Player.log"

Get-Content -Path $logPath -Tail 0 -Wait | ForEach-Object {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp] $_"
}
