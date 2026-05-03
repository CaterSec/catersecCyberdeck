#!/usr/bin/env bash
set -euo pipefail

# Bootstrap mínimo para CiberDeck - CATERSEC
# Ejecutar como root o con sudo: sudo bash scripts/bootstrap.sh catersec
USERNAME=${1:-catersec}

echo "Ejecutando bootstrap para usuario: $USERNAME"

apt update && apt full-upgrade -y
apt install -y sudo htop curl git ufw python3-pip

# Crear usuario si no existe
if ! id -u "$USERNAME" >/dev/null 2>&1; then
  adduser --gecos "" "$USERNAME"
fi

# Añadir a grupos
usermod -aG sudo,kali,netdev,audio,video "$USERNAME" || true

# Instalar docker
apt install -y docker.io
systemctl enable --now docker
usermod -aG docker "$USERNAME" || true

# Instalar herramientas básicas
apt install -y nmap aircrack-ng bettercap wireshark metasploit-framework nikto hydra wordlists || true

# Python deps para OLED
pip3 install --upgrade pip || true
pip3 install luma.oled psutil || true

# Firewall básico
apt install -y ufw || true
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 9443/tcp   # Portainer
ufw allow 19999/tcp  # Netdata
ufw --force enable

echo "Bootstrap completado. Añade tus claves SSH a /home/$USERNAME/.ssh/authorized_keys"
