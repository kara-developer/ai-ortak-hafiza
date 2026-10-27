#!/usr/bin/env bash
# Paralel oturum kilidi: iki yapay zeka aynı işe aynı anda girmesin.
#   kilit.sh al KAYNAK "ne yapıyorum"   → alır; başkasındaysa ÇAKIŞMA yazar, çıkış kodu 1
#   kilit.sh birak KAYNAK
#   kilit.sh liste
# KAYNAK serbest metin: "site", "sunucu:/etc/nginx", "proje-x" …  Kilit 4 saatte kendiliğinden düşer.
# Kilitler bilerek git'e girmez (yerel): ajanların farklı makinelerdeyse KILIT_DIZIN'i ortak bir sunucuda tut.
DIZIN="${KILIT_DIZIN:-$HOME/.ai-kilitler}"; SURE=$((4*3600)); KIM="${HAFIZA_KIM:-ai}"
mkdir -p "$DIZIN"
ad() { printf '%s' "$1" | tr -c 'A-Za-z0-9._-' '_'; }
canli() { [ -f "$1" ] && [ $(( $(date +%s) - $(stat -f %m "$1" 2>/dev/null || stat -c %Y "$1") )) -lt $SURE ]; }
case "$1" in
  al)
    [ -n "$2" ] || { echo "kullanım: kilit.sh al KAYNAK \"ne yapıyorum\""; exit 2; }
    f="$DIZIN/$(ad "$2")"
    if canli "$f" && ! grep -q "^kim=$KIM$" "$f"; then echo "⛔ ÇAKIŞMA: $2 — $(tr '\n' ' ' <"$f")"; exit 1; fi
    printf 'kim=%s\nne=%s\nzaman=%s\n' "$KIM" "${3:-}" "$(date '+%Y-%m-%d %H:%M')" >"$f"; echo "✓ kilit alındı: $2" ;;
  birak) rm -f "$DIZIN/$(ad "$2")" && echo "✓ bırakıldı: $2" ;;
  liste)
    for f in "$DIZIN"/*; do [ -f "$f" ] || continue; canli "$f" && echo "🔒 $(basename "$f") — $(tr '\n' ' ' <"$f")" || rm -f "$f"; done ;;
  *) echo "kullanım: kilit.sh al|birak|liste ..."; exit 2 ;;
esac
