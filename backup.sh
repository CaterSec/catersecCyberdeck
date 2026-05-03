#!/usr/bin/env bash
# Crear imagen comprimida de la SD/SSD (ejemplo)
DEV=${1:-/dev/mmcblk0}
OUTDIR=${2:-/home/catersec/backups}
mkdir -p "$OUTDIR"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
sudo dd if="$DEV" bs=4M status=progress | gzip > "$OUTDIR/krakenanzen-$TIMESTAMP.img.gz"
echo "Backup guardado en $OUTDIR"
