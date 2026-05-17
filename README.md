# ⚔️ CharacterExporter — Anniversary Edition

> A World of Warcraft addon for **TBC Anniversary** that exports your character's data with a single command.

![WoW Version](https://img.shields.io/badge/WoW-TBC%20Anniversary-f5c342?style=flat-square&logo=battle.net&logoColor=white)
![Version](https://img.shields.io/badge/version-0.1-blueviolet?style=flat-square)
![Language](https://img.shields.io/badge/language-Lua-00b4d8?style=flat-square)
![Interface](https://img.shields.io/badge/interface-20505-success?style=flat-square)
![License](https://img.shields.io/badge/license-MIT-orange?style=flat-square)

---

## 📖 About

**CharacterExporter** is a lightweight WoW addon designed for the TBC Anniversary server. It collects your character's stats, equipped gear, and other relevant data, then presents it in a clean, exportable format — ideal for tools, logs, spreadsheets, or personal tracking.

---

## ✨ Features

- 📋 **Character data export** — name, class, race, level, and stats
- 🛡️ **Equipment snapshot** — full list of equipped items with IDs and slots
- 🖥️ **In-game UI** — simple interface to trigger and copy the export
- ⚡ **Slash command** — export instantly from anywhere in the world
- 🪶 **Zero dependencies** — pure Lua, no external libraries needed

---

## 📁 Project Structure

```
CharacterExporter-Anniversary/
├── Core.lua                  # Addon initialization, logging & slash command
├── CharacterExporter.toc     # Addon metadata & load order
└── Modules/
    ├── Character.lua         # Character stats collection
    ├── Equipment.lua         # Equipped item data collection
    └── UI.lua                # In-game export window
```

---

## 🚀 Installation

1. Download or clone this repository:

   ```bash
   git clone https://github.com/Layno-Dev/CharacterExporter-Anniversary.git
   ```

2. Copy the `CharacterExporter-Anniversary` folder into your WoW addons directory:

   ```
   World of Warcraft/_classic_era_/Interface/AddOns/CharacterExporter/
   ```

3. Launch WoW, log in, and enable the addon in the **AddOns** menu on the character selection screen.

---

## 🎮 Usage

Once in-game, use the following slash command to trigger an export:

```
/cexport
```

This will open the export window with your character's current data ready to copy.

---

## 🧩 Compatibility

| Client                  | Status           |
| ----------------------- | ---------------- |
| TBC Anniversary (20505) | ✅ Supported     |
| Classic Era             | ⚠️ Untested      |
| Retail / Cata Classic   | ❌ Not supported |

---

## 🛠️ Development

Contributions are welcome! If you want to add features or fix bugs:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Commit your changes: `git commit -m "feat: add my feature"`
4. Push and open a Pull Request

### Useful Resources

- [WoW API Reference](https://warcraft.wiki.gg/wiki/World_of_Warcraft_API)
- [Addon Development Guide](https://warcraft.wiki.gg/wiki/Getting_started_with_writing_addons)
- [Lua 5.1 Reference](https://www.lua.org/manual/5.1/)

---

## 👤 Author

**LaynoZ** — [@Layno-Dev](https://github.com/Layno-Dev)

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

<p align="center">
  Built for adventurers, theorycrafters, and addon nerds
</p>
