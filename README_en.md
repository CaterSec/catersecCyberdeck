# CiberDeck - KrakenAnzen (Raspberry Pi 5) - CATERSEC

> Portable ciberdeck based on Raspberry Pi 5 designed for pentesting, auditing and portable lab use.
> Analyze. Exploit. Secure.

## Summary
DIY project integrating Raspberry Pi 5 with display, battery, keyboard and a toolkit for security testing. Ideal as a portable pentesting station and for demos.

## Includes
- Base image: Kali Linux ARM64 (Raspberry Pi 5)
- Headless boot via injecting `wpa_supplicant.conf` and `ssh` into the `boot` partition
- Nominal user and basic hardening (user: `catersec`)
- Docker + Portainer + Netdata containers
- UFW firewall configured (ssh, portainer, netdata)
- Bootstrap and utility scripts (startup, backup)
- OLED telemetry module with `oled_info.py` and systemd service


---

## Quick start (Headless)

1. Download Kali ARM64: https://www.kali.org/get-kali/#kali-arm
2. Flash using Raspberry Pi Imager or `dd`.
3. On the `boot` partition create an empty `ssh` file and `wpa_supplicant.conf` (use example with placeholders).

Example `wpa_supplicant.conf`:

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

4. Boot and connect: `ssh kali@kali.local` or `ssh kali@<ASSIGNED_IP>`
5. First steps on Pi (from `kali`):

```bash
sudo apt update && sudo apt full-upgrade -y
sudo adduser catersec
sudo usermod -aG sudo,kali,netdev,audio,video docker catersec || true
```

---

## Hardening & services
See README (Spanish) for examples of UFW, Docker, Portainer and Netdata configuration.

---

## OLED telemetry
Script located at `/home/catersec/scripts/oled_info.py` and systemd service `oled.service` (user `catersec`).

---

## Contribute
Fork, create a branch, open PRs with tests and documentation.

## License
MIT

## Contact
CATERSEC- catersec@hotmail.com
