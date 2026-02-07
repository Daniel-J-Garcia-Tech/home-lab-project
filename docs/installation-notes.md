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

*This homelab demonstrates practical implementation of enterprise Windows infrastructure in a controlled, learning-focused environment.*