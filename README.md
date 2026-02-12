# Active Directory Homelab Project

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
- Domain COntroller deployment
- Organizational Units (OUs) structure
- User and Group management
- Group Policy Objects (GPOs)
- FSMO roles management

## Networking
- DHCP Server configuration
- DNS integration
- Air-gapped network design
- NAT configuration

### Remote Access
- Remote Desktop Services (RDS)
- Session-based desktop deployment
- Thin client simulation

### Security & Maintenance
- Air-gapped patching workflow
- Manual update deployment
- Group Policy security filtering
- Network isolation

## Key Learning Outcomes
- Enterprise AD domain administration
- Windows Server Infrastructure management
- Network services infrastructure management
- Security best practices in isolated environments
- Troubleshooting and problem-solving

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