#!/usr/bin/env bash
# Oturum başı: hafızayı en güncel hale çek (git pull) ve özetini yapay zekaya bağlam olarak ver.
# Claude Code SessionStart hook'u olarak çalışır; stdout'a yazılan metin modele bağlam olarak gider.
# Asla oturumu durdurmaz (fail-open): hata olursa log'a yazar, uyarı basar, devam eder.

HAFIZA="${HAFIZA_KLASORU:-$HOME/ai-hafiza}"
LOG="$HAFIZA/.hafiza-sync.log"
KILIT="$HAFIZA/.git/pull.kilit"
cat >/dev/null                      # hook stdin'ini tüket
ts() { date '+%Y-%m-%d %H:%M:%S'; }
cd "$HAFIZA" 2>/dev/null || exit 0

if [ -d .git ]; then
  # Aynı anda açılan birden çok oturum eşzamanlı pull yapınca git bozuluyor → tek kilit, 60 sn içinde tekrar çekme.
  if [ -z "$(find .git/son-pull -maxdepth 0 -mmin -1 2>/dev/null)" ] && mkdir "$KILIT" 2>/dev/null; then
    trap 'rmdir "$KILIT" 2>/dev/null' EXIT
    if [ -n "$(git status --porcelain --untracked-files=no)" ]; then
      # Yerelde kaydedilmemiş değişiklik varsa pull YOK. stash kullanma: editörde o an yazılan metni kaybettirir.
      echo "[$(ts)] başlangıç: yerel değişiklik var, pull atlandı" >>"$LOG"
    elif OUT=$(git pull --rebase --quiet 2>&1); then
      touch .git/son-pull; echo "[$(ts)] başlangıç: pull ok" >>"$LOG"
    else
      echo "[$(ts)] başlangıç: pull HATASI: $OUT" >>"$LOG"
      echo "UYARI: hafıza git pull başarısız oldu, yazmadan önce elle kontrol et: cd $HAFIZA && git pull --rebase"
    fi
  fi
fi

# Özet: modele doğrudan bağlam (dosyaları okumayı unutsa bile son durumu görür)
echo "=== ORTAK HAFIZA ÖZETİ ($HAFIZA) — kurallar: KURALLAR.md ==="
echo "--- DURUM (son 15) ---";        tail -n 15 DURUM.md 2>/dev/null
echo "--- AÇIK GÖREVLER ---";          grep -E '^\- \[(DEVAM|ONAY BEKLİYOR)\]' GOREVLER.md 2>/dev/null | head -25
GUN="gunluk/$(date +%Y-%m-%d).md"
[ -f "$GUN" ] && { echo "--- BUGÜN ---"; tail -n 15 "$GUN"; }
echo "--- AKTİF KİLİTLER ---";        "$HAFIZA/araclar/kilit.sh" liste 2>/dev/null
exit 0
