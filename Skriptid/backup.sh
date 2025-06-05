#!/bin/bash

# Varukoopia kuupäeva ja kellaaja määramine
DATE=$(date +"%Y-%m-%d_%H-%M")

# Varukoopiate sihtkataloog
BACKUP_DIR="/var/backups"
TMP_DIR="/tmp/kasutajatugi_backup_$DATE"

WEB_DIR="/var/www/html/kasutajatugi"

DB_HOST="10.0.90.4"
DB_USER="kasutajatugi"
DB_PASS="StrongPass123"
DB_NAME="kasutajatugi"

mkdir -p "$TMP_DIR"

mysqldump -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" > "$TMP_DIR/db.sql"

cp -r "$WEB_DIR" "$TMP_DIR/web"

ARCHIVE_NAME="kasutajatugi_backup_${DATE}.tar.gz"
tar -czf "$BACKUP_DIR/$ARCHIVE_NAME" -C "$TMP_DIR" .

rm -rf "$TMP_DIR"

find "$BACKUP_DIR" -type f -name "kasutajatugi_backup_*.tar.gz" -mtime +7 -exec rm {} \;

echo "Backup valmis: $BACKUP_DIR/$ARCHIVE_NAME"