#!/bin/bash
#Patch Deployment Package

#Header
echo "===Patch Deployment Packge==="
echo ""

#File Checker
if ls /tmp/patches/*.deb > /dev/null 2>&1; then
	echo "Found .deb files"
else
	echo "No .deb files found, exiting."
	exit 1
fi

#Directory
today=$(date +%Y-%m-%d)
mkdir -p "/tmp/deployment/$today"

#Copying/Counting packages
cp /tmp/patches/*.deb "/tmp/deployment/$today"
echo "Package Count: $(ls /tmp/deployment/$today/*.deb | wc -l)"

#Compress
tar -czf /tmp/deployment/patch-package-$today.tar.gz /tmp/deployment/$today/

#End
echo ""
echo "Patch Package Transfered"