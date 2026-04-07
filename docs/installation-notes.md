# Installation and Setup Notes

## Environment Preparation

### Hardware
- **Host Machine:** ASUS ROG Laptop
- **CPU:** Intel i7-7700HQ (4 cores, 2.8GHz)
- **RAM:** 16GB
- **Storage:** 
  - 256GB NVMe SSD (Proxmox host)
  - 1TB HDD (VM storage)
- **Network:** WiFi (Intel iwlwifi driver)

### Hypervisor Installation
**Proxmox VE 9.1**
- Downloaded ISO from proxmox.com
- Created bootable USB with Rufus
- Installed to 256GB SSD, wiping previous Windows installation
- Configuration: ext4 filesystem, default partitioning

---

## Network Configuration

### Proxmox Host WiFi Setup
**Challenge:** WiFi needed for management access, but also air-gapped VMs

**Solution:** WiFi with removable NAT
- Configured static IP: 192.x.x.x
- Created systemd service for wpa_supplicant
- Implemented NAT with iptables (later disabled for air-gap)
- Added post-up command for default route

**Key Files:**
- `/etc/systemd/system/wpa_supplicant@wlp4s0.service`
- `/etc/network/interfaces`
- `/etc/wpa_supplicant/wpa_supplicant.conf`

### VM Network Architecture
**Internal Network:** 10.x.x.x/24
- vmbr0 bridge at 10.x.x.x
- NAT initially enabled, then disabled for air-gap
- VMs isolated from internet, communicate internally only

---

## Storage Configuration

### VM Storage Pool
**Mounted 1TB HDD for VM storage:**
```bash
mkfs.ext4 /dev/sda1
mkdir -p /mnt/vm-storage
mount /dev/sda1 /mnt/vm-storage
pvesm add dir vm-storage --path /mnt/vm-storage --content images,iso,vztmpl
```

**Made persistent via /etc/fstab:**
```
/dev/sda1 /mnt/vm-storage ext4 defaults 0 2
```

### ISO Management
**Uploaded ISOs to:** `/mnt/vm-storage/template/iso/`
- Windows Server 2025 Evaluation
- Windows 10 IoT Enterprise LTSC
- VirtIO drivers (virtio-win-0.1.285.iso)

---

## Virtual Machine Creation

### Windows Server 2025 (Domain Controller)

**Created via CLI for learning:**
```bash
qm create 102 \
  --name WinServer2025-CLI \
  --pool production-vms \
  --memory 8192 \
  --cores 2 \
  --cpu x86-64-v2-AES \
  --machine q35 \
  --bios ovmf \
  --efidisk0 vm-storage:1,format=qcow2,efitype=4m,pre-enrolled-keys=1 \
  --tpmstate0 vm-storage:1,version=v2.0 \
  --scsihw virtio-scsi-single \
  --scsi0 vm-storage:100,format=qcow2 \
  --ide2 vm-storage:iso/[Windows-ISO],media=cdrom \
  --ide3 vm-storage:iso/virtio-win-0.1.285.iso,media=cdrom \
  --boot order=ide2 \
  --ostype win11 \
  --net0 virtio,bridge=vmbr0
```

**Specifications:**
- VM ID: 102
- RAM: 8GB
- CPU: 2 cores
- Disk: 100GB (VirtIO SCSI)
- Network: VirtIO on vmbr0
- Static IP: 10.x.x.x

**Installation Steps:**
1. Booted from Windows Server ISO
2. Loaded VirtIO SCSI driver during installation (E:\vioscsi\w11\amd64)
3. Installed to 100GB disk
4. Post-install: Ran virtio-win-gt-x64.msi for additional drivers
5. Configured static IP manually

### Windows 10 Client

**Created via Web Interface:**
- VM ID: 103
- Name: Win10-Lab
- Resource Pool: Lab-Clients
- RAM: 4GB
- CPU: 2 cores
- Disk: 60GB (VirtIO SCSI)
- Network: VirtIO on vmbr0
- DHCP assigned IP (later: 10.12.59.x from DHCP scope)

**Installation Steps:**
1. Booted from Windows 10 IoT Enterprise LTSC ISO
2. Loaded VirtIO drivers during installation
3. Skipped product key (evaluation/testing)
4. Created local account initially
5. Installed VirtIO guest tools post-installation

---

## Active Directory Deployment

### Domain Controller Setup

**Installed Roles:**
- Active Directory Domain Services
- DNS Server
- DHCP Server
- Remote Desktop Services

**Domain Configuration:**
- Domain Name: lab.local
- Forest/Domain Functional Level: Windows Server 2025
- FSMO Roles: All five on single DC (expected for first DC)

**Post-Deployment Configuration:**
1. Created OU structure (Corporate, Workstations)
2. Created department OUs (IT, HR, Finance)
3. Added user accounts across departments
4. Created security group (IT Admins)
5. Moved computer objects to appropriate OUs

### DHCP Configuration

**Scope Settings:**
- Range: 10.x.x.x - 10.x.x.x
- Subnet: 255.255.255.0
- Gateway: 10.x.x.x
- DNS: 10.x.x.x (DC)
- Lease Duration: Default (8 days)

**Authorized DHCP server in Active Directory**

### DNS Configuration
- Automatically configured with AD DS installation
- Forward lookup zone: lab.local
- Reverse lookup zone: Auto-created
- DNS integrated with Active Directory

### Remote Desktop Services

**Deployment Type:** Quick Start (Session-based)

**Roles Installed:**
- RD Session Host
- RD Connection Broker
- RD Web Access
- RD Licensing

**Collection:** Session Collection
- User Group: Domain Users
- Profile Disks: Disabled (lab environment)

---

## Group Policy Implementation

### Created GPOs:

**1. Wallpaper Policy**
- Linked to: User Workstations OU
- Setting: Enforced desktop wallpaper
- Path: C:\Windows\Web\Wallpaper\Windows\img0.jpg

**2. Disable Windows Update**
- Linked to: User Workstations OU
- Setting: Removed access to Windows Update features
- Purpose: Control updates in air-gapped environment
- Security Filtering: Applied to Domain Users (excludes Domain Admins)

---

## Domain Join Process

**Windows 10 Client:**
1. Configured static IP initially (10.x.x.x)
2. Set DNS to DC (10.x.x.x)
3. Joined domain: lab.local
4. Used Administrator credentials
5. Restarted
6. Verified computer account appeared in AD
7. Later switched to DHCP after DHCP Server deployment

**Verification:**
- Logged in as domain user (lab\jsmith)
- Confirmed group membership with `whoami /groups`
- Applied Group Policy with `gpupdate /force`
- Tested RDS connection via mstsc

---

## Air-Gapped Configuration

### Removed Internet Access
**Disabled NAT routing:**
```bash
iptables-legacy -t nat -D POSTROUTING -s '10.x.x.x/24' -o wlp4s0 -j MASQUERADE
```

**Verification:**
- VMs can ping each other (10.x.x.x)
- VMs can ping Proxmox bridge (10.x.x.x)
- VMs cannot ping internet (8.8.8.8) - Expected

### Manual Patching Workflow

**Process:**
1. Downloaded updates on internet-connected PC from Microsoft Update Catalog
2. Transferred to USB drive
3. Copied to Proxmox: `/mnt/vm-storage/template/iso/`
4. Created ISO containing updates
5. Attached ISO to VM as additional CD drive
6. Installed manually in correct order:
   - Servicing Stack Update (SSU) first
   - Cumulative Update second
   - .NET Framework updates third
7. Verified installation via Windows Update history

**Required Service Configuration:**
- Enabled Windows Update service: `sc config wuauserv start=demand`
- Started service: `sc start wuauserv`
- Installed via command line: `wusa.exe [filename].msu`

---

## Resource Organization

### Resource Pools
- **production-vms:** Server infrastructure (Domain Controller)
- **Lab-Clients:** Client workstations (Windows 10)

### Naming Conventions
- VMs: Descriptive names with purpose (WinServer2025-CLI, Win10-Lab)
- OUs: Functional organization (Corporate, Workstations)
- Users: Standard format (first initial + last name)
- Groups: Descriptive purpose (IT Admins)

---

## Key Commands Reference

### Proxmox Management
```bash
# VM Control
qm list                   # List all VMs
qm start [vmid]           # Start VM
qm stop [vmid]            # Stop VM
qm status [vmid]          # Check VM status

# Storage Management
pvesm status              # Show storage status
pvesm add dir [name]      # Add directory storage

# Resource Pools
pvesh create /pools       # Create resource pool
pvesh get /pools          # List pools
```

### Windows Administration
```powershell
# Active Directory
Get-ADUser -Filter *                    # List all users
Get-ADComputer -Filter *                # List all computers
Get-ADOrganizationalUnit -Filter *      # List all OUs

# Group Policy
gpupdate /force                         # Force policy refresh
gpresult /r                             # Show applied policies

# Domain Join Verification
whoami                                  # Show current user
whoami /groups                          # Show group memberships
```

---

## Lessons and Best Practices

**What Worked Well:**
- CLI VM creation for learning and reproducibility
- Systematic documentation throughout process
- Testing after each major change
- Keeping backups of configuration files

**What Could Be Improved:**
- Could implement DHCP earlier to avoid manual IP configuration
- Snapshot VMs before major changes
- Test GPOs in isolated OU before wide deployment
- Document IP allocation scheme from the beginning

**Security Considerations:**
- Air-gapped environment prevents unauthorized access
- Group Policy provides centralized security management
- Separate resource pools aid in organization and potential isolation
- Manual update process ensures control over patching

---

## WSUS Configuration (Air-Gapped Limitations)

### WSUS Installation
**Installed Windows Server Update Services:**
- Role: Windows Server Update Services
- Database: Windows Internal Database (WID)
- Content Location: C:\WSUS
- Purpose: Centralized patch management for domain clients

**Configuration Challenges in Air-Gapped Environment:**
- WSUS designed for internet connectivity to download product catalog
- Product catalog (wsusscn2.cab) is for offline scanning, not WSUS import
- Air-gapped WSUS requires either:
  - Replica server architecture (upstream/downstream WSUS servers)
  - Initial internet connection for product catalog sync
  - Manual update import using wsusutil.exe with exported WSUS packages

**Current Status:**
- WSUS role installed and configured
- Automatic synchronization disabled
- Prepared for potential future configuration with upstream server or manual import workflow

**Key Learning:**
- WSUS is powerful for connected environments
- Air-gapped patch management often relies on manual processes
- Understanding both centralized (WSUS) and manual patching approaches is valuable

---

## Linux VM Installation and Configuration

### Ubuntu Server 24.04 LTS

**Created via CLI:**
```bash
qm create 104 \
  --name Ubuntu-Server-Lab \
  --pool production-vms \
  --memory 2048 \
  --cores 2 \
  --cpu host \
  --net0 virtio,bridge=vmbr0 \
  --ide2 vm-storage:iso/ubuntu-24.04.4-live-server-amd64.iso,media=cdrom \
  --boot order=ide2 \
  --ostype l26 \
  --scsihw virtio-scsi-single \
  --scsi0 vm-storage:20,format=qcow2
```

**Specifications:**
- VM ID: 104
- RAM: 2GB
- CPU: 2 cores
- Disk: 20GB (VirtIO SCSI)
- Network: VirtIO on vmbr0
- OS: Ubuntu Server 24.04.4 LTS (minimized installation)
- Hostname: ubuntu-lab
- User: labadmin

**Installation Process:**
- Selected Ubuntu Server (minimized) for minimal footprint
- Configured DHCP networking (IP from DC: 10.12.59.50)
- Installed OpenSSH server for remote management
- Skipped Ubuntu Pro subscription
- Created local administrator account

**Post-Installation Package Management:**
- Installed essential tools via manual .deb download and transfer
- Packages installed: htop, dnsutils, traceroute, apt-mirror, tree, ncdu, tcpdump
- Used USB transfer method (air-gapped workflow)
- Resolved dependencies using `apt --fix-broken install`

### Offline APT Repository Creation

**Purpose:** Enable air-gapped package management for Linux systems

**Repository Structure:**
/var/local-repo/
├── debs/           # Package files (.deb)
└── Packages        # Repository index metadata

**Implementation Steps:**

1. **Organized packages into repository structure:**
```bash
sudo mkdir -p /var/local-repo/debs
sudo cp ~/packages/*.deb /var/local-repo/debs/
```

2. **Generated repository index:**
```bash
sudo bash -c "apt-ftparchive packages debs > Packages"
```

3. **Configured APT to use local repository:**
Created `/etc/apt/sources.list.d/local-repo.list`:
deb [trusted=yes] file:///var/local-repo/ ./

4. **Updated APT cache:**
```bash
sudo apt update
```

5. **Tested installation from local repository:**
```bash
sudo apt remove tree -y
sudo apt install tree
```
Verified package installed from `file:/var/local-repo`

**Key Learning:**
- Manual package download workflow for air-gapped environments
- Dependency resolution challenges and solutions
- Repository metadata generation using apt-ftparchive
- Local repository configuration and testing

**Skills Demonstrated:**
- Linux system administration
- Air-gapped package management
- Repository creation and maintenance
- Dependency management
- Command-line package tools (dpkg, apt, apt-ftparchive)

---

## Air-Gap Network Verification and Enforcement

### Final Air-Gap Configuration

**Problem Identified:**
- NAT MASQUERADE rule was still active in iptables
- VMs had internet access despite intention to be air-gapped
- Rule showed 3,925 packets and 332KB of traffic had passed through

**Permanent Air-Gap Implementation:**

1. **Removed active NAT rule:**
```bash
iptables-legacy -t nat -D POSTROUTING -s '10.12.59.0/24' -o wlp4s0 -j MASQUERADE
```

2. **Prevented recreation on reboot:**
Commented out NAT rules in `/etc/network/interfaces`:
```bash
#    post-up iptables -t nat -A POSTROUTING -s '10.12.59.0/24' -o wlp4s0 -j MASQUERADE
#    post-down iptables -t nat -D POSTROUTING -s '10.12.59.0/24' -o wlp4s0 -j MASQUERADE
```

3. **Verification Testing:**
- VM 102 (Windows Server): ❌ Cannot ping 8.8.8.8 ✅
- VM 103 (Windows 10): ❌ Cannot ping 8.8.8.8 ✅
- VM 104 (Ubuntu): ❌ Cannot ping 8.8.8.8 ✅
- Internal connectivity: ✅ VMs can communicate with each other
- Domain services: ✅ Working (domain login functional)

**Result:**
All VMs confirmed isolated from internet while maintaining internal network functionality. Air-gap successfully enforced and verified.

---

## PowerShell Scripting and Automation

### Scripts Created

**Location:** `C:\Scripts\` on Windows Server (VM 102)

**1. System-Health-Check.ps1**

**Purpose:** Quick system status overview for daily health checks

**Features:**
- Computer name identification
- Operating system information
- System uptime calculation
- Memory usage (used/total in GB)
- Disk space reporting (C: drive)
- Color-coded output for readability

**Key PowerShell Concepts Demonstrated:**
- `Get-CimInstance` for system information retrieval
- Variables and object properties
- Mathematical calculations and rounding
- DateTime arithmetic for uptime
- Unit conversion (KB to GB)
- Formatted console output with colors

**Sample Output:**
=== System Health Check ===
Computer: WIN-MMKOM79RUSR
OS: Microsoft Windows Server 2025 Datacenter
Uptime: 3 days, 2 hours
Memory: 1.52 GB used / 7.98 GB total
Disk Space:
C: - Used: 21.53 GB, Free: 77.49 GB
Health check complete!

---

**2. Check-Installed-Updates.ps1**

**Purpose:** Verify patch deployment and track installed updates

**Features:**
- Lists last 10 installed Windows updates
- Shows HotFix ID, description, and installation date
- Formatted table output

**Key PowerShell Concepts:**
- `Get-HotFix` cmdlet for update information
- Pipeline operations (`|`)
- Object filtering and selection
- Table formatting

**Use Case:**
Essential for patch validation in air-gapped environments where automated update verification isn't available.

---

### PowerShell Skills Acquired

**Fundamentals:**
- Variables and data types
- Environment variables (`$env:`)
- Object properties and methods
- Mathematical operations
- String interpolation

**System Administration:**
- WMI/CIM queries for system information
- DateTime calculations
- Unit conversions
- Data formatting and presentation

**Script Development:**
- PowerShell ISE usage
- Script creation and saving (.ps1 files)
- Code commenting and documentation
- Reusable automation scripts

**Best Practices:**
- Descriptive variable names
- Color-coded output for different data types
- Proper script headers with purpose documentation
- Modular, readable code structure

---

## Backup, Restore, Snapshot, and Rollback Procedures

### Storage Migration for Snapshot Support

**Problem:** Initial VM storage (vm-storage, directory type) did not support snapshot functionality.

**Solution:** Migrated VMs 103 and 104 to local-lvm (LVM-thin) storage which supports snapshots.

**Migration Process:**

1. **Stopped VMs:**
```bash
qm stop 103
qm stop 104
```

2. **Migrated disks to LVM-thin storage:**
```bash
qm move-disk 104 scsi0 local-lvm --format raw --delete 1
qm move-disk 103 scsi0 local-lvm --format raw --delete 1
```

3. **Verified migration:**
```bash
qm config 103 | grep scsi0  # Confirmed: local-lvm:vm-103-disk-0
qm config 104 | grep scsi0  # Confirmed: local-lvm:vm-104-disk-0
```

**Storage Configuration After Migration:**
- **VM 102 (Windows Server):** vm-storage (directory) - 100GB
- **VM 103 (Windows 10):** local-lvm (LVM-thin) - 60GB  
- **VM 104 (Ubuntu):** local-lvm (LVM-thin) - 20GB

---

### Snapshot Procedures (LVM-thin Storage)

**VMs on local-lvm storage support instant snapshots.**

**Creating Snapshots via CLI:**
```bash
# Create snapshot
qm snapshot 104 before-snapshot-test --description "Clean state before snapshot training"

# List snapshots
qm listsnapshot 104

# Rollback to snapshot
qm rollback 104 before-snapshot-test

# Delete snapshot
qm delsnapshot 104 before-snapshot-test
```

**Snapshot Testing Process:**

1. Created baseline snapshot of VM 104 (Ubuntu)
2. Made changes to VM (created test file: `~/test-file.txt`)
3. Rolled back to snapshot
4. Verified changes were reverted (test file disappeared)

**Result:** Snapshots provide instant point-in-time recovery for VMs on LVM-thin storage.

**Use Cases:**
- Pre-patch snapshots for quick rollback
- Before major configuration changes
- Testing new software installations
- Quick recovery during maintenance windows

---

### Backup and Restore Procedures (All Storage Types)

**Proxmox backup (vzdump) works on any storage type and creates portable backup files.**

**Creating Backups via Web Interface:**

1. Navigate to VM → Backup tab
2. Click "Backup now"
3. Configure:
   - **Storage:** local (/var/lib/vz)
   - **Mode:** Snapshot
   - **Compression:** ZSTD
4. Click "Backup"

**Backup created for VM 102 (Windows Server):**
- Storage: local
- Size: ~22GB (compressed from 100GB disk)
- Duration: ~10 minutes
- Location: /var/lib/vz/dump/

**Restoring from Backup:**

1. Stop the VM (required before restore)
2. Navigate to VM → Backup tab
3. Select backup from list
4. Click "Restore"
5. Confirm restore operation
6. Start VM after restore completes

**Restore Testing Process:**

1. Created test file on VM 102 desktop (`test-before-restore.txt`)
2. Stopped VM 102
3. Restored from backup (taken before test file creation)
4. Started VM 102
5. Verified test file was gone - restore successful

**Result:** Backup and restore provides full VM recovery capability.

**Use Cases:**
- Disaster recovery
- VM migration between Proxmox hosts
- Long-term archival
- Major system changes requiring full recovery option

---

### Comparison: Snapshots vs Backups

| Feature | Snapshots (LVM-thin) | Backups (vzdump) |
|---------|---------------------|------------------|
| **Speed** | Instant (seconds) | Slow (minutes) |
| **Storage Required** | Minimal (delta only) | Full VM size |
| **Storage Type** | LVM-thin only | Any storage |
| **Portability** | Not portable | Portable file |
| **Best For** | Quick rollbacks | Disaster recovery |

**Best Practice Workflow:**

1. **Before patches/changes:** Take snapshot (if on LVM-thin)
2. **Weekly/monthly:** Full backup to local storage
3. **Before major upgrades:** Both snapshot AND backup
4. **After successful changes:** Delete old snapshots to free space

---

### Storage Considerations

**LVM-thin Over-provisioning Warning:**

During snapshot operations, received warning about thin pool over-provisioning:
WARNING: Sum of all thin volume sizes (160.00 GiB) exceeds the size of thin pool pve/data
and the amount of free space in volume group (16.00 GiB).

**Explanation:**
- LVM-thin allows over-provisioning (allocate more than physically available)
- Total allocated: 180GB (100GB + 60GB + 20GB)
- Physical available: ~148GB in thin pool
- Actual usage is much less than allocated
- This is normal for thin provisioning but requires monitoring

**Recommendation for Production:**
- Configure thin_pool_autoextend_threshold
- Monitor actual disk usage vs allocated
- Keep ~20% free space buffer for snapshots

---

*This homelab demonstrates practical implementation of enterprise Windows infrastructure in a controlled, learning-focused environment.*