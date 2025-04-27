Add-Type -AssemblyName PresentationFramework,WindowsBase,PresentationCore,WindowsFormsIntegration

# --- 0) Configuration load/save ---
$scriptDir     = Split-Path $MyInvocation.MyCommand.Path
$configPath    = Join-Path $scriptDir 'vrising_manager_config.json'
$defaultBase   = 'C:\vrisingserver'
$defaultBuffer = 1000

if (Test-Path $configPath) {
    $script:config = Get-Content $configPath -Raw | ConvertFrom-Json
    $changed      = $false
    # Ensure BaseDirectory
    if (-not $script:config.BaseDirectory -or $script:config.BaseDirectory -eq $scriptDir) {
        $script:config.BaseDirectory = $defaultBase; $changed = $true
    }
    # Ensure ServiceName
    if (-not $script:config.ServiceName) {
        $script:config.ServiceName = 'VRisingServer-9876'; $changed = $true
    }
    # Ensure LogBufferSize exists and is an integer
    if (-not ($script:config.PSObject.Properties.Name -contains 'LogBufferSize') -or -not ($script:config.LogBufferSize -as [int])) {
        # Add or overwrite LogBufferSize
        if ($script:config.PSObject.Properties.Name -contains 'LogBufferSize') {
            $script:config.PSObject.Properties['LogBufferSize'].Value = $defaultBuffer
        } else {
            $script:config | Add-Member -NotePropertyName 'LogBufferSize' -NotePropertyValue $defaultBuffer
        }
        $changed = $true
    }
    if ($changed) {
        $script:config | ConvertTo-Json | Set-Content $configPath -Encoding UTF8
    }
} else {
    $script:config = [PSCustomObject]@{
        BaseDirectory  = $defaultBase
        ServiceName    = 'VRisingServer-9876'
        LogBufferSize  = $defaultBuffer
    }
    $script:config | ConvertTo-Json | Set-Content $configPath -Encoding UTF8
}

function Derive-Paths {
    $script:baseDir        = $script:config.BaseDirectory
    $script:serviceName    = $script:config.ServiceName
    $script:nssmPath       = Join-Path $script:baseDir 'nssm.exe'
    $script:hostConfigPath = Join-Path $script:baseDir 'steamapps\common\VRisingDedicatedServer\save-data\Settings\ServerHostSettings.json'
    $script:gameConfigPath = Join-Path $script:baseDir 'steamapps\common\VRisingDedicatedServer\save-data\Settings\ServerGameSettings.json'
    $script:logFilePath    = Join-Path $script:baseDir 'steamapps\common\VRisingDedicatedServer\logs\VRisingServer.log'
    $script:savesPath      = Join-Path $script:baseDir 'steamapps\common\VRisingDedicatedServer\save-data\Saves\v3\world1'
}
Derive-Paths

#--- Settings Dialog ---
function Show-SettingsDialog {
    $xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" Title="Settings" Height="250" Width="500" WindowStartupLocation="CenterOwner">
  <Grid Margin="10">
    <Grid.RowDefinitions>
      <RowDefinition Height="Auto"/>
      <RowDefinition Height="Auto"/>
      <RowDefinition Height="Auto"/>
      <RowDefinition Height="*"/>
      <RowDefinition Height="Auto"/>
    </Grid.RowDefinitions>
    <Grid.ColumnDefinitions>
      <ColumnDefinition Width="Auto"/>
      <ColumnDefinition Width="*"/>
    </Grid.ColumnDefinitions>
    <TextBlock Grid.Row="0" Grid.Column="0" Margin="0,0,5,5" VerticalAlignment="Center">Base Directory:</TextBlock>
    <TextBox   Grid.Row="0" Grid.Column="1" Name="txtBaseDir" Margin="0,0,0,5"/>
    <TextBlock Grid.Row="1" Grid.Column="0" Margin="0,0,5,5" VerticalAlignment="Center">Service Name:</TextBlock>
    <TextBox   Grid.Row="1" Grid.Column="1" Name="txtServiceName" Margin="0,0,0,5"/>
    <TextBlock Grid.Row="2" Grid.Column="0" Margin="0,0,5,5" VerticalAlignment="Center">Log Buffer Size:</TextBlock>
    <TextBox   Grid.Row="2" Grid.Column="1" Name="txtBufferSize" Margin="0,0,0,5"/>
    <StackPanel Grid.Row="4" Grid.ColumnSpan="2" Orientation="Horizontal" HorizontalAlignment="Right">
      <Button Name="btnSave"   Width="75" Margin="5">Save</Button>
      <Button Name="btnCancel" Width="75" Margin="5">Cancel</Button>
    </StackPanel>
  </Grid>
</Window>
"@
    [xml]$xml   = $xaml
    $reader    = New-Object System.Xml.XmlNodeReader $xml
    $dlg       = [Windows.Markup.XamlReader]::Load($reader)
    $dlg.Owner = $window

    $txtBase   = $dlg.FindName('txtBaseDir')
    $txtSvc    = $dlg.FindName('txtServiceName')
    $txtBuffer = $dlg.FindName('txtBufferSize')
    $btnSave   = $dlg.FindName('btnSave')
    $btnCancel = $dlg.FindName('btnCancel')

    # populate
    $txtBase.Text   = $script:config.BaseDirectory
    $txtSvc.Text    = $script:config.ServiceName
    $txtBuffer.Text = $script:config.LogBufferSize

    $btnCancel.Add_Click({ $dlg.Close() })
    $btnSave.Add_Click({
        $script:config.BaseDirectory = $txtBase.Text
        $script:config.ServiceName   = $txtSvc.Text
        $script:config.LogBufferSize = [int]$txtBuffer.Text
        $script:config | ConvertTo-Json | Set-Content $configPath -Encoding UTF8
        Derive-Paths; UpdateServiceStatus; UpdateServiceDetails; UpdateLogView; $dlg.Close()
    })

    $dlg.ShowDialog() | Out-Null
}

#=== Main UI ===
$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" Title="VRising Server Manager version 1.0 by github.com/darryl-h" Height="600" Width="800">
  <Grid Margin="10">
    <Grid.RowDefinitions>
      <RowDefinition Height="Auto"/>
      <RowDefinition Height="Auto"/>
      <RowDefinition Height="Auto"/>
      <RowDefinition Height="*"/>
      <RowDefinition Height="Auto"/>
    </Grid.RowDefinitions>
    <!-- Row 1: Service controls -->
    <StackPanel Orientation="Horizontal" Grid.Row="0" Margin="0,0,0,5">
      <TextBlock Text="Service:" VerticalAlignment="Center" Margin="0,0,5,0"/>
      <Button Name="btnStart" Width="75" Margin="0,0,5,0">Start</Button>
      <Button Name="btnStop"  Width="75" Margin="0,0,5,0">Stop</Button>
      <Button Name="btnEdit"  Width="75">Edit</Button>
    </StackPanel>
    <!-- Row 2: Game-related settings -->
    <StackPanel Orientation="Horizontal" Grid.Row="1" Margin="0,0,0,5">
      <TextBlock Text="Settings:" VerticalAlignment="Center" Margin="0,0,5,0"/>
      <Button Name="btnOpenHostConfig" Width="120" Margin="0,0,5,0">Host Settings</Button>
      <Button Name="btnOpenGameConfig" Width="120" Margin="0,0,5,0">Game Settings</Button>
      <Button Name="btnOpenSaves"       Width="120">Game Saves</Button>
    </StackPanel>
    <!-- Row 3: Manager settings -->
    <StackPanel Orientation="Horizontal" Grid.Row="2" Margin="0,0,0,10">
      <TextBlock Text="Manager Settings:" VerticalAlignment="Center" Margin="0,0,5,0"/>
      <Button Name="btnSettings" Width="150">Configuration</Button>
    </StackPanel>
    <!-- Log viewer -->
    <TextBox Name="txtLog" Grid.Row="3" FontFamily="Consolas" IsReadOnly="True" VerticalScrollBarVisibility="Auto" TextWrapping="NoWrap"/>
    <!-- Status bar -->
    <StatusBar Grid.Row="4">
      <StatusBarItem><TextBlock Name="txtServiceState">Svc: Unknown</TextBlock></StatusBarItem>
      <StatusBarItem><TextBlock Name="txtUptime">Uptime: N/A</TextBlock></StatusBarItem>
      <StatusBarItem><TextBlock Name="txtExitCode">ExitCode: N/A</TextBlock></StatusBarItem>
      <StatusBarItem><TextBlock Name="txtStatus">Ready</TextBlock></StatusBarItem>
    </StatusBar>
  </Grid>
</Window>
"@
[xml]$xmlUI = $xaml; $reader = New-Object System.Xml.XmlNodeReader $xmlUI
$window   = [Windows.Markup.XamlReader]::Load($reader)

# controls
$btnStart          = $window.FindName('btnStart')
$btnStop           = $window.FindName('btnStop')
$btnEdit           = $window.FindName('btnEdit')
$btnOpenSaves      = $window.FindName('btnOpenSaves')
$btnOpenHostConfig = $window.FindName('btnOpenHostConfig')
$btnOpenGameConfig = $window.FindName('btnOpenGameConfig')
$btnSettings       = $window.FindName('btnSettings')
$txtLog            = $window.FindName('txtLog')
$txtStatus         = $window.FindName('txtStatus')
$txtServiceState   = $window.FindName('txtServiceState')
$txtUptime         = $window.FindName('txtUptime')
$txtExitCode       = $window.FindName('txtExitCode')

# Helper runner
function Run-Action($sb) {
    try { & $sb 2>&1 | Out-Null; return $true } catch {
        $window.Dispatcher.Invoke([Action]{ $txtStatus.Text = "Error: $_" })
        return $false
    }
}

# Update service status
function UpdateServiceStatus {
    $svc   = Get-Service -Name $script:serviceName -ErrorAction SilentlyContinue
    $state = if ($svc) { $svc.Status } else { 'NotInstalled' }
    $brush = switch ($state) {
        'Running'       { [System.Windows.Media.Brushes]::Green }
        'Stopped'       { [System.Windows.Media.Brushes]::Red }
        'NotInstalled'  { [System.Windows.Media.Brushes]::Orange }
        Default         { [System.Windows.Media.Brushes]::Black }
    }
    $window.Dispatcher.Invoke([Action]{
        $txtServiceState.Text       = "Svc: $state"
        $txtServiceState.Foreground = $brush
    })
}

# Update service details
function UpdateServiceDetails {
    $wmi = Get-WmiObject Win32_Service -Filter "Name='$script:serviceName'" -ErrorAction SilentlyContinue
    if ($wmi) {
        $exit   = $wmi.ExitCode
        $procId = $wmi.ProcessId
        if ($procId -and $procId -ne 0) {
            try {
                $start = (Get-Process -Id $procId -ErrorAction Stop).StartTime
                $span  = (Get-Date) - $start
                $uptxt = "{0:hh\:mm\:ss}" -f $span
            } catch {
                $uptxt = 'N/A'
            }
        } else { $uptxt = 'N/A' }
        $window.Dispatcher.Invoke([Action]{
            $txtExitCode.Text = "ExitCode: $exit"
            $txtUptime.Text   = "Uptime: $uptxt"
        })
    }
}

# Update log view (tail + reverse order)
function UpdateLogView {
    if (-not (Test-Path $script:logFilePath)) { return }
    $lines = Get-Content $script:logFilePath -Tail $script:config.LogBufferSize
    [array]::Reverse($lines)
    $window.Dispatcher.Invoke([Action]{
        $txtLog.Text       = $lines -join "`r`n"
        $txtLog.CaretIndex = 0
        $txtLog.ScrollToHome()
    })
}

# Wire up button events
$btnStart.Add_Click({  $txtStatus.Text='Starting…'; if (Run-Action{ Start-Service -Name $script:serviceName }) { $txtStatus.Text='Started'; UpdateServiceStatus; UpdateServiceDetails } })
$btnStop.Add_Click({   $txtStatus.Text='Stopping…'; if (Run-Action{ Stop-Service -Name $script:serviceName  }) { $txtStatus.Text='Stopped'; UpdateServiceStatus; UpdateServiceDetails } })
$btnEdit.Add_Click({   $txtStatus.Text='Editing…';   if (Test-Path $script:nssmPath) { Run-Action{ & $script:nssmPath edit $script:serviceName }; $txtStatus.Text='Edit opened' } else { $txtStatus.Text='nssm.exe missing' } })
$btnOpenSaves.Add_Click({       if (Test-Path $script:savesPath)      { Start-Process explorer  $script:savesPath       } else { $txtStatus.Text='Saves folder not found' } })
$btnOpenHostConfig.Add_Click({  if (Test-Path $script:hostConfigPath) { Start-Process notepad   $script:hostConfigPath  } else { $txtStatus.Text='Host config missing' } })
$btnOpenGameConfig.Add_Click({  if (Test-Path $script:gameConfigPath) { Start-Process notepad   $script:gameConfigPath  } else { $txtStatus.Text='Game config missing' } })
$btnSettings.Add_Click({ Show-SettingsDialog })

# Real-time log watching
if (Get-EventSubscriber -SourceIdentifier LogChanged -ErrorAction SilentlyContinue) { Unregister-Event -SourceIdentifier LogChanged }
$fsw = New-Object System.IO.FileSystemWatcher (Split-Path $script:logFilePath), (Split-Path $script:logFilePath -Leaf)
$fsw.EnableRaisingEvents = $true
Register-ObjectEvent $fsw Changed -SourceIdentifier LogChanged -Action { Start-Sleep -Milliseconds 200; UpdateLogView }

# Poll service status and details every 5 seconds
$timer = New-Object Windows.Threading.DispatcherTimer
$timer.Interval = [TimeSpan]::FromSeconds(5)
$timer.Add_Tick({ UpdateServiceStatus; UpdateServiceDetails })
$timer.Start()

# Initial load
UpdateServiceStatus; UpdateServiceDetails; UpdateLogView

# Show window
$window.ShowDialog() | Out-Null
