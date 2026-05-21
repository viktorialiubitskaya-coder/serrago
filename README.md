# Ristorante Serrago — Demo v3

Финальная версия. Все critical fixes сделаны + hero полностью переделан после второго раунда review.

## Архитектура страницы

| # | Секция | Фото (1 фото = 1 место, никаких дублей) |
|---|---|---|
| 1 | Hero — split layout, dish + text | `chefs-table.jpg` (native 1080px, в slot 600px) |
| 2 | Manifesto — quote on cream bg | — |
| 3 | Piatti — carousel 7 dishes | `tataki-tonno`, `crudo-misto`, `tartare-pesce`, `gamberi-pistacchio`, `carpaccio-cinghiale`, `gamberi-finocchi`, `gamberoni-saltati` |
| 4 | Lo Chef — editorial layout | `chef-giuseppe` + `pesce-fresco` + `plating-service` |
| 5 | Parallax — atmosfera | `sala-terrazza-insegna` (с insegna Serrago) |
| 6 | Galleria — asymmetric editorial grid | 8 уникальных `gallery-*` |
| 7 | La Sala — 3 фото террасы | `sala-terrazza-lunga` + `sala-interno-bonsai` + `sala-tavoli` |
| 8 | Recensioni — 5 verified TripAdvisor reviews | — |
| 9 | Riserva — phone CTA + form | — |
| 10 | Contatti — address + hours + IG | — |

24 уникальных photo asset, каждый используется **1 раз**. Никаких дублей.

## Hero — что изменилось

После первого preview hero на full-bleed (терраса с insegna) выглядел блёкло. Проблема — Instagram-фото 1080×1080 апскейленное в 1920×1080 = пикселизация на retina.

**Новый layout:**
- Split-grid `1.1fr 1fr` — text слева, dish photo справа
- Фото `chefs-table.jpg` показывается в **native размере** (max 600px на desktop) — никакого upscaling
- Cream фон, контрастные тарелки естественно становятся focal point
- Гигантская типография `clamp(3rem, 8vw, 6.5rem)` Cormorant 300
- Над CTA — gold accent divider (60px line) + trio "Pesce fresco · Cucina aperta · Chef-patron"
- Под фото — micro caption "Cucina aperta · La cucina che lavora"

Это honest editorial approach — мы не претендуем на professional photography, мы показываем реальный moment в нативном качестве.

## Палитра (derived from реального фото террасы)

```
--bg:        #F0EAE0   /* cream */
--bg2:       #E6DFD3
--surface:   #FFFFFF
--ink:       #1F1A17   /* warm sepia */
--text:      #2A2420
--muted:     #6B5D52
--soft:      #9D8E80
--accent:    #8B3D2E   /* terracotta — из стены Serrago */
--accent-l:  #B85A47
--sage:      #708477
```

## Файлы

```
serrago-v3/
├── index.html                   # 1635 строк
├── process_serrago_photos.sh    # Batch script для пересборки фото
├── manifest_final.json
├── README.md
└── img/                          # 50 файлов
    ├── logo-serrago-bw.png
    ├── tataki-tonno.{jpg,webp}
    ├── crudo-misto.{jpg,webp}
    ├── tartare-pesce.{jpg,webp}
    ├── gamberi-pistacchio.{jpg,webp}
    ├── carpaccio-cinghiale.{jpg,webp}
    ├── gamberi-finocchi.{jpg,webp}
    ├── gamberoni-saltati.{jpg,webp}
    ├── chef-giuseppe.{jpg,webp}
    ├── pesce-fresco.{jpg,webp}
    ├── plating-service.{jpg,webp}
    ├── chefs-table.{jpg,webp}     # NOW only in hero
    ├── gallery-*.{jpg,webp}       # 8 шт
    ├── sala-terrazza-insegna.{jpg,webp}   # only in parallax now
    ├── sala-terrazza-lunga.{jpg,webp}     # now in lasala-main
    ├── sala-interno-bonsai.{jpg,webp}
    └── sala-tavoli.{jpg,webp}
```

## Развёртывание

```bash
cd serrago-v3
python3 -m http.server 8080
# открыть http://localhost:8080
```

## Если позже захочешь AI hero

У тебя есть Gemini Imagen 4 pipeline в `/Users/mac/my_ai_project/.env`. Подсказка для prompt:

```
Cinematic 16:9 photo, contemporary Italian fine-dining restaurant in
Calabria. Soft warm interior lighting, terracotta walls, white tablecloths,
single wine glass in foreground (out of focus). Open kitchen visible in
distance with stainless steel and soft glow. Aspect ratio 21:9, ultra-wide,
shallow depth of field, restaurant atmosphere. No people. No text. No
generic stock-photo feel — editorial, magazine quality.
```

Сохрани как `hero-cinematic.{jpg,webp}` и замени hero-image picture sources. Layout уже готов к full-bleed — нужно только убрать grid и вернуть absolute positioning из старой версии (документация выше с palette → есть в git history через diff).

## Booking form — production

Сейчас работает через mailto (placeholder `info@ristoranteserrago.it`). В production:
1. Получить от Giuseppe реальный email
2. Wire к Resend / FormSpree / Vercel serverless
3. Опционально — Telegram notification Giuseppe о новых запросах

## Что осталось перед production

- [ ] P.IVA для footer
- [ ] Реальный email Giuseppe для формы
- [ ] Domain (ristoranteserrago.it)
- [ ] GDPR cookie banner + Privacy Policy + Cookie Policy
- [ ] Schema.org Restaurant JSON-LD
- [ ] Open Graph meta tags
- [ ] Google Analytics или Plausible
