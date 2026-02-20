# 🛜 macOS WiFi Diagnostics Tool

A lightweight, portable macOS WiFi diagnostics collector that gathers comprehensive wireless network information and packages it into a single ZIP file — ready to send to IT support or keep for your own records.

**No installation required. Just run one command in Terminal.**

---

## 📋 What It Does

Runs a full suite of macOS network and WiFi diagnostic commands, saves all output to a timestamped report, and compresses everything into a single `.zip` archive.

The tool automatically detects your WiFi interface name (typically `en0` or `en1`) so you don't need to configure anything before running it.

---

## 📦 What's Collected

| Category | Commands Used |
|---|---|
| **System Info** | `sw_vers`, `system_profiler SPHardwareDataType` |
| **IP Configuration** | `ifconfig`, `ipconfig getifaddr`, `ipconfig getpacket` |
| **Routing & Connections** | `netstat -rn`, active connections |
| **Connectivity Tests** | `ping`, `traceroute`, `nslookup`, `dig` |
| **DNS Settings** | DNS servers, search domains |
| **MTU Tests** | Fragmentation tests at 1472 and 1500 bytes |
| **Proxy Settings** | HTTP, HTTPS, SOCKS, PAC/auto-proxy, bypass domains |
| **WiFi Adapter & Driver** | `system_profiler SPAirPortDataType` |
| **Current Connection** | `airport -I` (signal, BSSID, channel, MCS rate, noise) |
| **Visible Networks** | `airport -s` (full scan with BSSID, signal, channel, security) |
| **Saved WiFi Profiles** | `networksetup -listpreferredwirelessnetworks` |
| **Network Services** | Service list, service order, current location |
| **ARP & IPv6 Neighbours** | `arp -a`, `ndp -a` |
| **Firewall Status** | Application firewall state and stealth mode |
| **System WiFi Logs** | Last 1 hour of WiFi-related system log entries |

---

## 🚀 How To Use

### Option 1 — Run directly from Terminal

```bash
curl -O https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/wifi_diagnostics.sh
chmod +x wifi_diagnostics.sh
./wifi_diagnostics.sh
```

### Option 2 — Download and run manually

1. Download `wifi_diagnostics.sh` from this repository
2. Open **Terminal** (`Applications → Utilities → Terminal`)
3. Navigate to your Downloads folder:
   ```bash
   cd ~/Downloads
   ```
4. Make the script executable:
   ```bash
   chmod +x wifi_diagnostics.sh
   ```
5. Run it:
   ```bash
   ./wifi_diagnostics.sh
   ```
6. Enter your Mac password when prompted (needed for a few commands)
7. Find your `WiFi_Report_YYYYMMDD_HHMMSS.zip` in the same folder when done

> **Tip:** Send the `.zip` file to your IT support team or keep it for your own troubleshooting records.

---

## 📁 Output Files

Running the tool produces a single ZIP in the same folder as the script:

```
WiFi_Report_20250219_143022.zip
└── WiFi_Diagnostics_20250219_143022.txt    ← Full text report of all commands
```

---

## ⚙️ Requirements

| Requirement | Details |
|---|---|
| **OS** | macOS 11 Big Sur or later (tested up to macOS 15 Sequoia) |
| **Shell** | Bash (built into macOS) |
| **Permissions** | Some commands require `sudo` — you will be prompted once for your password |
| **WiFi adapter** | A WiFi adapter must be present for WiFi-specific commands to return data |
| **Tools** | All tools used are built into macOS — no Homebrew or third-party installs needed |

> The `airport` utility is a hidden macOS tool located deep in a system framework. It provides richer WiFi signal data than any other built-in command. The script locates it automatically.

---

## 🔒 Privacy & Security

- **All data stays on your machine.** Nothing is uploaded or transmitted anywhere.
- You can review the full source code before running — it is a plain text `.sh` file.
- The `sudo` password prompt is required only for: network scanning (`airport -s`), firewall status, and system log access.
- The tool collects **network configuration data only**. It does **not** collect passwords, WiFi PSKs, personal files, or browser data.
- Saved WiFi network names are listed but **passwords are never extracted or logged**.

---

## 🛠️ Understanding the MTU Tests

The tool runs two ping tests with the "Don't Fragment" flag (`-D`):

| Test | Payload | Meaning if it **passes** |
|---|---|---|
| `ping -D -s 1472` | 1472 bytes + 28 byte header = 1500 | Standard 1500-byte MTU is intact |
| `ping -D -s 1500` | 1500 bytes + 28 byte header = 1528 | MTU is larger than standard (uncommon) |

If the **1472 test fails**, your effective MTU is below 1500 — common on VPN connections, PPPoE (DSL), or misconfigured networks. This can cause slow or broken connections for certain applications.

---

## 🔍 The `airport` Utility

The `airport` command is a powerful hidden macOS tool that provides detailed WiFi information not available through any other built-in command:

| Field | What it means |
|---|---|
| `SSID` | Name of the connected network |
| `BSSID` | MAC address of the access point you're connected to |
| `agrCtlRSSI` | Signal strength in dBm (closer to 0 is stronger) |
| `agrCtlNoise` | Background noise in dBm |
| `SNR` | Signal-to-noise ratio (higher is better) |
| `channel` | WiFi channel in use |
| `lastTxRate` | Last transmit rate in Mbps |
| `maxRate` | Maximum supported rate in Mbps |
| `MCS` | Modulation and Coding Scheme index |
| `NSS` | Number of spatial streams |

---

## 🖥️ Also Available for Windows

Looking for the Windows version of this tool? Check out the **Windows WiFi Diagnostics Tool** — same concept, built for Windows 10/11 using PowerShell.

➡️ [Windows WiFi Diagnostics Tool](https://github.com/YOUR_USERNAME/windows-wifi-diagnostics)

---

## 📄 License

This project is licensed under the **BSD 2-Clause License**. See [LICENSE](LICENSE) for details.

---

## 🤝 Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) before submitting a pull request.

---

## 📬 Author

**Manish Sharma**  
If you find this tool useful, feel free to ⭐ star the repository!
