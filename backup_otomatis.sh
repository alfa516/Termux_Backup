#!/data/data/com.termux/files/usr/bin/bash

# === Konfigurasi ===
FOLDER_BACKUP="$HOME/my_backup_files"
BACKUP_DIR="$HOME/backup_repo"
LOG_DIR="$HOME/.backup"
mkdir -p "$LOG_DIR"

BOT_TOKEN="7992625201:AAG4_8ay_NEySER9gxjKNBLKdGPdKJKnsEg"
CHAT_ID="7983170165"

WAKTU=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/backup_$WAKTU.tar.gz"
LOG_FILE="$LOG_DIR/backup.log"

# === Cek perubahan ===
cd "$FOLDER_BACKUP"
CHANGED=$(git status --porcelain)

if [ -z "$CHANGED" ]; then
  echo "[$WAKTU] ❌ Tidak ada perubahan, backup dibatalkan." | tee -a "$LOG_FILE"
  curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
    -d chat_id="$CHAT_ID" \
    -d text="❌ Tidak ada perubahan, backup $WAKTU dibatalkan."
  exit 0
fi

# === Kompres folder ===
cd "$HOME"
tar -czf "$BACKUP_FILE" "$(basename "$FOLDER_BACKUP")"

# === Pindah ke repo & commit ===
cp "$BACKUP_FILE" "$BACKUP_DIR"
cd "$BACKUP_DIR"
git add .
git commit -m "📦 Backup otomatis - $WAKTU"
git push -u origin main

# === Log dan kirim notifikasi ===
echo "[$WAKTU] ✅ Backup berhasil: $BACKUP_FILE" | tee -a "$LOG_FILE"
curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
  -d chat_id="$CHAT_ID" \
  -d text="✅ Backup berhasil jam $WAKTU\nFile: $(basename "$BACKUP_FILE")"

exit 0
