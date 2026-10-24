# Windows Diagnostic Toolkit

[Deutsch](README.md) | **English**

A menu-driven diagnostic and maintenance toolkit for Windows 10 and Windows 11.

The toolkit combines frequently used Windows diagnostic functions in a single batch file and adds an automated **PC health check with traffic-light status evaluation** as well as detailed TXT and HTML diagnostic reports.

## Features

### PC Health Check

The health check performs a series of checks without automatically making repairs or changes to the system.

It checks, among other things:

- storage device health
- available disk space
- RAM utilization
- CPU utilization
- system uptime
- pending Windows restart
- Windows Update services
- automatically started services
- Device Manager errors
- critical system events
- application errors
- default gateway
- DNS resolution
- Internet connectivity via TCP/443
- Microsoft Defender status
- Windows activation

Results are evaluated using a simple traffic-light system:

- **GREEN** – no unusual condition detected
- **YELLOW** – review or monitor
- **RED** – timely investigation or action recommended

In addition, the health check generates both a TXT report and a formatted HTML report.

## Additional Tools

The main menu currently includes functions from the following areas.

### Windows and Repair

- open Windows Update
- check and restart Windows Update services
- clear the Windows Update download cache
- `sfc /scannow`
- check the DISM component store
- repair the DISM component store
- display Windows activation status

### Network

- show saved Wi-Fi profiles
- show Wi-Fi driver information
- display IP configuration and network adapters
- display the routing table
- DNS test
- traceroute
- ping test
- TCP port test
- display and clear the DNS cache
- Winsock / TCP-IP reset

### Storage and Hardware

- CHKDSK online scan
- storage usage
- storage device health
- physical disk information
- RAM information
- CPU information
- GPU information
- temperature information, where exposed by Windows or the installed hardware

### Performance and Troubleshooting

- processes with high CPU usage
- processes with high memory usage
- startup entries
- suspicious or stopped automatic services
- critical system events from the last 24 hours
- critical application events from the last 24 hours
- Reliability Monitor
- Resource Monitor
- Task Manager

### Windows Tools

Direct access to:

- Storage settings
- Disk Management
- Startup Apps
- Task Scheduler
- Event Viewer
- Device Manager

### Diagnostic Reports

The toolkit can generate complete diagnostic reports:

- **TXT report** – useful for support, archiving, and sharing
- **HTML report** – clearly formatted technical system overview

Reports are stored by default in:

```text
%USERPROFILE%\Desktop\Windows_Diagnostics
```

## Menu Items and Commands Used

The following table shows which Windows, CMD, or PowerShell command is used by each menu item. Composite functions such as the health check and diagnostic reports combine multiple queries; for those entries, the main commands used are listed.

| No. | Menu item | Command / technique used |
|---:|---|---|
| 0 | PC health check with traffic-light status | Combination of `Get-CimInstance Win32_OperatingSystem`, `Get-PhysicalDisk`, `Get-CimInstance Win32_LogicalDisk`, `Get-Service`, `Get-CimInstance Win32_Service`, `Get-CimInstance Win32_PnPEntity`, `Get-WinEvent`, `Get-NetIPConfiguration`, `Resolve-DnsName`, `Test-NetConnection`, `Get-MpComputerStatus`, and `Get-CimInstance SoftwareLicensingProduct` |
| 1 | Open Windows Update | `start "" ms-settings:windowsupdate` |
| 2 | Check Windows Update services | `sc query wuauserv`, `sc query bits`, `sc query usosvc`, `sc query cryptsvc`, `sc query WaaSMedicSvc` |
| 3 | Restart Windows Update services | `net stop wuauserv`, `net stop bits`, `net stop cryptsvc`, followed by `net start ...` |
| 4 | Clear Windows Update download cache | Stop services, then `del /f /s /q "%windir%\SoftwareDistribution\Download\*"` and remove subdirectories |
| 5 | SFC system file check | `sfc /scannow` |
| 6 | Check DISM component store | `DISM /Online /Cleanup-Image /ScanHealth` |
| 7 | Repair DISM component store | `DISM /Online /Cleanup-Image /RestoreHealth` |
| 8 | Windows activation status | `cscript //nologo %windir%\system32\slmgr.vbs /xpr` and `/dli` |
| 9 | Show Wi-Fi profiles | `netsh wlan show profiles` |
| 10 | Show Wi-Fi driver information | `netsh wlan show drivers` |
| 11 | Network interfaces / IP configuration | `ipconfig /all` and `Get-NetAdapter` |
| 12 | Routing table | `route print` |
| 13 | Test DNS resolution | `nslookup <hostname>` and `Resolve-DnsName <hostname>` |
| 14 | Trace network route | `tracert <target>` |
| 15 | Ping test | `ping -n <count> <target>` |
| 16 | TCP port test | `Test-NetConnection -ComputerName <host> -Port <port> -InformationLevel Detailed` |
| 17 | Show DNS cache | `ipconfig /displaydns` |
| 18 | Clear DNS cache | `ipconfig /flushdns` |
| 19 | Winsock / TCP-IP reset | `netsh winsock reset` and `netsh int ip reset` |
| 20 | Check drive C: | `chkdsk C: /scan` |
| 21 | Analyze disk usage | `Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"` |
| 22 | SMART / disk health | `Get-PhysicalDisk` using `HealthStatus` and `OperationalStatus` |
| 23 | Physical disks | `Get-CimInstance Win32_DiskDrive` |
| 24 | RAM information | `Get-CimInstance Win32_ComputerSystem` and `Get-CimInstance Win32_PhysicalMemory` |
| 25 | CPU information | `Get-CimInstance Win32_Processor` |
| 26 | GPU information | `Get-CimInstance Win32_VideoController`; for NVIDIA, additionally `nvidia-smi` |
| 27 | Temperatures | `Get-CimInstance -Namespace root/wmi -ClassName MSAcpi_ThermalZoneTemperature`; for NVIDIA, additionally `nvidia-smi --query-gpu=...` |
| 28 | High-CPU processes | `Get-Process \| Sort-Object CPU -Descending \| Select-Object -First 20 ...` |
| 29 | High-memory processes | `Get-Process \| Sort-Object WorkingSet64 -Descending \| Select-Object -First 20 ...` |
| 30 | Startup entries | `Get-CimInstance Win32_StartupCommand` |
| 31 | Services with error status | `Get-CimInstance Win32_Service \| Where-Object { $_.StartMode -eq 'Auto' -and $_.State -ne 'Running' }` |
| 32 | Critical system events from the last 24h | `Get-WinEvent -FilterHashtable @{LogName='System';Level=1,2;StartTime=<24h>}` |
| 33 | Critical application events from the last 24h | `Get-WinEvent -FilterHashtable @{LogName='Application';Level=1,2;StartTime=<24h>}` |
| 34 | Windows Reliability Monitor | `perfmon /rel` |
| 35 | Resource Monitor | `resmon.exe` |
| 36 | Task Manager | `taskmgr.exe` |
| 37 | Storage settings | `start "" ms-settings:storagesense` |
| 38 | Disk Management | `diskmgmt.msc` |
| 39 | Startup Apps | `start "" ms-settings:startupapps` |
| 40 | Task Scheduler | `taskschd.msc` |
| 41 | Event Viewer | `eventvwr.msc` |
| 42 | Device Manager | `devmgmt.msc` |
| 43 | Complete TXT diagnostic report | Combination of `Get-CimInstance`, `Get-PhysicalDisk`, `Get-NetAdapter`, `Get-NetIPConfiguration`, `Get-Process`, `Get-WinEvent`, plus `Format-Table` / `Format-List`; output via `Set-Content` / `Add-Content` |
| 44 | Complete HTML diagnostic report | Uses the same system queries as the TXT report; tables are generated with `ConvertTo-Html -Fragment` and saved as HTML with `Set-Content` |
| 45 | Open report folder | `explorer.exe "%USERPROFILE%\Desktop\Windows_Diagnostics"` |

### Notes on the commands

The table lists the core commands actually used by the script. Some menu items add formatting, error handling, confirmation prompts, or variables for user-supplied targets. The complete implementation can be reviewed directly in [`windows-diagnostic-toolkit-en.bat`](windows-diagnostic-toolkit-en.bat).


## Installation

No installation is required.

1. Download `windows-diagnostic-toolkit.bat`.
2. Save the file locally.
3. Start it with a double-click.
4. Confirm the User Account Control prompt.

The script automatically requests administrator privileges.

## Requirements

- Windows 10 or Windows 11
- Windows PowerShell 5.1 or later
- Administrator privileges for some diagnostic and repair functions

Some hardware information may not be available on every system, depending on the device, driver, and manufacturer.

## Safety

The **PC Health Check** does not perform automatic repairs.

Functions that can make changes to the system are available separately in the menu. These include, for example:

- clearing the Windows Update cache
- DISM repair
- Winsock / TCP-IP reset

A current backup should be available before performing potentially disruptive changes on production systems.

## Interpreting the Results

The toolkit is a diagnostic aid and does not replace a complete hardware or security analysis.

In particular:

- individual Event Viewer errors do not automatically indicate a system fault
- Windows exposes SMART and temperature data only to a limited extent on some hardware
- high CPU or RAM values are point-in-time measurements
- Microsoft Defender being disabled can be normal when another security product is installed

The traffic-light evaluation is intended to prioritize findings and is not a guarantee that a system is healthy or defective.

## Privacy

The script operates locally on the Windows PC.

It does not upload diagnostic reports to an external server. However, some network checks use public destinations, for example for DNS or HTTPS connectivity testing.

Before publishing or sharing a diagnostic report, review it for information such as computer name, username, IP addresses, MAC addresses, device names, or installed components.

## Project Status

The project is under active development.

Planned improvements include:

- more targeted evaluation of important Windows Event IDs
- stronger weighting of Disk, NTFS, WHEA, and Kernel-Power events
- improved SMART evaluation
- combined health-check and detailed diagnostic report
- optional export functions
- additional plausibility checks for services and drivers

## Disclaimer

Use this software at your own risk. Before making changes to production systems, make sure backups are available and you understand the impact of the selected function.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE).
