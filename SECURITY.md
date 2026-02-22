# Security Policy

## Supported Versions

Only the latest release of the macOS WiFi Diagnostics Tool is actively maintained and eligible for security fixes.

| Version | Supported |
|---|---|
| Latest release | ✅ |
| Older releases | ❌ |

---

## What This Tool Collects

Before reporting a security concern, please understand what this tool does and does not collect:

**Collected:**
- Network interface configuration (IP addresses, MAC addresses, subnet masks)
- Routing table entries
- Visible WiFi networks and their BSSIDs (requires sudo)
- Saved WiFi profile names (SSIDs only — no passwords)
- DNS server addresses and search domains
- Proxy configuration
- WiFi adapter, driver, and signal details
- ARP and IPv6 neighbour tables
- Firewall state
- WiFi-related system log entries (last 2 hours)

**Never collected:**
- WiFi passwords or PSKs (macOS Keychain is never accessed)
- Browser history, cookies, or saved credentials
- Personal files or documents
- macOS account passwords
- Content of network traffic

---

## Reporting a Vulnerability

**Please do not report security vulnerabilities through public GitHub issues.**

If you discover a security vulnerability in this tool — for example, a scenario where the script could expose sensitive data, be exploited via a crafted network environment, execute arbitrary commands, or be used to escalate privileges — please report it privately.

**How to report:**

1. Go to the **Security** tab of this repository
2. Click **"Report a vulnerability"** to open a private advisory
3. Provide as much detail as possible (see template below)

Alternatively, you may contact the maintainer directly through GitHub by sending a private message.

**Please include in your report:**
- A description of the vulnerability and its potential impact
- Steps to reproduce the issue
- The macOS version and hardware (Intel or Apple Silicon) you observed it on
- Any suggested mitigations if you have them

---

## Response Timeline

| Action | Timeframe |
|---|---|
| Acknowledgement of report | Within 5 business days |
| Initial assessment | Within 10 business days |
| Fix or mitigation | As soon as reasonably possible depending on severity |
| Public disclosure | After a fix is released, coordinated with the reporter |

---

## Security Design Notes

This tool is designed with the following security principles:

- **No network transmission** — all output is saved locally. Nothing is uploaded anywhere.
- **Minimal sudo usage** — `sudo` is requested once at the start and used only for commands that genuinely require elevated access (`airport -s`, firewall queries, system log access). It is never used to modify system state.
- **Read-only** — the tool only reads system state. It does not modify network settings, system preferences, Keychain, or any configuration.
- **No third-party dependencies** — the tool uses only built-in macOS commands. No Homebrew packages, external binaries, or internet downloads are used.
- **Open source** — the full source of `wifi_diagnostics.sh` is available for review before running.
- **Sudo keepalive is scoped** — the background sudo keepalive process is explicitly killed when the script exits, and also terminates automatically if the parent process dies.

---

## Scope

This security policy covers `wifi_diagnostics.sh` in this repository. It does not cover:

- Forks or modified versions of this tool
- Third-party apps referenced in the README (e.g. Network Analyzer Pro)
- The underlying macOS operating system, Bash shell, or system frameworks

---

## Note on the `airport` Utility

The `airport` command is a private Apple framework binary. This tool uses it read-only to query current connection state and scan visible networks. It does not exploit or misuse the binary in any way. Apple has been progressively deprecating this utility in newer macOS versions and the script handles its absence gracefully.

---

*This policy was last reviewed: 2025*
