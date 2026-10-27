# AI Ortak Hafıza

Claude'la konuşuyorsun, ertesi gün Codex'e geçiyorsun, her şeyi baştan anlatıyorsun. Bu paket o sorunu çözer:
**bütün yapay zekaların aynı klasörü hafıza olarak kullanır.** Biri ne yaptıysa diğeri bilir.

Ben şirketimi 4 yapay zeka "bedeniyle" yönetiyorum: laptopta Claude Code, laptopta Codex, sunucuda telefondan konuştuğum ajan… Hepsi bu yapıyla aynı hafızayı paylaşıyor.
Bu repo o sistemin genel, kopyalanabilir hali. Aylarca yaşadığımız sorunların çözümleri içinde.

---

## İçinde ne var

```
ai-hafiza/
├── KURALLAR.md          ← her yapay zekanın uyduğu protokol (asıl değer burada)
├── DURUM.md             ← olay akışı: kim, ne zaman, ne yaptı (yalnız ekleme)
├── GOREVLER.md          ← açık işler: sahip + sıradaki adım + tarih
├── gunluk/              ← günlük notlar
├── hafiza/              ← kalıcı bilgi: tercihler, düzeltmeler, kararlar (dosya başı tek bilgi)
│   └── INDEKS.md
├── talimat/ORTAK-BLOK.md  ← CLAUDE.md / AGENTS.md / GEMINI.md'ye yapıştırılacak blok
├── hooks/
│   ├── oturum-basi.sh   ← açılışta: git pull + son durumu yapay zekaya bağlam olarak ver
│   ├── oturum-sonu.sh   ← kapanışta: commit + push (çakışmaya karşı korumalı)
│   └── claude-settings.json
└── araclar/
    ├── kilit.sh         ← iki yapay zeka aynı işe aynı anda girmesin
    └── durum-ekle.sh
```

---

## Kurulum (10 dk, kod bilgisi gerekmez)

**1. Klasörü al**
```bash
git clone https://github.com/kara-developer/ai-ortak-hafiza ~/ai-hafiza
```
Git bilmiyorsan ZIP indirip `~/ai-hafiza` olarak açman da yeterli (o zaman 4. adımı atla).

**2. Yapay zekalarına tanıt.** `talimat/ORTAK-BLOK.md`'deki bloğu kopyala, hepsinin talimat dosyasına yapıştır:

| Araç | Dosya |
|---|---|
| Claude Code | `~/.claude/CLAUDE.md` |
| Codex CLI | `~/.codex/AGENTS.md` |
| Gemini CLI | `~/.gemini/GEMINI.md` |
| Cursor | `.cursor/rules/` |
| ChatGPT / Claude.ai | Proje talimatları (klasörü dosya olarak ekle) |

**3. Otomatik hale getir (Claude Code).** `hooks/claude-settings.json`'daki `hooks` bölümünü `~/.claude/settings.json`'a ekle.
Artık her oturum hafızayı okuyarak açılır, bitince kendisi kaydeder. Hatırlatmana gerek kalmaz.

**En kolayı:** `PROMPT.md`'yi yapay zekana ver, kurulumu seninle adım adım o yapsın.

**4. Cihazlar arası (isteğe bağlı).** Klasörü **özel** bir GitHub reposuna gönder. Telefondaki/sunucudaki ajan aynı repoyu çeker.
Git yerine iCloud/Dropbox/Syncthing da olur; ama iki ajan aynı anda yazınca senkron araçları dosyanın kopyasını oluşturur, git ise birleştirir.

---

## Kuralların özü (KURALLAR.md'nin neden böyle olduğu)

Bu kurallar teoriden değil, bozulan şeylerden çıktı:

| Ne oldu | Kural |
|---|---|
| Aynı bilgi 3 dosyadaydı; biri güncellendi, ikisi bayat kaldı, yapay zeka bayat olanla iş yaptı | **Bilginin sahibi:** her bilgi tek dosyada, diğer yerler link verir |
| İki ajan aynı satırı aynı anda düzenledi, biri diğerininkini ezdi | **Yalnız ekleme:** DURUM ve günlükte satır değiştirilmez, eklenir |
| "Bu iş bitti" dedi, bitmemişti; görev listesi bayattı | **Kanıtla söyle:** durum dosyası, çıktı, log; liste değil |
| İki ajan aynı dosyayı aynı anda değiştirdi | **Kilit:** `kilit.sh al` → başkasındaysa dokunmaz |
| Aynı anda açılan oturumlar eşzamanlı `git pull` yapınca depo bozuldu | Hook'ta tek kilit + 60 sn içinde tekrar çekmez |
| Açılışta `git stash` editörde o an yazılan notu sildi | Yerel değişiklik varsa pull **atlanır**, stash yok |
| Çakışma işaretli (`<<<<<<<`) dosya commit edildi, hafıza bozuldu | Hook çakışma görünce commit etmez, uyarır |
| Hafıza dosyası şişti, yapay zeka sonunu okuyamadı | İndeks kısa (satır başı tek özet), ayrıntı ayrı dosyada; eski kayıt arşive |

---

## Günlük kullanım

Hiçbir şey yapmana gerek yok. Sadece arada şunu söyle:
- "Bunu hafızaya yaz" → `hafiza/`'ya kalıcı bilgi olarak girer.
- "Görev aç: … sıradaki adım …" → `GOREVLER.md`.
- Başka bir yapay zekaya geçince ona hiçbir şey anlatma, "nerede kalmıştık?" de.

---

**Kara Developer** · Instagram: [@kara.developer](https://instagram.com/kara.developer). Tek kişilik şirketimi AI ajanlarıyla yönetiyorum, çalışanı paylaşıyorum.
Lisans: MIT
