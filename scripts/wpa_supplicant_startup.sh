#!/bin/bash
# WiFi Auto-Start and Routing Configuration for Proxmox
# Purpose: Ensures WiFi connectivity and proper routing at boot
# Created: 2025 - Homelab Project
# 
# Problems Solved:
# 1. WiFi interface (wlp4s0) failed to auto-start on boot
#    - Conflict between systemd service and network interface hooks
# 2. Missing default route after reboot
#    - Gateway configured but not applied automatically
#
# Solutions Implemented:
# 1. systemd service file for wpa_supplicant
# 2. post-up command in network configuration to ensure default route

echo "=== WiFi Auto-Start Configuration ==="
echo ""
echo "PART 1: systemd Service File"
echo "Location: /etc/systemd/system/wpa_supplicant@wlp4s0.service"
echo ""

cat << 'EOF'
[Unit]
Description=WPA supplicant for %I
After=network-pre.target
Before=network.target

[Service]
Type=simple
ExecStart=/sbin/wpa_supplicant -c/etc/wpa_supplicant/wpa_supplicant.conf -iwlp4s0 -D nl80211,wext

[Install]
WantedBy=multi-user.target
EOF

echo ""
echo "=== Network Configuration ==="
echo ""
echo "PART 2: Network Interfaces Configuration"
echo "Location: /etc/network/interfaces"
echo "Add to wlp4s0 section:"
echo ""

cat << 'EOF'
auto wlp4s0
iface wlp4s0 inet static
    address 192.168.0.243/24
    gateway 192.168.0.1
    dns-nameservers 192.168.0.1
    post-up ip route add default via 192.168.0.1 dev wlp4s0 || true
EOF

echo ""
echo "Note: The '|| true' prevents failure if route already exists"
echo ""
echo "=== Installation Steps ==="
echo "1. Create systemd service file with content from PART 1"
echo "2. Enable service: systemctl enable wpa_supplicant@wlp4s0.service"
echo "3. Remove 'wpa-conf' line from /etc/network/interfaces (prevents conflicts)"
echo "4. Add 'post-up' line from PART 2 to ensure default route"
echo "5. Reload systemd: systemctl daemon-reload"
echo "6. Reboot and verify: ping 8.8.8.8"