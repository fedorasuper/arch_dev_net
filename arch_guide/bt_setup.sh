#!/bin/bash

echo "Turning Bluetooth Power ON..."
bluetoothctl power on
sleep 1

echo "Scanning for devices (5 seconds)..."
# Start scan in background, wait, then stop
bluetoothctl scan on & 
SCAN_PID=$!
sleep 5
kill $SCAN_PID

echo "------------------------------------"
echo "Available & Paired Devices:"
bluetoothctl devices
echo "------------------------------------"

# 1. Get User Input (Can be Name or MAC Address)
read -p "Enter the Device MAC Address (or unique part of name): " TARGET

# 2. Find the actual MAC Address if the user typed a name
DEVICE_MAC=$(bluetoothctl devices | grep -i "$TARGET" | awk '{print $2}' | head -n 1)

if [ -z "$DEVICE_MAC" ]; then
    echo "Error: Device not found in scan results."
    exit 1
fi

echo "Targeting Device: $DEVICE_MAC"

# 3. Check if already paired
IS_PAIRED=$(bluetoothctl info "$DEVICE_MAC" | grep "Paired: yes")

if [ -n "$IS_PAIRED" ]; then
    echo "Device already paired. Connecting..."
    bluetoothctl connect "$DEVICE_MAC"
else
    echo "New device detected. Attempting to Pair, Trust, and Connect..."
    # Using 'pair', 'trust', and 'connect' sequence
    bluetoothctl pair "$DEVICE_MAC"
    bluetoothctl trust "$DEVICE_MAC"
    bluetoothctl connect "$DEVICE_MAC"
fi

# 4. Final Status Check
echo "------------------------------------"
bluetoothctl info "$DEVICE_MAC" | grep "Connected:"
