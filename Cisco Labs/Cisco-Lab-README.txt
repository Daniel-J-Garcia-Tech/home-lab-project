# Cisco Network Engineering Labs
A comprehensive series of hands-on labs using Cisco Packet Tracer to build enterprise-grade networking skills. Each lab includes the Packet Tracer file, detailed README, topology screenshots, and verification testing.

## Lab Overview

**23 Total Labs Completed:**
- Lab 1 - Basic Switch Configuration (2 variations)
- Lab 2 - VLANs (2 variations)
- Lab 3 - Inter-VLAN Routing (2 variations)
- Lab 4 - Access Control Lists (2 variations)
- Lab 5 - Redundancy and High Availability with HSRP (2 variations)
- Lab 6 - Port Security (3 variations - shutdown, restrict, protect modes)
- Lab 7 - **CAPSTONE PROJECT** - Air-Gapped Government Network

**Project Stats:**
- **Total Devices Configured:** 50+ (switches, routers, PCs)
- **Total Configuration Lines:** 1000+ lines of Cisco IOS commands
- **Capstone Complexity:** 5 switches, 2 routers, 14 endpoints, 6 VLANs, 6 ACLs
- **Skills Demonstrated:** 40+ technical competencies

## Skills Demonstrated

### FOUNDATIONAL SKILLS

**Cisco CLI Navigation**
- User EXEC, Privileged EXEC, Global Config modes
- Interface configuration mode (physical and subinterface)
- Line configuration mode, ACL configuration mode
- Efficient mode navigation

**Device Configuration**
- Switch and router configuration from scratch
- Multiple device coordination (up to 7 devices)
- Hostname and password management
- Enable secret, service password-encryption
- Console and VTY line security
- Timeout and logging configuration

**Configuration Management**
- Saving configurations (write memory)
- Viewing running-config and startup-config
- Configuration backup and golden configs

### NETWORKING FUNDAMENTALS

**VLANs (Virtual LANs)**
- Creating and naming VLANs
- Access port configuration and assignment
- VLAN segmentation for security zones
- Multiple VLAN numbering schemes

**Trunk Ports**
- 802.1Q trunk configuration
- Allowed VLAN lists and native VLAN settings
- Multiple trunk links on switches
- Trunk verification and troubleshooting

**IP Addressing**
- Subnetting (192.168.x.x, 10.x.x.x, 172.16.x.x, 172.20.x.x)
- Default gateway configuration
- Management IP assignment
- IP scheme design and documentation
- Virtual IP addressing (HSRP)

**Inter-VLAN Routing**
- Router-on-a-stick configuration
- Subinterface creation and management
- 802.1Q encapsulation on subinterfaces
- Gateway configuration per VLAN
- Dual router coordination

### SECURITY

**Access Control Lists (ACLs)**
- Extended named ACL creation
- Wildcard mask calculation and usage
- ACL rule ordering (first match wins)
- Permit/deny statements for granular control
- ICMP granular control (echo-reply vs echo-request)
- TCP established connections
- **ACL direction (inbound vs outbound) - CRITICAL**
- ACL verification and match counters
- Implicit deny understanding

**Port Security**
- Sticky MAC address learning
- Port security violation modes (shutdown, restrict, protect)
- Maximum MAC address configuration
- Violation testing and recovery
- err-disabled state troubleshooting
- Security policy enforcement at Layer 2

**Security Best Practices**
- Defense-in-depth architecture
- Network segmentation by security zones
- Least privilege access
- Management VLAN separation
- Disabling unused interfaces
- Password encryption
- Console and remote access security

**Spanning Tree Protocol (STP)**
- Root bridge election and priority configuration
- PortFast for end devices (immediate forwarding)
- BPDU Guard (prevents rogue switches)
- Loop prevention in redundant topologies
- STP verification and troubleshooting

### HIGH AVAILABILITY & REDUNDANCY

**HSRP (Hot Standby Router Protocol)**
- Dual router topology design
- HSRP group configuration
- Virtual IP address configuration
- Priority configuration (Active router selection)
- Preemption for automatic recovery
- Active/Standby router roles
- HSRP verification commands

**Failover Testing**
- Simulating router failures
- Measuring failover time (~2-3 seconds)
- Testing automatic recovery
- Verifying preemption behavior
- Understanding HSRP state transitions

**Redundancy Design**
- Eliminating single points of failure
- Dual trunk link configuration
- Multiple router gateway design
- Redundant distribution layer
- High availability architecture

### TROUBLESHOOTING

**Systematic Problem-Solving**
- Testing connectivity with ping/traceroute
- Using show commands for verification
- Reading and interpreting command output
- Root cause analysis
- Physical and logical layer troubleshooting

**Common Issues Resolved**
- VLAN port assignment errors
- Trunk port configuration issues
- ACL direction errors (inbound vs outbound)
- Port security violations and recovery
- Router interface shutdown
- Native VLAN mismatches
- STP blocking unexpected ports
- HSRP neighbor discovery issues
- ACL naming convention inconsistencies

### DESIGN & PLANNING

**Network Architecture**
- Hierarchical design (access, distribution, core layers)
- Multi-VLAN network design
- IP addressing scheme planning
- Security zone separation
- Redundant path design
- High availability topology

**Documentation**
- Network topology diagrams
- IP addressing tables
- VLAN assignment documentation
- Security policies and ACL matrices
- Configuration standards
- Test procedures and results
- Troubleshooting notes

### CAPSTONE PROJECT HIGHLIGHTS

**Air-Gapped Government Network:**
- 5 switches (3 access, 2 distribution)
- 2 routers (HSRP configuration)
- 14 endpoints across 6 security zones
- 6 VLANs with different security requirements
- 6 Access Control Lists enforcing security policies
- Port security on all 14 access ports
- Spanning Tree Protocol (root bridge configuration)
- 100% security policy test success rate

**Security Zones Implemented:**
- VLAN 10: Thin Clients (can access servers, not databases)
- VLAN 20: Servers (can access databases, not thin clients)
- VLAN 30: Classified (completely isolated except management)
- VLAN 40: Database (can only respond, not initiate)
- VLAN 50: Guest Network (completely isolated from internal)
- VLAN 99: Management (full access to all zones)

**Key Technical Achievements:**
- ACL direction mastery (inbound filtering from VLANs)
- Defense-in-depth security implementation
- STP root bridge configuration
- Port security with multiple violation modes
- Complex multi-device coordination
- Production-ready documentation

### SOFT SKILLS

**Self-Directed Learning**
- Following technical documentation
- Building muscle memory through 23 labs
- Adapting to variations and new requirements
- Learning from mistakes and troubleshooting

**Technical Communication**
- Describing network issues clearly
- Explaining troubleshooting steps
- Documenting configurations
- Creating professional technical documentation

**Problem-Solving Mindset**
- Methodical troubleshooting approach
- Not panicking when configurations fail
- Testing assumptions systematically
- Verifying fixes work before moving on
- Patience with complex multi-device configurations

**Attention to Detail**
- Consistent naming conventions
- IP addressing accuracy
- ACL rule ordering
- Configuration verification

### PACKET TRACER LIMITATIONS DOCUMENTED

**Known Issues Encountered:**
- HSRP across complex multi-switch topologies (multicast forwarding)
- Native VLAN handling on router subinterfaces
- EtherChannel/Link Aggregation on some switch models
- ACL match counter inconsistencies

**Workarounds Developed:**
- Single router operation for complex testing
- Systematic verification of trunk configurations
- Individual trunk links instead of bundled EtherChannels
- Ping-based ACL verification when counters fail

## Project Structure

Each lab folder contains:
- `*.pkt` - Cisco Packet Tracer file
- `README.md` - Lab documentation with objectives, configurations, and test results
- `topology.png` - Network diagram screenshot
- `verification-*.png` - Screenshots showing successful testing

## Key Takeaways

**Total Experience:**
- 23 labs completed (19 foundational + 1 advanced capstone)
- 1000+ lines of Cisco IOS configuration
- 50+ devices configured
- 40+ technical competencies demonstrated
- Production-grade documentation created
- Real-world security policies implemented
- Complex troubleshooting scenarios resolved

---

**Technologies:** Cisco IOS, VLANs, 802.1Q Trunking, Inter-VLAN Routing, ACLs, HSRP, Port Security, STP, Packet Tracer

**Skills Level:** Entry to Intermediate Network Engineering