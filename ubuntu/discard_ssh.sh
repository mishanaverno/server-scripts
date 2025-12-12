#!/bin/bash
set -euo pipefail

SSH_PORT="$1"
SSH_CONFIG="/etc/ssh/sshd_config"

# запрет root
if grep -qE "^[[:space:]]*PermitRootLogin" "$SSH_CONFIG"; then
  sed -i "s/^[[:space:]]*PermitRootLogin.*/PermitRootLogin no/" "$SSH_CONFIG"
else
  echo "PermitRootLogin no" >> "$SSH_CONFIG"
fi

# порт
if grep -qE "^[[:space:]]*Port" "$SSH_CONFIG"; then
  sed -i "s/^[[:space:]]*Port.*/Port $SSH_PORT/" "$SSH_CONFIG"
else
  echo "Port $SSH_PORT" >> "$SSH_CONFIG"
fi

systemctl restart sshd

echo "SSH root вход выключен."
