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
```
lab.local
├── Corporate
│   ├── IT Department
│   ├── HR Department
│   └── Finance Department
├── Workstations
│   ├── IT Workstations
│   └── User Workstations
└── Domain Controllers (default)
```

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

| Computer Name | Location | Purpose |
|---------------|----------|---------|
| WIN-[DC-NAME] | Domain Controllers | Primary DC, DNS, DHCP, RDS |
| WIN10-Lab | Workstations\User Workstations | Domain-joined client, RDS testing |

## Group Policy Objects (GPOs)

| GPO Name | Linked To | Purpose |
|----------|-----------|---------|
| Wallpaper Policy | User Workstations | Enforces corporate desktop wallpaper |
| Disable Windows Update | User Workstations | Prevents automatic updates (air-gapped environment) |

---
*Structure designed for learning enterprise AD administration*