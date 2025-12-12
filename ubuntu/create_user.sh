#!/bin/bash
set -euo pipefail

NEW_USER="$1"
USER_PASSWORD="$2"

# и создание пользователя
if id "$NEW_USER" &>/dev/null; then
  echo "Пользователь $NEW_USER уже существует"
else
  useradd -m -s /bin/bash "$NEW_USER"
  # используем printf чтобы ровно одна строка form:user:pass\n
  printf "%s:%s\n" "$NEW_USER" "$USER_PASSWORD" | chpasswd
fi

# группа docker
if ! getent group docker >/dev/null; then
  groupadd docker
fi

usermod -aG sudo,www-data,docker "$NEW_USER"
