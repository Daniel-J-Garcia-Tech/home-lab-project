# Cisco Labs
A set of different stages of at home labs using Cisco Packet Tracer to learn managed Cisco hardware. Each lab comes with the packet tracer file, readme detailing the lab, and screenshot of the topology, and verification of system working

**Labs**
- Lab 1 - Basic switch config
- Lab 2 - VLANs
- Lab 3 - Inter-VLAN Routing
- Lab 4 - Access Control Lists
- Lab 5 - Redundancy and High Availability

## Skills Demonstrated
**FOUNDATIONAL SKILLS:**
- Cisco CLI Navigation
	User EXEC, Privileged EXEC, Global Config modes
	Interface configuration mode
	Line configuration mode
	ACL configuration mode
	Moving between modes efficiently

- Device Configuration
	Switch configuration from scratch
	Router configuration from scratch
	Hostname and password management
	Enable secret (encrypted passwords)
	Service password-encryption
	Console and VTY line security
	Timeout configuration
	Logging synchronous

- Configuration Management
	Saving configurations (write memory)
	Viewing running-config
	Viewing startup-config
	Configuration backup concepts

**NETWORKING FUNDAMENTALS:**
- VLANs (Virtual LANs)
	Creating VLANs with descriptive names
	Assigning ports to VLANs
	Access port configuration
	Understanding VLAN segmentation
	VLAN verification and troubleshooting

- Trunk Ports
	Configuring 802.1Q trunking
	Setting allowed VLANs on trunks
	Native VLAN configuration
	Understanding VLAN tagging
	Trunk verification

- IP Addressing
	Subnetting (192.168.x.x, 10.x.x.x, 172.16.x.x)
	Default gateway configuration
	Management IP assignment
	IP scheme design and documentation

- Inter-VLAN Routing
	Router-on-a-stick configuration
	Subinterface creation and management
	802.1Q encapsulation on subinterfaces
	Physical vs logical interfaces
	Gateway configuration per VLAN

**SECURITY:**
- Access Control Lists (ACLs)
	Extended ACL creation (named)
	Wildcard mask calculation and usage
	ACL rule ordering (first match wins)
	Permit and deny statements
	ICMP granular control (echo-reply vs echo-request)
	TCP established connections
	Applying ACLs to interfaces (inbound/outbound)
	ACL verification and match counters
	Implicit deny understanding

- Security Best Practices
	Least privilege access
	Defense-in-depth architecture
	Management VLAN separation
	Disabling unused interfaces (VLAN 1 shutdown)
	Password encryption
	Console and remote access security

**TROUBLESHOOTING:**
- Systematic Problem-Solving
	Testing connectivity with ping
	Using show commands for verification
	Reading and interpreting command output
	Identifying configuration errors
	Root cause analysis

- Common Issues Resolved
	VLAN port assignment errors (Lab 3 Var 3)
	Trunk port not coming up (Packet Tracer cable issue)
	ACL too permissive (Lab 4)
	Missing return traffic rules (ACL echo-reply)
	Router interface shutdown (Lab 4 Var 2)

- Verification Commands
	show vlan brief
	show interfaces trunk
	show ip interface brief
	show access-lists
	show running-config
	show ip interface [interface]

*DESIGN & PLANNING:*
- Network Architecture
	Multi-VLAN network design
	IP addressing scheme planning
	Security zone separation
	Gateway placement
	Trunk link design

- Documentation
	Network diagrams (conceptual)
	IP addressing schemes
	VLAN assignments
	Security policies
	Configuration standards

**SOFT SKILLS:**
- Self-Directed Learning
	Following technical documentation
	Building muscle memory through repetition
	Adapting to variations and new requirements
	Learning from mistakes

- Technical Communication
	Describing network issues clearly
	Explaining troubleshooting steps
	Understanding technical requirements
	Translating policy into configuration

- Problem-Solving Mindset

	Not panicking when things break
	Methodical troubleshooting approach
	Testing assumptions
	Verifying fixes work


**COMMAND PROFICIENCY:**
You can now configure from memory or minimal reference:
	Basic switch hardening
	VLAN creation and assignment
	Trunk port configuration
	Router subinterfaces
	Extended ACLs
	Interface IP addressing