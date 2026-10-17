#!/usr/bin/env bash
# Restaure une archive dans un volume n8n. À lancer depuis ~/n8n sur la VM.
#   ./restore.sh <archive.tar.gz>              restaure dans le vrai volume (écrase les données actuelles)
#   ./restore.sh <archive.tar.gz> --test       restaure dans un volume jetable et le vérifie, sans toucher à n8n
set -euo pipefail

cd "$(dirname "$0")"
ARCHIVE="${1:?usage: restore.sh <archive.tar.gz> [--test]}"
[ -f "$ARCHIVE" ] || { echo "archive introuvable: $ARCHIVE"; exit 1; }
ARCHIVE="$(readlink -f "$ARCHIVE")"

if [ "${2:-}" = "--test" ]; then
  VOLUME="n8n_restore_test"
  docker volume rm "$VOLUME" > /dev/null 2>&1 || true
  docker volume create "$VOLUME" > /dev/null
  docker run --rm -v "$VOLUME":/data -v "$ARCHIVE":/backup.tar.gz:ro alpine \
    tar xzf /backup.tar.gz -C /data
  docker run --rm -v "$VOLUME":/data:ro alpine sh -c \
    'ls -la /data && test -s /data/database.sqlite && echo "database.sqlite présent: OK"'
  docker volume rm "$VOLUME" > /dev/null
  echo "TEST OK (volume jetable supprimé)"
  exit 0
fi

read -r -p "Écraser le volume n8n_n8n_data avec $ARCHIVE ? (oui/non) " ANSWER
[ "$ANSWER" = "oui" ] || { echo "annulé"; exit 1; }

docker compose stop n8n
docker run --rm -v n8n_n8n_data:/data -v "$ARCHIVE":/backup.tar.gz:ro alpine \
  sh -c 'find /data -mindepth 1 -delete && tar xzf /backup.tar.gz -C /data'
docker compose start n8n
echo "Restauration terminée"
