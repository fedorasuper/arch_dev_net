#!/bin/bash

# Dates for filtering
TWO_DAYS_AGO=$(date -d "2 days ago" +'%Y-%m-%d')
SEVEN_DAYS_AGO=$(date -d "7 days ago" +'%Y-%m-%d')

echo "==============================="
echo "  ADVANCED NETWORK DIAGNOSTIC  "
echo "==============================="
echo "Generated on: $(date)"
echo "Hostname: $(hostname)"
echo

# -----------------------------
echo "1) Network Interfaces & IP:"
ip -brief addr
echo

echo "Routing Table:"
ip route
echo

# -----------------------------
echo "2) Open Listening Ports:"
ss -tulnp
echo

echo "Established Connections:"
ss -tanp | grep ESTAB
echo

# -----------------------------
echo "3) Check for Promiscuous Mode (Packet Sniffing Risk):"
ip link | grep PROMISC && echo "⚠ Promiscuous mode detected!"
echo

# -----------------------------
echo "4) Firewall Status & Rules:"
if command -v ufw >/dev/null 2>&1; then
    ufw status verbose
elif command -v firewall-cmd >/dev/null 2>&1; then
    firewall-cmd --state
    firewall-cmd --list-all
elif command -v iptables >/dev/null 2>&1; then
    iptables -L -n -v
fi
echo

# -----------------------------
echo "5) Check for Suspicious Processes:"
ps aux | grep -Ei "nc|netcat|nmap|hydra|xmrig|cryptominer|meterpreter|reverse_shell|tcpdump|wireshark" | grep -v grep
echo

# -----------------------------
echo "6) Check for SSH Security Settings:"
if [ -f /etc/ssh/sshd_config ]; then
    grep -Ei "PermitRootLogin|PasswordAuthentication" /etc/ssh/sshd_config
fi
echo

# -----------------------------
echo "7) DNS Configuration:"
cat /etc/resolv.conf
echo

# -----------------------------
echo "8) Hosts File Check (Possible Hijack):"
cat /etc/hosts
echo

# -----------------------------
echo "9) Recent Failed Login Attempts:"
lastb 2>/dev/null | head -n 10
echo

# -----------------------------
echo "10) Active Services:"
if command -v systemctl >/dev/null 2>&1; then
    systemctl list-units --type=service --state=running
fi
echo

# -----------------------------
echo "11) Check for World-Writable Files:"
find / -xdev -type f -perm -0002 2>/dev/null
echo

#-----------------------------
echo -e "\n[4] NEW FILES IN HOME DIRECTORY (Last 7 Days)"
# Changed -mtime -2 to -mtime -7
find ~ -type f -mtime -7 -ls 2>/dev/null | head -n 15

# -----------------------------
echo "12) Check Installed Repositories:"
if [ -d /etc/apt ]; then
    grep -r "^deb " /etc/apt/ 2>/dev/null
elif [ -d /etc/yum.repos.d ]; then
    grep -r "baseurl" /etc/yum.repos.d/ 2>/dev/null
fi
echo

echo "==============================="
echo " Network Diagnostic Complete"
echo "==============================="

echo " !! stop the button activity lokkup has been completed !!"

