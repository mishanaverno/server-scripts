#!/bin/bash
set -euo pipefail

if [[ -z "$1" ]]; then
    echo "Использование: $0 USER:PASS"
    exit 1
fi

INPUT="$1"

# USER:PASS
NEW_USER="${INPUT%%:*}"
USER_PASS="${INPUT#*:}"

if [[ -z "$NEW_USER" || -z "$USER_PASS" ]]; then
    echo "Ошибка: имя пользователя и пароль не должны быть пустыми"
    exit 1
fi

echo "[INFO] Создаём пользователя: $NEW_USER"

# Создание пользователя, если его нет
if ! id "$NEW_USER" &>/dev/null; then
    useradd -m -s /bin/bash "$NEW_USER"
    echo "$NEW_USER:$USER_PASS" | chpasswd
else
    echo "[INFO] Пользователь $NEW_USER уже существует"
fi

# Группа docker
if ! getent group docker &>/dev/null; then
    groupadd docker
fi

# Добавляем в группы
usermod -aG sudo,docker "$NEW_USER"

echo
echo "Готово!"
echo "Пользователь: $NEW_USER"
echo "Пароль: $USER_PASS"
echo "SSH root вход выключен."
