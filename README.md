# Active Directory Homelab Project

**Note**
I've also added a Cisco Labs folder that includes a 7 step lab process with Cisco Packet Tracer. Each lab build on skills to eventually reach the final Lab 7 Capstone Project. For more detailed explaining please view README in that folder

**Overview**
A fully functional Active Directory deomain environment built for learning enterprise

## Environment Architecture

**Hardware:**
- Host ROG Laptop (Intell i7-7700HQ, 16GB RAM)
- Hypervisor: Proxmox VE 9.1

**Virtual Hardware:**
- Windows Server 2025 (Domain Controller)
- Windows 10 IoT Enterprise LTSC (Domain-joined client)

## Technologies & Skills Demonstrated

### Active Directory
- Domain Controller deployment
- Organizational Units (OUs) structure
- User and Group management
- Group Policy Objects (GPOs)
- FSMO roles management

### Networking
- DHCP Server configuration
- DNS integration
- Air-gapped network design
- NAT configuration (and removal for isolation)
- Network segmentation and routing
- **SSH jump host / bastion host configuration**
- **ProxyJump for multi-hop SSH connections**

### Remote Access
- Remote Desktop Services (RDS)
- Session-based desktop deployment
- Thin client simulation
- SSH server configuration and management
- SSH jump host / ProxyJump usage

### Patch Management & Maintenance
- Air-gapped Windows patching workflow
- Air-gapped Linux package management
- Manual update deployment (Windows .msu, Linux .deb)
- WSUS installation and configuration
- Offline APT repository creation and maintenance
- Update dependency management
- Repository metadata generation (apt-ftparchive)

### Virtualization
- Proxmox VE administration
- VM creation via CLI (qm create)
- Resource pool management
- VirtIO driver configuration
- VM lifecycle management
- **Storage type configuration and migration**
- **LVM-thin vs directory storage**
- **Snapshot management and rollback procedures**
- **Backup and restore operations (vzdump)**
- **Disaster recovery testing**

### Linux System Administration
- Ubuntu Server installation and configuration
- Package management (apt, dpkg)
- Dependency resolution
- System monitoring (htop, logs, processes)
- File system navigation and management
- Service management (systemd)
- SSH server setup and hardening

### Scripting & Automation
- **PowerShell scripting fundamentals**
  - System health monitoring scripts
  - Patch verification automation
  - Variables, objects, and cmdlets
  - WMI/CIM queries for system data
  - Mathematical calculations and formatting
  - Script creation and reusability
- **Python scripting fundamentals**
  - System information retrieval
  - Package management validation
  - subprocess for system commands
  - Text processing and parsing
  - List comprehensions and filtering
  - Cross-platform scripting
- Bash scripting (WiFi startup automation)
- Network service configuration
- systemd service creation

### Security & Maintenance
- **Air-gapped environment configuration and verification**
- **Network isolation enforcement (iptables NAT removal)**
- **SSH key-based authentication (Ed25519)**
- **SSH passphrase-protected keys (two-factor authentication)**
- **Password authentication disabled (security hardening)**
- **SSH configuration files for streamlined access**
- **ProxyJump configuration for network segmentation**
- **Offline antivirus definition updates (Windows Defender)**
- Network file shares with proper permissions
- Share and NTFS permission management
- Group Policy security filtering
- Manual security update deployment
- Access control and permissions
- Firewall configuration

## Key Learning Outcomes
- Enterprise AD domain administration
- Windows Server infrastructure management
- Linux system administration fundamentals
- Network services configuration
- Security best practices in isolated environments
- Troubleshooting and problem-solving
- Air-gapped patch management for both Windows and Linux
- Offline repository creation and maintenance
- **Backup and disaster recovery procedures**
  - VM snapshots on LVM-thin storage
  - Snapshot rollback testing and verification
  - Full VM backup and restore via Proxmox
  - Understanding storage backend capabilities
  - Migration between storage types

## Project Status
- Active deployment - Ongoing learning and expanision

# Scripts

This directory contains automation scripts and configuration files created during the homelab project.

## wpa_supplicant_startup.sh

**Purpose:** Systemd service configuration for auto-starting WiFi on Proxmox host at boot.

**Problem Solved:** WiFi adapter (Intel iwlwifi) failed to initialize properly during boot sequence, causing network unavailability.

**Implementation:** Created custom systemd service to ensure wpa_supplicant starts with correct timing and parameters.

**Skills Demonstrated:**
- Linux systemd service creation
- Network service troubleshooting
- Startup order management
- WiFi authentication configuration

---
*This is a personal learning project for IT skill development.*