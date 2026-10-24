# Windows Diagnostic Toolkit

**Deutsch** | [English](README_EN.md)

Ein menübasiertes Diagnose- und Wartungstool für Windows 10 und Windows 11.

Das Toolkit bündelt häufig benötigte Windows-Diagnosefunktionen in einer einzigen Batch-Datei und ergänzt sie um einen automatischen **PC-Gesamtcheck mit Ampelsystem** sowie ausführliche TXT- und HTML-Diagnoseberichte.

## Funktionen

### PC-Gesamtcheck

Der Gesamtcheck führt eine Reihe von Prüfungen durch, ohne automatisch Reparaturen am System vorzunehmen.

Geprüft werden unter anderem:

- Zustand der Datenträger
- freier Speicherplatz
- RAM-Auslastung
- CPU-Auslastung
- Systemlaufzeit
- ausstehender Windows-Neustart
- Windows-Update-Dienste
- automatisch gestartete Dienste
- Gerätefehler im Geräte-Manager
- kritische Systemereignisse
- Anwendungsfehler
- Standardgateway
- DNS-Auflösung
- Internetverbindung über TCP/443
- Microsoft-Defender-Status
- Windows-Aktivierung

Die Ergebnisse werden mit einem einfachen Ampelsystem bewertet:

- **GRÜN** – kein auffälliger Zustand erkannt
- **GELB** – prüfen oder beobachten
- **ROT** – zeitnahe Prüfung bzw. Maßnahme empfohlen

Zusätzlich werden ein TXT- und ein formatierter HTML-Bericht erzeugt.

## Weitere Werkzeuge

Das Hauptmenü enthält derzeit Funktionen aus folgenden Bereichen:

### Windows und Reparatur

- Windows Update öffnen
- Update-Dienste prüfen und neu starten
- Windows-Update-Downloadcache leeren
- `sfc /scannow`
- DISM Component Store prüfen
- DISM Component Store reparieren
- Windows-Aktivierungsstatus anzeigen

### Netzwerk

- gespeicherte WLAN-Profile anzeigen
- WLAN-Treiberinformationen
- IP-Konfiguration und Netzwerkadapter
- Routingtabelle
- DNS-Test
- Traceroute
- Ping-Test
- TCP-Porttest
- DNS-Cache anzeigen und leeren
- Winsock-/TCP-IP-Reset

### Speicher und Hardware

- CHKDSK Online-Scan
- Speicherbelegung
- Datenträgerzustand
- physische Datenträger
- RAM-Informationen
- CPU-Informationen
- GPU-Informationen
- Temperaturinformationen, soweit Windows bzw. die Hardware diese bereitstellt

### Performance und Fehlersuche

- Prozesse mit hoher CPU-Last
- Prozesse mit hohem RAM-Verbrauch
- Autostart-Einträge
- auffällige automatische Dienste
- kritische Systemereignisse der letzten 24 Stunden
- kritische Anwendungsereignisse der letzten 24 Stunden
- Zuverlässigkeitsmonitor
- Ressourcenmonitor
- Task-Manager

### Windows-Werkzeuge

Direkter Aufruf von:

- Speichereinstellungen
- Datenträgerverwaltung
- Autostart-Einstellungen
- Aufgabenplanung
- Ereignisanzeige
- Geräte-Manager

### Diagnoseberichte

Das Toolkit kann zusätzlich vollständige Diagnoseberichte erzeugen:

- **TXT-Bericht** – gut für Support, Archivierung und Weitergabe
- **HTML-Bericht** – übersichtlich formatierte technische Systemübersicht

Die Berichte werden standardmäßig hier gespeichert:

```text
%USERPROFILE%\Desktop\Windows_Diagnostics
```

## Menüpunkte und verwendete Befehle

Die folgende Übersicht zeigt, welcher Windows-, CMD- oder PowerShell-Befehl hinter dem jeweiligen Menüpunkt steht. Bei zusammengesetzten Funktionen wie dem Gesamtcheck und den Diagnoseberichten werden mehrere Abfragen kombiniert; dort sind die wichtigsten verwendeten Befehle aufgeführt.

| Nr. | Menüpunkt | Verwendeter Befehl / Technik |
|---:|---|---|
| 0 | PC-Gesamtcheck mit Ampelsystem | Kombination aus `Get-CimInstance Win32_OperatingSystem`, `Get-PhysicalDisk`, `Get-CimInstance Win32_LogicalDisk`, `Get-Service`, `Get-CimInstance Win32_Service`, `Get-CimInstance Win32_PnPEntity`, `Get-WinEvent`, `Get-NetIPConfiguration`, `Resolve-DnsName`, `Test-NetConnection`, `Get-MpComputerStatus` und `Get-CimInstance SoftwareLicensingProduct` |
| 1 | Windows Update öffnen | `start "" ms-settings:windowsupdate` |
| 2 | Windows-Update-Dienste prüfen | `sc query wuauserv`, `sc query bits`, `sc query usosvc`, `sc query cryptsvc`, `sc query WaaSMedicSvc` |
| 3 | Windows-Update-Dienste neu starten | `net stop wuauserv`, `net stop bits`, `net stop cryptsvc`, anschließend `net start ...` |
| 4 | Windows-Update-Downloadcache leeren | Dienste stoppen, anschließend `del /f /s /q "%windir%\SoftwareDistribution\Download\*"` und Unterordner löschen |
| 5 | SFC-Systemdateiprüfung | `sfc /scannow` |
| 6 | DISM Component Store prüfen | `DISM /Online /Cleanup-Image /ScanHealth` |
| 7 | DISM Component Store reparieren | `DISM /Online /Cleanup-Image /RestoreHealth` |
| 8 | Windows-Aktivierungsstatus | `cscript //nologo %windir%\system32\slmgr.vbs /xpr` und `/dli` |
| 9 | WLAN-Profile anzeigen | `netsh wlan show profiles` |
| 10 | WLAN-Treiberinformationen | `netsh wlan show drivers` |
| 11 | Netzwerkinterfaces / IP-Konfiguration | `ipconfig /all` sowie `Get-NetAdapter` |
| 12 | Routingtabelle | `route print` |
| 13 | DNS-Auflösung testen | `nslookup <Hostname>` sowie `Resolve-DnsName <Hostname>` |
| 14 | Netzwerkroute verfolgen | `tracert <Ziel>` |
| 15 | Ping-Test | `ping -n <Anzahl> <Ziel>` |
| 16 | TCP-Porttest | `Test-NetConnection -ComputerName <Host> -Port <Port> -InformationLevel Detailed` |
| 17 | DNS-Cache anzeigen | `ipconfig /displaydns` |
| 18 | DNS-Cache leeren | `ipconfig /flushdns` |
| 19 | Winsock / TCP-IP Reset | `netsh winsock reset` und `netsh int ip reset` |
| 20 | Laufwerk C: prüfen | `chkdsk C: /scan` |
| 21 | Speicherbelegung analysieren | `Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"` |
| 22 | SMART / Datenträgerzustand | `Get-PhysicalDisk` mit `HealthStatus` und `OperationalStatus` |
| 23 | Physische Datenträger | `Get-CimInstance Win32_DiskDrive` |
| 24 | RAM-Informationen | `Get-CimInstance Win32_ComputerSystem` und `Get-CimInstance Win32_PhysicalMemory` |
| 25 | CPU-Informationen | `Get-CimInstance Win32_Processor` |
| 26 | GPU-Informationen | `Get-CimInstance Win32_VideoController`; bei NVIDIA zusätzlich `nvidia-smi` |
| 27 | Temperaturen | `Get-CimInstance -Namespace root/wmi -ClassName MSAcpi_ThermalZoneTemperature`; bei NVIDIA zusätzlich `nvidia-smi --query-gpu=...` |
| 28 | Prozesse mit hoher CPU-Last | `Get-Process \| Sort-Object CPU -Descending \| Select-Object -First 20 ...` |
| 29 | Prozesse mit hohem RAM-Verbrauch | `Get-Process \| Sort-Object WorkingSet64 -Descending \| Select-Object -First 20 ...` |
| 30 | Autostart-Einträge | `Get-CimInstance Win32_StartupCommand` |
| 31 | Dienste mit Fehlerstatus | `Get-CimInstance Win32_Service \| Where-Object { $_.StartMode -eq 'Auto' -and $_.State -ne 'Running' }` |
| 32 | Kritische Systemereignisse der letzten 24h | `Get-WinEvent -FilterHashtable @{LogName='System';Level=1,2;StartTime=<24h>}` |
| 33 | Kritische Anwendungsereignisse der letzten 24h | `Get-WinEvent -FilterHashtable @{LogName='Application';Level=1,2;StartTime=<24h>}` |
| 34 | Windows-Zuverlässigkeitsmonitor | `perfmon /rel` |
| 35 | Ressourcenmonitor | `resmon.exe` |
| 36 | Task-Manager | `taskmgr.exe` |
| 37 | Speichereinstellungen | `start "" ms-settings:storagesense` |
| 38 | Datenträgerverwaltung | `diskmgmt.msc` |
| 39 | Autostart-Apps | `start "" ms-settings:startupapps` |
| 40 | Aufgabenplanung | `taskschd.msc` |
| 41 | Ereignisanzeige | `eventvwr.msc` |
| 42 | Geräte-Manager | `devmgmt.msc` |
| 43 | Kompletter TXT-Diagnosebericht | Kombination aus `Get-CimInstance`, `Get-PhysicalDisk`, `Get-NetAdapter`, `Get-NetIPConfiguration`, `Get-Process`, `Get-WinEvent` sowie `Format-Table` / `Format-List`; Ausgabe per `Set-Content` / `Add-Content` |
| 44 | Kompletter HTML-Diagnosebericht | Dieselben Systemabfragen wie beim TXT-Bericht; Tabellen werden mit `ConvertTo-Html -Fragment` erzeugt und per `Set-Content` als HTML gespeichert |
| 45 | Report-Ordner öffnen | `explorer.exe "%USERPROFILE%\Desktop\Windows_Diagnostics"` |

### Hinweis zu den Befehlen

Die Tabelle zeigt die im Skript tatsächlich verwendeten Kernbefehle. Einige Menüpunkte ergänzen diese um Formatierung, Fehlerbehandlung, Sicherheitsabfragen oder Variablen für vom Benutzer eingegebene Ziele. Der vollständige Ablauf ist direkt in [`windows-diagnostic-toolkit.bat`](windows-diagnostic-toolkit.bat) einsehbar.


## Installation

Es ist keine Installation erforderlich.

1. `windows-diagnostic-toolkit.bat` herunterladen.
2. Datei lokal speichern.
3. Per Doppelklick starten.
4. Die Abfrage der Benutzerkontensteuerung bestätigen.

Das Skript fordert automatisch Administratorrechte an.

## Voraussetzungen

- Windows 10 oder Windows 11
- Windows PowerShell 5.1 oder neuer
- Administratorrechte für einige Diagnose- und Reparaturfunktionen

Einige Hardwareinformationen sind abhängig von Gerät, Treiber und Hersteller nicht auf jedem System verfügbar.

## Sicherheit

Der **PC-Gesamtcheck** führt keine automatischen Reparaturen durch.

Funktionen, die Änderungen am System verursachen können, sind separat im Menü verfügbar. Dazu gehören beispielsweise:

- Windows-Update-Cache leeren
- DISM-Reparatur
- Winsock-/TCP-IP-Reset

Vor kritischen Aktionen sollte grundsätzlich ein aktuelles Backup vorhanden sein.

## Hinweise zu den Ergebnissen

Das Toolkit ist ein Diagnosewerkzeug und ersetzt keine vollständige Hardware- oder Sicherheitsanalyse.

Insbesondere gilt:

- einzelne Ereignisanzeige-Fehler bedeuten nicht automatisch einen Systemdefekt
- Windows liefert SMART- und Temperaturwerte je nach Hardware nur eingeschränkt
- hohe CPU- oder RAM-Werte sind Momentaufnahmen
- deaktivierter Microsoft Defender kann normal sein, wenn eine andere Sicherheitssoftware eingesetzt wird

Die Ampelbewertung soll Auffälligkeiten priorisieren und ist keine Garantie für einen fehlerfreien oder defekten Zustand.

## Datenschutz

Das Skript arbeitet lokal auf dem Windows-PC.

Es überträgt keine Diagnoseberichte an einen externen Server. Netzwerkprüfungen verwenden jedoch öffentliche Ziele, beispielsweise für DNS- oder HTTPS-Konnektivitätstests.

Vor dem Veröffentlichen oder Weitergeben eines Diagnoseberichts sollte geprüft werden, ob darin Informationen wie Rechnername, Benutzername, IP-Adressen, MAC-Adressen, Gerätenamen oder installierte Komponenten enthalten sind.

## Projektstatus

Das Projekt befindet sich in aktiver Weiterentwicklung.

Geplante Verbesserungen:

- gezieltere Bewertung wichtiger Windows-Event-IDs
- stärkere Gewichtung von Disk-, NTFS-, WHEA- und Kernel-Power-Ereignissen
- verbesserte SMART-Auswertung
- kombinierter Health-Check- und Detailbericht
- optionale Exportfunktionen
- weitere Plausibilitätsprüfungen für Dienste und Treiber

## Haftungsausschluss

Die Nutzung erfolgt auf eigene Verantwortung. Vor Änderungen an produktiven Systemen sollten Backups vorhanden sein und die Auswirkungen der jeweiligen Funktion verstanden werden.

## Lizenz

Dieses Projekt steht unter der MIT-Lizenz. Siehe [LICENSE](LICENSE).
