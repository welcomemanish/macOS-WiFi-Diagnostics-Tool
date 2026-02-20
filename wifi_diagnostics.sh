#!/bin/bash
# ============================================================
# macOS WiFi Diagnostics Tool
# by Manish Sharma
#
# Collects comprehensive WiFi and network diagnostic info
# and packages everything into a single .zip archive.
# ============================================================

# ---- Colour codes ------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
BOLD='\033[1m'
RESET='\033[0m'

# ---- Header ------------------------------------------------
clear
echo ""
echo -e "${GRAY}============================================${RESET}"
echo -e "${CYAN}${BOLD}  macOS WiFi Diagnostics Tool${RESET}"
echo -e "${YELLOW}  by Manish Sharma${RESET}"
echo -e "${GRAY}============================================${RESET}"
echo ""

# ---- Check for sudo ----------------------------------------
if [ "$EUID" -ne 0 ]; then
    echo -e "${YELLOW}Some commands require Administrator (sudo) access.${RESET}"
    echo -e "${YELLOW}You may be prompted for your password.${RESET}"
    echo ""
    sudo -v
    if [ $? -ne 0 ]; then
        echo -e "${RED}sudo authentication failed. Some results may be incomplete.${RESET}"
    fi
fi

# Keep sudo session alive for the duration of the script
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
SUDO_KEEPALIVE_PID=$!

# ---- Detect WiFi interface ---------------------------------
WIFI_IF=$(networksetup -listallhardwareports 2>/dev/null | awk '/Wi-Fi/{found=1} found && /Device:/{print $2; exit}')

if [ -z "$WIFI_IF" ]; then
    echo -e "${RED}WARNING: No Wi-Fi interface detected. Some commands will be skipped.${RESET}"
    WIFI_IF="en0"  # fallback default
else
    echo -e "${GREEN}Detected WiFi interface: ${BOLD}$WIFI_IF${RESET}"
fi
echo ""

# ---- airport utility path ----------------------------------
AIRPORT="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"

# ---- Output paths ------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_TXT="$SCRIPT_DIR/WiFi_Diagnostics_$TIMESTAMP.txt"
ZIP_FILE="$SCRIPT_DIR/WiFi_Report_$TIMESTAMP.zip"

# ---- File header -------------------------------------------
cat > "$OUTPUT_TXT" <<EOF
macOS WiFi Diagnostics Tool Report
Generated : $(date '+%Y-%m-%d %H:%M:%S')
User      : $(whoami)
Hostname  : $(hostname)
macOS     : $(sw_vers -productName) $(sw_vers -productVersion) ($(sw_vers -buildVersion))
WiFi IF   : $WIFI_IF
============================================

EOF

# ---- Helper function ---------------------------------------
run_and_log() {
    local LABEL="$1"
    local CMD="$2"
    local USE_SUDO="${3:-false}"

    echo -e "${CYAN}Running: $LABEL${RESET}"

    # Section header in file
    cat >> "$OUTPUT_TXT" <<EOF
============================================
$LABEL
============================================
EOF

    # Run command
    if [ "$USE_SUDO" = "true" ]; then
        OUTPUT=$(sudo bash -c "$CMD" 2>&1)
    else
        OUTPUT=$(bash -c "$CMD" 2>&1)
    fi

    # Print to console
    echo "$OUTPUT"
    echo -e "${GRAY}---${RESET}"
    echo ""

    # Save to file
    echo "$OUTPUT" >> "$OUTPUT_TXT"
    echo "" >> "$OUTPUT_TXT"
}

# ============================================================
# SECTION 1 — System Info
# ============================================================
run_and_log "Date / Time"                               "date"
run_and_log "macOS Version"                             "sw_vers"
run_and_log "System Hardware Info"                      "system_profiler SPHardwareDataType"

# ============================================================
# SECTION 2 — Basic Connectivity
# ============================================================
run_and_log "Network Interface Config (ifconfig)"       "ifconfig"
run_and_log "IP Address ($WIFI_IF)"                     "ipconfig getifaddr $WIFI_IF"
run_and_log "DHCP Info ($WIFI_IF)"                      "ipconfig getpacket $WIFI_IF"
run_and_log "Routing Table"                             "netstat -rn"
run_and_log "Active Network Connections"                "netstat -an | head -60"
run_and_log "Ping 8.8.8.8 (4 packets)"                 "ping -c 4 8.8.8.8"
run_and_log "Traceroute to 8.8.8.8"                    "traceroute -n -m 30 -w 2 8.8.8.8"
run_and_log "DNS Lookup (google.com) - nslookup"        "nslookup google.com"
run_and_log "DNS Lookup (google.com) - dig"             "dig google.com"
run_and_log "DNS Servers ($WIFI_IF)"                    "networksetup -getdnsservers $WIFI_IF"
run_and_log "Search Domains ($WIFI_IF)"                 "networksetup -getsearchdomains $WIFI_IF"

# ============================================================
# SECTION 3 — MTU Tests
# NOTE: -D sets the Do Not Fragment flag (equivalent to -f on Windows)
#       -s sets payload size. Add 28 bytes for IP/ICMP header.
#       1472 + 28 = 1500 (standard Ethernet MTU)
#       If 1472 passes but 1500 fails, fragmentation is occurring.
#       Common on VPNs, PPPoE (DSL), or misconfigured networks.
# ============================================================
run_and_log "MTU Test - 1472 bytes (target: no fragmentation)"    "ping -c 4 -D -s 1472 8.8.8.8"
run_and_log "MTU Test - 1500 bytes (expect failure if MTU=1500)"  "ping -c 4 -D -s 1500 8.8.8.8"

# ============================================================
# SECTION 4 — Proxy Settings
# ============================================================
run_and_log "Web Proxy (HTTP)"                          "networksetup -getwebproxy $WIFI_IF"
run_and_log "Secure Web Proxy (HTTPS)"                  "networksetup -getsecurewebproxy $WIFI_IF"
run_and_log "SOCKS Proxy"                               "networksetup -getsocksfirewallproxy $WIFI_IF"
run_and_log "Auto-Proxy (PAC)"                          "networksetup -getautoproxyurl $WIFI_IF"
run_and_log "Proxy Bypass Domains"                      "networksetup -getproxybypassdomains $WIFI_IF"

# ============================================================
# SECTION 5 — WiFi Adapter & Hardware Details
# ============================================================
run_and_log "WiFi Hardware & Driver Info (system_profiler)"    "system_profiler SPAirPortDataType"
run_and_log "Network Hardware Ports"                           "networksetup -listallhardwareports"
run_and_log "WiFi Interface Details (networksetup)"            "networksetup -getinfo Wi-Fi"
run_and_log "WiFi Power Status"                                "networksetup -getairportpower $WIFI_IF"

# ============================================================
# SECTION 6 — Current WiFi Connection
# ============================================================
if [ -f "$AIRPORT" ]; then
    run_and_log "Current WiFi Connection Details (airport)"    "$AIRPORT -I"
    run_and_log "Scan Visible Networks (airport)"              "$AIRPORT -s" "true"
else
    echo -e "${YELLOW}airport utility not found — skipping airport commands${RESET}"
    echo "airport utility not found — skipping airport commands" >> "$OUTPUT_TXT"
fi

run_and_log "WiFi Network Name (SSID)"                         "networksetup -getairportnetwork $WIFI_IF"

# ============================================================
# SECTION 7 — Saved WiFi Profiles
# ============================================================
run_and_log "Preferred Wireless Networks (saved profiles)"    "networksetup -listpreferredwirelessnetworks $WIFI_IF"

# ============================================================
# SECTION 8 — Network Services & Configuration
# ============================================================
run_and_log "All Network Services"                             "networksetup -listallnetworkservices"
run_and_log "Network Service Order"                            "networksetup -listnetworkserviceorder"
run_and_log "Location"                                         "networksetup -getcurrentlocation"

# ============================================================
# SECTION 9 — ARP & Neighbours
# ============================================================
run_and_log "ARP Table"                                        "arp -a"
run_and_log "NDP Neighbour Table (IPv6)"                       "ndp -a 2>/dev/null || echo 'ndp not available'"

# ============================================================
# SECTION 10 — Firewall
# ============================================================
run_and_log "Application Firewall Status"                      "/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate" "true"
run_and_log "Firewall Stealth Mode"                            "/usr/libexec/ApplicationFirewall/socketfilterfw --getstealthmode" "true"

# ============================================================
# SECTION 11 — System Logs (WiFi related, last 100 lines)
# ============================================================
run_and_log "Recent WiFi System Log Entries"  \
    "log show --predicate 'subsystem == \"com.apple.wifi\"' --last 1h --info 2>/dev/null | tail -100 || echo 'log command unavailable'" \
    "true"

# ============================================================
# ZIP the output
# ============================================================
echo -e "${CYAN}Creating ZIP archive...${RESET}"

zip -j "$ZIP_FILE" "$OUTPUT_TXT" 2>/dev/null

if [ $? -eq 0 ]; then
    # Clean up the raw txt file since it's now inside the zip
    rm "$OUTPUT_TXT"
    echo -e "${GREEN}ZIP created -> $ZIP_FILE${RESET}"
else
    echo -e "${RED}Failed to create ZIP. Report saved as: $OUTPUT_TXT${RESET}"
fi

# ---- Kill sudo keepalive -----------------------------------
kill "$SUDO_KEEPALIVE_PID" 2>/dev/null

# ============================================================
# Done
# ============================================================
echo ""
echo -e "${GRAY}============================================${RESET}"
echo -e "${GREEN}${BOLD}  All diagnostics complete!${RESET}"
echo -e "${BOLD}  Report saved to:${RESET}"
echo -e "${YELLOW}  $ZIP_FILE${RESET}"
echo -e "${GRAY}============================================${RESET}"
echo ""
echo -e "${GRAY}Copyright (c) $(date +%Y) Manish Sharma. All rights reserved.${RESET}"
echo ""
