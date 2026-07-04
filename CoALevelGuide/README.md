# ⚔ CoA Level Guide — Conquest of Azeroth Leveling Addon

A comprehensive, feature-rich WoW addon for **Conquest of Azeroth** (Project Ascension) providing step-by-step leveling guidance, class tips, zone info, and waypoint integration.

---

## 📦 Installation

1. **Locate your WoW AddOns folder:**
   ```
   <WoW Install>\WTF\Account\<AccountName>\Interface\AddOns\
   ```
   > On Ascension/CoA, this is typically inside the Ascension launcher's game folder.

2. **Copy the entire `CoALevelGuide` folder** into the `AddOns` directory:
   ```
   Interface\AddOns\CoALevelGuide\
   ```

3. **Launch the game.** At the character select screen, click **"AddOns"** and make sure **CoA Level Guide** is checked and enabled.

4. **Log in.** A welcome message will appear in chat confirming the addon loaded.

---

## 🎮 Features

### 📋 Guide Tab
- **Step-by-step leveling guide** covering levels 1–60 for both Alliance and Horde
- Phase-based progression that auto-detects your faction and level
- **Per-step checkboxes** — click any step to mark it complete (saved across sessions)
- **Progress bars** showing completion percentage per zone phase
- Color-coded step types:
  - 🟡 Accept Quest
  - 🟢 Turn In Quest
  - 🔴 Kill / Farm
  - 🔵 Travel
  - 🟣 Dungeon
  - 🩵 Explore
  - ⚪ Tip / Warning
- **Waypoint support**: Right-click any step with coordinates to set a TomTom waypoint
- 📍 Coordinate indicator on steps that have map locations

### ⚔ Classes Tab
- **8 featured CoA classes** with full details (more to come in updates)
- Each class shows:
  - Role, Resource type, and Difficulty rating ★★★
  - All 3 specializations with descriptions
  - 8+ leveling tips specific to that class
  - Recommended best zones for leveling
- Click a class header to expand/collapse details

### 🗺 Zone Info Tab
- Every major leveling zone 1–60 for your faction
- Zone description, level range, flight path, and main hub
- 4–5 specific tips per zone
- Scrollable zone browser

### 🧭 Minimap Button
- Draggable minimap button (position saved across sessions)
- **Left Click**: Toggle the guide window
- **Right Click**: Options menu (Reset Progress, Open Guide)
- Hover tooltip with quick instructions

---

## 💬 Slash Commands

| Command | Description |
|---------|-------------|
| `/coalvl` | Toggle the guide window open/closed |
| `/coalvl zone` | Print your recommended leveling zone to chat |
| `/coalvl wp` | Set TomTom waypoint for your next incomplete step |
| `/coalvl class` | Open the Classes browser tab |
| `/coalvl reset` | Reset all saved progress (with confirmation) |
| `/coalvl help` | Show all available commands |

**Alias:** `/coalevelguide` works the same as `/coalvl`

---

## 🗺 TomTom Integration

For full waypoint support, install **TomTom** (WotLK 3.3.5 compatible version):
- With TomTom installed, right-clicking any step with coordinates will place a **crazy arrow** pointing you to the destination
- Without TomTom, the `/way` command is printed to chat for reference

---

## 📖 Leveling Phases Covered

| Phase | Levels | Content |
|-------|--------|---------|
| 1 (A) | 1–10   | Elwynn Forest |
| 2 (A) | 10–20  | Westfall + Deadmines |
| 3 (A) | 20–30  | Redridge Mountains + Duskwood |
| 1 (H) | 1–10   | Durotar |
| 2 (H) | 10–25  | The Barrens + Wailing Caverns |
| 4     | 25–40  | Stranglethorn Vale (Both) |
| 5     | 40–50  | Tanaris + Feralas (Both) |
| 6     | 50–60  | Un'Goro + Burning Steppes + EPL (Both) |

---

## ⚙ Classes Included

| Class | Role | Resource |
|-------|------|----------|
| Felsworn | DPS / Tank | Felfury |
| Witch Hunter | DPS Hybrid | Focus |
| Necromancer | DPS / Support | Runic Power |
| Tinker | DPS / Support | Energy |
| Runemaster | DPS / Tank | Rune Charges |
| Chronomancer | DPS / Support | Temporal Energy |
| Warden | Tank / DPS | Resolve |
| Spiritwalker | Healer / Support | Mana / Spirit |

---

## 🔧 Compatibility

- **WoW Client:** WotLK 3.3.5a (`## Interface: 30300`)
- **Server:** Conquest of Azeroth (Project Ascension)
- **TomTom:** Optional but recommended for waypoint arrows
- **SavedVariables:** Progress is saved per-account in `WTF\Account\<Name>\SavedVariables\CoALevelGuide.lua`

---

## 📝 Notes & Tips

> **CoA's open-world scaling** means you have flexibility in zone order. The guide provides an efficient path but feel free to explore!

> **At level 10**, visit your class trainer to unlock your **Specialization** — this dramatically changes your leveling style.

> **At level 30**, you can further customize your character using **Ability Essences** from the CoA system.

> **Dungeons** are highly recommended throughout leveling. The Random Dungeon Finder lets you queue while questing!

---

## 🛠 Developer Notes

The addon is structured as follows:
```
CoALevelGuide/
├── CoALevelGuide.toc       # Table of Contents (addon manifest)
├── CoALevelGuide.lua       # Entry point, events, slash commands
├── Data/
│   ├── Zones.lua           # Zone data (level ranges, tips, hubs)
│   ├── Classes.lua         # Class data (specs, tips, roles)
│   └── Steps.lua           # Step-by-step guide data
├── Core/
│   ├── Utils.lua           # Shared utility functions
│   ├── Waypoints.lua       # TomTom/waypoint integration
│   └── Progress.lua        # SavedVariables progress tracking
└── UI/
    ├── MinimapButton.lua   # Draggable minimap button
    ├── MainFrame.lua       # Main window with tab system
    ├── StepList.lua        # Guide tab: step list with checkboxes
    ├── ClassPanel.lua      # Classes tab: expandable class cards
    └── Tooltip.lua         # Enhanced tooltip helpers
```

To add more steps or classes, edit the files in `Data/`. The format is self-documenting with clear comments.

---

*Made with ❤️ for the Conquest of Azeroth community.*
