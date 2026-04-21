# Automation Scripts

This directory contains automation and monitoring scripts created during the homelab project, demonstrating cross-platform scripting skills for system administration.

---

## PowerShell Scripts (Windows)

### System-Health-Check.ps1

**Purpose:** Daily system health monitoring with automated reporting

**Features:**
- Computer name and OS information
- System uptime calculation
- Memory usage analysis (used/total in GB)
- Disk space reporting
- Date-stamped report files
- Error handling with try-catch
- Color-coded console output

**Use Case:** Daily health checks with automated report generation for tracking system state over time.

---

### Check-Installed-Updates.ps1

**Purpose:** Patch deployment verification and update history tracking

**Features:**
- Lists last 10 installed Windows updates
- Computer name and timestamp
- Date-stamped report files
- HotFix ID, description, and installation date
- Formatted table output

**Use Case:** Critical for air-gapped patch management - verify updates were installed successfully when automated Windows Update is disabled.

---

### Running-Services-Check.ps1

**Purpose:** Monitor running services and generate service inventory

**Features:**
- Counts total running services
- Filters by service status
- Exports complete running services list to file
- Computer name and timestamp

**Use Case:** Baseline service state before/after patching or system changes.

---

### service-recovery-check.ps1

**Purpose:** Post-patch service verification and auto-recovery

**Features:**
- Checks critical services (Windows Update, Time Service, Print Spooler)
- Automatically starts stopped services
- Try-catch error handling for each service
- Color-coded status output (Green=Running, Yellow=Started, Red=Failed)
- Date-stamped recovery reports

**Use Case:** Post-patch validation - ensures critical services are running after updates or system changes.

---

### multi-server-patch-report.ps1

**Purpose:** Multi-server patch compliance reporting

**Features:**
- Queries multiple servers remotely
- Retrieves last 5 updates per server
- Consolidated patch report across infrastructure
- Per-server error handling
- Date-stamped consolidated report

**Use Case:** Enterprise patch compliance - check update status across multiple domain controllers or servers from single console.

---

## Python Scripts (Linux)

### System-info.py

**Purpose:** System information gathering and documentation

**Features:**
- Hostname identification
- OS and kernel version
- Python version
- System uptime
- Date-stamped report files
- Error handling for uptime command

**Use Case:** System inventory and documentation for air-gapped infrastructure.

---

### check-packages.py

**Purpose:** Package inventory and validation

**Features:**
- Counts total installed packages
- Lists last 10 installed packages with versions
- Exports complete package list to file
- Date-stamped reports
- Error handling for dpkg command

**Use Case:** Package inventory baseline before/after patching for validation and compliance.

---

### Critical-package-check.py

**Purpose:** Verify critical packages are installed

**Features:**
- Checks array of critical packages (openssh-server, curl, vim)
- Pass/fail counters
- Installation status reporting
- Date-stamped validation reports

**Use Case:** Pre-deployment validation - ensure required packages are present before system goes into production.

---

### patch-validation-check.py

**Purpose:** Create package snapshot for patch validation

**Features:**
- Generates complete installed package list with versions
- Exports to text file for comparison
- Filters for installed packages only (ii status)
- Package count reporting

**Use Case:** Create "before" snapshot prior to patching - compare with "after" snapshot to validate changes.

---

### check-package-lists.py

**Purpose:** Compare package snapshots to detect changes

**Features:**
- File existence validation
- Set operations to find differences (added/removed packages)
- Counts total changes
- Error handling with exit codes

**Use Case:** Post-patch validation - compare before/after snapshots to verify only expected packages were modified.

---

### prepatch-diskusage-check.py

**Purpose:** Pre-patch disk space validation

**Features:**
- Checks multiple mount points (/, /home, /tmp)
- Calculates percentage used
- Warning thresholds (>80% = unsafe to patch)
- Clear/Not safe to patch recommendations
- Date-stamped validation reports

**Use Case:** Pre-patch safety check - prevent patching failures due to insufficient disk space.

---

## Bash Scripts (Linux)

### System-Snapshot.sh

**Purpose:** Quick system state snapshot

**Features:**
- Hostname and timestamp
- Kernel version
- Total package count
- Date-stamped snapshot files

**Use Case:** Rapid system state capture for baseline documentation or pre-change snapshots.

---

### Bash-Critical-package-check.sh

**Purpose:** Critical package verification with metrics

**Features:**
- Loops through critical package array
- Pass/fail counters
- Installation status reporting
- Date-stamped reports

**Use Case:** Pre-deployment validation checklist for required packages.

---

### pre-patch-backup.sh

**Purpose:** Automated pre-patch configuration backup

**Features:**
- Creates date-organized backup directories
- Backs up critical config files (hostname, network interfaces, DNS config)
- Validates each file copy operation
- Counts backed-up files
- TAR compression for archival
- Success/failure reporting per file

**Use Case:** Pre-patch safety - backup critical configurations before system changes to enable rollback if needed.

---

### patch-deployment-package.sh

**Purpose:** Package .deb files for offline deployment

**Features:**
- Validates .deb files exist before proceeding
- Creates date-organized deployment directory
- Copies and counts patch packages
- TAR compression for transfer
- Exit codes for automation integration

**Use Case:** Air-gapped patch deployment - package updates for transfer to isolated systems via USB or offline media.

---

### wpa_supplicant_startup.sh

**Purpose:** WiFi auto-start documentation and configuration guide

**Features:**
- systemd service configuration
- Network interface setup
- Default route configuration
- Troubleshooting documentation

**Use Case:** Headless server WiFi connectivity - ensures reliable wireless network access after reboots without manual intervention.

---

## Skills Demonstrated

**Cross-Platform Scripting:**
- PowerShell for Windows administration
- Python for cross-platform automation  
- Bash for Linux system configuration

**Advanced Concepts:**
- Exception handling (try-catch in PowerShell, error handling in Python/Bash)
- Remote server queries (PowerShell remoting)
- Set operations for data comparison (Python)
- Service auto-remediation
- File validation and verification
- Multi-server reporting
- Date-stamped logging
- Pass/fail metrics tracking
- Safety thresholds and warnings
- Backup automation with validation
- Package deployment workflows

**System Administration:**
- Pre-patch validation workflows
- Post-patch verification
- Configuration backup and recovery
- Package management and inventory
- Service monitoring and recovery
- Disk space management
- Multi-server reporting
- Health monitoring and alerting

**Best Practices:**
- Clear, commented code
- Consistent formatting
- Comprehensive error handling
- User-friendly output with color coding
- Date-stamped reports for tracking
- File validation before operations
- Exit codes for automation integration
- Detailed documentation

---

## Usage Notes

**PowerShell Scripts:**
- Run with: `powershell.exe -ExecutionPolicy Bypass -File .\script.ps1`
- Or set execution policy: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`

**Python Scripts:**
- Make executable: `chmod +x script.py`
- Run: `./script.py` or `python3 script.py`

**Bash Scripts:**
- Make executable: `chmod +x script.sh`
- Run: `./script.sh`

---

## Workflow Examples

**Pre-Patch Workflow:**
1. `prepatch-diskusage-check.py` - Verify sufficient disk space
2. `pre-patch-backup.sh` - Backup critical configurations
3. `patch-validation-check.py` - Create "before" package snapshot
4. Apply patches
5. `check-package-lists.py` - Compare before/after snapshots
6. `service-recovery-check.ps1` - Verify critical services running

**Multi-Server Compliance:**
1. `multi-server-patch-report.ps1` - Check patch status across infrastructure
2. Generate consolidated compliance report

**Package Deployment (Air-Gapped):**
1. `patch-deployment-package.sh` - Package .deb files for transfer
2. Transfer compressed package to isolated system
3. Extract and deploy packages
4. `patch-validation-check.py` - Verify installation

---

*These scripts demonstrate practical automation skills for enterprise IT administration in both air-gapped and connected environments, with emphasis on safety, validation, and production-ready error handling.*