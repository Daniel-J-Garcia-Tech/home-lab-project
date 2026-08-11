# Active Directory Homelab Project

> **Note:** This repository also includes a Cisco Labs folder with a 7-step lab progression using Cisco Packet Tracer, culminating in a capstone project. See the Cisco Labs README for details.

## Overview

A comprehensive enterprise IT infrastructure homelab built from scratch to demonstrate system administration, security hardening, and patch management skills in air-gapped environments. This project showcases hands-on experience with Windows Server, Linux administration, virtualization, scripting, and modern security best practices.

Built to meet the technical requirements for Air-Gapped Systems Administrator positions, with emphasis on offline patch management, backup/recovery procedures, and enterprise security configuration.

## Environment Architecture

**Hardware:**
- Host ROG Laptop (Intel i7-7700HQ, 16GB RAM)
- Hypervisor: Proxmox VE 9.1

**Virtual Machines:**
- Windows Server 2025 Datacenter (Domain Controller) - 8GB RAM, 100GB storage
- Windows 10 IoT Enterprise LTSC (Domain-joined client) - 4GB RAM, 60GB storage
- Ubuntu Server 24.04 LTS (Linux infrastructure) - 2GB RAM, 20GB storage

## Technologies & Skills Demonstrated

### Active Directory
- Domain Controller deployment
- Organizational Units (OUs) structure
- User and Group management
- **Group Policy Objects (GPOs):**
  - Desktop customization (wallpaper deployment)
  - Windows Update configuration
  - Network drive mapping automation
  - **Enterprise security policies (password, lockout, audit)**
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
- Remote monitoring and management (RMM) agent-based remote administration

### Patch Management & Maintenance
- Air-gapped Windows patching workflow
- Air-gapped Linux package management
- Manual update deployment (Windows .msu, Linux .deb)
- - WSUS installation and evaluation of air-gapped limitations (upstream/downstream replica architecture)
- Offline APT repository creation and maintenance
- Update dependency management
- - Offline .deb package management and dependency resolution; local APT mirror setup (apt-mirror)

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
- **PowerShell scripting**
  - System health monitoring and reporting
  - Patch verification and validation
  - Service monitoring and auto-recovery
  - Multi-server remote queries and reporting
  - Automated report generation with date-stamping
  - Try-catch exception handling
  - Variables, objects, and cmdlets
  - WMI/CIM queries for system data
  - Remote server administration
- **Python scripting**
  - System information gathering and inventory
  - Package management and validation
  - Pre-patch safety checks (disk space validation)
  - Package snapshot comparison (before/after validation)
  - Set operations for data analysis
  - subprocess for system commands
  - File I/O and error handling
  - List comprehensions and filtering
  - Cross-platform scripting concepts
- **Bash scripting**
  - Pre-patch configuration backup automation
  - Package deployment preparation
  - System snapshots and baselines
  - Critical package verification
  - WiFi startup automation
  - TAR compression and archival
  - File validation and verification
  - Network service configuration
  - systemd service creation

**All automation scripts with detailed documentation are available in [/scripts](/scripts).**

### Security & Maintenance
- **Air-gapped environment configuration and verification**
- **Network isolation enforcement (iptables NAT removal)**
- **SSH key-based authentication (Ed25519)**
- **SSH passphrase-protected keys (two-factor authentication)**
- **Password authentication disabled (security hardening)**
- **SSH configuration files for streamlined access**
- **ProxyJump configuration for network segmentation**
- **Offline antivirus definition updates (Windows Defender)**
- **Enterprise password policies (length, complexity, history, expiration)**
- **Account lockout policies (brute-force prevention)**
- **Comprehensive audit policies (security event logging)**
- **Modern security best practices (NIST guidelines, passphrase support)**
- Network file shares with proper permissions
- Share and NTFS permission management
- Group Policy security filtering
- Manual security update deployment
- Access control and permissions
- Firewall configuration

### Remote Monitoring & Management (RMM)
- **Self-hosted Tactical RMM server deployment** (Django/Vue/Go stack on Ubuntu Server)
- **Scoped on-demand internet access** (single-host NAT toggle preserving air-gap)
- **Windows agent deployment** (workstation and domain controller endpoints)
- **Endpoint monitoring** (disk space and service checks with alert thresholds)
- **Alert validation** (verified monitoring by inducing failures)
- **Patch-compliance scanning** (documented air-gap scanning limitations)
- **Centralized script execution** (single-agent and bulk fleet-wide PowerShell)
- **Internal DNS zone configuration** for service name resolution
- Detailed writeup available in [RMM-Deployment.md](/RMM-Deployment.md)

## Key Learning Outcomes

**Infrastructure & Administration:**
- Enterprise Active Directory domain deployment and management
- Windows Server 2025 infrastructure configuration
- Linux system administration (Ubuntu Server 24.04)
- Proxmox virtualization platform administration

**Security & Hardening:**
- Air-gapped environment design and enforcement
- SSH key-based authentication with two-factor (key + passphrase)
- Enterprise security policies (password, lockout, audit)
- Modern security best practices (NIST guidelines)

**Patch Management:**
- Offline Windows update deployment (air-gapped workflow)
- Offline Linux package management (manual .deb installation)
- Offline repository creation (APT repository for Ubuntu)
- Antivirus definition updates in isolated environments

**Backup & Recovery:**
- VM snapshot procedures (LVM-thin storage)
- Snapshot rollback testing and verification
- Full VM backup and restore operations
- Storage migration and disaster recovery

**Scripting & Automation:**
- PowerShell scripting (system monitoring, patch verification, service recovery, multi-server reporting)
- Python scripting (system information, package validation, pre-patch safety checks)
- Bash scripting (network automation, backup automation, package deployment)
- Cross-platform automation skills

**Monitoring & Management:**
- Self-hosted RMM deployment and fleet monitoring in an air-gapped environment
- Endpoint agent management, alerting configuration, and centralized script execution
- Understanding of air-gapped constraints on RMM patch scanning

## Project Status
- Active deployment - Ongoing learning and expansion

---

*This is a personal learning project for IT skill development.*