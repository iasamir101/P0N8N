#!/usr/bin/env bash
# Sauvegarde du volume n8n (workflows, credentials chiffrés, base SQLite). À lancer depuis ~/n8n sur la VM.
# n8n est arrêté quelques secondes pour obtenir une base SQLite cohérente. Garde les 7 dernières archives.
# La clé N8N_ENCRYPTION_KEY n'est PAS dans l'archive : la conserver à part (gestionnaire de mots de passe).
set -euo pipefail

cd "$(dirname "$0")"
VOLUME="n8n_n8n_data"
DEST="$HOME/backups/n8n"
STAMP="$(date +%Y%m%d-%H%M%S)"
FILE="$DEST/n8n-$STAMP.tar.gz"

mkdir -p "$DEST"

docker compose stop n8n
trap 'docker compose start n8n' EXIT

docker run --rm -v "$VOLUME":/data:ro -v "$DEST":/backup alpine \
  tar czf "/backup/n8n-$STAMP.tar.gz" -C /data .

# vérifie que l'archive est lisible
tar tzf "$FILE" > /dev/null

# rotation : ne garder que les 7 plus récentes
ls -1t "$DEST"/n8n-*.tar.gz | tail -n +8 | xargs -r rm --

echo "OK $FILE ($(du -h "$FILE" | cut -f1))"
