# VMware Workstation Player Installation Guide for Windows

## Overview

VMware Fusion is designed for **macOS only**. For Windows systems, you need **VMware Workstation Player** (free for personal use) or **VMware Workstation Pro** (paid, with additional features).

## Quick Start

1. **Run the installation script:**
   ```powershell
   .\install_vmware_workstation.ps1
   ```

2. **Or manually download:**
   - Visit: https://www.vmware.com/products/workstation-player/workstation-player-evaluation.html
   - Click "Download Now" for the free version
   - Run the installer and follow the prompts

## System Requirements

- **OS:** Windows 10 or later (64-bit)
- **Processor:** 64-bit processor with virtualization support (Intel VT-x or AMD-V)
- **RAM:** 4 GB minimum (8 GB recommended)
- **Disk Space:** 1.2 GB for application + additional space for VMs (5-10 GB per VM recommended)

## Installation Steps

### Method 1: Using the PowerShell Script

1. Open PowerShell as Administrator
2. Navigate to your project directory
3. Run: `.\install_vmware_workstation.ps1`
4. Follow the on-screen prompts

### Method 2: Manual Installation

1. **Download VMware Workstation Player:**
   - Go to: https://www.vmware.com/products/workstation-player/workstation-player-evaluation.html
   - Click "Download Now" (free for personal use)
   - You may need to create a VMware account (free)

2. **Run the Installer:**
   - Locate the downloaded `.exe` file (usually in Downloads folder)
   - Right-click and select "Run as Administrator"
   - Follow the installation wizard

3. **Complete Installation:**
   - Accept the license agreement
   - Choose installation location (default is recommended)
   - Choose whether to check for product updates
   - Click "Install" and wait for completion

4. **Restart (if prompted):**
   - VMware may require a system restart to enable virtualization features

## Enable Virtualization in BIOS

If virtualization is not enabled, you may need to enable it in your BIOS:

1. **Restart your computer**
2. **Enter BIOS/UEFI settings** (usually F2, F10, F12, or Del during boot)
3. **Navigate to Virtualization settings:**
   - Look for "Virtualization Technology" or "Intel VT-x" (Intel) or "AMD-V" (AMD)
   - Enable the setting
4. **Save and exit BIOS**
5. **Restart your computer**

## Verify Installation

After installation, verify VMware is installed:

```powershell
# Check installation directory
Test-Path "C:\Program Files\VMware"

# Check for VMware processes
Get-Process | Where-Object {$_.ProcessName -like "*vmware*"}
```

## Creating Your First Virtual Machine

1. **Open VMware Workstation Player**
2. **Click "Create a New Virtual Machine"**
3. **Choose installation method:**
   - Installer disc or ISO image (recommended)
   - Or "I will install the operating system later"
4. **Select guest operating system:**
   - Choose the OS you want to install (Linux, Windows, etc.)
5. **Name your VM and choose location**
6. **Set disk capacity** (recommended: 20-40 GB)
7. **Customize hardware** (optional):
   - Memory (RAM)
   - Processors
   - Network adapter
8. **Click "Finish" and start the VM**

## Troubleshooting

### Virtualization Not Enabled

**Error:** "This host does not support virtualization"

**Solution:**
1. Enable virtualization in BIOS (see above)
2. Ensure Hyper-V is disabled (if using Windows Pro):
   ```powershell
   # Check Hyper-V status
   Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All
   
   # Disable Hyper-V if needed (requires restart)
   Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All
   ```

### Installation Fails

**Solutions:**
1. Run installer as Administrator
2. Disable antivirus temporarily during installation
3. Ensure you have enough disk space
4. Check Windows Event Viewer for error details

### VM Won't Start

**Solutions:**
1. Verify virtualization is enabled in BIOS
2. Ensure enough RAM is available
3. Check VM settings (memory, processors)
4. Verify the ISO/image file is not corrupted

## Additional Resources

- **VMware Workstation Player Documentation:** https://docs.vmware.com/en/VMware-Workstation-Player/
- **VMware Community:** https://communities.vmware.com/
- **System Requirements:** https://www.vmware.com/products/workstation-player/workstation-player-evaluation.html

## Alternatives

If VMware doesn't meet your needs, consider these alternatives:

- **VirtualBox** (Free, open-source): https://www.virtualbox.org/
- **Hyper-V** (Windows Pro/Enterprise only): Built into Windows
- **WSL2** (For Linux): Windows Subsystem for Linux

## Notes

- VMware Workstation Player is **FREE** for personal, non-commercial use
- VMware Workstation Pro offers additional features but requires a license
- Always download VMware from the official website to avoid malware
- Keep VMware updated for security and performance improvements

