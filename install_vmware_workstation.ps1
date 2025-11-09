# VMware Workstation Player Installation Script for Windows
# This script helps download and install VMware Workstation Player (free version)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "VMware Workstation Player Installer" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "WARNING: This script should be run as Administrator for best results." -ForegroundColor Yellow
    Write-Host "Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    Write-Host ""
    $continue = Read-Host "Continue anyway? (Y/N)"
    if ($continue -ne "Y" -and $continue -ne "y") {
        exit
    }
}

# Check system requirements
Write-Host "Checking system requirements..." -ForegroundColor Green
$os = Get-CimInstance Win32_OperatingSystem
$ram = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
$arch = $os.OSArchitecture

Write-Host "OS: $($os.Caption)" -ForegroundColor White
Write-Host "Architecture: $arch" -ForegroundColor White
Write-Host "RAM: $ram GB" -ForegroundColor White
Write-Host ""

if ($ram -lt 4) {
    Write-Host "WARNING: Minimum 4 GB RAM recommended. You have $ram GB." -ForegroundColor Yellow
}

# VMware Workstation Player download URL (latest version)
# Note: You'll need to update this URL with the latest version from VMware's website
$downloadUrl = "https://www.vmware.com/go/getplayer-win"
$downloadPath = "$env:USERPROFILE\Downloads\VMware-Player.exe"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Installation Options:" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "1. Download VMware Workstation Player (FREE)" -ForegroundColor Green
Write-Host "2. Open VMware download page in browser" -ForegroundColor Green
Write-Host "3. Check if VMware is already installed" -ForegroundColor Green
Write-Host "4. Exit" -ForegroundColor Red
Write-Host ""

$choice = Read-Host "Select an option (1-4)"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "Downloading VMware Workstation Player..." -ForegroundColor Green
        Write-Host "Note: The download will open in your browser." -ForegroundColor Yellow
        Write-Host "After downloading, run the installer manually." -ForegroundColor Yellow
        Write-Host ""
        
        # Open the download page
        Start-Process "https://www.vmware.com/products/workstation-player/workstation-player-evaluation.html"
        
        Write-Host "Please download VMware Workstation Player from the browser." -ForegroundColor Cyan
        Write-Host "After downloading, you can:" -ForegroundColor Cyan
        Write-Host "  - Run the installer from your Downloads folder" -ForegroundColor White
        Write-Host "  - Or run this script again and choose option 3 to check installation" -ForegroundColor White
    }
    
    "2" {
        Write-Host "Opening VMware download page..." -ForegroundColor Green
        Start-Process "https://www.vmware.com/products/workstation-player/workstation-player-evaluation.html"
        Write-Host "Download page opened in browser." -ForegroundColor Green
    }
    
    "3" {
        Write-Host ""
        Write-Host "Checking for existing VMware installation..." -ForegroundColor Green
        
        $vmwareInstalled = $false
        
        # Check common installation paths
        $paths = @(
            "C:\Program Files\VMware",
            "${env:ProgramFiles(x86)}\VMware",
            "C:\Program Files (x86)\VMware"
        )
        
        foreach ($path in $paths) {
            if (Test-Path $path) {
                Write-Host "Found VMware installation at: $path" -ForegroundColor Green
                $vmwareInstalled = $true
                
                # List installed VMware products
                Get-ChildItem $path -Directory | ForEach-Object {
                    Write-Host "  - $($_.Name)" -ForegroundColor White
                }
            }
        }
        
        # Check registry
        $regPaths = @(
            "HKLM:\Software\VMware, Inc.\VMware Workstation",
            "HKLM:\Software\VMware, Inc.\VMware Player",
            "HKLM:\Software\Wow6432Node\VMware, Inc.\VMware Workstation",
            "HKLM:\Software\Wow6432Node\VMware, Inc.\VMware Player"
        )
        
        foreach ($regPath in $regPaths) {
            if (Test-Path $regPath) {
                Write-Host "Found VMware in registry: $regPath" -ForegroundColor Green
                $vmwareInstalled = $true
                
                try {
                    $version = Get-ItemProperty $regPath -Name "Version" -ErrorAction SilentlyContinue
                    if ($version) {
                        Write-Host "  Version: $($version.Version)" -ForegroundColor White
                    }
                } catch {
                    # Ignore errors
                }
            }
        }
        
        if (-not $vmwareInstalled) {
            Write-Host "VMware is not installed." -ForegroundColor Yellow
            Write-Host "Please download and install VMware Workstation Player." -ForegroundColor Yellow
        } else {
            Write-Host ""
            Write-Host "VMware appears to be installed!" -ForegroundColor Green
        }
    }
    
    "4" {
        Write-Host "Exiting..." -ForegroundColor Yellow
        exit
    }
    
    default {
        Write-Host "Invalid choice. Exiting..." -ForegroundColor Red
        exit
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Additional Information:" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "VMware Workstation Player is FREE for personal use." -ForegroundColor Green
Write-Host ""
Write-Host "System Requirements:" -ForegroundColor Yellow
Write-Host "  - 64-bit processor with virtualization support (Intel VT-x or AMD-V)" -ForegroundColor White
Write-Host "  - 4 GB RAM minimum (8 GB recommended)" -ForegroundColor White
Write-Host "  - 1.2 GB disk space for application" -ForegroundColor White
Write-Host "  - Windows 10 or later (64-bit)" -ForegroundColor White
Write-Host ""
Write-Host "After installation:" -ForegroundColor Yellow
Write-Host "  1. Enable virtualization in BIOS if not already enabled" -ForegroundColor White
Write-Host "  2. Restart your computer if prompted" -ForegroundColor White
Write-Host "  3. Open VMware Workstation Player and create your first VM" -ForegroundColor White
Write-Host ""
Write-Host "For more information, visit: https://www.vmware.com/products/workstation-player.html" -ForegroundColor Cyan

