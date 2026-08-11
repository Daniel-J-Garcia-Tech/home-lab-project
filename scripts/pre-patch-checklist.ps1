#Complete Pre-Patch Checklist

#Header
Write-Host "===Pre-Patch Checklist==="
Write-Host ""

#Var
$Today = Get-Date -Format "yyyy-MM-dd"
$Services = @("wuauserv", "W32TIME")
$Warnings = 0

#Checklist
try {
    #Computer Name
    Write-Host "Computer: $env:COMPUTERNAME" -ForegroundColor Green
    "Computer Name: $env:COMPUTERNAME" | Out-File C:\pre-patch-checlist-$Today.txt

    #Todays Date
    Write-Host "Todays Date: $Today" -ForegroundColor Green
    "Todays Date: $Today" | Out-File C:\pre-patch-checlist-$Today.txt -Append

    #Checking Disk Space
    $Drive = Get-PSDrive C
    $UsedGB = [math]::Round($Drive.Used / 1GB, 2)
    $FreeGB = [math]::Round($Drive.Free / 1GB, 2)
    Write-Host "C: $UsedGB GB, Free: $FreeGB GB" -ForegroundColor White
    "C: $UsedGB GB, Free: $FreeGB GB" | Out-File C:\pre-patch-checlist-$Today.txt -Append
        if ($FreeGB -lt 10) {
            Write-Host "WARNING: Low Disk Space" -ForegroundColor Red
            "Warning: Low Disk Space" | Out-File C:\pre-patch-checlist-$Today.txt -Append
            $Warnings +=1
        } else {
        Write-Host "Disk Space OK" -ForegroundColor White
        "Disk Space OK" | Out-File C:\pre-patch-checlist-$Today.txt -Append
        }

    #Check Running Services
    foreach ($Service in $Services) {
        try {
            $ServiceStatus = Get-Service $Service -ErrorAction Stop
            if ($ServiceStatus.Status -eq "Running") {
                Write-Host "$Service - Running" -ForegroundColor Green
                "$Service - Running" | Out-File C:\pre-patch-checlist-$Today.txt -Append
            } else {
                Write-Host "$Service - Not Running" -ForegroundColor Red
                "$Service - Not Running" | Out-File C:\pre-patch-checlist-$Today.txt -Append
                $Warnings +=1
            }
        } catch {
            Write-Host "Could not check $Service" -ForegroundColor Red
            "Could not check $Service" | Out-File C:\pre-patch-checlist-$Today.txt -Append
            $Warnings +=1
        }
    }
    #Last 5 Updates
    try {
        $Update = Get-HotFix -ErrorAction Stop | Select-Object -Last 5
        Write-Host "Last 5  Installed Updates:" -ForegroundColor Yellow
        $Update | Format-Table -Autosize HotfixID, Description, InstalledOn
        $Update | Out-File C:\pre-patch-checlist-$Today.txt -Append
    } catch {
        Write-Host "ERROR: Could not retrieve updates" -ForegroundColor Red
        "Error: Could not retrieve updates" | Out-File C:\pre-patch-checlist-$Today.txt -Append
        $Warnings +=1
    }
} catch {
    Write-Host "ERROR: Checklist Failed" -ForegroundColor Red
    "ERROR: Checklist Failed" | Out-File C:\pre-patch-checlist-$Today.txt -Append
    $Warnings +=1
}

#Warnings
if ($Warnings -gt 0) {
    Write-Host "Review Warnings before patching" -ForegroundColor Red
    "Review Warnings before patching" | Out-File C:\pre-patch-checlist-$Today.txt -Append
} else {
    Write-Host "System ready for patching" -ForegroundColor Green
    "System ready for patching" | Out-File C:\pre-patch-checlist-$Today.txt -Append
}

#End
Write-Host ""
Write-Host "Pre-Patch Checklist Complete!" 