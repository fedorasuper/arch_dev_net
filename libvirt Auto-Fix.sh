#!/usr/bin/env bash
echo "==== KVM / QEMU / libvirt Auto-Fix for Arch Linux ===="
if [[ $EUID -ne 0 ]]; then
  echo "[ERROR] Run this script with sudo:"
  echo "  sudo $0"
  exit 1
fi
USER_NAME=${SUDO_USER}
echo "[INFO] Installing required packages..."
pacman -S --needed --noconfirm \
  qemu-full \
  libvirt \
  virt-manager \
  dnsmasq \
  bridge-utils \
  dmidecode
echo "[INFO] Enabling and starting libvirtd..."
systemctl enable --now libvirtd
echo "[INFO] Loading KVM kernel modules..."
if grep -q vmx /proc/cpuinfo; then
  echo "  Detected Intel CPU"
  modprobe kvm_intel
elif grep -q svm /proc/cpuinfo; then
  echo "  Detected AMD CPU"
  modprobe kvm_amd
else
  echo "[WARN] Could not detect Intel/AMD virtualization flags"
fi
echo "[INFO] Adding user to libvirt and kvm groups..."
if [[ -n "$USER_NAME" ]]; then
  usermod -aG libvirt,kvm "$USER_NAME"
  echo "  User '$USER_NAME' added to groups"
fi
echo "[INFO] Restarting libvirtd..."
systemctl restart libvirtd
echo
echo "==== STATUS CHECK ===="
echo "[CHECK] QEMU binary:"
which qemu-system-x86_64
echo
echo "[CHECK] KVM modules:"
lsmod | grep kvm
echo
echo "[CHECK] libvirtd status:"
systemctl --no-pager status libvirtd | head -n 10
echo
echo "==== DONE ===="
echo "IMPORTANT: Log out and log back in for group changes to take effect!"
