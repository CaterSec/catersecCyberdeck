# CiberDeck - KrakenAnzen (Raspberry Pi 5) - CATERSEC

> Ciberdeck portátil basado en Raspberry Pi 5 — diseñado para pentesting, auditoría y laboratorio portátil.
> Analizo. Exploto. Aseguro.

## Resumen
Proyecto DIY que integra Raspberry Pi 5 con pantalla, batería, teclado y una colección de herramientas de ciberseguridad. Ideal como estación portátil para pentesting y para demostraciones.

## Qué incluye
- Imagen base: Kali Linux ARM64 (Raspberry Pi 5)
- Arranque headless mediante inyección de `wpa_supplicant.conf` y archivo `ssh` en la partición `boot`
- Usuario nominal y hardening básico (usuario: `catersec`)
- Docker + Portainer + Netdata containerizados
- Firewall UFW configurado (ssh, portainer, netdata)
- Scripts de bootstrap y utilidades (arranque, backup)
- Módulo de telemetría OLED con script `oled_info.py` y servicio systemd


---

## Guía rápida de puesta en marcha (Headless)

1. Descargar imagen de Kali ARM64: https://www.kali.org/get-kali/#kali-arm

2. Flasheo: usa Raspberry Pi Imager o `dd`.

3. Preparar arranque headless (en partición `boot` crea):
   - archivo vacío `ssh` (activa SSH)
   - `wpa_supplicant.conf` (usa el ejemplo con placeholders)

Ejemplo `wpa_supplicant.conf`:

```conf
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=ES

network={
    ssid="SSID_PLACEHOLDER"
    psk="PSK_PLACEHOLDER"
    key_mgmt=WPA-PSK
}
```

4. Arranque y conexión: `ssh kali@kali.local` o `ssh kali@<IP_ASIGNADA>`

5. Primeros pasos en la Pi (desde `kali`):

```bash
# actualizar sistema
sudo apt update && sudo apt full-upgrade -y

# crear usuario nominal (reemplaza 'catersec' por el usuario deseado si necesitas otro)
sudo adduser catersec
sudo usermod -aG sudo,kali,netdev,audio,video docker catersec || true
```

---

## Hardening básico (recomendado)
```bash
sudo hostnamectl set-hostname KrakenAnzen

sudo apt install -y ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 9443/tcp   # Portainer
sudo ufw allow 19999/tcp  # Netdata
sudo ufw --force enable
sudo ufw status verbose
```

---

## Docker / Portainer / Netdata (containers)
Instalar Docker:
```bash
sudo apt install -y docker.io
sudo systemctl enable --now docker
sudo usermod -aG docker catersec
newgrp docker || true
```

Portainer:
```bash
docker volume create portainer_data

docker run -d -p 8000:8000 -p 9443:9443 --name portainer   --restart=always   -v /var/run/docker.sock:/var/run/docker.sock   -v portainer_data:/data   portainer/portainer-ce:latest
```

Netdata:
```bash
docker run -d --name=netdata -p 19999:19999   -v netdataconfig:/etc/netdata -v netdatalib:/var/lib/netdata -v netdatacache:/var/cache/netdata   -v /etc/passwd:/host/etc/passwd:ro -v /etc/group:/host/etc/group:ro -v /proc:/host/proc:ro   -v /sys:/host/sys:ro -v /etc/os-release:/host/etc/os-release:ro   --restart always --cap-add SYS_PTRACE --security-opt apparmor=unconfined netdata/netdata
```

---

## Herramientas recomendadas (instalación)
```bash
sudo apt install -y nmap metasploit-framework nikto aircrack-ng hydra wordlists bettercap wireshark python3-pip htop curl git ufw
sudo pip3 install luma.oled psutil
```

---

## Módulo OLED (telemetría local)
Script en `/home/catersec/scripts/oled_info.py` (ver carpeta `scripts/`).
Instala y habilita el servicio systemd `oled.service` apuntando al usuario `catersec`.

---

## Contribuir
1. Fork
2. Crear branch `feature/<nombre>`
3. PR con descripción y pruebas

## Licencia
MIT (sugerida)

## Contacto
CATERSEC — (catersec@hotmail.com)
