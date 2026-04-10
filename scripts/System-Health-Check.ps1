# System Health Check Script
# Purpose: Quick system status overview

Write-Host "=== System Health Check ===" -ForegroundColor Cyan
Write-Host ""

# Computer Name
Write-Host "Computer: $env:COMPUTERNAME" -ForegroundColor Green

# OS Information
$OS = Get-CimInstance Win32_OperatingSystem
Write-Host "OS: $($OS.Caption)" -ForegroundColor Green
Write-Host "OS Version: $($OS.Version)" -ForegroundColor Green

# Uptime
$Uptime = (Get-Date) - $OS.LastBootUpTime
Write-Host "Uptime: $($Uptime.Days) days, $($Uptime.Hours) hours" -ForegroundColor Green

# Memory
$TotalRAM = [math]::Round($OS.TotalVisibleMemorySize / 1MB, 2)
$FreeRAM = [math]::Round($OS.FreePhysicalMemory / 1MB, 2)
$UsedRAM = $TotalRAM - $FreeRAM
Write-Host "Memory: $UsedRAM GB used / $TotalRAM GB total" -ForegroundColor Yellow

# Disk Space
Write-Host ""
Write-Host "Disk Space:" -ForegroundColor Cyan
$Drive = Get-PSDrive C
$UsedGB = [math]::Round($Drive.Used / 1GB, 2)
$FreeGB = [math]::Round($Drive.Free / 1GB, 2)
Write-Host "  C: - Used: $UsedGB GB, Free: $FreeGB GB" -ForegroundColor White

Write-Host ""
Write-Host "Health check complete!" -ForegroundColor Green