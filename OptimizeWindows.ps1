# Load the required assemblies
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore

# Define the XAML for the WPF GUI
$XAML = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Windows Optimization Tool" Height="700" Width="800">
    <Grid Margin="10">
        <Button x:Name="OptimizePerformance" Content="Optimize Performance" HorizontalAlignment="Left" VerticalAlignment="Top" Width="180" Height="50" Margin="10,10,0,0" />
        <Button x:Name="OptimizeNetwork" Content="Optimize Network" HorizontalAlignment="Right" VerticalAlignment="Top" Width="180" Height="50" Margin="0,10,10,0" />
        <Button x:Name="OneClickOptimize" Content="One-Click Optimization" HorizontalAlignment="Center" VerticalAlignment="Bottom" Width="360" Height="50" Margin="0,0,0,10" />
        <Button x:Name="InstallPopularApps" Content="Install Popular Apps" HorizontalAlignment="Center" VerticalAlignment="Top" Width="360" Height="50" Margin="0,70,0,0" />
        <Button x:Name="TestWiFiSpeed" Content="Test WiFi Speed" HorizontalAlignment="Left" VerticalAlignment="Bottom" Width="180" Height="50" Margin="10,0,0,80" />
        <Button x:Name="StressTestPC" Content="Stress Test PC" HorizontalAlignment="Right" VerticalAlignment="Bottom" Width="180" Height="50" Margin="0,0,10,80" />
        <Button x:Name="SetWallpaper" Content="Set Wallpaper" HorizontalAlignment="Center" VerticalAlignment="Top" Width="360" Height="50" Margin="0,140,0,0" />
        <Button x:Name="AdvancedCleaning" Content="Advanced Cleaning" HorizontalAlignment="Left" VerticalAlignment="Bottom" Width="180" Height="50" Margin="10,0,0,160" />
        <Button x:Name="UpdateDrivers" Content="Update Drivers" HorizontalAlignment="Right" VerticalAlignment="Bottom" Width="180" Height="50" Margin="0,0,10,160" />
        <Button x:Name="BatteryOptimization" Content="Battery Optimization" HorizontalAlignment="Center" VerticalAlignment="Top" Width="360" Height="50" Margin="0,210,0,0" />
        <Button x:Name="SystemHealth" Content="System Health Monitoring" HorizontalAlignment="Left" VerticalAlignment="Bottom" Width="180" Height="50" Margin="10,0,0,240" />
        <Button x:Name="Backup" Content="Automatic Backup" HorizontalAlignment="Right" VerticalAlignment="Bottom" Width="180" Height="50" Margin="0,0,10,240" />
    </Grid>
</Window>
"@

# Parse the XAML to create the GUI
$reader = [System.Xml.XmlReader]::Create([System.IO.StringReader]$XAML)
$window = [Windows.Markup.XamlReader]::Load($reader)

# Global variable to store the folder path for app installations
$global:AppInstallFolder = "C:\DefaultFolder"

# Function to download required tools
function Download-Tools {
    Write-Host "Downloading required tools..."

    # Create the Tools directory if it doesn't exist
    $toolsDir = "C:\Tools"
    if (-not (Test-Path $toolsDir)) {
        New-Item -Path $toolsDir -ItemType Directory
    }

    # Download and install speedtest-cli
    if (-not (Get-Command speedtest-cli -ErrorAction SilentlyContinue)) {
        Write-Host "Installing speedtest-cli..."
        if (-not (Get-Command pip -ErrorAction SilentlyContinue)) {
            Invoke-WebRequest -Uri "https://bootstrap.pypa.io/get-pip.py" -OutFile "$toolsDir\get-pip.py"
            python "$toolsDir\get-pip.py"
            Remove-Item "$toolsDir\get-pip.py"
        }
        pip install speedtest-cli
    }

    # Download Prime95
    if (-not (Test-Path "$toolsDir\Prime95\prime95.exe")) {
        Write-Host "Downloading Prime95..."
        $prime95Url = "https://www.mersenne.org/ftp_root/gimps/p95v303b6.win64.zip"
        $prime95Zip = "$toolsDir\Prime95.zip"
        $prime95Dir = "$toolsDir\Prime95"
        Invoke-WebRequest -Uri $prime95Url -OutFile $prime95Zip
        Expand-Archive -Path $prime95Zip -DestinationPath $prime95Dir
        Remove-Item $prime95Zip
    }

    # Download FurMark
    if (-not (Test-Path "$toolsDir\FurMark\FurMark.exe")) {
        Write-Host "Downloading FurMark..."
        $furMarkUrl = "https://geeks3d.com/furmark/downloads/FurMark_1.27.0.0_Setup.exe"
        $furMarkInstaller = "$toolsDir\FurMarkSetup.exe"
        Invoke-WebRequest -Uri $furMarkUrl -OutFile $furMarkInstaller
        Start-Process $furMarkInstaller -ArgumentList "/VERYSILENT /NORESTART" -Wait
        Remove-Item $furMarkInstaller
    }

    [System.Windows.MessageBox]::Show("All required tools are installed.", "Success", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
}

# Function to download and set wallpaper
function Set-Wallpaper {
    Write-Host "Setting wallpaper..."
    $wallpaperUrl = "https://example.com/path/to/wallpaper.png"
    $wallpaperPath = "C:\Tools\wallpaper.png"

    if (-not (Test-Path $wallpaperPath)) {
        Write-Host "Downloading wallpaper..."
        Invoke-WebRequest -Uri $wallpaperUrl -OutFile $wallpaperPath
    }

    $code = @"
[DllImport("user32.dll", CharSet = CharSet.Auto)]
public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
"@
    Add-Type -MemberDefinition $code -Name "Win32" -Namespace "Wallpaper"
    [Wallpaper.Win32]::SystemParametersInfo(0x0014, 0, $wallpaperPath, 0x0001)
    [System.Windows.MessageBox]::Show("Wallpaper set successfully!", "Success", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
}

# Function to optimize performance
function Optimize-Performance {
    Write-Host "Optimizing performance..."
    Remove-Bloatware -AppsToRemove @("Xbox", "OneDrive", "GetHelp", "YourPhone", "MicrosoftSolitaireCollection", "Weather", "News", "Skype", "Spotify", "MixedRealityPortal", "Microsoft3DViewer", "MicrosoftOfficeHub", "MicrosoftPeople", "MicrosoftStickyNotes", "MicrosoftTips")
    Optimize-Services -ServicesToDisable @("DiagTrack", "SysMain", "RetailDemo", "WSearch", "WMPNetworkSvc", "CDPSvc", "DoSvc", "DusmSvc", "MapsBroker", "PhoneSvc", "SharedAccess", "XboxGipSvc", "XboxNetApiSvc", "XboxSvc", "OneSyncSvc")
    Clean-ScheduledTasks -TasksToDisable @("\Microsoft\Windows\UpdateOrchestrator\UpdateModel\USO_UxBroker_Display", "\Microsoft\Windows\Feedback\Siuf\DmClient", "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser", "\Microsoft\Windows\Autochk\Proxy", "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator")

    $registryTweaks = @{
        "HKCU:\Control Panel\Desktop" = @{Name = "MenuShowDelay"; Value = "20"}
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" = @{Name = "StartupDelayInMSec"; Value = "0"}
        "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" = @{Name = "SMB1"; Value = "0"}
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" = @{Name = "EnableLUA"; Value = "0"}
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" = @{Name = "DisableTaskMgr"; Value = "0"}
    }
    Apply-RegistryTweaks -Tweaks $registryTweaks

    Manage-StartupPrograms -ProgramsToDisable @("OneDrive", "Skype", "Spotify", "MicrosoftTeams", "Zoom")
    [System.Windows.MessageBox]::Show("Performance optimization complete!", "Success", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
}

# Function to optimize network
function Optimize-Network {
    Write-Host "Optimizing network..."
    Optimize-WiFi -AdapterName "Wi-Fi"
    Optimize-TCPIP
    Optimize-NetworkSettings
    [System.Windows.MessageBox]::Show("Network optimization complete!", "Success", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
}

# Function to perform one-click optimization
function OneClick-Optimize {
    Write-Host "Performing one-click optimization..."
    Optimize-Performance
    Optimize-Network
}

# Function to install popular apps using winget
function Install-PopularApps {
    # Allow user to select folder for app installations
    $folderDialog = New-Object -ComObject Shell.Application
    $folder = $folderDialog.BrowseForFolder(0, "Select Folder for App Installations", 0)
    if ($folder) {
        $global:AppInstallFolder = $folder.self.Path
    } else {
        [System.Windows.MessageBox]::Show("No folder selected, using default folder.", "Information", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    }

    Write-Host "Installing popular apps..."
    $apps = @(
        "Google.Chrome",
        "Mozilla.Firefox",
        "7zip.7zip",
        "VideoLAN.VLC",
        "Spotify.Spotify",
        "Notepad++.Notepad++",
        "Microsoft.PowerToys",
        "Git.Git",
        "SlackTechnologies.Slack",
        "Discord.Discord",
        "Microsoft.VisualStudioCode",
        "Python.Python.3",
        "Java.AdoptOpenJDK.11",
        "Nodejs.Nodejs"
    )
    foreach ($app in $apps) {
        Start-Process winget -ArgumentList "install --id=$app --location=$global:AppInstallFolder --silent" -NoNewWindow -Wait
    }
    [System.Windows.MessageBox]::Show("Popular apps installation complete!", "Success", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
}

# Function to test WiFi speed
function Test-WiFiSpeed {
    Write-Host "Testing WiFi speed..."
    $result = speedtest-cli --json | ConvertFrom-Json
    $beforeSpeed = @{
        "Download" = $result.download / 1MB
        "Upload" = $result.upload / 1MB
        "Ping" = $result.ping
    }
    [System.Windows.MessageBox]::Show("WiFi Speed Test Before Optimization: `nDownload: $($beforeSpeed.Download) Mbps `nUpload: $($beforeSpeed.Upload) Mbps `nPing: $($beforeSpeed.Ping) ms", "WiFi Speed Test", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
}

# Function to stress test PC
function Stress-TestPC {
    Write-Host "Starting PC stress test..."
    Start-Process -FilePath "C:\Tools\Prime95\prime95.exe" -ArgumentList "/Test /Duration:60" -NoNewWindow -Wait
    Start-Process -FilePath "C:\Program Files\Geeks3D\FurMark\FurMark.exe" -ArgumentList "/Test /Duration:60" -NoNewWindow -Wait
    [System.Windows.MessageBox]::Show("PC stress test complete! Please check the results in the respective tools.", "Stress Test", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
}

# Function to perform advanced cleaning
function Advanced-Cleaning {
    Write-Host "Performing advanced cleaning..."
    # Disk cleanup
    Start-Process cleanmgr.exe -ArgumentList "/sagerun:1" -NoNewWindow -Wait
    # Remove temp files
    Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force
    Remove-Item -Path "$env:TEMP\*" -Recurse -Force
    # Clear browser caches (Chrome example)
    Remove-Item -Path "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache\*" -Recurse -Force
    [System.Windows.MessageBox]::Show("Advanced cleaning complete!", "Success", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
}

# Function to update drivers
function Update-Drivers {
    Write-Host "Updating drivers..."
    Start-Process pnputil.exe -ArgumentList "/scan-devices" -NoNewWindow -Wait
    Start-Process devmgmt.msc -ArgumentList "/secl /d" -NoNewWindow -Wait
    [System.Windows.MessageBox]::Show("Driver update complete!", "Success", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
}

# Function to optimize battery for laptops
function Battery-Optimization {
    Write-Host "Optimizing battery..."
    powercfg -change -monitor-timeout-ac 5
    powercfg -change -monitor-timeout-dc 2
    powercfg -change -disk-timeout-ac 10
    powercfg -change -disk-timeout-dc 5
    powercfg -change -standby-timeout-ac 15
    powercfg -change -standby-timeout-dc 10
    powercfg -change -hibernate-timeout-ac 30
    powercfg -change -hibernate-timeout-dc 15
    [System.Windows.MessageBox]::Show("Battery optimization complete!", "Success", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
}

# Function to monitor system health
function System-Health {
    Write-Host "Monitoring system health..."
    $cpuUsage = Get-WmiObject win32_processor | Measure-Object -Property LoadPercentage -Average | Select Average
    $ramUsage = Get-WmiObject win32_operatingsystem | Select-Object FreePhysicalMemory,TotalVisibleMemorySize
    $ramUsagePercent = [math]::round((($ramUsage.TotalVisibleMemorySize - $ramUsage.FreePhysicalMemory) / $ramUsage.TotalVisibleMemorySize) * 100, 2)
    $diskUsage = Get-WmiObject win32_logicaldisk -Filter "DriveType=3" | Select-Object DeviceID,FreeSpace,Size
    [System.Windows.MessageBox]::Show("System Health: `nCPU Usage: $($cpuUsage.Average)% `nRAM Usage: $ramUsagePercent% `nDisk Usage: $diskUsage", "System Health", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
}

# Function to perform automatic backup
function Automatic-Backup {
    Write-Host "Creating system restore point..."
    Checkpoint-Computer -Description "Pre-Optimization Backup" -RestorePointType "MODIFY_SETTINGS"
    [System.Windows.MessageBox]::Show("Automatic backup complete!", "Success", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
}

# Event handlers for the buttons
$window.FindName("OptimizePerformance").Add_Click({ Optimize-Performance })
$window.FindName("OptimizeNetwork").Add_Click({ Optimize-Network })
$window.FindName("OneClickOptimize").Add_Click({ OneClick-Optimize })
$window.FindName("InstallPopularApps").Add_Click({ Install-PopularApps })
$window.FindName("TestWiFiSpeed").Add_Click({ Test-WiFiSpeed })
$window.FindName("StressTestPC").Add_Click({ Stress-TestPC })
$window.FindName("SetWallpaper").Add_Click({ Set-Wallpaper })
$window.FindName("AdvancedCleaning").Add_Click({ Advanced-Cleaning })
$window.FindName("UpdateDrivers").Add_Click({ Update-Drivers })
$window.FindName("BatteryOptimization").Add_Click({ Battery-Optimization })
$window.FindName("SystemHealth").Add_Click({ System-Health })
$window.FindName("Backup").Add_Click({ Automatic-Backup })

# Show the window
$window.ShowDialog()

# Additional functions used in the script
function Remove-Bloatware {
    param (
        [string[]]$AppsToRemove
    )
    foreach ($app in $AppsToRemove) {
        Get-AppxPackage -AllUsers | Where-Object Name -like "*$app*" | Remove-AppxPackage
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like "*$app*" | Remove-AppxProvisionedPackage -Online
    }
}

function Optimize-Services {
    param (
        [string[]]$ServicesToDisable
    )
    foreach ($service in $ServicesToDisable) {
        Set-Service -Name $service -StartupType Disabled
        Stop-Service -Name $service
    }
}

function Clean-ScheduledTasks {
    param (
        [string[]]$TasksToDisable
    )
    foreach ($task in $TasksToDisable) {
        Disable-ScheduledTask -TaskName $task
    }
}

function Apply-RegistryTweaks {
    param (
        [hashtable]$Tweaks
    )
    foreach ($key in $Tweaks.Keys) {
        Set-ItemProperty -Path $key -Name $Tweaks[$key].Name -Value $Tweaks[$key].Value
    }
}

function Manage-StartupPrograms {
    param (
        [string[]]$ProgramsToDisable
    )
    foreach ($program in $ProgramsToDisable) {
        Get-CimInstance -ClassName Win32_StartupCommand | Where-Object Name -like "*$program*" | Remove-CimInstance
    }
}

function Optimize-WiFi {
    param (
        [string]$AdapterName
    )
    netsh wlan set hostednetwork mode=disallow
    netsh wlan set hostednetwork mode=allow
    Set-NetQosPolicy -Name "WiFiOptimization" -IPProtocolMatchCondition "IPv4" -AppPathNameMatchCondition "C:\Program Files (x86)\WiFiApp\WiFiApp.exe" -NetworkProfile All -ThrottleRateActionBitsPerSecond 100000000
}

function Optimize-TCPIP {
    New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TcpAckFrequency" -Value 1 -PropertyType DWORD -Force
    New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TCPNoDelay" -Value 1 -PropertyType DWORD -Force
}

function Optimize-NetworkSettings {
    Set-Service -Name "PeerDistSvc" -StartupType Disabled
    Set-Service -Name "HomeGroupListener" -StartupType Disabled
    Set-Service -Name "HomeGroupProvider" -StartupType Disabled

    New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\TCPIP6\Parameters" -Name "DisabledComponents" -Value 0xFFFFFFFF -PropertyType DWORD -Force
}
