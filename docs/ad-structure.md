# Active Directory Structure

## Domain Information
- **Domain Name:** lab.local
- **Forest Functional Level:** Windows Server 2025
- **Domain Functional Level:** Windows Server 2025

## FSMO Roles
All five FSMO roles are held by the single Domain Controller:

**Forest-level roles:**
- Schema Master
- Domain Naming Master

**Domain-level roles:**
- RID Master
- PDC Emulator
- Infrastructure Master

## Organizational Unit (OU) Structure
[DOMAIN].local
├── Corporate
│   ├── IT Department
│   ├── HR Department
│   └── Finance Department
├── Workstations
│   ├── IT Workstations
│   └── User Workstations
└── Domain Controllers (default)

## User Accounts

| Username | Full Name | Department | Member Of |
|----------|-----------|------------|-----------|
| jsmith | John Smith | IT Department | Domain Users, IT Admins |
| sjohnson | Sarah Johnson | HR Department | Domain Users |
| mdavis | Mike Davis | Finance Department | Domain Users |

## Security Groups

| Group Name | Type | Scope | Purpose |
|------------|------|-------|---------|
| IT Admins | Security | Global | Administrative access for IT staff |
| Domain Admins | Security | Global | Built-in domain administrators |
| Domain Users | Security | Global | All domain user accounts |

## Computer Accounts

| Computer Name | OS | Location | Purpose |
|---------------|-----|----------|---------|
| WIN-[DC-NAME] | Windows Server 2025 | Domain Controllers | Primary DC, DNS, DHCP, RDS, File Server |
| WIN10-Lab | Windows 10 IoT LTSC | Workstations\User Workstations | Domain-joined client, RDS testing |
| ubuntu-lab | Ubuntu Server 24.04 | N/A (Linux) | Linux infrastructure, offline repository |

## Network Services

**DHCP Scope:**
- Range: 10.x.x.50 - 10.x.x.200
- Gateway: 10.x.x.1
- DNS: 10.x.x.10 (Domain Controller)

**File Shares:**
- SharedFiles (\\DC\SharedFiles)
  - Mapped as Z: drive via Group Policy
  - NTFS Permissions: Domain Users (Modify), Domain Admins (Full Control)

## Group Policy Objects (GPOs)

| GPO Name | Linked To | Purpose | Notes |
|----------|-----------|---------|-------|
| Wallpaper Policy | User Workstations | Enforces corporate desktop wallpaper | - |
| Disable Windows Update | User Workstations | Prevents automatic updates (air-gapped) | Security Filtering: Excludes Domain Admins |
| Map Shared Drive | Domain Root | Auto-maps Z: drive to \\DC\SharedFiles | Applied to all domain users |
| Security Policies | Domain Root | Password, lockout, and audit policies | Enterprise security configuration |

**Security Policies GPO Details:**
- Password: 12 char minimum, complexity required, 365 day max age, passphrase support
- Lockout: 4 failed attempts, 30 minute duration
- Audit: Comprehensive logging (logon, account management, policy changes, system events)

---

*Structure designed for learning enterprise AD administration in air-gapped environments*