@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 >nul
title Daily Windows Toolkit - Extended Health Edition (English)
color 0B

:: ================================================================
:: DAILY WINDOWS TOOLKIT - EXTENDED HEALTH EDITION
:: Windows 10 / 11
:: ================================================================

:: ---------- Ensure administrator privileges ----------
net session >nul 2>&1
if not "%errorlevel%"=="0" (
    echo Requesting administrator privileges...
    powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
      "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

:: ---------- Report directory ----------
set "REPORTDIR=%USERPROFILE%\Desktop\Windows_Diagnostics"
if not exist "%REPORTDIR%" mkdir "%REPORTDIR%" >nul 2>&1

:MENU
cls
echo ============================================================================
echo                DAILY WINDOWS TOOLKIT - EXTENDED HEALTH EDITION
echo ============================================================================
echo.
echo  HEALTH CHECK
echo  -----------
echo   0. PC health check with traffic-light status
echo.
echo  WINDOWS / REPAIR
echo  ------------------
echo   1. Open Windows Update
echo   2. Check Windows Update services
echo   3. Restart Windows Update services
echo   4. Clear Windows Update download cache
echo   5. Run SFC system file check
echo   6. Check DISM component store
echo   7. Repair DISM component store
echo   8. Show Windows activation status
echo.
echo  NETWORK
echo  --------
echo   9. Show Wi-Fi profiles
echo  10. Show Wi-Fi driver information
echo  11. Show network interfaces / IP configuration
echo  12. Show routing table
echo  13. Test DNS resolution
echo  14. Trace network route
echo  15. Ping-Test
echo  16. Port test (TCP)
echo  17. Show DNS cache
echo  18. Clear DNS cache
echo  19. Prepare Winsock / TCP-IP reset
echo.
echo  STORAGE / HARDWARE
echo  -------------------
echo  20. Check drive C: with CHKDSK /scan
echo  21. Analyze disk usage
echo  22. Show SMART / disk health
echo  23. Show physical disks
echo  24. Show RAM information
echo  25. Show CPU information
echo  26. Show GPU information
echo  27. Show temperatures (where available)
echo.
echo  PERFORMANCE / TROUBLESHOOTING
echo  -------------------------
echo  28. Show high-CPU processes
echo  29. Show high-memory processes
echo  30. Show startup entries
echo  31. Show services with error status
echo  32. Critical system events from the last 24h
echo  33. Critical application events from the last 24h
echo  34. Open Windows Reliability Monitor
echo  35. Open Resource Monitor
echo  36. Open Task Manager
echo.
echo  WINDOWS TOOLS
echo  -----------------
echo  37. Open Storage settings
echo  38. Open Disk Management
echo  39. Open Startup Apps
echo  40. Open Task Scheduler
echo  41. Open Event Viewer
echo  42. Open Device Manager
echo.
echo  DIAGNOSTIC REPORT
echo  ---------------
echo  43. Create complete TXT diagnostic report
echo  44. Create complete HTML diagnostic report
echo  45. Open report folder
echo.
echo  ----------------------------------------------------------------------------
echo   R. Refresh menu
echo   Q. Exit
echo  ----------------------------------------------------------------------------
echo.

set /p "choice=Selection: "

if /I "%choice%"=="0"  goto HEALTHCHECK
if /I "%choice%"=="1"  goto UPDATE_OPEN
if /I "%choice%"=="2"  goto UPDATE_CHECK
if /I "%choice%"=="3"  goto UPDATE_RESTART
if /I "%choice%"=="4"  goto UPDATE_CACHE
if /I "%choice%"=="5"  goto SFC_SCAN
if /I "%choice%"=="6"  goto DISM_CHECK
if /I "%choice%"=="7"  goto DISM_REPAIR
if /I "%choice%"=="8"  goto ACTIVATION
if /I "%choice%"=="9"  goto WIFI_PROFILES
if /I "%choice%"=="10" goto WIFI_DRIVER
if /I "%choice%"=="11" goto NET_INTERFACES
if /I "%choice%"=="12" goto ROUTING
if /I "%choice%"=="13" goto DNS_TEST
if /I "%choice%"=="14" goto TRACE_TEST
if /I "%choice%"=="15" goto PING_TEST
if /I "%choice%"=="16" goto PORT_TEST
if /I "%choice%"=="17" goto DNS_SHOW
if /I "%choice%"=="18" goto DNS_FLUSH
if /I "%choice%"=="19" goto NETWORK_RESET
if /I "%choice%"=="20" goto CHKDSK
if /I "%choice%"=="21" goto DISK_USAGE
if /I "%choice%"=="22" goto SMART
if /I "%choice%"=="23" goto PHYSICAL_DISKS
if /I "%choice%"=="24" goto RAM_INFO
if /I "%choice%"=="25" goto CPU_INFO
if /I "%choice%"=="26" goto GPU_INFO
if /I "%choice%"=="27" goto TEMP_INFO
if /I "%choice%"=="28" goto TOP_CPU
if /I "%choice%"=="29" goto TOP_RAM
if /I "%choice%"=="30" goto STARTUP_LIST
if /I "%choice%"=="31" goto SERVICE_ERRORS
if /I "%choice%"=="32" goto SYS_EVENTS
if /I "%choice%"=="33" goto APP_EVENTS
if /I "%choice%"=="34" goto RELIABILITY
if /I "%choice%"=="35" goto RESMON
if /I "%choice%"=="36" goto TASKMGR
if /I "%choice%"=="37" goto STORAGE_SETTINGS
if /I "%choice%"=="38" goto DISKMGMT
if /I "%choice%"=="39" goto STARTUP_APPS
if /I "%choice%"=="40" goto TASK_SCHEDULER
if /I "%choice%"=="41" goto EVENT_VIEWER
if /I "%choice%"=="42" goto DEVICE_MANAGER
if /I "%choice%"=="43" goto REPORT_TXT
if /I "%choice%"=="44" goto REPORT_HTML
if /I "%choice%"=="45" goto REPORT_FOLDER
if /I "%choice%"=="R" goto MENU
if /I "%choice%"=="Q" goto END

echo.
echo Invalid selection.
timeout /t 2 >nul
goto MENU

:: ================================================================
:: HEALTH CHECK
:: ================================================================

:HEALTHCHECK
cls
echo ============================================================================
echo PC-HEALTH CHECK MIT AMPELSYSTEM
echo ============================================================================
echo.
echo The check includes:
echo - disk health and free space
echo - RAM utilization
echo - system uptime / pending restart
echo - Windows Update services
echo - automatic services
echo - Device Manager errors
echo - system and application errors from the last 24 hours
echo - network / DNS / basic Internet connectivity
echo - Windows Defender where available
echo.
echo NO repairs are performed automatically.
echo.
echo Please wait...
echo.

set "TMPPS=%TEMP%\WindowsToolkitHealth_%RANDOM%.ps1"

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
  "$src=Get-Content -LiteralPath '%~f0'; $start=($src | Select-String '^REMPS_BEGIN$').LineNumber; $end=($src | Select-String '^REMPS_END$').LineNumber; if(-not $start -or -not $end){exit 10}; $code=$src[$start..($end-2)] | ForEach-Object { $_ -replace '^REMPS ?','' }; Set-Content -LiteralPath '%TMPPS%' -Value $code -Encoding UTF8"

if not exist "%TMPPS%" (
    echo Error: health-check module could not be extracted.
    goto PAUSE_RETURN
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%TMPPS%" -ReportDir "%REPORTDIR%"
set "HCERR=%errorlevel%"
del /q "%TMPPS%" >nul 2>&1

echo.
if "%HCERR%"=="0" (
    echo Health check completed.
) else (
    echo The health check ended with error code %HCERR% .
)
goto PAUSE_RETURN

:: ================================================================
:: WINDOWS / REPAIR
:: ================================================================

:UPDATE_OPEN
start "" ms-settings:windowsupdate
goto RETURN

:UPDATE_CHECK
cls
echo ============================================================================
echo WINDOWS UPDATE SERVICES
echo ============================================================================
echo.
for %%S in (wuauserv bits usosvc cryptsvc WaaSMedicSvc) do (
    echo --- %%S ---
    sc query "%%S" | findstr /I "SERVICE_NAME STATE"
    echo.
)
goto PAUSE_RETURN

:UPDATE_RESTART
cls
echo ============================================================================
echo RESTART WINDOWS UPDATE SERVICES
echo ============================================================================
echo.
net stop wuauserv /y
net stop bits /y
net stop cryptsvc /y
echo.
net start cryptsvc
net start bits
net start wuauserv
echo.
echo Operation completed.
goto PAUSE_RETURN

:UPDATE_CACHE
cls
echo ============================================================================
echo CLEAR WINDOWS UPDATE DOWNLOAD CACHE
echo ============================================================================
echo.
echo This removes only already downloaded update files.
echo Installed updates will NOT be uninstalled.
echo.
choice /C YN /N /M "Continue? [Y/N]: "
if errorlevel 2 goto MENU
net stop wuauserv /y
net stop bits /y
del /f /s /q "%windir%\SoftwareDistribution\Download\*" >nul 2>&1
for /d %%D in ("%windir%\SoftwareDistribution\Download\*") do rd /s /q "%%D" >nul 2>&1
net start bits
net start wuauserv
echo.
echo Download cache cleared.
goto PAUSE_RETURN

:SFC_SCAN
cls
echo ============================================================================
echo SFC SYSTEM FILE CHECK
echo ============================================================================
echo.
sfc /scannow
goto PAUSE_RETURN

:DISM_CHECK
cls
echo ============================================================================
echo CHECK DISM COMPONENT STORE
echo ============================================================================
echo.
DISM /Online /Cleanup-Image /ScanHealth
goto PAUSE_RETURN

:DISM_REPAIR
cls
echo ============================================================================
echo REPAIR DISM COMPONENT STORE
echo ============================================================================
echo.
choice /C YN /N /M "Start repair? [Y/N]: "
if errorlevel 2 goto MENU
DISM /Online /Cleanup-Image /RestoreHealth
goto PAUSE_RETURN

:ACTIVATION
cls
echo ============================================================================
echo WINDOWS ACTIVATION
echo ============================================================================
echo.
cscript //nologo "%windir%\system32\slmgr.vbs" /xpr
echo.
cscript //nologo "%windir%\system32\slmgr.vbs" /dli
goto PAUSE_RETURN

:: ================================================================
:: NETWORK
:: ================================================================

:WIFI_PROFILES
cls
netsh wlan show profiles
goto PAUSE_RETURN

:WIFI_DRIVER
cls
netsh wlan show drivers
goto PAUSE_RETURN

:NET_INTERFACES
cls
ipconfig /all
echo.
powershell.exe -NoProfile -Command "Get-NetAdapter | Sort-Object Status,Name | Format-Table -AutoSize Name,InterfaceDescription,Status,LinkSpeed,MacAddress"
goto PAUSE_RETURN

:ROUTING
cls
route print
goto PAUSE_RETURN

:DNS_TEST
cls
set "dnsTarget="
set /p "dnsTarget=Hostname [www.microsoft.com]: "
if not defined dnsTarget set "dnsTarget=www.microsoft.com"
nslookup "%dnsTarget%"
echo.
powershell.exe -NoProfile -Command "Resolve-DnsName '%dnsTarget%' -ErrorAction SilentlyContinue | Format-Table -AutoSize"
goto PAUSE_RETURN

:TRACE_TEST
cls
set "traceTarget="
set /p "traceTarget=Target [1.1.1.1]: "
if not defined traceTarget set "traceTarget=1.1.1.1"
tracert "%traceTarget%"
goto PAUSE_RETURN

:PING_TEST
cls
set "pingTarget="
set /p "pingTarget=Target [1.1.1.1]: "
if not defined pingTarget set "pingTarget=1.1.1.1"
set "pingCount="
set /p "pingCount=Number of pings [10]: "
if not defined pingCount set "pingCount=10"
ping -n %pingCount% "%pingTarget%"
goto PAUSE_RETURN

:PORT_TEST
cls
set "portTarget="
set /p "portTarget=Hostname/IP [1.1.1.1]: "
if not defined portTarget set "portTarget=1.1.1.1"
set "portNumber="
set /p "portNumber=TCP-Port [443]: "
if not defined portNumber set "portNumber=443"
powershell.exe -NoProfile -Command "Test-NetConnection -ComputerName '%portTarget%' -Port %portNumber% -InformationLevel Detailed"
goto PAUSE_RETURN

:DNS_SHOW
cls
ipconfig /displaydns
goto PAUSE_RETURN

:DNS_FLUSH
cls
ipconfig /flushdns
goto PAUSE_RETURN

:NETWORK_RESET
cls
echo WARNING: The network stack will be reset. Restart recommended.
echo.
choice /C YN /N /M "Really perform reset? [Y/N]: "
if errorlevel 2 goto MENU
netsh winsock reset
netsh int ip reset
goto PAUSE_RETURN

:: ================================================================
:: HARDWARE / STORAGE
:: ================================================================

:CHKDSK
cls
chkdsk C: /scan
goto PAUSE_RETURN

:DISK_USAGE
cls
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
  "Get-CimInstance Win32_LogicalDisk -Filter \"DriveType=3\" | ForEach-Object { [PSCustomObject]@{Laufwerk=$_.DeviceID;Gesamt_GB=[math]::Round($_.Size/1GB,1);Free_GB=[math]::Round($_.FreeSpace/1GB,1);Belegt_Prozent=[math]::Round((1-($_.FreeSpace/$_.Size))*100,1)} } | Format-Table -AutoSize"
goto PAUSE_RETURN

:SMART
cls
powershell.exe -NoProfile -Command "Get-PhysicalDisk | Select FriendlyName,MediaType,BusType,HealthStatus,OperationalStatus,@{N='SizeGB';E={[math]::Round($_.Size/1GB,1)}} | Format-Table -AutoSize"
goto PAUSE_RETURN

:PHYSICAL_DISKS
cls
powershell.exe -NoProfile -Command "Get-CimInstance Win32_DiskDrive | Select Model,SerialNumber,InterfaceType,MediaType,@{N='SizeGB';E={[math]::Round($_.Size/1GB,1)}} | Format-Table -AutoSize"
goto PAUSE_RETURN

:RAM_INFO
cls
powershell.exe -NoProfile -Command "$cs=Get-CimInstance Win32_ComputerSystem; Write-Host ('Installed RAM: {0:N2} GB' -f ($cs.TotalPhysicalMemory/1GB)); Get-CimInstance Win32_PhysicalMemory | Select BankLabel,DeviceLocator,Manufacturer,PartNumber,Speed,ConfiguredClockSpeed,@{N='CapacityGB';E={[math]::Round($_.Capacity/1GB,2)}} | Format-Table -AutoSize"
goto PAUSE_RETURN

:CPU_INFO
cls
powershell.exe -NoProfile -Command "Get-CimInstance Win32_Processor | Select Name,Manufacturer,NumberOfCores,NumberOfLogicalProcessors,MaxClockSpeed,CurrentClockSpeed,LoadPercentage | Format-List"
goto PAUSE_RETURN

:GPU_INFO
cls
powershell.exe -NoProfile -Command "Get-CimInstance Win32_VideoController | Select Name,DriverVersion,VideoProcessor,@{N='AdapterRAM_GB';E={if($_.AdapterRAM){[math]::Round($_.AdapterRAM/1GB,2)}else{'n/a'}}},CurrentHorizontalResolution,CurrentVerticalResolution,CurrentRefreshRate | Format-List"
where nvidia-smi >nul 2>&1
if "%errorlevel%"=="0" nvidia-smi
goto PAUSE_RETURN

:TEMP_INFO
cls
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$t=Get-CimInstance -Namespace root/wmi -ClassName MSAcpi_ThermalZoneTemperature -ErrorAction SilentlyContinue; if($t){$t | ForEach-Object {[PSCustomObject]@{Sensor=$_.InstanceName;Celsius=[math]::Round(($_.CurrentTemperature/10)-273.15,1)}} | Format-Table -AutoSize}else{Write-Host 'No ACPI temperature sensors available.'}"
where nvidia-smi >nul 2>&1
if "%errorlevel%"=="0" nvidia-smi --query-gpu=name,temperature.gpu,fan.speed,power.draw --format=csv,noheader
goto PAUSE_RETURN

:: ================================================================
:: PERFORMANCE
:: ================================================================

:TOP_CPU
cls
powershell.exe -NoProfile -Command "Get-Process | Sort-Object CPU -Descending | Select-Object -First 20 ProcessName,Id,@{N='CPU_s';E={[math]::Round($_.CPU,1)}},@{N='RAM_MB';E={[math]::Round($_.WorkingSet64/1MB,1)}} | Format-Table -AutoSize"
goto PAUSE_RETURN

:TOP_RAM
cls
powershell.exe -NoProfile -Command "Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 20 ProcessName,Id,@{N='RAM_MB';E={[math]::Round($_.WorkingSet64/1MB,1)}},@{N='CPU_s';E={[math]::Round($_.CPU,1)}} | Format-Table -AutoSize"
goto PAUSE_RETURN

:STARTUP_LIST
cls
powershell.exe -NoProfile -Command "Get-CimInstance Win32_StartupCommand | Select Name,Command,Location,User | Format-Table -Wrap -AutoSize"
goto PAUSE_RETURN

:SERVICE_ERRORS
cls
powershell.exe -NoProfile -Command "Get-CimInstance Win32_Service | Where-Object {($_.StartMode -eq 'Auto') -and ($_.State -ne 'Running')} | Select Name,DisplayName,State,StartMode,ExitCode | Format-Table -AutoSize"
goto PAUSE_RETURN

:SYS_EVENTS
cls
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$s=(Get-Date).AddHours(-24); Get-WinEvent -FilterHashtable @{LogName='System';Level=1,2;StartTime=$s} -ErrorAction SilentlyContinue | Select-Object -First 50 TimeCreated,Id,ProviderName,LevelDisplayName,Message | Format-List"
goto PAUSE_RETURN

:APP_EVENTS
cls
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$s=(Get-Date).AddHours(-24); Get-WinEvent -FilterHashtable @{LogName='Application';Level=1,2;StartTime=$s} -ErrorAction SilentlyContinue | Select-Object -First 50 TimeCreated,Id,ProviderName,LevelDisplayName,Message | Format-List"
goto PAUSE_RETURN

:RELIABILITY
start "" perfmon /rel
goto RETURN

:RESMON
start "" resmon.exe
goto RETURN

:TASKMGR
start "" taskmgr.exe
goto RETURN

:: ================================================================
:: WINDOWS TOOLS
:: ================================================================

:STORAGE_SETTINGS
start "" ms-settings:storagesense
goto RETURN

:DISKMGMT
start "" diskmgmt.msc
goto RETURN

:STARTUP_APPS
start "" ms-settings:startupapps
goto RETURN

:TASK_SCHEDULER
start "" taskschd.msc
goto RETURN

:EVENT_VIEWER
start "" eventvwr.msc
goto RETURN

:DEVICE_MANAGER
start "" devmgmt.msc
goto RETURN

:: ================================================================
:: REPORTS
:: ================================================================

:REPORT_TXT
cls
echo ============================================================================
echo KOMPLETTER TXT-DIAGNOSTIC REPORT
echo ============================================================================
echo.
set "TXTREPORT=%REPORTDIR%\Windows_Diagnose_%COMPUTERNAME%_%RANDOM%.txt"
echo Creating report...
echo Target: %TXTREPORT%
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
  "$out='%TXTREPORT%';" ^
  "$os=Get-CimInstance Win32_OperatingSystem; $cs=Get-CimInstance Win32_ComputerSystem; $bios=Get-CimInstance Win32_BIOS;" ^
  "function Sec([string]$t){Add-Content $out ''; Add-Content $out ('='*78); Add-Content $out ('  '+$t); Add-Content $out ('='*78)};" ^
  "function Tab($x){if($null -eq $x -or @($x).Count -eq 0){Add-Content $out 'No data / no issues detected.'}else{($x|Format-Table -AutoSize|Out-String -Width 220).TrimEnd()|Add-Content $out}};" ^
  "function Lst($x){if($null -eq $x -or @($x).Count -eq 0){Add-Content $out 'No data / no issues detected.'}else{($x|Format-List|Out-String -Width 220).TrimEnd()|Add-Content $out}};" ^
  "@('WINDOWS DIAGNOSTIC REPORT',('Computer : '+$env:COMPUTERNAME),('Created : '+(Get-Date -Format 'dd.MM.yyyy HH:mm:ss'))) | Set-Content $out -Encoding UTF8;" ^
  "Sec 'SYSTEM'; Lst ([pscustomobject]@{Computer=$env:COMPUTERNAME;User=$env:USERNAME;Manufacturer=$cs.Manufacturer;Model=$cs.Model;Windows=$os.Caption;Version=$os.Version;Build=$os.BuildNumber;Architecture=$os.OSArchitecture;Installed=$os.InstallDate;Last_Boot=$os.LastBootUpTime;Uptime_Days=[math]::Round(((Get-Date)-$os.LastBootUpTime).TotalDays,1);RAM_GB=[math]::Round($cs.TotalPhysicalMemory/1GB,2);BIOS=$bios.SMBIOSBIOSVersion;BIOS_Date=$bios.ReleaseDate});" ^
  "Sec 'CPU'; Lst (Get-CimInstance Win32_Processor|Select Name,Manufacturer,NumberOfCores,NumberOfLogicalProcessors,MaxClockSpeed,CurrentClockSpeed,LoadPercentage);" ^
  "Sec 'RAM MODULES'; Tab (Get-CimInstance Win32_PhysicalMemory|Select BankLabel,DeviceLocator,Manufacturer,PartNumber,Speed,ConfiguredClockSpeed,@{N='Capacity_GB';E={[math]::Round($_.Capacity/1GB,2)}});" ^
  "Sec 'GRAPHICS'; Tab (Get-CimInstance Win32_VideoController|Select Name,DriverVersion,VideoProcessor,@{N='RAM_GB';E={if($_.AdapterRAM){[math]::Round($_.AdapterRAM/1GB,2)}else{'n/a'}}});" ^
  "Sec 'PHYSICAL DISKS'; Tab (Get-PhysicalDisk|Select FriendlyName,MediaType,BusType,HealthStatus,OperationalStatus,@{N='Size_GB';E={[math]::Round($_.Size/1GB,1)}});" ^
  "Sec 'DRIVES'; Tab (Get-CimInstance Win32_LogicalDisk -Filter \"DriveType=3\"|Select DeviceID,VolumeName,FileSystem,@{N='Size_GB';E={[math]::Round($_.Size/1GB,1)}},@{N='Free_GB';E={[math]::Round($_.FreeSpace/1GB,1)}},@{N='Free_Percent';E={[math]::Round(($_.FreeSpace/$_.Size)*100,1)}});" ^
  "Sec 'NETWORKADAPTER'; Tab (Get-NetAdapter|Select Name,InterfaceDescription,Status,LinkSpeed,MacAddress);" ^
  "Sec 'IP CONFIGURATION'; Lst (Get-NetIPConfiguration|Select InterfaceAlias,InterfaceDescription,IPv4Address,IPv4DefaultGateway,DNSServer);" ^
  "Sec 'TOP 20 PROCESSES BY RAM'; Tab (Get-Process|Sort WorkingSet64 -Descending|Select -First 20 ProcessName,Id,@{N='RAM_MB';E={[math]::Round($_.WorkingSet64/1MB,1)}},@{N='CPU_s';E={if($_.CPU){[math]::Round($_.CPU,1)}else{0}}});" ^
  "Sec 'TOP 20 PROCESSES BY CPU TIME'; Tab (Get-Process|Sort CPU -Descending|Select -First 20 ProcessName,Id,@{N='CPU_s';E={if($_.CPU){[math]::Round($_.CPU,1)}else{0}}},@{N='RAM_MB';E={[math]::Round($_.WorkingSet64/1MB,1)}});" ^
  "Sec 'STARTUP'; Tab (Get-CimInstance Win32_StartupCommand|Select Name,Command,Location,User);" ^
  "Sec 'AUTOMATIC SERVICES NOT RUNNING'; Tab (Get-CimInstance Win32_Service|Where {$_.StartMode -eq 'Auto' -and $_.State -ne 'Running'}|Select Name,DisplayName,State,StartMode,ExitCode);" ^
  "Sec 'DEVICE MANAGER ERRORS'; Tab (Get-CimInstance Win32_PnPEntity|Where {$_.ConfigManagerErrorCode -ne 0}|Select Name,PNPDeviceID,ConfigManagerErrorCode);" ^
  "$since=(Get-Date).AddHours(-24);" ^
  "Sec 'SYSTEM ERRORS / CRITICAL EVENTS - LAST 24 HOURS'; Lst (Get-WinEvent -FilterHashtable @{LogName='System';Level=1,2;StartTime=$since} -ErrorAction SilentlyContinue|Select -First 50 TimeCreated,Id,ProviderName,LevelDisplayName,Message);" ^
  "Sec 'APPLICATION ERRORS / CRITICAL EVENTS - LAST 24 HOURS'; Lst (Get-WinEvent -FilterHashtable @{LogName='Application';Level=1,2;StartTime=$since} -ErrorAction SilentlyContinue|Select -First 50 TimeCreated,Id,ProviderName,LevelDisplayName,Message)"

echo.
echo TXT report created.
start "" notepad.exe "%TXTREPORT%"
goto PAUSE_RETURN

:REPORT_HTML
cls
echo ============================================================================
echo KOMPLETTER HTML-DIAGNOSTIC REPORT
echo ============================================================================
echo.
echo Der Creating report...
echo.

set "TMPHTMLPS=%TEMP%\WindowsToolkitHTML_%RANDOM%.ps1"

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
  "$src=Get-Content -LiteralPath '%~f0'; $start=($src | Select-String '^REMHTML_BEGIN$').LineNumber; $end=($src | Select-String '^REMHTML_END$').LineNumber; if(-not $start -or -not $end){exit 10}; $code=$src[$start..($end-2)] | ForEach-Object { $_ -replace '^REMHTML ?','' }; Set-Content -LiteralPath '%TMPHTMLPS%' -Value $code -Encoding UTF8"

if not exist "%TMPHTMLPS%" (
    echo.
    echo ERROR: HTML report module could not be extracted.
    echo.
    pause
    goto MENU
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%TMPHTMLPS%" -ReportDir "%REPORTDIR%"
set "HTMLERR=%errorlevel%"

del /q "%TMPHTMLPS%" >nul 2>&1

echo.
if "%HTMLERR%"=="0" (
    echo HTML report created successfully.
) else (
    echo ERROR while creating the HTML report.
    echo PowerShell error code: %HTMLERR%
)
echo.
pause
goto MENU

:REPORT_FOLDER
start "" explorer.exe "%REPORTDIR%"
goto RETURN

:: ================================================================
:: HELPER
:: ================================================================

:RETURN
timeout /t 1 >nul
goto MENU

:PAUSE_RETURN
echo.
pause
goto MENU

:END
endlocal
exit /b


:: ============================================================================
:: Eingebettetes PowerShell-Modul fuer HTML-Diagnosebericht
:: ============================================================================
REMHTML_BEGIN
REMHTML param([Parameter(Mandatory=$true)][string]$ReportDir)
REMHTML $ErrorActionPreference = 'Stop'
REMHTML if(-not (Test-Path $ReportDir)){ New-Item -ItemType Directory -Path $ReportDir -Force | Out-Null }
REMHTML $stamp = Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'
REMHTML $htmlFile = Join-Path $ReportDir ("Windows_Diagnose_{0}_{1}.html" -f $env:COMPUTERNAME,$stamp)
REMHTML function HtmlEncode($s){
REMHTML   if($null -eq $s){ return '' }
REMHTML   return [System.Net.WebUtility]::HtmlEncode([string]$s)
REMHTML }
REMHTML function Html-Table([string]$Title,$Data){
REMHTML   if($null -eq $Data -or @($Data).Count -eq 0){
REMHTML     return "<section><h2>$(HtmlEncode $Title)</h2><p class='muted'>No data / no issues detected.</p></section>"
REMHTML   }
REMHTML   $fragment = $Data | ConvertTo-Html -Fragment
REMHTML   return "<section><h2>$(HtmlEncode $Title)</h2>$fragment</section>"
REMHTML }
REMHTML try {
REMHTML   $os = Get-CimInstance Win32_OperatingSystem
REMHTML   $cs = Get-CimInstance Win32_ComputerSystem
REMHTML   $bios = Get-CimInstance Win32_BIOS
REMHTML   $cpu = Get-CimInstance Win32_Processor
REMHTML   $ram = Get-CimInstance Win32_PhysicalMemory
REMHTML   $gpu = Get-CimInstance Win32_VideoController
REMHTML   $physical = Get-PhysicalDisk -ErrorAction SilentlyContinue
REMHTML   $logical = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"
REMHTML   $net = Get-NetAdapter -ErrorAction SilentlyContinue
REMHTML   $ip = Get-NetIPConfiguration -ErrorAction SilentlyContinue
REMHTML   $topRam = Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 20 ProcessName,Id,@{N='RAM_MB';E={[math]::Round($_.WorkingSet64/1MB,1)}},@{N='CPU_s';E={if($_.CPU){[math]::Round($_.CPU,1)}else{0}}}
REMHTML   $topCpu = Get-Process | Sort-Object CPU -Descending | Select-Object -First 20 ProcessName,Id,@{N='CPU_s';E={if($_.CPU){[math]::Round($_.CPU,1)}else{0}}},@{N='RAM_MB';E={[math]::Round($_.WorkingSet64/1MB,1)}}
REMHTML   $startup = Get-CimInstance Win32_StartupCommand | Select-Object Name,Command,Location,User
REMHTML   $badSvc = Get-CimInstance Win32_Service | Where-Object {$_.StartMode -eq 'Auto' -and $_.State -ne 'Running'} | Select-Object Name,DisplayName,State,StartMode,ExitCode
REMHTML   $badDev = Get-CimInstance Win32_PnPEntity | Where-Object {$_.ConfigManagerErrorCode -ne 0} | Select-Object Name,PNPDeviceID,ConfigManagerErrorCode
REMHTML   $since = (Get-Date).AddHours(-24)
REMHTML   $sysEv = Get-WinEvent -FilterHashtable @{LogName='System';Level=1,2;StartTime=$since} -ErrorAction SilentlyContinue | Select-Object -First 50 TimeCreated,Id,ProviderName,LevelDisplayName,Message
REMHTML   $appEv = Get-WinEvent -FilterHashtable @{LogName='Application';Level=1,2;StartTime=$since} -ErrorAction SilentlyContinue | Select-Object -First 50 TimeCreated,Id,ProviderName,LevelDisplayName,Message
REMHTML   $uptimeDays = [math]::Round(((Get-Date)-$os.LastBootUpTime).TotalDays,1)
REMHTML   $style = @(
REMHTML     '<style>'
REMHTML     'body{font-family:Segoe UI,Arial,sans-serif;margin:0;background:#f3f4f6;color:#1f2937}'
REMHTML     '.wrap{max-width:1500px;margin:0 auto;padding:24px}'
REMHTML     '.hero{background:#111827;color:#fff;padding:22px 26px;border-radius:12px;margin-bottom:18px}'
REMHTML     '.hero h1{margin:0 0 8px}.hero p{margin:3px 0;color:#d1d5db}'
REMHTML     'section{background:#fff;padding:18px 20px;border-radius:10px;margin:14px 0;box-shadow:0 1px 4px rgba(0,0,0,.12);overflow:auto}'
REMHTML     'h2{font-size:20px;margin:0 0 14px;border-bottom:2px solid #e5e7eb;padding-bottom:8px}'
REMHTML     'table{border-collapse:collapse;width:100%;font-size:13px}'
REMHTML     'th,td{border-bottom:1px solid #e5e7eb;padding:7px 9px;text-align:left;vertical-align:top}'
REMHTML     'th{background:#f9fafb}'
REMHTML     '.muted{color:#6b7280}'
REMHTML     '.meta{display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:8px 20px}'
REMHTML     '.meta div{padding:5px 0}.meta b{display:inline-block;min-width:110px}'
REMHTML     '</style>'
REMHTML   ) -join [Environment]::NewLine
REMHTML   $meta = @(
REMHTML     "<div><b>Computer</b> $(HtmlEncode $env:COMPUTERNAME)</div>"
REMHTML     "<div><b>User</b> $(HtmlEncode $env:USERNAME)</div>"
REMHTML     "<div><b>Windows</b> $(HtmlEncode $os.Caption)</div>"
REMHTML     "<div><b>Version</b> $(HtmlEncode $os.Version) / Build $(HtmlEncode $os.BuildNumber)</div>"
REMHTML     "<div><b>Architecture</b> $(HtmlEncode $os.OSArchitecture)</div>"
REMHTML     "<div><b>Manufacturer</b> $(HtmlEncode $cs.Manufacturer)</div>"
REMHTML     "<div><b>Model</b> $(HtmlEncode $cs.Model)</div>"
REMHTML     "<div><b>RAM</b> $([math]::Round($cs.TotalPhysicalMemory/1GB,2)) GB</div>"
REMHTML     "<div><b>Laufzeit</b> $uptimeDays Tage</div>"
REMHTML     "<div><b>BIOS</b> $(HtmlEncode $bios.SMBIOSBIOSVersion)</div>"
REMHTML   ) -join [Environment]::NewLine
REMHTML   $parts = [System.Collections.Generic.List[string]]::new()
REMHTML   $parts.Add("<!doctype html><html><head><meta charset='utf-8'><title>Windows Diagnostic Report</title>$style</head><body><div class='wrap'>")
REMHTML   $parts.Add("<div class='hero'><h1>Windows Diagnostic Report</h1><p>Computer: $(HtmlEncode $env:COMPUTERNAME)</p><p>Created: $(Get-Date -Format 'dd.MM.yyyy HH:mm:ss')</p></div>")
REMHTML   $parts.Add("<section><h2>System Overview</h2><div class='meta'>$meta</div></section>")
REMHTML   $parts.Add((Html-Table 'CPU' ($cpu | Select-Object Name,Manufacturer,NumberOfCores,NumberOfLogicalProcessors,MaxClockSpeed,CurrentClockSpeed,LoadPercentage)))
REMHTML   $parts.Add((Html-Table 'RAM Modules' ($ram | Select-Object BankLabel,DeviceLocator,Manufacturer,PartNumber,Speed,ConfiguredClockSpeed,@{N='Capacity_GB';E={[math]::Round($_.Capacity/1GB,2)}})))
REMHTML   $parts.Add((Html-Table 'Graphics' ($gpu | Select-Object Name,DriverVersion,VideoProcessor,@{N='RAM_GB';E={if($_.AdapterRAM){[math]::Round($_.AdapterRAM/1GB,2)}else{'n/a'}}})))
REMHTML   $parts.Add((Html-Table 'Physical Disks' ($physical | Select-Object FriendlyName,MediaType,BusType,HealthStatus,OperationalStatus,@{N='Size_GB';E={[math]::Round($_.Size/1GB,1)}})))
REMHTML   $parts.Add((Html-Table 'Drives' ($logical | Select-Object DeviceID,VolumeName,FileSystem,@{N='Size_GB';E={[math]::Round($_.Size/1GB,1)}},@{N='Free_GB';E={[math]::Round($_.FreeSpace/1GB,1)}},@{N='Free_Percent';E={[math]::Round(($_.FreeSpace/$_.Size)*100,1)}})))
REMHTML   $parts.Add((Html-Table 'Network Adapters' ($net | Select-Object Name,InterfaceDescription,Status,LinkSpeed,MacAddress)))
REMHTML   $parts.Add((Html-Table 'IP Configuration' ($ip | Select-Object InterfaceAlias,InterfaceDescription,IPv4Address,IPv4DefaultGateway,DNSServer)))
REMHTML   $parts.Add((Html-Table 'Top 20 Processes by RAM' $topRam))
REMHTML   $parts.Add((Html-Table 'Top 20 Processes by CPU Time' $topCpu))
REMHTML   $parts.Add((Html-Table 'Startup' $startup))
REMHTML   $parts.Add((Html-Table 'Automatic Services Not Running' $badSvc))
REMHTML   $parts.Add((Html-Table 'Device Manager Errors' $badDev))
REMHTML   $parts.Add((Html-Table 'System Errors / Critical Events - Last 24 Hours' $sysEv))
REMHTML   $parts.Add((Html-Table 'Application Errors / Critical Events - Last 24 Hours' $appEv))
REMHTML   $parts.Add("<section><p class='muted'>Note: This report is a technical snapshot. Individual events or stopped services do not automatically indicate a defect.</p></section>")
REMHTML   $parts.Add('</div></body></html>')
REMHTML   Set-Content -Path $htmlFile -Value ($parts -join [Environment]::NewLine) -Encoding UTF8
REMHTML   Write-Host ''
REMHTML   Write-Host ('HTML report created: ' + $htmlFile)
REMHTML   Start-Process $htmlFile
REMHTML   exit 0
REMHTML }
REMHTML catch {
REMHTML   Write-Host ''
REMHTML   Write-Host 'HTML REPORT ERROR:'
REMHTML   Write-Host $_.Exception.Message
REMHTML   Write-Host ''
REMHTML   Write-Host ('Position: ' + $_.InvocationInfo.PositionMessage)
REMHTML   exit 1
REMHTML }
REMHTML_END

:: ============================================================================
:: Embedded PowerShell module for the health check.
:: The following lines are extracted when the health check starts.
:: ============================================================================

REMPS_BEGIN
REMPS param([Parameter(Mandatory=$true)][string]$ReportDir)
REMPS $ErrorActionPreference = 'SilentlyContinue'
REMPS if(-not (Test-Path $ReportDir)){ New-Item -ItemType Directory -Path $ReportDir -Force | Out-Null }
REMPS $stamp = Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'
REMPS $htmlFile = Join-Path $ReportDir ("PC_Healthcheck_{0}_{1}.html" -f $env:COMPUTERNAME,$stamp)
REMPS $txtFile  = Join-Path $ReportDir ("PC_Healthcheck_{0}_{1}.txt" -f $env:COMPUTERNAME,$stamp)
REMPS $results = [System.Collections.Generic.List[object]]::new()
REMPS function Add-Result([string]$Status,[string]$Check,[string]$Message,[string]$Detail=''){
REMPS   $results.Add([pscustomobject]@{Status=$Status;Check=$Check;Message=$Message;Detail=$Detail}) | Out-Null
REMPS }
REMPS function Worst-Status {
REMPS   if($results.Status -contains 'RED'){ return 'RED' }
REMPS   if($results.Status -contains 'YELLOW'){ return 'YELLOW' }
REMPS   return 'GREEN'
REMPS }
REMPS Write-Host ''
REMPS Write-Host '======================================================================='
REMPS Write-Host ' PC-HEALTH CHECK'
REMPS Write-Host '======================================================================='
REMPS Write-Host ''
REMPS # System / Uptime
REMPS $os = Get-CimInstance Win32_OperatingSystem
REMPS $uptimeDays = [math]::Round(((Get-Date)-$os.LastBootUpTime).TotalDays,1)
REMPS if($uptimeDays -ge 60){ Add-Result 'RED' 'System uptime' "PC has been running for $uptimeDays days without a restart." 'Restart recommended soon.' }
REMPS elseif($uptimeDays -ge 30){ Add-Result 'YELLOW' 'System uptime' "PC has been running for $uptimeDays days without a restart." 'A restart is recommended.' }
REMPS else { Add-Result 'GREEN' 'System uptime' "Last restart was $uptimeDays days ago." }
REMPS # Pending reboot
REMPS $pending = $false
REMPS $rebootKeys = @(
REMPS   'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending',
REMPS   'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired'
REMPS )
REMPS foreach($k in $rebootKeys){ if(Test-Path $k){$pending=$true} }
REMPS $pfro=(Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Name PendingFileRenameOperations -ErrorAction SilentlyContinue).PendingFileRenameOperations
REMPS if($pfro){$pending=$true}
REMPS if($pending){ Add-Result 'YELLOW' 'Pending restart' 'Windows reports a pending restart.' 'Restart Windows.' } else { Add-Result 'GREEN' 'Pending restart' 'No pending restart detected.' }
REMPS # Disk health
REMPS $pdisks = Get-PhysicalDisk
REMPS if($pdisks){
REMPS   foreach($d in $pdisks){
REMPS     $name=$d.FriendlyName
REMPS     if($d.HealthStatus -eq 'Healthy' -and ($d.OperationalStatus -contains 'OK')){ Add-Result 'GREEN' "Disk: $name" 'Windows reports the disk as healthy.' }
REMPS     elseif($d.HealthStatus -eq 'Healthy'){ Add-Result 'YELLOW' "Disk: $name" "HealthStatus=$($d.HealthStatus), OperationalStatus=$($d.OperationalStatus -join ', ')." 'Check the disk in more detail.' }
REMPS     else { Add-Result 'RED' "Disk: $name" "HealthStatus=$($d.HealthStatus), OperationalStatus=$($d.OperationalStatus -join ', ')." 'Back up data and inspect the disk immediately.' }
REMPS   }
REMPS } else { Add-Result 'YELLOW' 'Disk health' 'Get-PhysicalDisk returned no data.' 'SMART ggf. mit Manufacturertool oder CrystalDiskInfo pruefen.' }
REMPS # Free space
REMPS $vols=Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"
REMPS foreach($v in $vols){
REMPS   if(-not $v.Size){continue}
REMPS   $freePct=[math]::Round(($v.FreeSpace/$v.Size)*100,1)
REMPS   $freeGB=[math]::Round($v.FreeSpace/1GB,1)
REMPS   if($freePct -lt 5 -or $freeGB -lt 5){ Add-Result 'RED' "Free space $($v.DeviceID)" "Only $freeGB GB ($freePct %) free." 'Free up disk space urgently.' }
REMPS   elseif($freePct -lt 15 -or $freeGB -lt 15){ Add-Result 'YELLOW' "Free space $($v.DeviceID)" "$freeGB GB ($freePct %) free." 'Monitor or clean up disk space.' }
REMPS   else { Add-Result 'GREEN' "Free space $($v.DeviceID)" "$freeGB GB ($freePct %) free." }
REMPS }
REMPS # RAM
REMPS $totalKB=[double]$os.TotalVisibleMemorySize
REMPS $freeKB=[double]$os.FreePhysicalMemory
REMPS if($totalKB -gt 0){
REMPS   $usedPct=[math]::Round((1-($freeKB/$totalKB))*100,1)
REMPS   $freeGB=[math]::Round($freeKB/1MB,2)
REMPS   if($usedPct -ge 95){ Add-Result 'RED' 'RAM utilization' "$usedPct % used, approx. $freeGB GB free." 'Very high memory utilization.' }
REMPS   elseif($usedPct -ge 85){ Add-Result 'YELLOW' 'RAM utilization' "$usedPct % used, approx. $freeGB GB free." 'Monitor memory utilization.' }
REMPS   else { Add-Result 'GREEN' 'RAM utilization' "$usedPct % used, approx. $freeGB GB free." }
REMPS }
REMPS # Windows Update services
REMPS foreach($svcName in @('wuauserv','BITS')){
REMPS   $svc=Get-Service $svcName -ErrorAction SilentlyContinue
REMPS   if(-not $svc){ Add-Result 'YELLOW' "Service $svcName" 'Service nicht gefunden.' }
REMPS   elseif($svc.Status -eq 'Running'){ Add-Result 'GREEN' "Service $svcName" 'Service laeuft.' }
REMPS   else {
REMPS     $cim=Get-CimInstance Win32_Service -Filter "Name='$svcName'"
REMPS     if($cim.StartMode -eq 'Disabled'){ Add-Result 'RED' "Service $svcName" 'Service ist deaktiviert.' 'Windows Update may be affected.' }
REMPS     else { Add-Result 'YELLOW' "Service $svcName" "Status: $($svc.Status), Startup type: $($cim.StartMode)." }
REMPS   }
REMPS }
REMPS # Automatic services not running
REMPS $badSvcs=Get-CimInstance Win32_Service | Where-Object { $_.StartMode -eq 'Auto' -and $_.State -ne 'Running' -and $_.Name -notin @('MapsBroker','sppsvc','WbioSrvc','edgeupdate','edgeupdatem') }
REMPS $badCount=@($badSvcs).Count
REMPS if($badCount -ge 5){ Add-Result 'YELLOW' 'Automatic services' "$badCount automatic services are not running." (($badSvcs | Select-Object -First 10 -ExpandProperty Name) -join ', ') }
REMPS elseif($badCount -gt 0){ Add-Result 'YELLOW' 'Automatic services' "$badCount automatic services are not running." (($badSvcs | Select-Object -First 10 -ExpandProperty Name) -join ', ') }
REMPS else { Add-Result 'GREEN' 'Automatic services' 'No suspicious automatic services detected.' }
REMPS # Device manager errors
REMPS $badDevices=Get-CimInstance Win32_PnPEntity | Where-Object { $_.ConfigManagerErrorCode -ne 0 }
REMPS $devCount=@($badDevices).Count
REMPS if($devCount -gt 0){
REMPS   Add-Result 'RED' 'Device Manager' "$devCount devices with an error code detected." (($badDevices | Select-Object -First 10 | ForEach-Object {"$($_.Name) (Code $($_.ConfigManagerErrorCode))"}) -join '; ')
REMPS } else { Add-Result 'GREEN' 'Device Manager' 'No devices with a ConfigManager error code detected.' }
REMPS # Events last 24 hours
REMPS $since=(Get-Date).AddHours(-24)
REMPS $sysCritical=@(Get-WinEvent -FilterHashtable @{LogName='System';Level=1;StartTime=$since} -ErrorAction SilentlyContinue)
REMPS $sysErrors=@(Get-WinEvent -FilterHashtable @{LogName='System';Level=2;StartTime=$since} -ErrorAction SilentlyContinue)
REMPS if($sysCritical.Count -gt 0){ Add-Result 'RED' 'System events 24h' "$($sysCritical.Count) critical and $($sysErrors.Count) error events." (($sysCritical | Select-Object -First 5 | ForEach-Object {"ID $($_.Id) $($_.ProviderName)"}) -join ', ') }
REMPS elseif($sysErrors.Count -ge 20){ Add-Result 'YELLOW' 'System events 24h' "$($sysErrors.Count) error events in the last 24 hours." 'Review Event Viewer in more detail.' }
REMPS elseif($sysErrors.Count -gt 0){ Add-Result 'YELLOW' 'System events 24h' "$($sysErrors.Count) error events in the last 24 hours." }
REMPS else { Add-Result 'GREEN' 'System events 24h' 'No system errors or critical events in the last 24 hours.' }
REMPS $appCritical=@(Get-WinEvent -FilterHashtable @{LogName='Application';Level=1;StartTime=$since} -ErrorAction SilentlyContinue)
REMPS $appErrors=@(Get-WinEvent -FilterHashtable @{LogName='Application';Level=2;StartTime=$since} -ErrorAction SilentlyContinue)
REMPS if($appCritical.Count -gt 0){ Add-Result 'RED' 'Application events 24h' "$($appCritical.Count) critical and $($appErrors.Count) error events." }
REMPS elseif($appErrors.Count -ge 20){ Add-Result 'YELLOW' 'Application events 24h' "$($appErrors.Count) error events in the last 24 hours." }
REMPS elseif($appErrors.Count -gt 0){ Add-Result 'YELLOW' 'Application events 24h' "$($appErrors.Count) error events in the last 24 hours." }
REMPS else { Add-Result 'GREEN' 'Application events 24h' 'No application errors or critical events in the last 24 hours.' }
REMPS # Network gateway
REMPS $cfg=Get-NetIPConfiguration | Where-Object {$_.IPv4DefaultGateway -and $_.NetAdapter.Status -eq 'Up'} | Select-Object -First 1
REMPS if($cfg){
REMPS   $gw=$cfg.IPv4DefaultGateway.NextHop
REMPS   if(Test-Connection $gw -Count 1 -Quiet){ Add-Result 'GREEN' 'Default gateway' "Gateway $gw reachable." } else { Add-Result 'RED' 'Default gateway' "Gateway $gw nicht reachable." 'Check the local network.' }
REMPS } else { Add-Result 'RED' 'Default gateway' 'Kein aktives IPv4-Default gateway erkannt.' }
REMPS # DNS
REMPS try{
REMPS   $dns=Resolve-DnsName 'www.microsoft.com' -Type A -ErrorAction Stop
REMPS   if($dns){ Add-Result 'GREEN' 'DNS' 'DNS resolution is working.' }
REMPS } catch { Add-Result 'RED' 'DNS' 'DNS resolution failed.' $_.Exception.Message }
REMPS # Internet TCP 443 - avoids relying only on ICMP
REMPS try{
REMPS   $tcp=Test-NetConnection 'www.microsoft.com' -Port 443 -WarningAction SilentlyContinue
REMPS   if($tcp.TcpTestSucceeded){ Add-Result 'GREEN' 'Internet TCP/443' 'HTTPS connection to www.microsoft.com succeeded.' }
REMPS   else { Add-Result 'RED' 'Internet TCP/443' 'HTTPS connection to www.microsoft.com failed.' }
REMPS } catch { Add-Result 'RED' 'Internet TCP/443' 'Internet connectivity test failed.' $_.Exception.Message }
REMPS # Defender
REMPS $mp=Get-MpComputerStatus -ErrorAction SilentlyContinue
REMPS if($mp){
REMPS   if(-not $mp.AntivirusEnabled){ Add-Result 'RED' 'Microsoft Defender' 'Microsoft Defender Antivirus is disabled.' 'This can be normal if another antivirus product is installed.' }
REMPS   elseif(-not $mp.RealTimeProtectionEnabled){ Add-Result 'RED' 'Microsoft Defender' 'Real-time protection is disabled.' }
REMPS   else {
REMPS     $sigAge=$mp.AntivirusSignatureAge
REMPS     if($sigAge -gt 7){ Add-Result 'YELLOW' 'Microsoft Defender' "Real-time protection active, but signatures are $sigAge days old." 'Update antivirus signatures.' }
REMPS     else { Add-Result 'GREEN' 'Microsoft Defender' "Real-time protection active, signature age: $sigAge day(s)." }
REMPS   }
REMPS } else { Add-Result 'YELLOW' 'Microsoft Defender' 'Defender status could not be read.' 'Another antivirus product may be in use.' }
REMPS # Windows activation
REMPS try{
REMPS   $lic=Get-CimInstance SoftwareLicensingProduct | Where-Object {$_.PartialProductKey -and $_.Name -like 'Windows*'} | Select-Object -First 1
REMPS   if($lic.LicenseStatus -eq 1){ Add-Result 'GREEN' 'Windows activation' 'Windows is activated.' }
REMPS   else { Add-Result 'YELLOW' 'Windows activation' "LicenseStatus=$($lic.LicenseStatus)." 'Check activation status.' }
REMPS } catch { Add-Result 'YELLOW' 'Windows activation' 'Activation status could not be determined.' }
REMPS # CPU snapshot
REMPS $cpu=(Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average
REMPS if($null -ne $cpu){
REMPS   $cpu=[math]::Round($cpu,0)
REMPS   if($cpu -ge 95){ Add-Result 'RED' 'CPU utilization' "$cpu % snapshot." 'Very high CPU load.' }
REMPS   elseif($cpu -ge 80){ Add-Result 'YELLOW' 'CPU utilization' "$cpu % snapshot." 'High CPU load.' }
REMPS   else { Add-Result 'GREEN' 'CPU utilization' "$cpu % snapshot." }
REMPS }
REMPS # Overall
REMPS $overall=Worst-Status
REMPS $red=@($results | Where-Object Status -eq 'RED').Count
REMPS $yellow=@($results | Where-Object Status -eq 'YELLOW').Count
REMPS $green=@($results | Where-Object Status -eq 'GREEN').Count
REMPS Write-Host ('OVERALL STATUS: ' + $overall)
REMPS Write-Host ("GREEN: {0}   YELLOW: {1}   RED: {2}" -f $green,$yellow,$red)
REMPS Write-Host ''
REMPS foreach($r in $results){
REMPS   $prefix = switch($r.Status){'GREEN'{'[GREEN]'} 'YELLOW'{'[YELLOW ]'} 'RED'{'[RED  ]'}}
REMPS   Write-Host ("{0} {1}: {2}" -f $prefix,$r.Check,$r.Message)
REMPS   if($r.Detail){ Write-Host ('         -> ' + $r.Detail) }
REMPS }
REMPS # TXT
REMPS $lines=@()
REMPS $lines+='PC-HEALTH CHECK'
REMPS $lines+=('Computer: '+$env:COMPUTERNAME)
REMPS $lines+=('Date: '+(Get-Date))
REMPS $lines+=('Overall status: '+$overall)
REMPS $lines+=("GREEN: $green   YELLOW: $yellow   RED: $red")
REMPS $lines+=''
REMPS foreach($r in $results){$lines+=("[{0}] {1}: {2}" -f $r.Status,$r.Check,$r.Message); if($r.Detail){$lines+=('    '+$r.Detail)}}
REMPS Set-Content -Path $txtFile -Value $lines -Encoding UTF8
REMPS # HTML
REMPS $overallClass=$overall.ToLower()
REMPS $rows=foreach($r in $results){
REMPS   $cls=$r.Status.ToLower()
REMPS   "<tr><td><span class='badge $cls'>$($r.Status)</span></td><td>$([System.Net.WebUtility]::HtmlEncode($r.Check))</td><td>$([System.Net.WebUtility]::HtmlEncode($r.Message))</td><td>$([System.Net.WebUtility]::HtmlEncode($r.Detail))</td></tr>"
REMPS }
REMPS $css = @(
REMPS '<style>'
REMPS 'body{font-family:Segoe UI,Arial,sans-serif;margin:28px;background:#f3f4f6;color:#1f2937}'
REMPS '.card{background:white;border-radius:12px;padding:20px;margin-bottom:20px;box-shadow:0 2px 8px #00000018}'
REMPS 'h1{margin-top:0}.summary{font-size:20px}.badge{padding:4px 10px;border-radius:999px;font-weight:700;color:white;display:inline-block;min-width:62px;text-align:center}'
REMPS '.gruen{background:#15803d}.gelb{background:#ca8a04}.rot{background:#b91c1c}'
REMPS 'table{width:100%;border-collapse:collapse;background:white}th,td{border-bottom:1px solid #ddd;padding:10px;text-align:left;vertical-align:top}th{background:#e5e7eb}'
REMPS '.small{color:#6b7280;font-size:13px}'
REMPS '</style>'
REMPS ) -join [Environment]::NewLine
REMPS $html = @(
REMPS '<!doctype html><html><head><meta charset="utf-8"><title>PC Healthcheck</title>'
REMPS $css
REMPS '</head><body>'
REMPS "<div class='card'><h1>PC-Gesamtcheck - $env:COMPUTERNAME</h1>"
REMPS "<div class='summary'>Overall status: <span class='badge $overallClass'>$overall</span></div>"
REMPS "<p>GREEN: $green &nbsp;&nbsp; YELLOW: $yellow &nbsp;&nbsp; RED: $red</p>"
REMPS "<div class='small'>Created: $(Get-Date)</div></div>"
REMPS "<div class='card'><table><thead><tr><th>Status</th><th>Check</th><th>Result</th><th>Note</th></tr></thead><tbody>"
REMPS ($rows -join [Environment]::NewLine)
REMPS '</tbody></table></div>'
REMPS '<div class="card small">Note: Der Gesamtcheck ist eine Schnellbewertung. Einzelne gelbe Meldungen sind nicht automatisch ein Defekt. SMART-, Temperatur- und Sicherheitsdaten koennen je nach Hardware, Treibern und eingesetzter Sicherheitssoftware unvollstaendig sein.</div>'
REMPS '</body></html>'
REMPS ) -join [Environment]::NewLine
REMPS Set-Content -Path $htmlFile -Value $html -Encoding UTF8
REMPS Write-Host ''
REMPS Write-Host ('TXT report : ' + $txtFile)
REMPS Write-Host ('HTML report: ' + $htmlFile)
REMPS Start-Process $htmlFile
REMPS exit 0
REMPS_END