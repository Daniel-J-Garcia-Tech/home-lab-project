# Lab 1.1: Basic Switch Configuration

## Objective
Learn fundamental Cisco switch configuration including security hardening, management access, and golden config creation.

##LAB 1.1
Requirements:

Hostname: SW-ACCESS-01
Enable secret: SecurePass2025!
Console password: Console456
VTY password: Remote789
Management IP: 10.50.100.5
Subnet mask: 255.255.255.0
Default gateway: 10.50.100.1
Timeout: 10 minutes, 0 seconds

## Topology
- 1x Cisco 2960 Switch
- 2x PCs

## Skills Practiced
- CLI navigation (User EXEC, Privileged EXEC, Global Config modes)
- Hostname configuration
- Password security (enable secret, console, VTY)
- Management IP configuration
- Configuration backup

## Key Commands
```
hostname SW1
enable secret [password]
line console 0
line vty 0 15
interface vlan 1
ip address 10.50.100.5 255.255.255.0
ip default-gateway 10.50.100.1
write memory
```

## Lessons Learned
- `enable secret` uses MD5 encryption vs plaintext
- VTY lines allow remote SSH access
- Must use `no shutdown` on VLAN interfaces
- Packet Tracer has display quirks with timeouts

## Start-up Config
SW-Access-01#show startup-config
Using 1307 bytes
!
version 15.0
no service timestamps log datetime msec
no service timestamps debug datetime msec
service password-encryption
!
hostname SW-Access-01
!
enable secret 5 $1$mERr$963uGhnfy8xSxL6Rw2O4W/
!
!
!
!
!
!
spanning-tree mode pvst
spanning-tree extend system-id
!
interface FastEthernet0/1
!
interface FastEthernet0/2
!
interface FastEthernet0/3
!
interface FastEthernet0/4
!
interface FastEthernet0/5
!
interface FastEthernet0/6
!
interface FastEthernet0/7
!
interface FastEthernet0/8
!
interface FastEthernet0/9
!
interface FastEthernet0/10
!
interface FastEthernet0/11
!
interface FastEthernet0/12
!
interface FastEthernet0/13
!
interface FastEthernet0/14
!
interface FastEthernet0/15
!
interface FastEthernet0/16
!
interface FastEthernet0/17
!
interface FastEthernet0/18
!
interface FastEthernet0/19
!
interface FastEthernet0/20
!
interface FastEthernet0/21
!
interface FastEthernet0/22
!
interface FastEthernet0/23
!
interface FastEthernet0/24
!
interface GigabitEthernet0/1
!
interface GigabitEthernet0/2
!
interface Vlan1
 ip address 10.50.100.5 255.255.255.0
!
ip default-gateway 10.50.100.1
!
!
!
!
line con 0
 password 7 080243401A160912465E5A
 exec-timeout 10 0
 logging synchronous
 login
!
line vty 0 4
 password 7 08134943060D00404A52
 exec-timeout 10 0
 login
line vty 5 15
 password 7 08134943060D00404A52
 exec-timeout 10 0
 login
!
!
!
!
end