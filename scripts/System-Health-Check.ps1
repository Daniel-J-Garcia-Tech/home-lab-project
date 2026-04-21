# System Health Check Script
# Purpose: Quick system status overview

Write-Host "=== System Health Check ===" -ForegroundColor Cyan
Write-Host ""

#Time Var
$Today = Get-Date -Format "yyyy-MM-dd"

# Computer Name
try {
    Write-Host "Computer: $env:COMPUTERNAME" -ForegroundColor Green
    "Computer: $env:COMPUTERNAME" | Out-File C:\healthcheckreport-$Today.txt

# OS Information
    $OS = Get-CimInstance Win32_OperatingSystem -ErrorAction Stop
    Write-Host "OS: $($OS.Caption)" -ForegroundColor Green
    "OS: $($OS.Caption)" | Out-File C:\healthcheckreport-$Today.txt -Append
    Write-Host "OS Version: $($OS.Version)" -ForegroundColor Green
    "OS Version: $($OS.Version)" | Out-File C:\healthcheckreport-$Today.txt -Append

# Uptime
    $Uptime = (Get-Date) - $OS.LastBootUpTime
    Write-Host "Uptime: $($Uptime.Days) days, $($Uptime.Hours) hours" -ForegroundColor Green
    "Uptime: $($Uptime.Days) days, $($Uptime.Hours) hours" | Out-File C:\healthcheckreport-$Today.txt -Append

# Memory
    $TotalRAM = [math]::Round($OS.TotalVisibleMemorySize / 1MB, 2)
    $FreeRAM = [math]::Round($OS.FreePhysicalMemory / 1MB, 2)
    $UsedRAM = $TotalRAM - $FreeRAM
    Write-Host "Memory: $UsedRAM GB used / $TotalRAM GB total" -ForegroundColor Yellow
    "Memory: $UsedRAM GB used / $TotalRAM GB total" | Out-File C:\healthcheckreport-$Today.txt -Append

# Disk Space
    Write-Host ""
    Write-Host "Disk Space:" -ForegroundColor Cyan
    "Disk Space:" | Out-File C:\healthcheckreport-$Today.txt -Append
    $Drive = Get-PSDrive C
    $UsedGB = [math]::Round($Drive.Used / 1GB, 2)
    $FreeGB = [math]::Round($Drive.Free / 1GB, 2)
    Write-Host "C: - Used: $UsedGB GB, Free: $FreeGB GB" -ForegroundColor White
    "C: - Used: $UsedGB GB, Free: $FreeGB GB" | Out-File C:\healthcheckreport-$Today.txt -Append
} catch {
    Write-Host "ERROR: Could not get OS Information"
    exit
}

Write-Host ""
Write-Host "Health check complete!" -ForegroundColor Green