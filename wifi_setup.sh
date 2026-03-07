#!/bin/bash

# 1. Get the wireless device name
DEVICE=$(iwctl device list | grep -E "station" | awk '{print $2}' | head -n 1)

if [ -z "$DEVICE" ]; then
    echo "Error: No wireless device found."
    exit 1
fi

echo "Using device: $DEVICE"

# 2. Scan and list networks
echo "Scanning for available networks..."
iwctl station "$DEVICE" scan
sleep 2 # Give the scan time to populate
echo "------------------------------------"
iwctl station "$DEVICE" get-networks
echo "------------------------------------"

# 3. Get SSID from user
read -p "Enter the SSID (Network Name): " SSID

# 4. Check if the network is already "Known" (saved)
IS_KNOWN=$(iwctl known-networks list | grep -w "$SSID")

if [ -n "$IS_KNOWN" ]; then
    echo "Known network detected. Connecting without password..."
    iwctl station "$DEVICE" connect "$SSID"
else
    # 5. New network: Ask for password
    echo "New network detected."
    read -sp "Enter Password for \"$SSID\": " PASSWORD
    echo -e "\nConnecting..."
    
    # Connect using the --passphrase flag for new connections
    iwctl --passphrase "$PASSWORD" station "$DEVICE" connect "$SSID"
fi

# 6. Verify Connection
sleep 2
echo "------------------------------------"
iwctl station "$DEVICE" show | grep -E "State|Connected network"
