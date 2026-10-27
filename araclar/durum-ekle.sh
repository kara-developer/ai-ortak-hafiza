#!/usr/bin/env bash
# DURUM.md'ye doğru biçimde tek satır ekler:  durum-ekle.sh "ne yaptım — sonuç"
HAFIZA="${HAFIZA_KLASORU:-$HOME/ai-hafiza}"
[ -n "$1" ] || { echo 'kullanım: durum-ekle.sh "ne yaptım — sonuç"'; exit 2; }
echo "- $(date '+%Y-%m-%d %H:%M') (${HAFIZA_KIM:-ai}) $1" >> "$HAFIZA/DURUM.md" && echo "✓ eklendi"
