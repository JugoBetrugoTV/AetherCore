# AetherCore - WoW Addon Framework

![AetherCore](https://img.shields.io/badge/AetherCore-WoW%20Addon%20Framework-blue)
![Version](https://img.shields.io/badge/version-1.0.0-green)
![License](https://img.shields.io/badge/license-MIT-orange)

English | [Deutsch](#deutsch)

## Overview

**AetherCore** is a comprehensive World of Warcraft addon framework designed to enhance gameplay with powerful themes, modular components, quality-of-life features, and advanced database tracking capabilities. Whether you're looking to customize your UI, improve your workflow, or track game data efficiently, AetherCore provides a robust foundation for all your needs.

### Key Features

- **🎨 Dynamic Theme System**: Multiple professionally designed themes with full customization
- **📦 Modular Architecture**: Extensible module system for flexible functionality
- **⚡ Quality of Life Features**: Enhanced gameplay experience with practical utilities
- **📊 Database Tracking**: Comprehensive tracking and logging of game data
- **🔧 Easy Configuration**: User-friendly settings and preferences management

---

## 📋 Table of Contents

1. [Installation](#installation)
2. [Features](#features)
3. [Themes](#themes)
4. [Modules](#modules)
5. [Configuration](#configuration)
6. [Troubleshooting](#troubleshooting)
7. [Contributing](#contributing)
8. [Deutsch](#deutsch)

---

## Installation

### Requirements

- **World of Warcraft** (Latest Expansion)
- **Retail or Classic Client**
- Basic knowledge of addon installation

### Installation Steps

#### Method 1: Manual Installation

1. **Download the Addon**
   - Download the latest release from the [Releases](../../releases) page
   - Or clone the repository: `git clone https://github.com/JugoBetrugoTV/AetherCore.git`

2. **Locate WoW Addons Folder**
   - **Windows**: `C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\`
   - **macOS**: `/Applications/World of Warcraft/_retail_/Interface/AddOns/`
   - **Linux**: `~/.wine/drive_c/Program Files (x86)/World of Warcraft/_retail_/Interface/AddOns/`

3. **Copy the Addon**
   - Extract or copy the `AetherCore` folder into the `AddOns` directory
   - Ensure the folder structure is: `Interface/AddOns/AetherCore/`

4. **Enable the Addon**
   - Launch World of Warcraft
   - In the Character Selection screen, click "Addons"
   - Check the box next to "AetherCore" to enable it
   - Reload the UI or restart the game

#### Method 2: Using Package Managers

If you use addon managers like CurseForge or WowUp:

1. Search for "AetherCore"
2. Click "Install"
3. The addon will be automatically placed in your AddOns folder
4. Enable it in-game

### Verification

After installation, verify the addon is loaded:
- Type `/aetherc` or `/ac` in-game chat
- You should see the AetherCore menu
- Check the Main Menu > Addons for AetherCore status

---

## Features

### 1. Dynamic Theme System

AetherCore includes a sophisticated theme engine that allows seamless switching between professionally crafted visual styles:

- **Dark Theme**: Low-light optimized interface perfect for evening gaming sessions
- **Light Theme**: Clean, bright interface for well-lit environments
- **Minimalist Theme**: Distraction-free design focusing on essential information
- **Classic Theme**: Traditional WoW aesthetic with modern enhancements
- **Custom Themes**: Create and share your own themes with the community

**Theme Benefits:**
- Consistent color schemes across all UI elements
- Reduced eye strain with multiple brightness options
- Accessibility improvements for colorblind players
- Instant theme switching without UI reload

### 2. Quality of Life Features

Enhance your gameplay with practical, time-saving utilities:

- **Smart Quest Tracking**: Intelligent quest objective management
- **Enhanced Inventory Management**: Quick-sort and filter systems
- **Auto-Vendor Junk**: Automatically sell grayed-out items
- **Buff Reminder**: Notifications for expired buffs
- **Group Utilities**: Enhanced raid and party information
- **Performance Monitoring**: FPS and latency tracking
- **Customizable Hotkeys**: Bind any action to your preferred keys

### 3. Modular System

The addon framework is built on a modular architecture:

- **Core Module**: Essential functionality and framework
- **UI Module**: Interface customization and management
- **Database Module**: Data persistence and tracking
- **Utilities Module**: Helper functions and tools
- **Optional Modules**: Install only what you need

Each module can be independently enabled or disabled in the settings.

### 4. Advanced Database Tracking

Track and analyze game data with powerful persistence features:

- **Activity Logging**: Record gameplay statistics and achievements
- **Equipment Tracking**: Monitor gear changes and upgrades
- **Gold Tracking**: Track income and expenses
- **Raid Data**: Store raid progression and performance metrics
- **Custom Tracking**: Define your own tracking parameters
- **Data Export**: Export tracked data for external analysis

---

## Themes

### Theme Management

Access themes through the main configuration menu or type `/ac themes`

### Available Themes

| Theme Name | Style | Best For | Colors |
|-----------|-------|----------|--------|
| **Dark** | Modern Dark | Night gaming | #1a1a1a - #ffffff |
| **Light** | Clean Bright | Day gaming | #ffffff - #000000 |
| **Minimalist** | Distraction-free | Competitive play | #2a2a2a - #cccccc |
| **Classic** | Traditional WoW | Nostalgia | Gold & Bronze |
| **Custom** | User-defined | Personal preference | Customizable |

### Creating Custom Themes

1. Open Settings: `/ac settings`
2. Navigate to "Themes" > "Create New Theme"
3. Customize colors, fonts, and layouts
4. Save with a unique name
5. Share with the community (optional)

**Theme File Structure:**
```
/AetherCore/themes/mytheme/
├── colors.lua
├── fonts.lua
└── layouts.lua
```

---

## Modules

### Core Module

**Purpose**: Foundation of AetherCore framework
- Initialization and event handling
- Core API and utilities
- Configuration management

**Usage**: Automatically loaded; no configuration needed

### UI Module

**Purpose**: Interface customization and enhancement
- Frame management
- Custom UI elements
- Theme application

**Configuration**:
```
/ac ui settings
- Enable/Disable custom UI elements
- Adjust frame positions and sizes
- Configure transparency and scaling
```

### Database Module

**Purpose**: Data storage and retrieval
- SQLite-based persistent storage
- Query and analytics functions
- Automated backups

**Features**:
- Automatic weekly backups
- Data integrity checking
- Export/Import functionality

**Command**: `/ac database`

### Utilities Module

**Purpose**: Helper functions and productivity tools
- Chat enhancements
- Cooldown tracking
- Target analysis

**Available Commands**:
```
/aetherc config     - Open configuration panel
/aetherc status     - Display addon status
/aetherc reset      - Reset to default settings
/aetherc help       - Show command help
```

### Optional Modules

**Advanced Features Module**:
- Raid warnings
- Boss timers
- Strategy guides

**Enable**: `/ac modules toggle advanced`

**PvP Enhancements Module**:
- Arena information
- Battleground statistics
- Enemy team tracking

**Enable**: `/ac modules toggle pvp`

---

## Configuration

### Quick Setup

1. **First Launch**: AetherCore initializes with default settings
2. **Configuration Menu**: Type `/ac settings` or `/aetherc config`
3. **Categories**:
   - General (Language, Autosave, Debug Mode)
   - Display (Theme, Scaling, Transparency)
   - Features (Module toggles, Feature toggles)
   - Database (Backup frequency, Data retention)
   - Keybindings (Custom hotkeys)
   - About (Version, Credits)

### Configuration Files

Settings are stored in:
```
WoW/WTF/Account/[Account]/SavedVariables/AetherCore.lua
```

### Common Settings

**Auto-save Database**: Enabled (Recommended)
**Theme**: Dark (Default)
**Update Frequency**: Every 5 minutes (Customizable)
**Debug Mode**: Disabled (Enable for troubleshooting)

### Advanced Configuration

For advanced users, edit the Lua configuration files directly:

```lua
-- Example: Modifying refresh rate
AetherCore_Config = {
    database = {
        updateFrequency = 300,  -- seconds
        autoBackup = true,
        retentionDays = 30
    },
    ui = {
        theme = "dark",
        scale = 1.0,
        opacity = 1.0
    }
}
```

---

## Troubleshooting

### Common Issues and Solutions

#### 1. Addon Not Loading

**Problem**: "AetherCore" doesn't appear in the addon list

**Solutions**:
- Verify installation path: `Interface/AddOns/AetherCore/`
- Check folder structure includes `AetherCore.toc` file
- Ensure folder name is exactly "AetherCore" (case-sensitive on Mac/Linux)
- Disable conflicting addons temporarily
- Clear WoW cache: Delete `WoW/Cache/` folder

**Command to verify**: `/aetherc status`

#### 2. Settings Not Saving

**Problem**: Configuration reverts after logout

**Solutions**:
- Check file permissions on SavedVariables folder
- Ensure `AetherCore.lua` in SavedVariables is writable
- Try resetting settings: `/ac reset`
- Check disk space availability
- Disable read-only mode on the addon folder

#### 3. Database Corruption

**Problem**: "Database error" message or data loss

**Solutions**:
- Type `/ac database repair` to run integrity check
- Restore from backup: `/ac database restore`
- Check database file: `SavedVariables/AetherCore_DB.lua`
- Contact support with error logs if issue persists

**Log Location**: `WoW/Logs/AetherCore_error.log`

#### 4. Performance Issues

**Problem**: FPS drops or lag after enabling AetherCore

**Solutions**:
- Disable unused modules: `/ac modules list`
- Reduce database update frequency: `/ac settings > Database`
- Enable low-performance mode: `/ac performance low`
- Check for conflicting addons
- Update to latest AetherCore version

#### 5. Theme Not Applying

**Problem**: Selected theme doesn't change UI appearance

**Solutions**:
- Verify theme installation in `/themes/` folder
- Reload UI: `/reload` or `/rl`
- Reset UI to defaults: `/ac reset`
- Clear temporary theme cache: `/ac clearcache`
- Ensure custom theme syntax is valid

#### 6. Chat Commands Not Working

**Problem**: `/ac` or `/aetherc` commands don't respond

**Solutions**:
- Verify addon is enabled in addon list
- Use alternative command: `/aetherc` (if `/ac` doesn't work)
- Check for typos in command spelling
- Reload UI: `/reload`
- Verify addon loaded: Check "Addons" in main menu

### Getting Help

1. **Check Documentation**: Review this README and in-game help
2. **Enable Debug Mode**: `/ac settings > General > Debug Mode`
3. **Check Logs**: Review error logs at `WoW/Logs/AetherCore_error.log`
4. **Community Support**: Visit our [Issues](../../issues) page
5. **Bug Report**: Include:
   - WoW version and locale
   - AetherCore version: `/ac version`
   - Error message (exact text)
   - Steps to reproduce
   - `AetherCore_error.log` file contents

---

## Contributing

Contributions are welcome! Help improve AetherCore:

### How to Contribute

1. **Report Bugs**: Create an issue with detailed information
2. **Suggest Features**: Share ideas for new modules or improvements
3. **Submit Code**: Fork the repository and create a pull request
4. **Improve Documentation**: Help us make guides clearer
5. **Create Themes**: Design and share custom themes

### Development Setup

```bash
git clone https://github.com/JugoBetrugoTV/AetherCore.git
cd AetherCore
# Make your changes
git commit -am "Description of changes"
git push origin your-branch
```

### Code Style

- Follow Lua conventions
- Add comments for complex logic
- Test thoroughly before submitting PR
- Include documentation for new features

---

## License

AetherCore is released under the MIT License. See [LICENSE](LICENSE) file for details.

---

## Credits

**Developer**: JugoBetrugoTV  
**Contributors**: Community members and testers  
**Version**: 1.0.0  
**Last Updated**: December 19, 2025

---

---

# Deutsch

## Übersicht

**AetherCore** ist ein umfassendes World of Warcraft-Addon-Framework, das das Spielerlebnis durch leistungsstarke Designs, modulare Komponenten, Quality-of-Life-Funktionen und fortgeschrittene Datenverfolgung verbessert. Egal ob Sie Ihre Benutzeroberfläche anpassen, Ihren Arbeitsablauf verbessern oder Spieldaten effizient verfolgen möchten – AetherCore bietet eine robuste Grundlage für alle Ihre Anforderungen.

### Hauptmerkmale

- **🎨 Dynamisches Design-System**: Mehrere professionell gestaltete Designs mit vollständiger Anpassung
- **📦 Modulare Architektur**: Erweiterbares Modulsystem für flexible Funktionalität
- **⚡ Quality-of-Life-Funktionen**: Verbessertes Spielerlebnis mit praktischen Dienstprogrammen
- **📊 Datenbankverfolgung**: Umfassende Verfolgung und Protokollierung von Spieldaten
- **🔧 Einfache Konfiguration**: Benutzerfreundliche Einstellungs- und Präferenzverwaltung

---

## 📋 Inhaltsverzeichnis

1. [Installation](#installation-de)
2. [Funktionen](#funktionen)
3. [Designs](#designs)
4. [Module](#module-de)
5. [Konfiguration](#konfiguration-de)
6. [Fehlerbehebung](#fehlerbehebung)
7. [Beitragen](#beitragen-de)

---

## Installation (Deutsch) {#installation-de}

### Anforderungen

- **World of Warcraft** (Neueste Erweiterung)
- **Retail oder Classic Client**
- Grundkenntnisse zur Addon-Installation

### Installationsschritte

#### Methode 1: Manuelle Installation

1. **Addon herunterladen**
   - Laden Sie die neueste Version von der [Releases](../../releases)-Seite herunter
   - Oder klonen Sie das Repository: `git clone https://github.com/JugoBetrugoTV/AetherCore.git`

2. **WoW Addons-Ordner finden**
   - **Windows**: `C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\`
   - **macOS**: `/Applications/World of Warcraft/_retail_/Interface/AddOns/`
   - **Linux**: `~/.wine/drive_c/Program Files (x86)/World of Warcraft/_retail_/Interface/AddOns/`

3. **Addon kopieren**
   - Extrahieren oder kopieren Sie den `AetherCore`-Ordner in das `AddOns`-Verzeichnis
   - Stellen Sie sicher, dass die Ordnerstruktur wie folgt aussieht: `Interface/AddOns/AetherCore/`

4. **Addon aktivieren**
   - Starten Sie World of Warcraft
   - Klicken Sie auf dem Charakterauswahlbildschirm auf "Addons"
   - Aktivieren Sie das Kontrollkästchen neben "AetherCore"
   - Laden Sie die Benutzeroberfläche neu oder starten Sie das Spiel neu

#### Methode 2: Addon-Manager verwenden

Wenn Sie Addon-Manager wie CurseForge oder WowUp verwenden:

1. Suchen Sie nach "AetherCore"
2. Klicken Sie auf "Installieren"
3. Das Addon wird automatisch im AddOns-Ordner platziert
4. Aktivieren Sie es im Spiel

### Überprüfung

Nach der Installation überprüfen Sie, ob das Addon geladen ist:
- Geben Sie `/aetherc` oder `/ac` im Spielchat ein
- Sie sollten das AetherCore-Menü sehen
- Überprüfen Sie das Hauptmenü > Addons auf AetherCore-Status

---

## Funktionen

### 1. Dynamisches Design-System

AetherCore verfügt über eine raffinierte Design-Engine, die nahtlose Umschaltungen zwischen professionell gestalteten visuellen Stilen ermöglicht:

- **Dunkles Design**: Für Niedriglichtsituationen optimierte Schnittstelle
- **Helles Design**: Saubere, helle Schnittstelle für gut beleuchtete Umgebungen
- **Minimalistisches Design**: Ablenkungsfreier Entwurf mit Fokus auf wesentliche Informationen
- **Klassisches Design**: Traditionelle WoW-Ästhetik mit modernen Verbesserungen
- **Benutzerdefinierte Designs**: Erstellen und teilen Sie Ihre eigenen Designs mit der Gemeinschaft

**Design-Vorteile:**
- Konsistente Farbschemen über alle UI-Elemente
- Reduzierte Augenbelastung mit mehreren Helligkeitsoptionen
- Verbesserungen der Barrierefreiheit für farbenblinde Spieler
- Sofortiges Design-Wechsel ohne Neustart der Benutzeroberfläche

### 2. Quality-of-Life-Funktionen

Verbessern Sie Ihr Spielerlebnis mit praktischen, zeitsparenden Dienstprogrammen:

- **Intelligente Questverfolgung**: Intelligente Verwaltung von Questzielen
- **Verbesserte Bestandsverwaltung**: Schnell-Sortierung und Filtersysteme
- **Auto-Vendor-Schrott**: Verkaufen Sie automatisch ergraute Gegenstände
- **Buff-Erinnerung**: Benachrichtigungen für abgelaufene Buffs
- **Grup­pen­dia­logs**: Erweiterte Raid- und Gruppeninformationen
- **Leistungsüberwachung**: FPS- und Latenz-Tracking
- **Anpassbare Hotkeys**: Binden Sie jede Aktion an Ihre bevorzugten Tasten

### 3. Modulares System

Das Addon-Framework ist auf einer modularen Architektur aufgebaut:

- **Core-Modul**: Wesentliche Funktionalität und Framework
- **UI-Modul**: Schnittstellen-Anpassung und Verwaltung
- **Datenbank-Modul**: Datenverfolgung und -speicherung
- **Utilities-Modul**: Hilfsfunktionen und Tools
- **Optionale Module**: Installieren Sie nur, was Sie benötigen

Jedes Modul kann in den Einstellungen unabhängig aktiviert oder deaktiviert werden.

### 4. Fortgeschrittene Datenbankverfolgung

Verfolgen und analysieren Sie Spieldaten mit leistungsstarken Persistenz-Funktionen:

- **Aktivitätsprotokollierung**: Aufzeichnung von Spielstatistiken und Errungenschaften
- **Ausrüstungsverfolgung**: Überwachen Sie Ausrüstungswechsel und Upgrades
- **Gold-Verfolgung**: Verfolgen Sie Einnahmen und Ausgaben
- **Raid-Daten**: Speichern Sie Raid-Progression und Leistungsmetriken
- **Benutzerdefinierte Verfolgung**: Definieren Sie Ihre eigenen Verfolgungsparameter
- **Datenexport**: Exportieren Sie verfollgte Daten für externe Analyse

---

## Designs {#designs}

### Design-Verwaltung

Greifen Sie auf Designs über das Hauptkonfigurationsmenü oder den Befehl `/ac themes` zu

### Verfügbare Designs

| Design-Name | Stil | Ideal für | Farben |
|-----------|-------|----------|--------|
| **Dunkel** | Modernes Dunkel | Nachts Gaming | #1a1a1a - #ffffff |
| **Hell** | Sauberes Helles | Tag Gaming | #ffffff - #000000 |
| **Minimalistisch** | Ablenkungsfrei | Competitive Play | #2a2a2a - #cccccc |
| **Klassisch** | Traditionelles WoW | Nostalgie | Gold & Bronze |
| **Benutzerdefiniert** | Benutzerdefiniert | Persönliche Vorliebe | Anpassbar |

### Benutzerdefinierte Designs erstellen

1. Öffnen Sie Einstellungen: `/ac settings`
2. Navigieren Sie zu "Designs" > "Neues Design erstellen"
3. Passen Sie Farben, Schriftarten und Layouts an
4. Speichern Sie mit einem eindeutigen Namen
5. Teilen Sie mit der Gemeinschaft (optional)

**Design-Dateistruktur:**
```
/AetherCore/themes/meindesign/
├── colors.lua
├── fonts.lua
└── layouts.lua
```

---

## Module {#module-de}

### Core-Modul

**Zweck**: Grundlage des AetherCore-Frameworks
- Initialisierung und Event-Verarbeitung
- Core API und Dienstprogramme
- Konfigurationsverwaltung

**Verwendung**: Wird automatisch geladen; keine Konfiguration erforderlich

### UI-Modul

**Zweck**: Schnittstellen-Anpassung und Verbesserung
- Frame-Verwaltung
- Benutzerdefinierte UI-Elemente
- Design-Anwendung

**Konfiguration**:
```
/ac ui settings
- Aktivieren/Deaktivieren benutzerdefinierter UI-Elemente
- Passen Sie Frame-Positionen und -Größen an
- Konfigurieren Sie Transparenz und Skalierung
```

### Datenbank-Modul

**Zweck**: Datenspeicherung und -abruf
- SQLite-basierte persistente Speicherung
- Abfrage- und Analysefunktionen
- Automatisierte Sicherungen

**Funktionen**:
- Automatische wöchentliche Sicherungen
- Datenintegritätsprüfung
- Export/Import-Funktionalität

**Befehl**: `/ac database`

### Utilities-Modul

**Zweck**: Hilfsfunktionen und Produktivitäts-Tools
- Chat-Verbesserungen
- Cooldown-Verfolgung
- Ziel-Analyse

**Verfügbare Befehle**:
```
/aetherc config     - Öffnen Sie das Konfigurationsfenster
/aetherc status     - Zeigen Sie den Addon-Status an
/aetherc reset      - Auf Standardeinstellungen zurücksetzen
/aetherc help       - Befehlshilfe anzeigen
```

### Optionale Module

**Erweiterte Funktionen-Modul**:
- Raid-Warnungen
- Boss-Timer
- Strategieleitfäden

**Aktivieren**: `/ac modules toggle advanced`

**PvP-Verbesserungen-Modul**:
- Arena-Informationen
- Schlachtfeld-Statistiken
- Verfolgung gegnerischer Teams

**Aktivieren**: `/ac modules toggle pvp`

---

## Konfiguration {#konfiguration-de}

### Schnelleinrichtung

1. **Erste Inbetriebnahme**: AetherCore wird mit Standardeinstellungen initialisiert
2. **Konfigurationsmenü**: Geben Sie `/ac settings` oder `/aetherc config` ein
3. **Kategorien**:
   - Allgemein (Sprache, Autosave, Debug-Modus)
   - Anzeige (Design, Skalierung, Transparenz)
   - Funktionen (Modul-Umschalter, Funktions-Umschalter)
   - Datenbank (Sicherungshäufigkeit, Datenverfügung)
   - Tastenbelegung (Benutzerdefinierte Hotkeys)
   - Über (Version, Credits)

### Konfigurationsdateien

Einstellungen werden gespeichert in:
```
WoW/WTF/Account/[Account]/SavedVariables/AetherCore.lua
```

### Allgemeine Einstellungen

**Auto-Save-Datenbank**: Aktiviert (Empfohlen)
**Design**: Dunkel (Standard)
**Aktualisierungshäufigkeit**: Alle 5 Minuten (Anpassbar)
**Debug-Modus**: Deaktiviert (Aktivieren zur Fehlerbehebung)

### Erweiterte Konfiguration

Für fortgeschrittene Benutzer bearbeiten Sie die Lua-Konfigurationsdateien direkt:

```lua
-- Beispiel: Aktualisierungsrate ändern
AetherCore_Config = {
    database = {
        updateFrequency = 300,  -- Sekunden
        autoBackup = true,
        retentionDays = 30
    },
    ui = {
        theme = "dark",
        scale = 1.0,
        opacity = 1.0
    }
}
```

---

## Fehlerbehebung

### Häufige Probleme und Lösungen

#### 1. Addon wird nicht geladen

**Problem**: "AetherCore" wird in der Addon-Liste nicht angezeigt

**Lösungen**:
- Überprüfen Sie den Installationspfad: `Interface/AddOns/AetherCore/`
- Überprüfen Sie die Ordnerstruktur einschließlich der Datei `AetherCore.toc`
- Stellen Sie sicher, dass der Ordnername genau "AetherCore" ist (bei Mac/Linux case-sensitive)
- Deaktivieren Sie vorübergehend konflikt­gende Addons
- Löschen Sie den WoW-Cache: Löschen Sie den Ordner `WoW/Cache/`

**Befehl zur Überprüfung**: `/aetherc status`

#### 2. Einstellungen werden nicht gespeichert

**Problem**: Die Konfiguration wird nach dem Abmelden zurückgesetzt

**Lösungen**:
- Überprüfen Sie die Dateiberechtigung für den SavedVariables-Ordner
- Stellen Sie sicher, dass `AetherCore.lua` in SavedVariables schreibbar ist
- Versuchen Sie, die Einstellungen zurückzusetzen: `/ac reset`
- Überprüfen Sie die verfügbare Festplattengröße
- Deaktivieren Sie den Schreibschutz im Addon-Ordner

#### 3. Datenbank-Korruption

**Problem**: "Datenbankfehler"-Meldung oder Datenverlust

**Lösungen**:
- Führen Sie die Integritätsprüfung durch: `/ac database repair`
- Wiederherstellen aus Sicherung: `/ac database restore`
- Überprüfen Sie die Datenbankdatei: `SavedVariables/AetherCore_DB.lua`
- Kontaktieren Sie den Support mit Fehlerprotokollen bei Problemen

**Protokollspeicherort**: `WoW/Logs/AetherCore_error.log`

#### 4. Leistungsprobleme

**Problem**: FPS-Abfall oder Verzögerung nach Aktivierung von AetherCore

**Lösungen**:
- Deaktivieren Sie nicht verwendete Module: `/ac modules list`
- Reduzieren Sie die Datenbank-Aktualisierungshäufigkeit: `/ac settings > Datenbank`
- Aktivieren Sie den Low-Performance-Modus: `/ac performance low`
- Überprüfen Sie auf Konflikte mit anderen Addons
- Aktualisieren Sie auf die neueste AetherCore-Version

#### 5. Design wird nicht angewendet

**Problem**: Das ausgewählte Design ändert das Erscheinungsbild der Benutzeroberfläche nicht

**Lösungen**:
- Überprüfen Sie die Design-Installation im Ordner `/themes/`
- Laden Sie die Benutzeroberfläche neu: `/reload` oder `/rl`
- Setzen Sie die Benutzeroberfläche auf Standardwerte zurück: `/ac reset`
- Löschen Sie den temporären Design-Cache: `/ac clearcache`
- Stellen Sie sicher, dass die benutzerdefinierte Design-Syntax gültig ist

#### 6. Chat-Befehle funktionieren nicht

**Problem**: Befehle `/ac` oder `/aetherc` reagieren nicht

**Lösungen**:
- Überprüfen Sie, ob das Addon in der Addon-Liste aktiviert ist
- Verwenden Sie einen alternativen Befehl: `/aetherc` (wenn `/ac` nicht funktioniert)
- Überprüfen Sie auf Tippfehler in der Befehlsschreibweise
- Laden Sie die Benutzeroberfläche neu: `/reload`
- Überprüfen Sie, ob das Addon geladen ist: Überprüfen Sie "Addons" im Hauptmenü

### Hilfe bekommen

1. **Dokumentation überprüfen**: Lesen Sie diese README und die In-Game-Hilfe
2. **Debug-Modus aktivieren**: `/ac settings > Allgemein > Debug-Modus`
3. **Protokolle überprüfen**: Überprüfen Sie Fehlerprotokolle unter `WoW/Logs/AetherCore_error.log`
4. **Community-Support**: Besuchen Sie unsere [Issues](../../issues)-Seite
5. **Bug-Bericht**: Fügen Sie folgendes ein:
   - WoW-Version und Sprache
   - AetherCore-Version: `/ac version`
   - Fehlermeldung (genaue Wortlaut)
   - Schritte zum Reproduzieren
   - Inhalt der Datei `AetherCore_error.log`

---

## Beitragen {#beitragen-de}

Beiträge sind willkommen! Helfen Sie, AetherCore zu verbessern:

### Wie man beiträgt

1. **Bugs melden**: Erstellen Sie ein Problem mit detaillierten Informationen
2. **Funktionen vorschlagen**: Teilen Sie Ideen für neue Module oder Verbesserungen
3. **Code einreichen**: Forken Sie das Repository und erstellen Sie einen Pull Request
4. **Dokumentation verbessern**: Helfen Sie uns, Leitfäden klarer zu gestalten
5. **Designs erstellen**: Entwerfen und teilen Sie benutzerdefinierte Designs

### Entwicklungs-Setup

```bash
git clone https://github.com/JugoBetrugoTV/AetherCore.git
cd AetherCore
# Nehmen Sie Ihre Änderungen vor
git commit -am "Beschreibung der Änderungen"
git push origin your-branch
```

### Code-Stil

- Folgen Sie Lua-Konventionen
- Fügen Sie Kommentare für komplexe Logik hinzu
- Testen Sie gründlich vor dem Einreichen von PRs
- Fügen Sie Dokumentation für neue Funktionen hinzu

---

## Lizenz

AetherCore wird unter der MIT-Lizenz freigegeben. Weitere Informationen finden Sie in der Datei [LICENSE](LICENSE).

---

## Danksagungen

**Entwickler**: JugoBetrugoTV  
**Mitwirkende**: Community-Mitglieder und Tester  
**Version**: 1.0.0  
**Zuletzt aktualisiert**: 19. Dezember 2025

---

**[⬆ Back to Top](#aethercore---wow-addon-framework)**
