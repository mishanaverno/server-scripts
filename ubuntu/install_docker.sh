#!/bin/bash
set -e

echo "[INFO] Updating system..."
apt update -y
apt upgrade -y

echo "[INFO] Removing old Docker versions (если были)..."
apt remove -y docker docker-engine docker.io containerd runc || true

echo "[INFO] Installing dependencies..."
apt install -y ca-certificates curl gnupg lsb-release

echo "[INFO] Adding Docker GPG key..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo "[INFO] Adding Docker repository..."
ARCH=$(dpkg --print-architecture)
UBUNTU_CODENAME=$(lsb_release -cs)

echo \
"deb [arch=${ARCH} signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu ${UBUNTU_CODENAME} stable" \
| tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "[INFO] Updating package index..."
apt update -y

echo "[INFO] Installing Docker Engine..."
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "[INFO] Enabling Docker service..."
systemctl enable docker
systemctl start docker

echo "[SUCCESS] Docker installed!"

echo
echo "=== Versions ==="
docker --version
docker compose version