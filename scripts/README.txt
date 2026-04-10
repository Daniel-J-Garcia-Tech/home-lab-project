# Automation Scripts

This directory contains automation and monitoring scripts created during the homelab project, demonstrating cross-platform scripting skills for system administration.

---

## PowerShell Scripts (Windows)

### System-Health-Check.ps1

**Platform:** Windows Server 2025  
**Location:** `C:\Scripts\` on Domain Controller

**Purpose:** Quick system status overview for daily health monitoring

**Features:**
- Computer name identification
- Operating system version and build
- System uptime calculation (days and hours)
- Memory usage analysis (used/total in GB)
- Disk space reporting (C: drive usage and available space)
- Color-coded console output for readability

**Output Example:**
=== System Health Check ===
Computer: SERVER-DC01
OS: Microsoft Windows Server 2025 Datacenter
Uptime: 3 days, 2 hours
Memory: 1.52 GB used / 7.98 GB total
Disk Space:
C: - Used: 21.53 GB, Free: 77.49 GB
Health check complete!

**Technical Skills:**
- `Get-CimInstance` for WMI/CIM queries
- Object property manipulation
- DateTime arithmetic
- Mathematical calculations and rounding
- Unit conversion (KB to GB)
- Formatted console output with color

**Use Case:** Run daily to verify server health, disk space availability, and identify potential resource constraints before they become critical issues.

---

### Check-Installed-Updates.ps1

**Platform:** Windows Server 2025  
**Location:** `C:\Scripts\` on Domain Controller

**Purpose:** Verify patch deployment and track update history in air-gapped environment

**Features:**
- Lists last 10 installed Windows updates
- Displays HotFix ID, description, and installation date
- Formatted table output for easy reading
- Essential for offline patch validation

**Output Example:**
=== Installed Windows Updates ===
Last 10 installed updates:
KB5066131    Update           1/11/26
KB5073379    Security Update  1/11/26
KB5072725    Security Update  1/11/26
...
Report complete!

**Technical Skills:**
- `Get-HotFix` cmdlet for update queries
- Pipeline operations (`|`)
- Object selection and filtering
- Table formatting

**Use Case:** Critical for air-gapped patch management - verify updates were installed successfully when automated Windows Update is disabled.

---

## Python Scripts (Linux)

### system-info.py

**Platform:** Ubuntu Server 24.04 LTS  
**Location:** `/home/labadmin/scripts/`

**Purpose:** Display comprehensive system information for Linux systems

**Features:**
- Hostname identification
- Operating system and kernel version
- Python version (runtime environment verification)
- System uptime (human-readable format)
- Clean, formatted output

**Output Example:**
=== System Information ===
Hostname: ubuntu-lab
OS: Linux 6.8.0-107-generic
Python: 3.12.3
Uptime: up 24 minutes
Script complete!

**Technical Skills:**
- Module imports (`os`, `platform`, `subprocess`)
- System command execution via subprocess
- String formatting (f-strings)
- Cross-platform system queries

**Use Case:** Quick system verification and documentation, particularly useful for inventory management and health checks in air-gapped Linux infrastructure.

---

### check-packages.py

**Platform:** Ubuntu Server 24.04 LTS  
**Location:** `/home/labadmin/scripts/`

**Purpose:** Report on installed packages for patch validation and compliance

**Features:**
- Counts total installed packages
- Lists last 10 installed packages
- Displays package names and versions
- Formatted output for easy parsing

**Output Example:**
=== Installed Packages Report ===
Total packages installed: 492
Last 10 installed packages:
wireless-regdb                 2025.10.07-0ubuntu1~24.04.1
xauth                          1:1.1.2-1build1
zstd                           1.5.5+dfsg2-2build1.1
...
Report complete!

**Technical Skills:**
- subprocess module for system commands
- Text processing and parsing
- List comprehensions and filtering
- String manipulation
- Working with package management tools (dpkg)

**Use Case:** Essential for offline Linux patch management - verify package installations in air-gapped environments where automated update tracking isn't available. Equivalent to PowerShell's `Get-HotFix` for Linux systems.

---

## Bash Scripts (Linux)

### wpa_supplicant_startup.sh

**Platform:** Proxmox VE 9.1 (Debian-based)  
**Location:** `/etc/systemd/system/` (as systemd service)

**Purpose:** Automated WiFi connection at boot for Proxmox host

**Problem Solved:**  
WiFi adapter (Intel iwlwifi) failed to initialize during boot sequence, causing network unavailability and requiring manual intervention.

**Solution:**  
Created custom systemd service to ensure wpa_supplicant starts with correct timing and parameters after network interfaces are available.

**Implementation:**
- systemd service file configuration
- Network service dependencies (After=network.target)
- Startup order management
- WiFi authentication via wpa_supplicant

**Technical Skills:**
- systemd service creation
- Network service troubleshooting
- Startup sequence management
- WiFi configuration (WPA2)

**Use Case:** Essential for headless server operation - ensures reliable WiFi connectivity without manual intervention after reboots or power cycles.

---

## Skills Demonstrated

**Cross-Platform Scripting:**
- PowerShell for Windows administration
- Python for cross-platform automation
- Bash for Linux system configuration

**System Administration:**
- Health monitoring and reporting
- Patch validation and verification
- Package management
- Network service automation

**Best Practices:**
- Clear, commented code
- Consistent formatting
- Error handling
- User-friendly output
- Documentation and usage examples

---

## Usage Notes

**PowerShell Scripts:**
- Run with execution policy: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`
- Or run directly: `powershell.exe -ExecutionPolicy Bypass -File .\script.ps1`

**Python Scripts:**
- Make executable: `chmod +x script.py`
- Run: `./script.py` or `python3 script.py`

**Bash Scripts:**
- Make executable: `chmod +x script.sh`
- Run: `./script.sh`

---

*These scripts demonstrate practical automation skills for enterprise IT administration in both air-gapped and connected environments.*