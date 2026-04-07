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

## Challenge 7: WSUS in Air-Gapped Environment

**Problem:**
- Attempted to configure WSUS for air-gapped patch management
- WSUS configuration wizard requires upstream server connectivity
- Product catalog cannot be easily imported offline
- wsusscn2.cab (offline scan file) is not the same as WSUS product catalog

**Root Cause:**
- WSUS is designed with internet connectivity in mind
- Product catalog synced from Microsoft Update during initial configuration
- Air-gapped WSUS requires replica server architecture or export/import from connected WSUS

**Attempted Solutions:**
- Downloaded wsusscn2.cab (offline Windows Update scan file)
- Attempted manual import via wsusutil.exe
- Configured WSUS to disable automatic synchronization

**Actual Solution:**
- Recognized that air-gapped WSUS requires either:
  - Upstream/downstream server architecture
  - Initial sync with internet before air-gapping
  - Manual update import with proper WSUS export packages

**Lesson Learned:**
- Not all enterprise tools translate directly to air-gapped environments
- Manual patching processes (already practiced) are often more practical for air-gapped systems
- Understanding tool limitations is as important as knowing how to use them
- Real-world air-gapped environments may use alternative patch management strategies
- WSUS knowledge still valuable for understanding centralized patch management concepts

**Interview Value:**
- Demonstrates understanding of both centralized and manual patching
- Shows problem-solving when tools don't fit the environment
- Recognizes when to use alternative approaches
- Understands enterprise patch management architecture

---

## Challenge 8: Linux Package Dependencies in Air-Gapped Environment

**Problem:**
- Attempted to install packages (.deb files) downloaded individually
- Installation failed due to missing dependencies
- Each package required multiple other packages not initially downloaded
- Error messages: "dependency problems prevent configuration"

**Root Cause:**
- .deb packages have complex dependency trees
- Downloading a single package doesn't include its dependencies
- APT normally handles this automatically by downloading from repositories
- In air-gapped environments, all dependencies must be manually acquired

**Solution:**
- Installed packages using `sudo dpkg -i *.deb`
- Used `sudo apt --fix-broken install` to identify missing dependencies
- APT downloaded dependencies from available online repositories (archive.ubuntu.com)
- Some packages failed due to security.ubuntu.com repository DNS issues
- Successfully installed: htop, dnsutils, traceroute, tree, ncdu, tcpdump, apt-mirror

**Lesson Learned:**
- Dependencies are critical in Linux package management
- Air-gapped environments require downloading entire dependency trees
- Tools exist for this (apt-rdepends, apt-offline) but weren't available
- `apt --fix-broken install` can resolve dependencies if partial internet access exists
- True air-gap requires pre-downloading all dependencies or maintaining full repository mirrors
- Understanding dependency resolution is essential for offline patch management

---

## Challenge 9: Creating Offline APT Repository

**Problem:**
- Needed to demonstrate offline Linux package management capability
- Full Ubuntu repository mirror (via apt-mirror) would require 50-100+ GB download
- Limited time and disk space for comprehensive mirror
- DNS resolution issues preventing some repository access

**Root Cause:**
- Full repository mirrors are designed for complete offline installations
- Lab environment doesn't need entire Ubuntu package ecosystem
- Goal was to demonstrate understanding, not create production infrastructure

**Solution:**
- Created small, custom local APT repository from manually downloaded packages
- Used `/var/local-repo/` following Linux FHS (Filesystem Hierarchy Standard)
- Generated repository metadata with `apt-ftparchive packages`
- Configured APT to use local file:// URI
- Tested by removing and reinstalling package from local repo

**Implementation:**
```bash
# Created repo structure
sudo mkdir -p /var/local-repo/debs

# Copied packages
sudo cp ~/packages/*.deb /var/local-repo/debs/

# Generated index
sudo bash -c "apt-ftparchive packages debs > Packages"

# Configured APT source
echo 'deb [trusted=yes] file:///var/local-repo/ ./' | sudo tee /etc/apt/sources.list.d/local-repo.list

# Tested
sudo apt update
sudo apt install tree
```

**Lesson Learned:**
- Small, focused repositories are practical for air-gapped demos
- Understanding repository structure more important than size
- `apt-ftparchive` creates APT-compatible metadata from .deb files
- Local file:// repositories work identically to HTTP repositories
- [trusted=yes] bypasses GPG signature verification for local repos
- This approach scales: same process works for 10 packages or 10,000
- Interview demonstration doesn't require production-scale infrastructure

---

## Challenge 10: SSH Access Between Network Segments

**Problem:**
- Main PC (192.168.0.x network) couldn't directly SSH to Ubuntu VM (10.12.59.x network)
- Connection timeout errors despite SSH service running
- Different subnets with no direct routing

**Root Cause:**
- Network topology: Main PC and VMs on different networks
- Main PC → Home WiFi (192.168.0.x)
- Proxmox → WiFi + Internal bridge (vmbr0)
- VMs → Internal network only (10.12.59.x)
- No route exists between 192.168.0.x and 10.12.59.x

**Solution:**
- Used SSH jump/proxy through Proxmox host
- Two-hop connection: Main PC → Proxmox → Ubuntu VM
- Manual method: SSH to Proxmox, then SSH to VM
- Alternative: `ssh -J root@192.168.0.243 labadmin@10.12.59.50` (ProxyJump)

**Lesson Learned:**
- Network segmentation requires understanding routing paths
- SSH jump hosts are common in enterprise environments
- ProxyJump (-J flag) simplifies multi-hop connections
- Air-gapped doesn't mean "no network" - means isolated network
- Internal networks still need proper addressing and routing
- Copy/paste capability via SSH significantly improves troubleshooting efficiency

---

## Challenge 11: Air-Gap Enforcement and Verification

**Problem:**
- Believed VMs were air-gapped after initial NAT rule removal
- Discovered NAT MASQUERADE rule was still active in iptables
- Rule showed 3,925 packets and 332KB transferred - VMs had been accessing internet
- Previous air-gap attempts were incomplete

**Root Cause:**
- NAT rule existed in two places: active iptables rules AND network configuration file
- Removing from one location wasn't sufficient
- Network configuration file (`/etc/network/interfaces`) recreated the rule on reboot
- Multiple layers of network configuration required comprehensive approach

**Solution:**
1. Removed active NAT rule from iptables:
```bash
iptables-legacy -t nat -D POSTROUTING -s '10.12.59.0/24' -o wlp4s0 -j MASQUERADE
```

2. Commented out (preserved for future re-enable if needed) NAT rules in `/etc/network/interfaces`:
```bash
#    post-up iptables -t nat -A POSTROUTING -s '10.12.59.0/24' -o wlp4s0 -j MASQUERADE
#    post-down iptables -t nat -D POSTROUTING -s '10.12.59.0/24' -o wlp4s0 -j MASQUERADE
```

3. Verified air-gap on all three VMs:
- Tested internet connectivity (ping 8.8.8.8) - all failed ✅
- Tested internal connectivity - working ✅
- Verified domain services - functional ✅

**Lesson Learned:**
- Air-gapping requires verification at multiple levels
- Network isolation isn't "set it and forget it" - requires testing
- Configuration persistence (surviving reboots) is separate from active state
- Documentation of network changes prevents confusion later
- Commenting out rules (rather than deleting) preserves configuration for future needs
- Thorough testing of all VMs ensures complete isolation
- Understanding the difference between runtime state and persistent configuration is critical

---

## Challenge 12: Storage Types and Snapshot Capability

**Problem:**
- Attempted to create snapshots on VMs stored on directory-based storage (vm-storage)
- Received "feature not available" error despite VMs using qcow2 disk format
- qcow2 format supports snapshots in general, but Proxmox implementation depends on storage type

**Root Cause:**
- Proxmox's snapshot feature availability depends on storage backend, not just disk format
- Directory storage (even with qcow2) does not enable snapshot features in Proxmox
- LVM-thin, ZFS, and Ceph storage types support snapshots natively
- Initial VM deployment on vm-storage (directory type) limited snapshot capability

**Solution:**
1. Identified storage types and their capabilities:
   - `local-lvm`: LVM-thin pool - supports snapshots ✅
   - `vm-storage`: Directory storage - no snapshot support ❌

2. Migrated VMs 103 and 104 to local-lvm for snapshot support:
```bash
qm move-disk 103 scsi0 local-lvm --format raw --delete 1
qm move-disk 104 scsi0 local-lvm --format raw --delete 1
```

3. Kept VM 102 on vm-storage, used backup/restore instead

4. Verified snapshot functionality on migrated VMs

**Lesson Learned:**
- Storage backend determines feature availability in virtualization platforms
- Different storage types have different capabilities and use cases
- LVM-thin provides snapshots but has over-provisioning considerations
- Directory storage is simple but lacks advanced features
- Migration between storage types is straightforward but requires VM downtime
- Both snapshots and backups have valid use cases - not either/or
- Understanding storage architecture is critical for production environments

**Skills Demonstrated:**
- Storage type comparison and selection
- VM disk migration between storage backends
- Snapshot creation and rollback testing
- Backup and restore procedures
- Understanding virtualization storage layers

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