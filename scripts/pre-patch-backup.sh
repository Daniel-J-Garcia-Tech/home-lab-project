#!/bin/bash
#Pre-Patch Backup

#Header
echo "===Pre-Patch Backup==="
echo ""

#Create Backup Folder
today=$(date +%Y-%m-%d)
mkdir -p "/tmp/prepatch/$today"
echo "Date & Time: $(date)" > prepatchbackup-$today.txt

#Copy Files
cp /etc/hostname "/tmp/prepatch/$today/hostname"
if [ -f "/tmp/prepatch/$today/hostname" ]; then
	echo "Hostname Successfully Copied"
	echo "Hostname Successfully Copied" >> prepatchbackup-$today.txt
else
	echo "Hostname Failed to Copy"
	echo "Hostname Failed to Copy" >> prepatchbackup-$today.txt
fi

cp /etc/network/interfaces "/tmp/prepatch/$today/interfaces"
if [ -f "/tmp/prepatch/$today/interfaces" ]; then
	echo "Interfaces Successfully Copied"
	echo "Interfaces Successfully Copied" >> prepatchbackup-$today.txt
else
	echo "Interfaces Failed to Copy"
	echo "Interfaces Failed to Copy" >> prepatchbackup-$today.txt
fi

cp /etc/resolv.conf "/tmp/prepatch/$today/resolv.conf"
if [ -f "/tmp/prepatch/$today/resolv.conf" ]; then
	echo "Resolv Successfully Copied"
	echo "Resolv Successfully Copied" >> prepatchbackup-$today.txt
else
	echo "Resolv Failed to Copy"
	echo "Resolv Failed to Copy" >> prepatchbackup-$today.txt
fi

echo "Files Backed up: $(ls /tmp/prepatch/$today | wc -l)" >> prepatchbackup-$today.txt

#Compress
tar -czf /tmp/prepatch/pre-patch-$today.tar.gz /tmp/prepatch/$today

#End
echo ""
echo "Pre-Patch Backup complete"