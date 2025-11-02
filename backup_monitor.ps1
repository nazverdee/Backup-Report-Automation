# =====================
# Back up Monitoring Script
# Description: Backs up files from a source folder to external HDD,
# logs results to CSV, and generates an HTML dashboard

# =========================

#Define variables
$Source = "$env:USERPROFILE\Documents"
$Destination = "N:\Backups"
$LogFile = "N:\BackupLogs\backup_report.csv"
$HTMLReport = "N:\BackupLogs\dashboard.html"

#Create folders
New-Item -ItemType Directory -Force -Path $Destination | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path $LogFile) | Out-Null

#Setup Tracking Variables
$Date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$BackupStatus = "Success"
$FileCount = 0
$BackupSize = 0

#Copy Files (Backup Process)

try { #try ... catch = handles errors safely
    $Files = Get-ChildItem -Path $Source -Recurse -File # ls all files in the source folder
    foreach ($file in $Files) { #loop copies each file to the destination
        $target = $file.FullName.Replace($Source, $Destination)
        New-Item -ItemType Directory -Force -Path (Split-Path $target) | Out-Null
        Copy-Item -Path $file.FullName -Destination $target -Force
        $FileCount++
        $BackupSize += $file.Length
    }
} catch {
    $BackupStatus ="Failed"
}

#Log the backup Results to CSV

$BackupData = [PSCustomObject]@{
    Date =$Date
    Status =$BackupStatus
    FileCount =$FileCount
    SizeMD = [math]::Round($BackupSize / 1MB, 2)
}

if (Test-Path $LogFile) {
    $BackupData | Export-Csv -Path $LogFile -Append -NoTypeInformation
} else {
    $BackupData | Export-Csv -Path $LogFile -NoTypeInformation
}

#Create HTML

$Table = Import-Csv $LogFile | ConvertTo-Html -As Table -PreContent "<h2>Backup Report Dashboard</h2>"

$Style = @"
<style>
body { font-family: Arial; margin: 40px; background-color: #f4f4f4; }
table { border-collapse: collapse; width: 80%; margin: auto; background: white; }
th, td { border: 1px solid #ccc; padding: 8px; text-align: center; }
th { background-color: #0078D7; color: white; }
h2 { text-align: center; color: #333; }
</style>
"@

$Table | Out-File $HTMLReport
(Get-Content $HTMLReport) | Set-Content $HTMLReport
Add-Content -Path $HTMLReport -Value $Style -Encoding UTF8 -Force

#Confirmation Message

Write-Host "Backup completed. Report saved to $HTMLReport"


