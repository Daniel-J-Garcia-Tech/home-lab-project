# Lessons Learned

## Overview
This document captures key challenges, solutions, and insights gained during the homelab project. These experiences demonstrate problem-solving skills and technical growth.

---

## Challenge 1: Proxmox WiFi Configuration at Boot

**Problem:**
- Proxmox WiFi would connect manually but failed to auto-start on boot
- `wpa_supplicant` service starting before network interface was ready
- Missing default route after reboot

**Root Cause:**
- Conflict between systemd service and network interface hooks
- `wpa-conf` line in `/etc/network/interfaces` caused duplicate startup attempts

**Solution:**
- Created systemd service for wpa_supplicant: `/etc/systemd/system/wpa_supplicant@wlp4s0.service`
- Removed `wpa-conf` line from network interfaces file to prevent conflicts
- Added `post-up` command to ensure default route is set

**Lesson Learned:**
- Service startup order matters in Linux
- Understanding the interaction between systemd and traditional init scripts is crucial
- Always test configurations across reboots

---

## Challenge 2: VirtIO Drivers and Windows Installation

**Problem:**
- Windows Server couldn't detect the 100GB virtual disk during installation
- Standard IDE controllers too slow for production-like performance

**Root Cause:**
- Windows doesn't include VirtIO drivers by default
- SCSI controller requires manual driver loading

**Solution:**
- Downloaded VirtIO driver ISO from official source
- Loaded SCSI storage driver during Windows installation (browsing to `vioscsi\amd64\w11`)
- Installed full VirtIO guest tools package post-installation for network and other drivers

**Lesson Learned:**
- Paravirtualized drivers significantly improve VM performance
- Always verify driver availability before choosing virtual hardware
- Understanding the difference between emulated and paravirtualized hardware

---

## Challenge 3: Group Policy Blocking Manual Updates

**Problem:**
- Created GPO to disable Windows Update for air-gapped practice
- GPO blocked even administrators from installing updates manually
- Windows Update service remained disabled even after GPO changes

**Root Cause:**
- GPO applied to entire OU, including admin accounts
- Service startup type persisted after GPO scope change
- Group Policy doesn't automatically reverse previous configurations

**Solution:**
- Implemented GPO security filtering to exclude Domain Admins
- Manually re-enabled Windows Update service: `sc config wuauserv start=demand`
- Used `gpupdate /force` to apply changes immediately

**Lesson Learned:**
- GPO security filtering provides granular control
- Group Policy changes don't automatically undo previous configurations
- Services may need manual intervention after policy changes
- Importance of testing GPOs before wide deployment

---

## Challenge 4: Air-Gapped Patching Workflow

**Problem:**
- Need to update Windows systems without internet access
- WSUS Offline Update tool outdated for Windows 10 21H2 and Server 2025
- Manual update process unfamiliar

**Root Cause:**
- Recent OS versions not supported by older offline update tools
- Microsoft Update Catalog requires manual navigation and understanding of update dependencies

**Solution:**
- Researched update order: Servicing Stack Update (SSU) must install before Cumulative Updates
- Downloaded updates from Microsoft Update Catalog on internet-connected PC
- Created ISO containing updates for VM delivery
- Installed via command line: `wusa.exe filename.msu`

**Lesson Learned:**
- Update installation order is critical (SSU → Cumulative → .NET)
- Air-gapped environments require careful planning and offline media
- Understanding Windows Update architecture and dependencies
- Real-world security environments often require offline patching

---

## Challenge 5: DNS and Network Connectivity

**Problem:**
- Client couldn't ping Domain Controller despite correct IP configuration
- "Destination host unreachable" errors

**Root Cause:**
- Domain Controller VM was powered off
- Classic troubleshooting oversight - assumed running status

**Solution:**
- Verified VM status via Proxmox: `qm status 102`
- Started the VM
- Connectivity immediately restored

**Lesson Learned:**
- Always verify the basics first ("Is it plugged in? Is it turned on?")
- Use monitoring tools to check service/VM status before deep troubleshooting
- Document expected running state of critical infrastructure

---

## Challenge 6: WiFi Driver Limitations with Network Bridging

**Problem:**
- Attempted to bridge WiFi interface (wlp4s0) directly for VM networking
- Error: "Device does not allow enslaving to a bridge"

**Root Cause:**
- Many WiFi drivers don't support bridging due to wireless protocol limitations
- 802.11 standards make traditional bridging complex

**Solution:**
- Implemented NAT-based networking instead
- Created isolated internal network (10.12.59.0/24)
- Used iptables MASQUERADE for internet access (later disabled for air-gap)
- VMs communicate through virtual bridge, NAT translates to WiFi when needed

**Lesson Learned:**
- WiFi and Ethernet have different capabilities in virtualization
- NAT is a valid alternative to bridging
- Understanding network topology options in virtualized environments
- Sometimes the "standard" approach doesn't work - adaptability is key

---

## Key Takeaways

**Technical Skills Gained:**
- Linux system administration (systemd, networking, services)
- Windows Server infrastructure (AD DS, DHCP, DNS, RDS)
- Virtualization best practices (Proxmox, VirtIO, resource allocation)
- Network design (NAT, bridging, air-gapped architectures)
- Security hardening (GPO, offline patching, isolation)

**Soft Skills Developed:**
- Systematic troubleshooting methodology
- Reading and interpreting technical documentation
- Persistence through complex problems
- Learning from failures
- Documenting solutions for future reference

**Professional Growth:**
- Understanding enterprise IT infrastructure
- Appreciation for proper change management
- Recognition of security vs. usability tradeoffs
- Value of testing in non-production environments

---

*This homelab project provided hands-on experience that supplements theoretical knowledge and demonstrates practical problem-solving abilities.*