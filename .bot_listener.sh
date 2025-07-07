#!/data/data/com.termux/files/usr/bin/bash

BOT_TOKEN="7992625201:AAG4_8ay_NEySER9gxjKNBLKdGPdKJKnsEg"
CHAT_ID="7983170165"
LAST_UPDATE_ID=0

while true; do
  echo "[DEBUG] Menunggu perintah dari Telegram..."
  RESP=$(curl -s "https://api.telegram.org/bot$BOT_TOKEN/getUpdates?offset=$LAST_UPDATE_ID")
  MSG_TEXT=$(echo "$RESP" | grep -oP '(?<="text":")[^"]+')
  echo "[DEBUG] Pesan masuk: $MSG_TEXT"
  UPDATE_ID=$(echo "$RESP" | grep -oP '(?<="update_id":)[0-9]+' | tail -n1)

  if [ "$UPDATE_ID" != "" ] && [ "$UPDATE_ID" -gt "$LAST_UPDATE_ID" ]; then
    LAST_UPDATE_ID=$((UPDATE_ID + 1))

    case "$MSG_TEXT" in
      "INFO")
        echo "[BOT] Menjalankan perintah INFO..."
        IP=$(curl -s ifconfig.me)
        WIFI=$(termux-wifi-connectioninfo | grep ssid)
        BAT=$(termux-battery-status | grep percentage)
        curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
          -d chat_id="$CHAT_ID" \
          -d text="INFO:\n🔋 Baterai: $BAT\n🌐 IP: $IP\n📶 WiFi: $WIFI"
        ;;
      "HELP")
        echo "[BOT] Menjalankan perintah HELP..."
        curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
          -d chat_id="$CHAT_ID" \
          -d text="Perintah tersedia: INFO, HELP, LOKASI"
        ;;
      "LOKASI")
        echo "[BOT] Menjalankan perintah LOKASI..."
        bash $HOME/anti_hilang.sh
        ;;
      *)
        echo "[BOT] Perintah tidak dikenali: $MSG_TEXT"
        ;;
    esac
  fi

  sleep 5
done
