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
