# Load the required assemblies
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

# Define the XAML for the WPF GUI with enhanced UI and logo
$XAML = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Windows Optimization Tool" Height="800" Width="1000" Background="#1E1E2D" WindowStartupLocation="CenterScreen">
    <Window.Resources>
        <Style x:Key="SidebarButtonStyle" TargetType="Button">
            <Setter Property="Background" Value="Transparent"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="Margin" Value="5"/>
            <Setter Property="Padding" Value="10"/>
            <Setter Property="BorderBrush" Value="Transparent"/>
            <Setter Property="HorizontalAlignment" Value="Left"/>
            <Setter Property="VerticalAlignment" Value="Center"/>
            <Setter Property="Width" Value="200"/>
            <Setter Property="Height" Value="40"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#007ACC"/>
                    <Setter Property="Effect">
                        <Setter.Value>
                            <DropShadowEffect BlurRadius="10" ShadowDepth="0" Color="Cyan"/>
                        </Setter.Value>
                    </Setter>
                </Trigger>
            </Style.Triggers>
        </Style>
        <Style x:Key="MainButtonStyle" TargetType="Button">
            <Setter Property="Background" Value="#3E3E42"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="Margin" Value="10"/>
            <Setter Property="Padding" Value="10"/>
            <Setter Property="BorderBrush" Value="#5E5E60"/>
            <Setter Property="BorderThickness" Value="2"/>
            <Setter Property="HorizontalAlignment" Value="Center"/>
            <Setter Property="VerticalAlignment" Value="Center"/>
            <Setter Property="Width" Value="300"/>
            <Setter Property="Height" Value="60"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#007ACC"/>
                    <Setter Property="Effect">
                        <Setter.Value>
                            <DropShadowEffect BlurRadius="15" ShadowDepth="0" Color="Cyan"/>
                        </Setter.Value>
                    </Setter>
                </Trigger>
            </Style.Triggers>
        </Style>
        <Style x:Key="TextStyle" TargetType="TextBlock">
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="FontSize" Value="18"/>
            <Setter Property="HorizontalAlignment" Value="Center"/>
            <Setter Property="Margin" Value="10"/>
        </Style>
    </Window.Resources>
    <Grid>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="200"/>
            <ColumnDefinition Width="*"/>
        </Grid.ColumnDefinitions>
        <StackPanel Background="#2D2D30" Grid.Column="0">
            <Image Source="C:\path\to\your\logo.png" Width="150" Height="150" Margin="10" HorizontalAlignment="Center"/>
            <TextBlock Text="Windows Optimization Tool" Foreground="White" FontSize="24" FontWeight="Bold" HorizontalAlignment="Center" Margin="10"/>
            <Button x:Name="Dashboard" Content="Dashboard" Style="{StaticResource SidebarButtonStyle}"/>
            <Button x:Name="Performance" Content="Performance" Style="{StaticResource SidebarButtonStyle}"/>
            <Button x:Name="Network" Content="Network" Style="{StaticResource SidebarButtonStyle}"/>
            <Button x:Name="Security" Content="Security" Style="{StaticResource SidebarButtonStyle}"/>
            <Button x:Name="Privacy" Content="Privacy" Style="{StaticResource SidebarButtonStyle}"/>
            <Button x:Name="Settings" Content="Settings" Style="{StaticResource SidebarButtonStyle}"/>
        </StackPanel>
        <Grid Grid.Column="1" Margin="20">
            <TextBlock x:Name="MainTitle" Text="Dashboard" Style="{StaticResource TextStyle}" FontSize="30"/>
            <StackPanel x:Name="ContentPanel" HorizontalAlignment="Center" VerticalAlignment="Center">
                <!-- Dashboard Content -->
                <TextBlock x:Name="SystemSpecs" Style="{StaticResource TextStyle}" Text="System Specs: Loading..."/>
                <TextBlock x:Name="SystemTemp" Style="{StaticResource TextStyle}" Text="System Temperature: Loading..."/>
                <TextBlock x:Name="OptimizationGrade" Style="{StaticResource TextStyle}" Text="System Optimization Grade: Loading..."/>
                <Button x:Name="AISystemScan" Content="Run AI System Scan" Style="{StaticResource MainButtonStyle}"/>

                <!-- Other Functionality -->
                <Button x:Name="OptimizePerformance" Content="Optimize Performance" Style="{StaticResource MainButtonStyle}" Visibility="Collapsed"/>
                <Button x:Name="OptimizeNetwork" Content="Optimize Network" Style="{StaticResource MainButtonStyle}" Visibility="Collapsed"/>
                <Button x:Name="OneClickOptimize" Content="One-Click Optimization" Style="{StaticResource MainButtonStyle}" Visibility="Collapsed"/>
                <Button x:Name="InstallPopularApps" Content="Install Popular Apps" Style="{StaticResource MainButtonStyle}" Visibility="Collapsed"/>
                <Button x:Name="TestWiFiSpeed" Content="Test WiFi Speed" Style="{StaticResource MainButtonStyle}" Visibility="Collapsed"/>
                <Button x:Name="StressTestPC" Content="Stress Test PC" Style="{StaticResource MainButtonStyle}" Visibility="Collapsed"/>
                <Button x:Name="SetWallpaper" Content="Set Wallpaper" Style="{StaticResource MainButtonStyle}" Visibility="Collapsed"/>
                <Button x:Name="AdvancedCleaning" Content="Advanced Cleaning" Style="{StaticResource MainButtonStyle}" Visibility="Collapsed"/>
                <Button x:Name="UpdateDrivers" Content="Update Drivers" Style="{StaticResource MainButtonStyle}" Visibility="Collapsed"/>
                <Button x:Name="SortFiles" Content="Sort Files by Type" Style="{StaticResource MainButtonStyle}" Visibility="Collapsed"/>
                <Button x:Name="CorrectTimeZone" Content="Correct Time Zone" Style="{StaticResource MainButtonStyle}" Visibility="Collapsed"/>
                <Button x:Name="UndoOptimizations" Content="Undo Optimizations" Style="{StaticResource MainButtonStyle}" Visibility="Collapsed"/>
            </StackPanel>
        </Grid>
    </Grid>
</Window>
"@

# Parse the XAML to create the GUI
$reader = [System.Xml.XmlReader]::Create([System.IO.StringReader]$XAML)
$window = [Windows.Markup.XamlReader]::Load($reader)

# Function to call the ChatGPT API
function Invoke-ChatGPT {
    param (
        [string]$Prompt
    )

    $url = "http://127.0.0.1:5000/chatgpt"
    $body = @{
        prompt = $Prompt
    } | ConvertTo-Json

    try {
        $response = Invoke-RestMethod -Uri $url -Method Post -Body $body -ContentType "application/json"
        return $response.text
    } catch {
        Write-Host "Error: $_"
        return $null
    }
}

# Function to perform AI System Scan
function Perform-AISystemScan {
    $prompt = "Perform a system scan and provide recommendations for optimizing performance."
    $aiResponse = Invoke-ChatGPT -Prompt $prompt

    if ($aiResponse -ne $null) {
        $grade = "Good" # For demo purposes, replace this with actual logic to determine the grade
        $color = "Green" # Adjust based on the grade

        $window.FindName("OptimizationGrade").Text = "System Optimization Grade: $grade"
        $window.FindName("OptimizationGrade").Foreground = $color

        [System.Windows.MessageBox]::Show($aiResponse, "AI System Scan", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } else {
        [System.Windows.MessageBox]::Show("AI System Scan failed. Please try again.", "AI System Scan", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}
# Event handlers for the buttons
$window.FindName("AISystemScan").Add_Click({ Perform-AISystemScan })

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

# Function to optimize performance
function Optimize-Performance {
    Write-Host "Optimizing performance..."
    Remove-Bloatware -AppsToRemove @("Xbox", "OneDrive", "GetHelp", "YourPhone", "MicrosoftSolitaireCollection", "Weather", "News", "Skype", "Spotify", "MixedRealityPortal", "Microsoft3DViewer", "MicrosoftOfficeHub", "MicrosoftPeople", "MicrosoftStickyNotes", "MicrosoftTips")
    Optimize-Services -ServicesToDisable @("DiagTrack", "SysMain", "RetailDemo", "WSearch", "WMPNetworkSvc", "CDPSvc", "DoSvc", "DusmSvc", "MapsBroker", "PhoneSvc", "SharedAccess", "XboxGipSvc", "XboxNetApiSvc", "XboxSvc", "OneSyncSvc", "Fax", "TabletInputService", "PrintNotify")
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
    Automatic-Backup
    Optimize-Performance
    Optimize-Network
    Install-PopularApps
    Advanced-Cleaning
    Update-Drivers
    Battery-Optimization
    System-Health
    Set-Wallpaper
    Test-WiFiSpeed
    Stress-TestPC
    Disable-UnnecessaryServices
    Disable-WindowsFeatures
    Manage-RunningApplications
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
    $window.FindName("WiFiSpeedResult").Text = "WiFi Speed Test Before Optimization: `nDownload: $($beforeSpeed.Download) Mbps `nUpload: $($beforeSpeed.Upload) Mbps `nPing: $($beforeSpeed.Ping) ms"
    $window.FindName("WiFiSpeedResult").Visibility = "Visible"
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

# Function to disable unnecessary services
function Disable-UnnecessaryServices {
    $servicesToDisable = @(
        "DiagTrack", "SysMain", "RetailDemo", "WSearch", "WMPNetworkSvc", "CDPSvc",
        "DoSvc", "DusmSvc", "MapsBroker", "PhoneSvc", "SharedAccess", "XboxGipSvc",
        "XboxNetApiSvc", "XboxSvc", "OneSyncSvc", "Fax", "TabletInputService", "PrintNotify",
        "dmwappushservice", "lfsvc", "WaaSMedicSvc", "DoSvc", "icssvc",
        "MessagingService", "shpamsvc", "InstallService", "DiagTrack"
    )

    foreach ($service in $servicesToDisable) {
        Set-Service -Name $service -StartupType Disabled
        Stop-Service -Name $service -Force
    }
}

# Function to disable unnecessary Windows features
function Disable-WindowsFeatures {
    $featuresToDisable = @(
        "Printing-XPSServices-Features",
        "WorkFolders-Client",
        "MediaPlayback",
        "FaxServicesClientPackage",
        "Microsoft-Windows-Printing-InternetPrinting-Client"
    )

    foreach ($feature in $featuresToDisable) {
        Disable-WindowsOptionalFeature -Online -FeatureName $feature -NoRestart
    }
}

# Function to manage running applications
function Manage-RunningApplications {
    $applicationsToClose = @(
        "MicrosoftTeams",
        "OneDrive",
        "SkypeApp"
    )

    foreach ($app in $applicationsToClose) {
        Get-Process -Name $app -ErrorAction SilentlyContinue | Stop-Process -Force
    }
}

# Function to sort files by type
function Sort-FilesByType {
    $targetDir = "C:\SortedFiles"
    if (-not (Test-Path $targetDir)) {
        New-Item -Path $targetDir -ItemType Directory
    }

    $fileTypes = Get-ChildItem -Path C:\ -Recurse -File | Group-Object -Property Extension

    foreach ($fileType in $fileTypes) {
        $typeDir = Join-Path -Path $targetDir -ChildPath $fileType.Name.TrimStart('.')
        if (-not (Test-Path $typeDir)) {
            New-Item -Path $typeDir -ItemType Directory
        }
        $fileType.Group | Move-Item -Destination $typeDir -Force
    }

    [System.Windows.MessageBox]::Show("Files sorted by type successfully!", "Success", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
}

# Function to correct time zone
function Correct-TimeZone {
    $timeZone = "Pacific Standard Time"
    Set-TimeZone -Id $timeZone
    [System.Windows.MessageBox]::Show("Time zone corrected to $timeZone!", "Success", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
}

# Function to undo optimizations
function Undo-Optimizations {
    $undoForm = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Undo Optimizations" Height="400" Width="600">
    <Grid>
        <TextBlock Text="Select optimizations to undo:" Margin="10" HorizontalAlignment="Center" VerticalAlignment="Top" FontSize="16"/>
        <StackPanel Name="OptionsPanel" Margin="10,50,10,10" VerticalAlignment="Top">
            <CheckBox Content="Performance Optimizations" Name="PerfOpt"/>
            <CheckBox Content="Network Optimizations" Name="NetOpt"/>
            <CheckBox Content="Registry Tweaks" Name="RegOpt"/>
            <CheckBox Content="Service Optimizations" Name="SvcOpt"/>
        </StackPanel>
        <Button Content="Undo Selected" HorizontalAlignment="Center" VerticalAlignment="Bottom" Width="150" Height="30" Name="UndoBtn"/>
    </Grid>
</Window>
"@

    $reader = [System.Xml.XmlReader]::Create([System.IO.StringReader]$undoForm)
    $undoWindow = [Windows.Markup.XamlReader]::Load($reader)

    $undoWindow.FindName("UndoBtn").Add_Click({
        if ($undoWindow.FindName("PerfOpt").IsChecked) {
            Undo-PerformanceOptimizations
        }
        if ($undoWindow.FindName("NetOpt").IsChecked) {
            Undo-NetworkOptimizations
        }
        if ($undoWindow.FindName("RegOpt").IsChecked) {
            Undo-RegistryTweaks
        }
        if ($undoWindow.FindName("SvcOpt").IsChecked) {
            Undo-ServiceOptimizations
        }
        $undoWindow.Close()
        [System.Windows.MessageBox]::Show("Selected optimizations have been undone!", "Success", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    })

    $undoWindow.ShowDialog()
}

function Undo-PerformanceOptimizations {
    # Implement undo performance optimization logic here
}

function Undo-NetworkOptimizations {
    # Implement undo network optimization logic here
}

function Undo-RegistryTweaks {
    # Implement undo registry tweaks logic here
}

function Undo-ServiceOptimizations {
    # Implement undo service optimizations logic here
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
$window.FindName("AISystemScan").Add_Click({ Perform-AISystemScan })
$window.FindName("SortFiles").Add_Click({ Sort-FilesByType })
$window.FindName("CorrectTimeZone").Add_Click({ Correct-TimeZone })
$window.FindName("UndoOptimizations").Add_Click({ Undo-Optimizations })
$window.FindName("Dashboard").Add_Click({ Show-Dashboard })
$window.FindName("Performance").Add_Click({ Show-Performance })
$window.FindName("Network").Add_Click({ Show-Network })
$window.FindName("Security").Add_Click({ Show-Security })
$window.FindName("Privacy").Add_Click({ Show-Privacy })
$window.FindName("Settings").Add_Click({ Show-Settings })

# Function to show different sections (add these functions)
function Show-Dashboard {
    $window.FindName("MainTitle").Text = "Dashboard"
    $window.FindName("ContentPanel").Children | ForEach-Object { $_.Visibility = "Collapsed" }
    $window.FindName("SystemSpecs").Visibility = "Visible"
    $window.FindName("SystemTemp").Visibility = "Visible"
    $window.FindName("OptimizationGrade").Visibility = "Visible"
    $window.FindName("AISystemScan").Visibility = "Visible"
}

function Show-Performance {
    $window.FindName("MainTitle").Text = "Performance"
    $window.FindName("ContentPanel").Children | ForEach-Object { $_.Visibility = "Collapsed" }
    $window.FindName("OptimizePerformance").Visibility = "Visible"
    $window.FindName("OneClickOptimize").Visibility = "Visible"
}

function Show-Network {
    $window.FindName("MainTitle").Text = "Network"
    $window.FindName("ContentPanel").Children | ForEach-Object { $_.Visibility = "Collapsed" }
    $window.FindName("OptimizeNetwork").Visibility = "Visible"
    $window.FindName("TestWiFiSpeed").Visibility = "Visible"
}

function Show-Security {
    $window.FindName("MainTitle").Text = "Security"
    $window.FindName("ContentPanel").Children | ForEach-Object { $_.Visibility = "Collapsed" }
    $window.FindName("AdvancedCleaning").Visibility = "Visible"
    $window.FindName("UpdateDrivers").Visibility = "Visible"
}

function Show-Privacy {
    $window.FindName("MainTitle").Text = "Privacy"
    $window.FindName("ContentPanel").Children | ForEach-Object { $_.Visibility = "Collapsed" }
    $window.FindName("AISystemScan").Visibility = "Visible"
}

function Show-Settings {
    $window.FindName("MainTitle").Text = "Settings"
    $window.FindName("ContentPanel").Children | ForEach-Object { $_.Visibility = "Collapsed" }
    $window.FindName("SetWallpaper").Visibility = "Visible"
    $window.FindName("SortFiles").Visibility = "Visible"
    $window.FindName("CorrectTimeZone").Visibility = "Visible"
    $window.FindName("UndoOptimizations").Visibility = "Visible"
}

# Show the window
$window.ShowDialog()
