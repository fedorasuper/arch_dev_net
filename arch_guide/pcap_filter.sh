#!/bin/bash

echo "=========================================="
echo "      CUSTOM PACKET CAPTURE (TCPDUMP)     "
echo "=========================================="

# 1. Get User Input
read -p "Enter Source IP (or press Enter for any): " SRC_IP
read -p "Enter Destination IP (or press Enter for any): " DST_IP
read -p "Enter Port Number (or press Enter for any): " PORT

# 2. Build the Filter String
FILTER=""

if [ -n "$SRC_IP" ]; then
    FILTER="src host $SRC_IP"
fi

if [ -n "$DST_IP" ]; then
    if [ -n "$FILTER" ]; then FILTER="$FILTER and "; fi
    FILTER="${FILTER}dst host $DST_IP"
fi

if [ -n "$PORT" ]; then
    if [ -n "$FILTER" ]; then FILTER="$FILTER and "; fi
    FILTER="${FILTER}port $PORT"
fi

# 3. Execution Logic
echo -e "\n[!] Starting capture on all interfaces..."
if [ -z "$FILTER" ]; then
    echo "[*] Filter: Capturing ALL traffic (No filters provided)"
    sudo tcpdump -i any -n -A
else
    echo "[*] Filter: $FILTER"
    # Run the command with the constructed filter
    sudo tcpdump -i any -n -A $FILTER
fi
