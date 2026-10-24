@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 >nul
title Daily Windows Toolkit - Extended Health Edition
color 0B

:: ================================================================
:: DAILY WINDOWS TOOLKIT - EXTENDED HEALTH EDITION
:: Windows 10 / 11
:: ================================================================

:: ---------- Adminrechte sicherstellen ----------
net session >nul 2>&1
if not "%errorlevel%"=="0" (
    echo Administratorrechte werden angefordert...
    powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
      "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

:: ---------- Arbeitsverzeichnis fuer Reports ----------
set "REPORTDIR=%USERPROFILE%\Desktop\Windows_Diagnostics"
if not exist "%REPORTDIR%" mkdir "%REPORTDIR%" >nul 2>&1

:MENU
cls
echo ============================================================================
echo                DAILY WINDOWS TOOLKIT - EXTENDED HEALTH EDITION
echo ============================================================================
echo.
echo  GESAMTCHECK
echo  -----------
echo   0. PC-Gesamtcheck mit Ampelsystem
echo.
echo  WINDOWS / REPARATUR
echo  ------------------
echo   1. Windows Update oeffnen
echo   2. Windows-Update-Dienste pruefen
echo   3. Windows-Update-Dienste neu starten
echo   4. Windows-Update-Downloadcache leeren
echo   5. SFC Systemdateipruefung starten
echo   6. DISM Component Store pruefen
echo   7. DISM Component Store reparieren
echo   8. Windows-Aktivierungsstatus anzeigen
echo.
echo  NETZWERK
echo  --------
echo   9. WLAN-Profile anzeigen
echo  10. WLAN-Treiberinformationen anzeigen
echo  11. Netzwerkinterfaces / IP-Konfiguration anzeigen
echo  12. Routingtabelle anzeigen
echo  13. DNS-Aufloesung testen
echo  14. Netzwerkroute verfolgen
echo  15. Ping-Test
echo  16. Port-Test (TCP)
echo  17. DNS-Cache anzeigen
echo  18. DNS-Cache leeren
echo  19. Winsock / TCP-IP Reset vorbereiten
echo.
echo  SPEICHER / HARDWARE
echo  -------------------
echo  20. Laufwerk C: mit CHKDSK /scan pruefen
echo  21. Speicherbelegung analysieren
echo  22. SMART / Datentraegerzustand anzeigen
echo  23. Physische Datentraeger anzeigen
echo  24. RAM-Informationen anzeigen
echo  25. CPU-Informationen anzeigen
echo  26. GPU-Informationen anzeigen
echo  27. Temperaturen anzeigen (soweit verfuegbar)
echo.
echo  PERFORMANCE / FEHLERSUCHE
echo  -------------------------
echo  28. Prozesse mit hoher CPU-Last anzeigen
echo  29. Prozesse mit hohem RAM-Verbrauch anzeigen
echo  30. Autostart-Eintraege anzeigen
echo  31. Dienste mit Fehlerstatus anzeigen
echo  32. Kritische Systemereignisse der letzten 24h
echo  33. Kritische Anwendungsereignisse der letzten 24h
echo  34. Windows-Zuverlaessigkeitsmonitor oeffnen
echo  35. Ressourcenmonitor oeffnen
echo  36. Task-Manager oeffnen
echo.
echo  WINDOWS-WERKZEUGE
echo  -----------------
echo  37. Speichereinstellungen oeffnen
echo  38. Datentraegerverwaltung oeffnen
echo  39. Autostart-Apps oeffnen
echo  40. Aufgabenplanung oeffnen
echo  41. Ereignisanzeige oeffnen
echo  42. Geraetemanager oeffnen
echo.
echo  DIAGNOSEBERICHT
echo  ---------------
echo  43. Kompletten TXT-Diagnosebericht erstellen
echo  44. Kompletten HTML-Diagnosebericht erstellen
echo  45. Report-Ordner oeffnen
echo.
echo  ----------------------------------------------------------------------------
echo   R. Menue aktualisieren
echo   Q. Beenden
echo  ----------------------------------------------------------------------------
echo.

set /p "choice=Auswahl: "

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
echo Ungueltige Auswahl.
timeout /t 2 >nul
goto MENU

:: ================================================================
:: GESAMTCHECK
:: ================================================================

:HEALTHCHECK
cls
echo ============================================================================
echo PC-GESAMTCHECK MIT AMPELSYSTEM
echo ============================================================================
echo.
echo Der Check prueft u.a.:
echo - Datentraegerzustand und freien Speicher
echo - RAM-Auslastung
echo - Systemlaufzeit / ausstehenden Neustart
echo - Windows-Update-Dienste
echo - automatische Dienste
echo - Geraetemanager-Fehler
echo - System- und Anwendungsfehler der letzten 24 Stunden
echo - Netzwerk / DNS / Internet-Grundfunktion
echo - Windows Defender soweit verfuegbar
echo.
echo Es werden KEINE Reparaturen automatisch ausgefuehrt.
echo.
echo Bitte warten...
echo.

set "TMPPS=%TEMP%\WindowsToolkitHealth_%RANDOM%.ps1"

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
  "$src=Get-Content -LiteralPath '%~f0'; $start=($src | Select-String '^REMPS_BEGIN$').LineNumber; $end=($src | Select-String '^REMPS_END$').LineNumber; if(-not $start -or -not $end){exit 10}; $code=$src[$start..($end-2)] | ForEach-Object { $_ -replace '^REMPS ?','' }; Set-Content -LiteralPath '%TMPPS%' -Value $code -Encoding UTF8"

if not exist "%TMPPS%" (
    echo Fehler: Health-Check-Modul konnte nicht extrahiert werden.
    goto PAUSE_RETURN
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%TMPPS%" -ReportDir "%REPORTDIR%"
set "HCERR=%errorlevel%"
del /q "%TMPPS%" >nul 2>&1

echo.
if "%HCERR%"=="0" (
    echo Gesamtcheck abgeschlossen.
) else (
    echo Der Gesamtcheck wurde mit Fehlercode %HCERR% beendet.
)
goto PAUSE_RETURN

:: ================================================================
:: WINDOWS / REPARATUR
:: ================================================================

:UPDATE_OPEN
start "" ms-settings:windowsupdate
goto RETURN

:UPDATE_CHECK
cls
echo ============================================================================
echo WINDOWS-UPDATE-DIENSTE
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
echo WINDOWS-UPDATE-DIENSTE NEU STARTEN
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
echo Vorgang abgeschlossen.
goto PAUSE_RETURN

:UPDATE_CACHE
cls
echo ============================================================================
echo WINDOWS-UPDATE-DOWNLOADCACHE LEEREN
echo ============================================================================
echo.
echo Dies entfernt nur bereits heruntergeladene Update-Dateien.
echo Installierte Updates werden NICHT deinstalliert.
echo.
choice /C JN /N /M "Fortfahren? [J/N]: "
if errorlevel 2 goto MENU
net stop wuauserv /y
net stop bits /y
del /f /s /q "%windir%\SoftwareDistribution\Download\*" >nul 2>&1
for /d %%D in ("%windir%\SoftwareDistribution\Download\*") do rd /s /q "%%D" >nul 2>&1
net start bits
net start wuauserv
echo.
echo Downloadcache wurde geleert.
goto PAUSE_RETURN

:SFC_SCAN
cls
echo ============================================================================
echo SFC SYSTEMDATEIPRUEFUNG
echo ============================================================================
echo.
sfc /scannow
goto PAUSE_RETURN

:DISM_CHECK
cls
echo ============================================================================
echo DISM COMPONENT STORE PRUEFEN
echo ============================================================================
echo.
DISM /Online /Cleanup-Image /ScanHealth
goto PAUSE_RETURN

:DISM_REPAIR
cls
echo ============================================================================
echo DISM COMPONENT STORE REPARIEREN
echo ============================================================================
echo.
choice /C JN /N /M "Reparatur starten? [J/N]: "
if errorlevel 2 goto MENU
DISM /Online /Cleanup-Image /RestoreHealth
goto PAUSE_RETURN

:ACTIVATION
cls
echo ============================================================================
echo WINDOWS-AKTIVIERUNG
echo ============================================================================
echo.
cscript //nologo "%windir%\system32\slmgr.vbs" /xpr
echo.
cscript //nologo "%windir%\system32\slmgr.vbs" /dli
goto PAUSE_RETURN

:: ================================================================
:: NETZWERK
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
set /p "traceTarget=Ziel [1.1.1.1]: "
if not defined traceTarget set "traceTarget=1.1.1.1"
tracert "%traceTarget%"
goto PAUSE_RETURN

:PING_TEST
cls
set "pingTarget="
set /p "pingTarget=Ziel [1.1.1.1]: "
if not defined pingTarget set "pingTarget=1.1.1.1"
set "pingCount="
set /p "pingCount=Anzahl Pings [10]: "
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
echo ACHTUNG: Netzwerkstack wird zurueckgesetzt. Neustart empfohlen.
echo.
choice /C JN /N /M "Reset wirklich ausfuehren? [J/N]: "
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
  "Get-CimInstance Win32_LogicalDisk -Filter \"DriveType=3\" | ForEach-Object { [PSCustomObject]@{Laufwerk=$_.DeviceID;Gesamt_GB=[math]::Round($_.Size/1GB,1);Frei_GB=[math]::Round($_.FreeSpace/1GB,1);Belegt_Prozent=[math]::Round((1-($_.FreeSpace/$_.Size))*100,1)} } | Format-Table -AutoSize"
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
powershell.exe -NoProfile -Command "$cs=Get-CimInstance Win32_ComputerSystem; Write-Host ('Installierter RAM: {0:N2} GB' -f ($cs.TotalPhysicalMemory/1GB)); Get-CimInstance Win32_PhysicalMemory | Select BankLabel,DeviceLocator,Manufacturer,PartNumber,Speed,ConfiguredClockSpeed,@{N='CapacityGB';E={[math]::Round($_.Capacity/1GB,2)}} | Format-Table -AutoSize"
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
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$t=Get-CimInstance -Namespace root/wmi -ClassName MSAcpi_ThermalZoneTemperature -ErrorAction SilentlyContinue; if($t){$t | ForEach-Object {[PSCustomObject]@{Sensor=$_.InstanceName;Celsius=[math]::Round(($_.CurrentTemperature/10)-273.15,1)}} | Format-Table -AutoSize}else{Write-Host 'Keine ACPI-Temperatursensoren verfuegbar.'}"
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
:: WINDOWS-WERKZEUGE
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
echo KOMPLETTER TXT-DIAGNOSEBERICHT
echo ============================================================================
echo.
set "TXTREPORT=%REPORTDIR%\Windows_Diagnose_%COMPUTERNAME%_%RANDOM%.txt"
echo Bericht wird erstellt...
echo Ziel: %TXTREPORT%
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
  "$out='%TXTREPORT%';" ^
  "$os=Get-CimInstance Win32_OperatingSystem; $cs=Get-CimInstance Win32_ComputerSystem; $bios=Get-CimInstance Win32_BIOS;" ^
  "function Sec([string]$t){Add-Content $out ''; Add-Content $out ('='*78); Add-Content $out ('  '+$t); Add-Content $out ('='*78)};" ^
  "function Tab($x){if($null -eq $x -or @($x).Count -eq 0){Add-Content $out 'Keine Daten / keine Auffaelligkeiten.'}else{($x|Format-Table -AutoSize|Out-String -Width 220).TrimEnd()|Add-Content $out}};" ^
  "function Lst($x){if($null -eq $x -or @($x).Count -eq 0){Add-Content $out 'Keine Daten / keine Auffaelligkeiten.'}else{($x|Format-List|Out-String -Width 220).TrimEnd()|Add-Content $out}};" ^
  "@('WINDOWS DIAGNOSEBERICHT',('Computer : '+$env:COMPUTERNAME),('Erstellt : '+(Get-Date -Format 'dd.MM.yyyy HH:mm:ss'))) | Set-Content $out -Encoding UTF8;" ^
  "Sec 'SYSTEM'; Lst ([pscustomobject]@{Computer=$env:COMPUTERNAME;Benutzer=$env:USERNAME;Hersteller=$cs.Manufacturer;Modell=$cs.Model;Windows=$os.Caption;Version=$os.Version;Build=$os.BuildNumber;Architektur=$os.OSArchitecture;Installiert=$os.InstallDate;Letzter_Start=$os.LastBootUpTime;Laufzeit_Tage=[math]::Round(((Get-Date)-$os.LastBootUpTime).TotalDays,1);RAM_GB=[math]::Round($cs.TotalPhysicalMemory/1GB,2);BIOS=$bios.SMBIOSBIOSVersion;BIOS_Datum=$bios.ReleaseDate});" ^
  "Sec 'CPU'; Lst (Get-CimInstance Win32_Processor|Select Name,Manufacturer,NumberOfCores,NumberOfLogicalProcessors,MaxClockSpeed,CurrentClockSpeed,LoadPercentage);" ^
  "Sec 'RAM-MODULE'; Tab (Get-CimInstance Win32_PhysicalMemory|Select BankLabel,DeviceLocator,Manufacturer,PartNumber,Speed,ConfiguredClockSpeed,@{N='Kapazitaet_GB';E={[math]::Round($_.Capacity/1GB,2)}});" ^
  "Sec 'GRAFIK'; Tab (Get-CimInstance Win32_VideoController|Select Name,DriverVersion,VideoProcessor,@{N='RAM_GB';E={if($_.AdapterRAM){[math]::Round($_.AdapterRAM/1GB,2)}else{'n/a'}}});" ^
  "Sec 'PHYSISCHE DATENTRAEGER'; Tab (Get-PhysicalDisk|Select FriendlyName,MediaType,BusType,HealthStatus,OperationalStatus,@{N='Groesse_GB';E={[math]::Round($_.Size/1GB,1)}});" ^
  "Sec 'LAUFWERKE'; Tab (Get-CimInstance Win32_LogicalDisk -Filter \"DriveType=3\"|Select DeviceID,VolumeName,FileSystem,@{N='Groesse_GB';E={[math]::Round($_.Size/1GB,1)}},@{N='Frei_GB';E={[math]::Round($_.FreeSpace/1GB,1)}},@{N='Frei_Prozent';E={[math]::Round(($_.FreeSpace/$_.Size)*100,1)}});" ^
  "Sec 'NETZWERKADAPTER'; Tab (Get-NetAdapter|Select Name,InterfaceDescription,Status,LinkSpeed,MacAddress);" ^
  "Sec 'IP-KONFIGURATION'; Lst (Get-NetIPConfiguration|Select InterfaceAlias,InterfaceDescription,IPv4Address,IPv4DefaultGateway,DNSServer);" ^
  "Sec 'TOP 20 PROZESSE NACH RAM'; Tab (Get-Process|Sort WorkingSet64 -Descending|Select -First 20 ProcessName,Id,@{N='RAM_MB';E={[math]::Round($_.WorkingSet64/1MB,1)}},@{N='CPU_s';E={if($_.CPU){[math]::Round($_.CPU,1)}else{0}}});" ^
  "Sec 'TOP 20 PROZESSE NACH CPU-ZEIT'; Tab (Get-Process|Sort CPU -Descending|Select -First 20 ProcessName,Id,@{N='CPU_s';E={if($_.CPU){[math]::Round($_.CPU,1)}else{0}}},@{N='RAM_MB';E={[math]::Round($_.WorkingSet64/1MB,1)}});" ^
  "Sec 'AUTOSTART'; Tab (Get-CimInstance Win32_StartupCommand|Select Name,Command,Location,User);" ^
  "Sec 'AUTOMATISCHE DIENSTE, DIE NICHT LAUFEN'; Tab (Get-CimInstance Win32_Service|Where {$_.StartMode -eq 'Auto' -and $_.State -ne 'Running'}|Select Name,DisplayName,State,StartMode,ExitCode);" ^
  "Sec 'GERAETEMANAGER-FEHLER'; Tab (Get-CimInstance Win32_PnPEntity|Where {$_.ConfigManagerErrorCode -ne 0}|Select Name,PNPDeviceID,ConfigManagerErrorCode);" ^
  "$since=(Get-Date).AddHours(-24);" ^
  "Sec 'SYSTEMFEHLER / KRITISCHE EREIGNISSE - LETZTE 24 STUNDEN'; Lst (Get-WinEvent -FilterHashtable @{LogName='System';Level=1,2;StartTime=$since} -ErrorAction SilentlyContinue|Select -First 50 TimeCreated,Id,ProviderName,LevelDisplayName,Message);" ^
  "Sec 'ANWENDUNGSFEHLER / KRITISCHE EREIGNISSE - LETZTE 24 STUNDEN'; Lst (Get-WinEvent -FilterHashtable @{LogName='Application';Level=1,2;StartTime=$since} -ErrorAction SilentlyContinue|Select -First 50 TimeCreated,Id,ProviderName,LevelDisplayName,Message)"

echo.
echo TXT-Bericht wurde erstellt.
start "" notepad.exe "%TXTREPORT%"
goto PAUSE_RETURN

:REPORT_HTML
cls
echo ============================================================================
echo KOMPLETTER HTML-DIAGNOSEBERICHT
echo ============================================================================
echo.
echo Der Bericht wird erstellt...
echo.

set "TMPHTMLPS=%TEMP%\WindowsToolkitHTML_%RANDOM%.ps1"

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
  "$src=Get-Content -LiteralPath '%~f0'; $start=($src | Select-String '^REMHTML_BEGIN$').LineNumber; $end=($src | Select-String '^REMHTML_END$').LineNumber; if(-not $start -or -not $end){exit 10}; $code=$src[$start..($end-2)] | ForEach-Object { $_ -replace '^REMHTML ?','' }; Set-Content -LiteralPath '%TMPHTMLPS%' -Value $code -Encoding UTF8"

if not exist "%TMPHTMLPS%" (
    echo.
    echo FEHLER: HTML-Report-Modul konnte nicht extrahiert werden.
    echo.
    pause
    goto MENU
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%TMPHTMLPS%" -ReportDir "%REPORTDIR%"
set "HTMLERR=%errorlevel%"

del /q "%TMPHTMLPS%" >nul 2>&1

echo.
if "%HTMLERR%"=="0" (
    echo HTML-Bericht wurde erfolgreich erstellt.
) else (
    echo FEHLER beim Erstellen des HTML-Berichts.
    echo PowerShell-Fehlercode: %HTMLERR%
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
REMHTML     return "<section><h2>$(HtmlEncode $Title)</h2><p class='muted'>Keine Daten / keine Auffaelligkeiten.</p></section>"
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
REMHTML     "<div><b>Benutzer</b> $(HtmlEncode $env:USERNAME)</div>"
REMHTML     "<div><b>Windows</b> $(HtmlEncode $os.Caption)</div>"
REMHTML     "<div><b>Version</b> $(HtmlEncode $os.Version) / Build $(HtmlEncode $os.BuildNumber)</div>"
REMHTML     "<div><b>Architektur</b> $(HtmlEncode $os.OSArchitecture)</div>"
REMHTML     "<div><b>Hersteller</b> $(HtmlEncode $cs.Manufacturer)</div>"
REMHTML     "<div><b>Modell</b> $(HtmlEncode $cs.Model)</div>"
REMHTML     "<div><b>RAM</b> $([math]::Round($cs.TotalPhysicalMemory/1GB,2)) GB</div>"
REMHTML     "<div><b>Laufzeit</b> $uptimeDays Tage</div>"
REMHTML     "<div><b>BIOS</b> $(HtmlEncode $bios.SMBIOSBIOSVersion)</div>"
REMHTML   ) -join [Environment]::NewLine
REMHTML   $parts = [System.Collections.Generic.List[string]]::new()
REMHTML   $parts.Add("<!doctype html><html><head><meta charset='utf-8'><title>Windows Diagnosebericht</title>$style</head><body><div class='wrap'>")
REMHTML   $parts.Add("<div class='hero'><h1>Windows Diagnosebericht</h1><p>Computer: $(HtmlEncode $env:COMPUTERNAME)</p><p>Erstellt: $(Get-Date -Format 'dd.MM.yyyy HH:mm:ss')</p></div>")
REMHTML   $parts.Add("<section><h2>Systemuebersicht</h2><div class='meta'>$meta</div></section>")
REMHTML   $parts.Add((Html-Table 'CPU' ($cpu | Select-Object Name,Manufacturer,NumberOfCores,NumberOfLogicalProcessors,MaxClockSpeed,CurrentClockSpeed,LoadPercentage)))
REMHTML   $parts.Add((Html-Table 'RAM-Module' ($ram | Select-Object BankLabel,DeviceLocator,Manufacturer,PartNumber,Speed,ConfiguredClockSpeed,@{N='Kapazitaet_GB';E={[math]::Round($_.Capacity/1GB,2)}})))
REMHTML   $parts.Add((Html-Table 'Grafik' ($gpu | Select-Object Name,DriverVersion,VideoProcessor,@{N='RAM_GB';E={if($_.AdapterRAM){[math]::Round($_.AdapterRAM/1GB,2)}else{'n/a'}}})))
REMHTML   $parts.Add((Html-Table 'Physische Datentraeger' ($physical | Select-Object FriendlyName,MediaType,BusType,HealthStatus,OperationalStatus,@{N='Groesse_GB';E={[math]::Round($_.Size/1GB,1)}})))
REMHTML   $parts.Add((Html-Table 'Laufwerke' ($logical | Select-Object DeviceID,VolumeName,FileSystem,@{N='Groesse_GB';E={[math]::Round($_.Size/1GB,1)}},@{N='Frei_GB';E={[math]::Round($_.FreeSpace/1GB,1)}},@{N='Frei_Prozent';E={[math]::Round(($_.FreeSpace/$_.Size)*100,1)}})))
REMHTML   $parts.Add((Html-Table 'Netzwerkadapter' ($net | Select-Object Name,InterfaceDescription,Status,LinkSpeed,MacAddress)))
REMHTML   $parts.Add((Html-Table 'IP-Konfiguration' ($ip | Select-Object InterfaceAlias,InterfaceDescription,IPv4Address,IPv4DefaultGateway,DNSServer)))
REMHTML   $parts.Add((Html-Table 'Top 20 Prozesse nach RAM' $topRam))
REMHTML   $parts.Add((Html-Table 'Top 20 Prozesse nach CPU-Zeit' $topCpu))
REMHTML   $parts.Add((Html-Table 'Autostart' $startup))
REMHTML   $parts.Add((Html-Table 'Automatische Dienste, die nicht laufen' $badSvc))
REMHTML   $parts.Add((Html-Table 'Geraetemanager-Fehler' $badDev))
REMHTML   $parts.Add((Html-Table 'Systemfehler / kritische Ereignisse - letzte 24 Stunden' $sysEv))
REMHTML   $parts.Add((Html-Table 'Anwendungsfehler / kritische Ereignisse - letzte 24 Stunden' $appEv))
REMHTML   $parts.Add("<section><p class='muted'>Hinweis: Der Bericht ist eine technische Momentaufnahme. Einzelne Ereignisse oder gestoppte Dienste sind nicht automatisch ein Defekt.</p></section>")
REMHTML   $parts.Add('</div></body></html>')
REMHTML   Set-Content -Path $htmlFile -Value ($parts -join [Environment]::NewLine) -Encoding UTF8
REMHTML   Write-Host ''
REMHTML   Write-Host ('HTML-Bericht erstellt: ' + $htmlFile)
REMHTML   Start-Process $htmlFile
REMHTML   exit 0
REMHTML }
REMHTML catch {
REMHTML   Write-Host ''
REMHTML   Write-Host 'FEHLER BEIM HTML-REPORT:'
REMHTML   Write-Host $_.Exception.Message
REMHTML   Write-Host ''
REMHTML   Write-Host ('Position: ' + $_.InvocationInfo.PositionMessage)
REMHTML   exit 1
REMHTML }
REMHTML_END

:: ============================================================================
:: Eingebettetes PowerShell-Modul fuer den Gesamtcheck.
:: Die folgenden Zeilen werden beim Start des Gesamtchecks extrahiert.
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
REMPS   if($results.Status -contains 'ROT'){ return 'ROT' }
REMPS   if($results.Status -contains 'GELB'){ return 'GELB' }
REMPS   return 'GRUEN'
REMPS }
REMPS Write-Host ''
REMPS Write-Host '======================================================================='
REMPS Write-Host ' PC-GESAMTCHECK'
REMPS Write-Host '======================================================================='
REMPS Write-Host ''
REMPS # System / Uptime
REMPS $os = Get-CimInstance Win32_OperatingSystem
REMPS $uptimeDays = [math]::Round(((Get-Date)-$os.LastBootUpTime).TotalDays,1)
REMPS if($uptimeDays -ge 60){ Add-Result 'ROT' 'Systemlaufzeit' "PC laeuft seit $uptimeDays Tagen ohne Neustart." 'Neustart zeitnah empfohlen.' }
REMPS elseif($uptimeDays -ge 30){ Add-Result 'GELB' 'Systemlaufzeit' "PC laeuft seit $uptimeDays Tagen ohne Neustart." 'Ein Neustart ist sinnvoll.' }
REMPS else { Add-Result 'GRUEN' 'Systemlaufzeit' "Letzter Neustart vor $uptimeDays Tagen." }
REMPS # Pending reboot
REMPS $pending = $false
REMPS $rebootKeys = @(
REMPS   'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending',
REMPS   'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired'
REMPS )
REMPS foreach($k in $rebootKeys){ if(Test-Path $k){$pending=$true} }
REMPS $pfro=(Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Name PendingFileRenameOperations -ErrorAction SilentlyContinue).PendingFileRenameOperations
REMPS if($pfro){$pending=$true}
REMPS if($pending){ Add-Result 'GELB' 'Ausstehender Neustart' 'Windows meldet einen ausstehenden Neustart.' 'Neustart durchfuehren.' } else { Add-Result 'GRUEN' 'Ausstehender Neustart' 'Kein ausstehender Neustart erkannt.' }
REMPS # Disk health
REMPS $pdisks = Get-PhysicalDisk
REMPS if($pdisks){
REMPS   foreach($d in $pdisks){
REMPS     $name=$d.FriendlyName
REMPS     if($d.HealthStatus -eq 'Healthy' -and ($d.OperationalStatus -contains 'OK')){ Add-Result 'GRUEN' "Datentraeger: $name" 'Windows meldet den Datentraeger als fehlerfrei.' }
REMPS     elseif($d.HealthStatus -eq 'Healthy'){ Add-Result 'GELB' "Datentraeger: $name" "HealthStatus=$($d.HealthStatus), OperationalStatus=$($d.OperationalStatus -join ', ')." 'Datentraeger genauer pruefen.' }
REMPS     else { Add-Result 'ROT' "Datentraeger: $name" "HealthStatus=$($d.HealthStatus), OperationalStatus=$($d.OperationalStatus -join ', ')." 'Daten sichern und Datentraeger sofort genauer pruefen.' }
REMPS   }
REMPS } else { Add-Result 'GELB' 'Datentraegerzustand' 'Get-PhysicalDisk liefert keine Daten.' 'SMART ggf. mit Herstellertool oder CrystalDiskInfo pruefen.' }
REMPS # Free space
REMPS $vols=Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"
REMPS foreach($v in $vols){
REMPS   if(-not $v.Size){continue}
REMPS   $freePct=[math]::Round(($v.FreeSpace/$v.Size)*100,1)
REMPS   $freeGB=[math]::Round($v.FreeSpace/1GB,1)
REMPS   if($freePct -lt 5 -or $freeGB -lt 5){ Add-Result 'ROT' "Freier Speicher $($v.DeviceID)" "Nur $freeGB GB ($freePct %) frei." 'Dringend Speicherplatz freigeben.' }
REMPS   elseif($freePct -lt 15 -or $freeGB -lt 15){ Add-Result 'GELB' "Freier Speicher $($v.DeviceID)" "$freeGB GB ($freePct %) frei." 'Speicherplatz beobachten bzw. bereinigen.' }
REMPS   else { Add-Result 'GRUEN' "Freier Speicher $($v.DeviceID)" "$freeGB GB ($freePct %) frei." }
REMPS }
REMPS # RAM
REMPS $totalKB=[double]$os.TotalVisibleMemorySize
REMPS $freeKB=[double]$os.FreePhysicalMemory
REMPS if($totalKB -gt 0){
REMPS   $usedPct=[math]::Round((1-($freeKB/$totalKB))*100,1)
REMPS   $freeGB=[math]::Round($freeKB/1MB,2)
REMPS   if($usedPct -ge 95){ Add-Result 'ROT' 'RAM-Auslastung' "$usedPct % belegt, ca. $freeGB GB frei." 'Sehr hohe Speicherauslastung.' }
REMPS   elseif($usedPct -ge 85){ Add-Result 'GELB' 'RAM-Auslastung' "$usedPct % belegt, ca. $freeGB GB frei." 'Speicherauslastung beobachten.' }
REMPS   else { Add-Result 'GRUEN' 'RAM-Auslastung' "$usedPct % belegt, ca. $freeGB GB frei." }
REMPS }
REMPS # Windows Update services
REMPS foreach($svcName in @('wuauserv','BITS')){
REMPS   $svc=Get-Service $svcName -ErrorAction SilentlyContinue
REMPS   if(-not $svc){ Add-Result 'GELB' "Dienst $svcName" 'Dienst nicht gefunden.' }
REMPS   elseif($svc.Status -eq 'Running'){ Add-Result 'GRUEN' "Dienst $svcName" 'Dienst laeuft.' }
REMPS   else {
REMPS     $cim=Get-CimInstance Win32_Service -Filter "Name='$svcName'"
REMPS     if($cim.StartMode -eq 'Disabled'){ Add-Result 'ROT' "Dienst $svcName" 'Dienst ist deaktiviert.' 'Windows Update kann beeintraechtigt sein.' }
REMPS     else { Add-Result 'GELB' "Dienst $svcName" "Status: $($svc.Status), Starttyp: $($cim.StartMode)." }
REMPS   }
REMPS }
REMPS # Automatic services not running
REMPS $badSvcs=Get-CimInstance Win32_Service | Where-Object { $_.StartMode -eq 'Auto' -and $_.State -ne 'Running' -and $_.Name -notin @('MapsBroker','sppsvc','WbioSrvc','edgeupdate','edgeupdatem') }
REMPS $badCount=@($badSvcs).Count
REMPS if($badCount -ge 5){ Add-Result 'GELB' 'Automatische Dienste' "$badCount automatische Dienste laufen nicht." (($badSvcs | Select-Object -First 10 -ExpandProperty Name) -join ', ') }
REMPS elseif($badCount -gt 0){ Add-Result 'GELB' 'Automatische Dienste' "$badCount automatische Dienste laufen nicht." (($badSvcs | Select-Object -First 10 -ExpandProperty Name) -join ', ') }
REMPS else { Add-Result 'GRUEN' 'Automatische Dienste' 'Keine auffaelligen automatisch gestarteten Dienste erkannt.' }
REMPS # Device manager errors
REMPS $badDevices=Get-CimInstance Win32_PnPEntity | Where-Object { $_.ConfigManagerErrorCode -ne 0 }
REMPS $devCount=@($badDevices).Count
REMPS if($devCount -gt 0){
REMPS   Add-Result 'ROT' 'Geraetemanager' "$devCount Geraete mit Fehlercode erkannt." (($badDevices | Select-Object -First 10 | ForEach-Object {"$($_.Name) (Code $($_.ConfigManagerErrorCode))"}) -join '; ')
REMPS } else { Add-Result 'GRUEN' 'Geraetemanager' 'Keine Geraete mit ConfigManager-Fehlercode erkannt.' }
REMPS # Events last 24 hours
REMPS $since=(Get-Date).AddHours(-24)
REMPS $sysCritical=@(Get-WinEvent -FilterHashtable @{LogName='System';Level=1;StartTime=$since} -ErrorAction SilentlyContinue)
REMPS $sysErrors=@(Get-WinEvent -FilterHashtable @{LogName='System';Level=2;StartTime=$since} -ErrorAction SilentlyContinue)
REMPS if($sysCritical.Count -gt 0){ Add-Result 'ROT' 'Systemereignisse 24h' "$($sysCritical.Count) kritische und $($sysErrors.Count) Fehlerereignisse." (($sysCritical | Select-Object -First 5 | ForEach-Object {"ID $($_.Id) $($_.ProviderName)"}) -join ', ') }
REMPS elseif($sysErrors.Count -ge 20){ Add-Result 'GELB' 'Systemereignisse 24h' "$($sysErrors.Count) Fehlerereignisse in den letzten 24 Stunden." 'Ereignisanzeige genauer pruefen.' }
REMPS elseif($sysErrors.Count -gt 0){ Add-Result 'GELB' 'Systemereignisse 24h' "$($sysErrors.Count) Fehlerereignisse in den letzten 24 Stunden." }
REMPS else { Add-Result 'GRUEN' 'Systemereignisse 24h' 'Keine Fehler oder kritischen Systemereignisse in den letzten 24 Stunden.' }
REMPS $appCritical=@(Get-WinEvent -FilterHashtable @{LogName='Application';Level=1;StartTime=$since} -ErrorAction SilentlyContinue)
REMPS $appErrors=@(Get-WinEvent -FilterHashtable @{LogName='Application';Level=2;StartTime=$since} -ErrorAction SilentlyContinue)
REMPS if($appCritical.Count -gt 0){ Add-Result 'ROT' 'Anwendungsereignisse 24h' "$($appCritical.Count) kritische und $($appErrors.Count) Fehlerereignisse." }
REMPS elseif($appErrors.Count -ge 20){ Add-Result 'GELB' 'Anwendungsereignisse 24h' "$($appErrors.Count) Fehlerereignisse in den letzten 24 Stunden." }
REMPS elseif($appErrors.Count -gt 0){ Add-Result 'GELB' 'Anwendungsereignisse 24h' "$($appErrors.Count) Fehlerereignisse in den letzten 24 Stunden." }
REMPS else { Add-Result 'GRUEN' 'Anwendungsereignisse 24h' 'Keine Fehler oder kritischen Anwendungsereignisse in den letzten 24 Stunden.' }
REMPS # Network gateway
REMPS $cfg=Get-NetIPConfiguration | Where-Object {$_.IPv4DefaultGateway -and $_.NetAdapter.Status -eq 'Up'} | Select-Object -First 1
REMPS if($cfg){
REMPS   $gw=$cfg.IPv4DefaultGateway.NextHop
REMPS   if(Test-Connection $gw -Count 1 -Quiet){ Add-Result 'GRUEN' 'Standardgateway' "Gateway $gw erreichbar." } else { Add-Result 'ROT' 'Standardgateway' "Gateway $gw nicht erreichbar." 'Lokales Netzwerk pruefen.' }
REMPS } else { Add-Result 'ROT' 'Standardgateway' 'Kein aktives IPv4-Standardgateway erkannt.' }
REMPS # DNS
REMPS try{
REMPS   $dns=Resolve-DnsName 'www.microsoft.com' -Type A -ErrorAction Stop
REMPS   if($dns){ Add-Result 'GRUEN' 'DNS' 'DNS-Aufloesung funktioniert.' }
REMPS } catch { Add-Result 'ROT' 'DNS' 'DNS-Aufloesung fehlgeschlagen.' $_.Exception.Message }
REMPS # Internet TCP 443 - avoids relying only on ICMP
REMPS try{
REMPS   $tcp=Test-NetConnection 'www.microsoft.com' -Port 443 -WarningAction SilentlyContinue
REMPS   if($tcp.TcpTestSucceeded){ Add-Result 'GRUEN' 'Internet TCP/443' 'HTTPS-Verbindung zu www.microsoft.com erfolgreich.' }
REMPS   else { Add-Result 'ROT' 'Internet TCP/443' 'HTTPS-Verbindung zu www.microsoft.com fehlgeschlagen.' }
REMPS } catch { Add-Result 'ROT' 'Internet TCP/443' 'Internet-Verbindungstest fehlgeschlagen.' $_.Exception.Message }
REMPS # Defender
REMPS $mp=Get-MpComputerStatus -ErrorAction SilentlyContinue
REMPS if($mp){
REMPS   if(-not $mp.AntivirusEnabled){ Add-Result 'ROT' 'Microsoft Defender' 'Microsoft Defender Antivirus ist deaktiviert.' 'Falls ein anderer Virenscanner installiert ist, kann dies normal sein.' }
REMPS   elseif(-not $mp.RealTimeProtectionEnabled){ Add-Result 'ROT' 'Microsoft Defender' 'Echtzeitschutz ist deaktiviert.' }
REMPS   else {
REMPS     $sigAge=$mp.AntivirusSignatureAge
REMPS     if($sigAge -gt 7){ Add-Result 'GELB' 'Microsoft Defender' "Echtzeitschutz aktiv, Signaturen aber $sigAge Tage alt." 'Signaturen aktualisieren.' }
REMPS     else { Add-Result 'GRUEN' 'Microsoft Defender' "Echtzeitschutz aktiv, Signaturalter: $sigAge Tag(e)." }
REMPS   }
REMPS } else { Add-Result 'GELB' 'Microsoft Defender' 'Defender-Status nicht auslesbar.' 'Moeglicherweise wird ein anderer Virenscanner verwendet.' }
REMPS # Windows activation
REMPS try{
REMPS   $lic=Get-CimInstance SoftwareLicensingProduct | Where-Object {$_.PartialProductKey -and $_.Name -like 'Windows*'} | Select-Object -First 1
REMPS   if($lic.LicenseStatus -eq 1){ Add-Result 'GRUEN' 'Windows-Aktivierung' 'Windows ist aktiviert.' }
REMPS   else { Add-Result 'GELB' 'Windows-Aktivierung' "LicenseStatus=$($lic.LicenseStatus)." 'Aktivierungsstatus pruefen.' }
REMPS } catch { Add-Result 'GELB' 'Windows-Aktivierung' 'Aktivierungsstatus konnte nicht bestimmt werden.' }
REMPS # CPU snapshot
REMPS $cpu=(Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average
REMPS if($null -ne $cpu){
REMPS   $cpu=[math]::Round($cpu,0)
REMPS   if($cpu -ge 95){ Add-Result 'ROT' 'CPU-Auslastung' "$cpu % Momentaufnahme." 'Sehr hohe CPU-Last.' }
REMPS   elseif($cpu -ge 80){ Add-Result 'GELB' 'CPU-Auslastung' "$cpu % Momentaufnahme." 'Hohe CPU-Last.' }
REMPS   else { Add-Result 'GRUEN' 'CPU-Auslastung' "$cpu % Momentaufnahme." }
REMPS }
REMPS # Overall
REMPS $overall=Worst-Status
REMPS $red=@($results | Where-Object Status -eq 'ROT').Count
REMPS $yellow=@($results | Where-Object Status -eq 'GELB').Count
REMPS $green=@($results | Where-Object Status -eq 'GRUEN').Count
REMPS Write-Host ('GESAMTSTATUS: ' + $overall)
REMPS Write-Host ("GRUEN: {0}   GELB: {1}   ROT: {2}" -f $green,$yellow,$red)
REMPS Write-Host ''
REMPS foreach($r in $results){
REMPS   $prefix = switch($r.Status){'GRUEN'{'[GRUEN]'} 'GELB'{'[GELB ]'} 'ROT'{'[ROT  ]'}}
REMPS   Write-Host ("{0} {1}: {2}" -f $prefix,$r.Check,$r.Message)
REMPS   if($r.Detail){ Write-Host ('         -> ' + $r.Detail) }
REMPS }
REMPS # TXT
REMPS $lines=@()
REMPS $lines+='PC-GESAMTCHECK'
REMPS $lines+=('Computer: '+$env:COMPUTERNAME)
REMPS $lines+=('Datum: '+(Get-Date))
REMPS $lines+=('Gesamtstatus: '+$overall)
REMPS $lines+=("GRUEN: $green   GELB: $yellow   ROT: $red")
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
REMPS "<div class='summary'>Gesamtstatus: <span class='badge $overallClass'>$overall</span></div>"
REMPS "<p>GRUEN: $green &nbsp;&nbsp; GELB: $yellow &nbsp;&nbsp; ROT: $red</p>"
REMPS "<div class='small'>Erstellt: $(Get-Date)</div></div>"
REMPS "<div class='card'><table><thead><tr><th>Status</th><th>Pruefung</th><th>Ergebnis</th><th>Hinweis</th></tr></thead><tbody>"
REMPS ($rows -join [Environment]::NewLine)
REMPS '</tbody></table></div>'
REMPS '<div class="card small">Hinweis: Der Gesamtcheck ist eine Schnellbewertung. Einzelne gelbe Meldungen sind nicht automatisch ein Defekt. SMART-, Temperatur- und Sicherheitsdaten koennen je nach Hardware, Treibern und eingesetzter Sicherheitssoftware unvollstaendig sein.</div>'
REMPS '</body></html>'
REMPS ) -join [Environment]::NewLine
REMPS Set-Content -Path $htmlFile -Value $html -Encoding UTF8
REMPS Write-Host ''
REMPS Write-Host ('TXT-Bericht : ' + $txtFile)
REMPS Write-Host ('HTML-Bericht: ' + $htmlFile)
REMPS Start-Process $htmlFile
REMPS exit 0
REMPS_END