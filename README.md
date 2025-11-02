# Backup Report Automation 💾

This PowerShell script automates daily backups from a local folder to an a different Backups location (in my caase, an external HD), while generating both CSV logs and an HTML dashboard that tracks backup performance over time.

---

## Features
- Backs up files automatically from `Documents` → `N:\Backups`
- Logs backup results (date, file count, size, status)
- Generates a simple HTML dashboard
- Easily schedulable with Windows Task Scheduler

---

## Usage
1. Download `backup_monitor.ps1`
2. Edit the `$Source` and `$Destination` paths to match your setup
3. Run in PowerShell:
   ```powershell
   .\backup_monitor.ps1
