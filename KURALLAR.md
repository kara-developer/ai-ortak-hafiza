# Ortak Hafıza Kuralları

Bu klasör, kullandığın bütün yapay zekaların (Claude, Codex, Gemini, telefondaki ajan…) **tek ortak hafızasıdır**.
Hangi yapay zeka olursan ol, işe başlamadan önce bu dosyayı oku ve kurallara uy.

## 1. Oturum başı
1. `DURUM.md`'nin **son 30 satırını** oku. Kimin, ne zaman, ne yaptığını gör.
2. `GOREVLER.md`'yi oku. Senin işin hangisi, sıradaki adım ne?
3. Bugünün günlüğü (`gunluk/YYYY-AA-GG.md`) varsa oku.
4. Kullanıcı hakkında bir şey hatırlaman gerekiyorsa `hafiza/INDEKS.md`'ye bak, ilgili dosyayı aç.

## 2. Bilginin sahibi (en önemli kural)
Her bilgi **tek bir dosyada** yaşar. Aynı bilgiyi iki yere kopyalama; diğer yerden link ver.

| Bilgi | Sahibi |
|---|---|
| Ne oldu (olay akışı) | `DURUM.md` (yalnız ekleme) |
| Açık işler, kimde, sıradaki adım, tarih | `GOREVLER.md` |
| Günün ayrıntısı | `gunluk/YYYY-AA-GG.md` |
| Kalıcı bilgi: tercihler, düzeltmeler, proje kararları, adresler | `hafiza/*.md` (dosya başı tek bilgi) |
| Proje ayrıntısı | `projeler/<proje>/` |

Neden: aynı bilgi üç yerde olursa biri güncellenir, ikisi bayat kalır ve yapay zekalar çelişen bilgiyle çalışır.
Bayat bir kopya bulursan düzeltmeye çalışma: sil ya da sahibine link ver.

## 3. Yalnız ekleme
`DURUM.md` ve günlüklerde **mevcut satırı değiştirme, silme**. Sonuna yeni satır ekle.
Biçim: `- 2026-10-28 14:05 (Claude) ne yaptım — sonuç`

Neden: iki yapay zeka aynı satırı aynı anda düzenlerse biri diğerinin yazdığını ezer. Ekleme çakışmaz.

## 4. Kim yazdı belli olsun
Her satırda parantez içinde kim olduğunu yaz: `(Claude)`, `(Codex)`, `(Gemini)`, `(Telefon)`.

## 5. Durumu kanıtla söyle
"Bitti / bekliyor / çalışıyor" demeden önce kanıta bak (dosya, çıktı, log). Görev listesi bayat olabilir.

## 6. Paralel çalışma kilidi
Aynı dosyayı/servisi/projeyi değiştirmeden önce `araclar/kilit.sh al KAYNAK "ne yapıyorum"`.
`ÇAKIŞMA` dönerse dokunma, kullanıcıya söyle. Bitince `araclar/kilit.sh birak KAYNAK`. Kilit 4 saatte kendiliğinden düşer.

## 7. Oturum sonu
1. Yaptığın işi `DURUM.md`'ye tek satır ekle.
2. Görev bittiyse `GOREVLER.md`'de `[BİTTİ]` yap; yeni iş çıktıysa ekle (sahip + sıradaki adım + tarih).
3. Kullanıcı sana kalıcı bir tercih/düzeltme söylediyse `hafiza/`'ya yaz (önce aynı konuda dosya var mı bak, varsa güncelle).
4. Git kullanıyorsan commit + push hook'u bunu otomatik yapar.

## 8. Hafızaya ne yazılmaz
Şifre, token, API anahtarı **asla**. Koddan/git geçmişinden zaten okunabilen şeyler. Yalnız bu konuşmayı ilgilendiren geçici şeyler.
