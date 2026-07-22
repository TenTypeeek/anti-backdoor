# 🛡️ Eclipse AntiBackdoor

Stop malicious resources before they become a problem.
**Eclipse AntiBackdoor** is a lightweight security resource for FiveM that automatically scans your server for known backdoors by cross-referencing files against a live database of malicious domains. If a threat is detected, it immediately force-stops the infected resource to keep your server safe.
Built for server owners who want automated, real-time protection without sacrificing server performance.

## 🚀 Why Eclipse AntiBackdoor?
Every day, leaked resources and fake "optimized" scripts circulate through the FiveM community. Many contain hidden backdoors that connect to malicious remote endpoints or grant unauthorized access to your server.
**Eclipse AntiBackdoor** acts as your automated security guard. Scanning newly loaded resources on the fly, halting malicious scripts before they execute, and alerting your team instantly.

## ✨ Features
- **⚡ Real-Time Resource Protection**
  - Automatically inspects any resource as soon as it starts (`onResourceStart`).
  - **Auto-Quarantine:** Instantly force-stops (`stop <resource>`) infected resources before they can execute harmful payloads.
- **🌐 Dynamic Threat Database**
  - Downloads the latest known malicious domain signatures directly from an online threat database on startup.
  - Ensures protection against brand-new threats as soon as they are identified.
- **📦 Built-in Offline Fallback**
  - If the online API is unreachable, the system automatically falls back to an internal list of known malicious domains.
- **📄 Deep Resource Inspection**
  - Scans resource manifests (`fxmanifest.lua`, `__resource.lua`).
  - Scans files declared inside manifests automatically.
  - Checks common script locations (`server.lua`, `client.lua`, `server/main.lua`, `client/main.lua`, `config.lua`).
- **🚨 Instant Discord Webhook Alerts**
  - Sends a detailed alert directly to your Discord channel when a threat is identified, containing:
  - Resource name
  - Infected file path
  - Specific malicious domain found
* **🪶 Extremely Lightweight**
  - Scans only when resources are actively starting up.
  - Zero continuous background loops or performance cost during gameplay.

## 📸 What You Get
- ✅ **Automated Threat Detection & Auto-Stop**
- ✅ **Detailed Color-Coded Console Logging**
- ✅ **Discord Security Alerts**
- ✅ **Continuously Updated Domain Database + Fallback**
- ✅ **Zero Framework Dependencies (Works on standalone, ESX, QB-Core, etc.)**

## 🛠️ Compatibility

- ✅ **FiveM FXServer (Linux / Windows)**
- ✅ **Framework Independent** (Runs standalone on any server)

## 📥 Installation

0. Download the resource (ofc) https://github.com/TenTypeeek/Anti-Backdoor
1. Download the resource and place `ec_antibackdoor` into your `resources` folder.
2. Open `main.lua` and set your Discord Webhook URL:
```lua
local webhookUrl = "YOUR_DISCORD_WEBHOOK_URL_HERE"
```
3. Add `ensure ec_antibackdoor` near the top of your `server.cfg` so it starts before other resources.
4. Restart your server.

That's it! Your server is now protected*.

*this doesnt meant that you are 100% protected from all backdoors, there can still be some undetected backdoors

## ❤️ Open Source

Eclipse AntiBackdoor is completely open source.
Contributions, feature suggestions, and community pull requests are always welcome!