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
