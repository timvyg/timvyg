#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Connect to Raspberry Pi via SSH with security confirmation
    
.DESCRIPTION
    This script provides a secure way to connect to your Raspberry Pi via SSH.
    Requires a 4-digit security code before connecting.
    
.NOTES
    Requires OpenSSH client (usually pre-installed on Windows 10+)
#>

# Configuration
$ConfigFile = "$PSScriptRoot\.pi_security"
$Config = @{
    Host = "192.168.7.241"
    User = "pi1"
    Port = 22
    Password = "I AM THE GREATEST!"
    SecurityCode = ""
}

# Load stored security code if it exists
if (Test-Path $ConfigFile) {
    try {
        $storedCode = Get-Content $ConfigFile -Raw
        if ($storedCode) {
            $Config.SecurityCode = $storedCode.Trim()
        }
    } catch {
        # If reading fails, continue with empty code
    }
}

# Function to display banner
function Show-Banner {
    Write-Host ""
    Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║  Raspberry Pi SSH Connection          ║" -ForegroundColor Cyan
    Write-Host "║  Security Required                    ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

# Function to prompt for security code
function Request-SecurityCode {
    param([int]$MaxAttempts = 3)
    
    for ($attempt = 1; $attempt -le $MaxAttempts; $attempt++) {
        Write-Host "`nSecurity Verification Required" -ForegroundColor Yellow
        Write-Host "════════════════════════════════════" -ForegroundColor Yellow
        $enteredCode = Read-Host "Enter 4-digit security code"
        
        if ($enteredCode -eq $Config.SecurityCode) {
            return $true
        } else {
            $remaining = $MaxAttempts - $attempt
            if ($remaining -gt 0) {
                Write-Host "Invalid code. $remaining attempt(s) remaining." -ForegroundColor Red
            }
        }
    }
    
    Write-Host "`nMaximum attempts exceeded. Access denied." -ForegroundColor Red
    return $false
}

# Check if OpenSSH client is available
if (-not (Get-Command ssh -ErrorAction SilentlyContinue)) {
    Write-Host "Error: SSH client not found. Please install OpenSSH client." -ForegroundColor Red
    Write-Host "You can install it with: Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0" -ForegroundColor Yellow
    exit 1
}

# Display banner
Show-Banner

# Request security code if not already set
if ([string]::IsNullOrEmpty($Config.SecurityCode)) {
    Write-Host "No security code configured. Setting up now..." -ForegroundColor Yellow
    $code1 = Read-Host "Enter your 4-digit security code"
    $code2 = Read-Host "Confirm your 4-digit security code"
    
    if ($code1 -eq $code2 -and $code1.Length -eq 4 -and $code1 -match '^\d{4}$') {
        try {
            $code1 | Out-File -FilePath $ConfigFile -NoNewline -Force
            $Config.SecurityCode = $code1
            Write-Host "Security code set successfully!" -ForegroundColor Green
            Write-Host "Please run the script again to connect." -ForegroundColor Yellow
            exit 0
        } catch {
            Write-Host "Error: Failed to save security code. $($_.Exception.Message)" -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "Error: Codes do not match or are invalid. Please try again." -ForegroundColor Red
        exit 1
    }
}

# Request security verification
if (-not (Request-SecurityCode)) {
    exit 1
}

# Display connection info
Write-Host ""
Write-Host "Connecting to Raspberry Pi..." -ForegroundColor Green
Write-Host "  Host: $($Config.Host)" -ForegroundColor White
Write-Host "  User: $($Config.User)" -ForegroundColor White
Write-Host "  Port: $($Config.Port)" -ForegroundColor White
Write-Host "  Auth: Password" -ForegroundColor White
Write-Host ""

# Check if sshpass is available (for password authentication on Windows)
$useSshpass = $false
if (Get-Command sshpass -ErrorAction SilentlyContinue) {
    $useSshpass = $true
}

# Build SSH command
$sshArgs = @()
$sshArgs += "-p"
$sshArgs += $Config.Port
$sshArgs += "-o"
$sshArgs += "PreferredAuthentications=password"
$sshArgs += "-o"
$sshArgs += "PubkeyAuthentication=no"
$sshArgs += "-o"
$sshArgs += "StrictHostKeyChecking=no"
$sshArgs += "$($Config.User)@$($Config.Host)"

# Connect via SSH with password
try {
    if ($useSshpass) {
        Write-Host "Establishing SSH connection with password..." -ForegroundColor Yellow
        $env:SSHPASS = $Config.Password
        sshpass -e ssh @sshArgs
        Remove-Item Env:\SSHPASS
    } else {
        Write-Host "Establishing SSH connection..." -ForegroundColor Yellow
        Write-Host "You will be prompted for the password." -ForegroundColor Yellow
        Write-Host "Note: For automatic password input, install sshpass for Windows" -ForegroundColor Gray
        Write-Host ""
        ssh @sshArgs
    }
}
catch {
    Write-Host ""
    Write-Host "Error: Failed to connect to $($Config.Host)" -ForegroundColor Red
    Write-Host "Details: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Troubleshooting tips:" -ForegroundColor Yellow
    Write-Host "  1. Check if the Raspberry Pi is powered on and on the network"
    Write-Host "  2. Verify the IP address is correct: $($Config.Host)"
    Write-Host "  3. Ensure SSH is enabled on the Raspberry Pi"
    Write-Host "  4. Check firewall settings"
    Write-Host "  5. Verify username: $($Config.User)"
    Write-Host ""
    exit 1
}

