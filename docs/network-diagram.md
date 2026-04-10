# Network Architecture Diagram

```mermaid
graph TB
    subgraph "Physical Hardware"
        Laptop[ROG Laptop<br/>Intel i7-7700HQ, 16GB RAM<br/>256GB SSD + 1TB HDD]
    end
    
    subgraph "Proxmox VE 9.1"
        PVE[Proxmox Host<br/>WiFi: 192.x.x.243<br/>Bridge: 10.x.x.1]
        Bridge[vmbr0 Bridge<br/>Internal Network: 10.x.x.0/24]
        
        subgraph "Air-Gapped VM Network"
            DC[Windows Server 2025<br/>VM ID: 102<br/>IP: 10.x.x.10 (Static)<br/>RAM: 8GB, Disk: 100GB<br/>Roles: AD DS, DNS, DHCP,<br/>RDS, WSUS, File Server]
            
            Client[Windows 10 IoT LTSC<br/>VM ID: 103<br/>IP: 10.x.x.50-200 (DHCP)<br/>RAM: 4GB, Disk: 60GB<br/>Domain-Joined Client]
            
            Linux[Ubuntu Server 24.04<br/>VM ID: 104<br/>IP: 10.x.x.50-200 (DHCP)<br/>RAM: 2GB, Disk: 20GB<br/>SSH Server, APT Repo]
        end
    end
    
    subgraph "External"
        Router[Home WiFi Router<br/>192.x.x.0/24]
        Internet((Internet))
    end
    
    Laptop --> PVE
    PVE -->|WiFi Connection<br/>NAT DISABLED| Router
    Router --> Internet
    PVE --> Bridge
    Bridge -.->|Air-Gapped<br/>No Internet| DC
    Bridge -.->|Air-Gapped<br/>No Internet| Client
    Bridge -.->|Air-Gapped<br/>No Internet| Linux
    DC <-->|AD Authentication<br/>DNS, DHCP| Client
    DC <-->|DNS, DHCP| Linux
    Client -.->|RDP Session| DC
    Linux -.->|SSH (Port 22)| DC
    
    style DC fill:#e1f5ff
    style Client fill:#ffe1e1
    style Linux fill:#d4f5d4
    style Bridge fill:#f0f0f0
    style PVE fill:#d4edda
    style Internet fill:#ffcccc,stroke:#ff0000,stroke-width:3px
```

## Network Details

**Proxmox Host:**
- Management: WiFi (192.x.x.243)
- VM Bridge: vmbr0 (10.x.x.1)
- NAT: Disabled (air-gapped)

**Domain Controller (VM 102):**
- Static IP: 10.x.x.10
- Services: AD DS, DNS, DHCP, RDS, WSUS, File Server
- DHCP Scope: 10.x.x.50 - 10.x.x.200

**Windows Client (VM 103):**
- DHCP assigned IP
- Domain-joined to [DOMAIN].local
- RDS thin client

**Linux Server (VM 104):**
- DHCP assigned IP
- SSH server (key-based auth only)
- Offline APT repository
- Domain services: DNS resolution via DC

**Security:**
- All VMs isolated from internet (verified)
- Internal communication only
- SSH requires key authentication (password auth disabled)
- Air-gap enforced via disabled NAT

---

*Network designed for learning air-gapped enterprise infrastructure*