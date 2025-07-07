#!/data/data/com.termux/files/usr/bin/bash

# Folder repo git lokal
REPO_DIR="$HOME/backup_repo"

# File-file yang mau di-backup (sesuaikan path-nya)
FILES_TO_BACKUP=(
  "/data/data/com.termux/files/usr/etc/bash.bashrc"
  "$HOME/anti_hilang.sh"
  "$HOME/.bot_listener.sh"
)

# Token & repo (jika mau push otomatis, pastikan sudah set remote origin)
# Kalau belum, setting dulu dengan:
# cd $REPO_DIR
# git remote add origin https://github.com/4lf4king/Termux_Backup.git

cd "$REPO_DIR" || { echo "Repo folder tidak ditemukan!"; exit 1; }

# Copy file yang mau backup ke repo folder
for file in "${FILES_TO_BACKUP[@]}"; do
  if [ -f "$file" ]; then
    cp "$file" "$REPO_DIR/"
    echo "Copied $file"
  else
    echo "File $file tidak ditemukan, dilewati."
  fi
done

# Tambah semua file ke git
git add .

# Commit dengan pesan tanggal & waktu
git commit -m "Backup otomatis - $(date '+%Y-%m-%d %H:%M:%S')" || echo "Tidak ada perubahan untuk di commit."

# Push ke GitHub (branch main)
git push origin main

echo "Backup selesai!"
