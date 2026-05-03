#!/usr/bin/env python3
import time
import socket
import psutil
from luma.core.interface.serial import i2c
from luma.oled.device import ssd1306
from luma.core.render import canvas
from PIL import ImageFont


def get_ip():
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
        s.close()
        return ip
    except:
        return "Sin Red"


def main():
    serial = i2c(port=1, address=0x3C)
    device = ssd1306(serial)
    font = ImageFont.load_default()

    while True:
        try:
            ip = get_ip()
            cpu = int(psutil.cpu_percent())
            ram = int(psutil.virtual_memory().percent)
            hora = time.strftime("%H:%M:%S")

            with canvas(device) as draw:
                draw.text((2, 0), "KRAKEN ANZEN", font=font, fill=255)
                draw.text((0, 12), "----", font=font, fill=255)
                draw.text((0, 24), f"IP: {ip}", font=font, fill=255)
                draw.text((0, 38), f"C:{cpu}% R:{ram}%", font=font, fill=255)
                draw.text((50, 52), hora, font=font, fill=255)
        except Exception as e:
            print("OLED error:", e)
        time.sleep(2)

if __name__ == "__main__":
    main()
