#!/usr/bin/env bash
# Oturum sonu: değişiklikleri commit + push et. Claude Code Stop/SessionEnd hook'u; Codex/diğerleri için elle ya da cron.
# Çakışma işareti (<<<<<<<) varsa ASLA commit etmez. Push reddedilirse bir kez rebase edip tekrar dener.

HAFIZA="${HAFIZA_KLASORU:-$HOME/ai-hafiza}"
LOG="$HAFIZA/.hafiza-sync.log"
KILIT="$HAFIZA/.git/push.kilit"
KIM="${HAFIZA_KIM:-ai}"            # commit'te kim yazdı belli olsun: claude, codex, telefon…
cat >/dev/null
ts() { date '+%Y-%m-%d %H:%M:%S'; }
cd "$HAFIZA" 2>/dev/null && [ -d .git ] || exit 0

# Değişiklik ve gönderilmemiş commit yoksa iş yok (her tur sonunda çalışabildiği için ucuz olmalı)
[ -z "$(git status --porcelain)" ] && [ -z "$(git log --oneline @{u}..HEAD 2>/dev/null)" ] && exit 0

# mkdir atomik kilit (macOS'ta flock yok); 5 dk'dan eski kilit bayattır
if ! mkdir "$KILIT" 2>/dev/null; then
  [ -n "$(find "$KILIT" -maxdepth 0 -mmin -5 2>/dev/null)" ] && exit 0
  rmdir "$KILIT" 2>/dev/null; mkdir "$KILIT" 2>/dev/null || exit 0
fi
trap 'rmdir "$KILIT" 2>/dev/null' EXIT

DAL=$(git symbolic-ref --short -q HEAD)
if [ -z "$DAL" ] || [ -e "$(git rev-parse --git-path rebase-merge)" ] || [ -e "$(git rev-parse --git-path MERGE_HEAD)" ]; then
  echo "[$(ts)] son: detached HEAD ya da yarım rebase/merge — dokunulmadı" >>"$LOG"; exit 0
fi
if grep -rl '^<<<<<<< ' --include='*.md' . >/dev/null 2>&1; then
  echo "[$(ts)] son: DURDU — çakışma işareti var" >>"$LOG"
  echo "UYARI: hafızada çözülmemiş git çakışması var, commit edilmedi. İki tarafın içeriğini de koruyarak çöz."
  exit 0
fi

if [ -n "$(git status --porcelain)" ]; then
  git add -A && git -c user.name="$KIM" -c user.email="$KIM@ai-hafiza" commit -q -m "$KIM oturum: $(date '+%Y-%m-%d %H:%M')" 2>>"$LOG"
fi
if ! git push -q 2>>"$LOG"; then
  if ! { git pull --rebase -q 2>>"$LOG" && git push -q 2>>"$LOG"; }; then
    [ -e "$(git rev-parse --git-path rebase-merge)" ] && git rebase --abort 2>>"$LOG"
    echo "[$(ts)] son: PUSH BAŞARISIZ — commit yerelde" >>"$LOG"; echo "UYARI: hafıza push edilemedi, log: $LOG"; exit 0
  fi
fi
echo "[$(ts)] son: $(git rev-parse --short HEAD) gönderildi" >>"$LOG"
exit 0
