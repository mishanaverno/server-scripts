#!/bin/bash
set -euo pipefail

# -------------------------
# Функции ввода
# -------------------------
read_nonempty() {
  local prompt="$1" v
  while true; do
    read -rp "$prompt" v
    [ -n "$v" ] && { printf '%s' "$v"; return; }
    echo "Значение не может быть пустым."
  done
}

INPUT="$1"

if [[ "$INPUT" != *@*:* ]]; then
    echo "Неверный формат. Используй name@host:port"
    exit 1
fi

NAME="${INPUT%%@*}"
HOST_PORT="${INPUT#*@}"

HOST="${HOST_PORT%%:*}"
PORT="${HOST_PORT##*:}"

if [[ -z "$NAME" || -z "$HOST" || -z "$PORT" ]]; then
    echo "Ошибка: имя, хост или порт пустые."
    exit 1
fi

PASS=$(read_nonempty "Пароль пользователя: ")

echo "NEW_USER=$NAME"
echo "NEW_PASS=$PASS"
echo "HOST=$HOST"
echo "NEW_SSH_PORT=$PORT"

ssh -p 22 root@$HOST "
  bash -c \"\$(wget -qO - https://raw.githubusercontent.com/mishanaverno/server-scripts/main/ubuntu/create_user.sh)\" -- $NAME:$PASS &&
  bash -c \"\$(wget -qO - https://raw.githubusercontent.com/mishanaverno/server-scripts/main/ubuntu/discard_ssh.sh)\" -- $PORT &&
  bash -c \"\$(wget -qO - https://raw.githubusercontent.com/mishanaverno/server-scripts/main/ubuntu/install_docker.sh)\"
"
