# Ristorante Serrago — Demo v3

Финальная версия после critical review. Все 4 critical fixes сделаны + 4 secondary.

## Что изменилось vs v2

### Critical (по review feedback)

| Проблема | Что сделано |
|---|---|
| Gold-on-black палитра (luxury cliché) | **Полная замена** на cream/terracotta, цвета derived из реального фото террасы Serrago — `#8B3D2E` accent взят с самой стены ресторана |
| "Vieni a trovarci" в Contatti | Заменено на "Dove siamo" |
| Форма "Prenota via WhatsApp" | Кнопка → "Richiedi prenotazione". Форма теперь отправляет mailto: info@ristoranteserrago.it (в production — wire to backend/CRM). WhatsApp deeplink убран полностью |
| Слово "Prenota" 4× | Сокращено до 0× (как CTA). Везде "Riserva" (nav, hero, section title) или "prenotazione" (noun в форме) |

### Secondary (мои предложения)

| Проблема | Что сделано |
|---|---|
| Hero video unknown origin | Заменено на static photo `hero-serrago.jpg` (16:9 crop из фото террасы с insegna). Никакого AI/unknown content |
| Tonno × 2 (Tataki + Sesamo) | Убран `tonno-sesamo`. Осталось 7 piatti |
| Carpaccio cinghiale "странный" | Усилен framing: tag "Unico di terra", description "L'unico piatto di terra in un menu di mare" |
| Fabricated reviews с fake именами | Заменены на **5 verified реальных reviews** из публичных TripAdvisor отзывов (через web search), каждая помечена "Recensione Tripadvisor", без вымышленных имён |
| Phone number unprominent | Большая кнопка-карточка в Riserva секции с иконкой и явным "Chiamaci direttamente" |

### Не тронуто (работало в v2)

- Editorial asymmetric Galleria layout
- Lo Chef секция с Giuseppe
- La Sala секция с 3 фото террасы
- Chef's Table parallax
- 8 piatti carousel (теперь 7)
- Mobile menu + accessibility (skip-link, focus-visible, ARIA)
- WebP fallback через `<picture>`
- Logo Serrago (теперь tinted в terracotta filter)

## Palette reference

Реальные цвета извлечены из фото `dish_045` (терраса с insegna):

```
--bg:        #F0EAE0   /* cream — tone of tablecloth + shatre */
--bg2:       #E6DFD3   /* darker cream — section alternance */
--surface:   #FFFFFF   /* pure white — cards */
--ink:       #1F1A17   /* warm sepia — text */
--text:      #2A2420   /* body text */
--muted:     #6B5D52   /* warm brown-grey — secondary */
--soft:      #9D8E80   /* softer brown */
--accent:    #8B3D2E   /* DEEP TERRACOTTA — from real wall */
--accent-l:  #B85A47   /* lighter terracotta — hover */
--sage:      #708477   /* secondary accent — from plants */
--border:    #D4CBBC   /* cream-based border */
```

Эта палитра — **сами цвета ресторана**. Никакого generic luxury.

## Файлы

```
serrago-v3/
├── index.html                   # 1541 строк
├── process_serrago_photos.sh    # Batch script
├── manifest_final.json          # Manifest по 67 источникам
├── README.md                    # Этот файл
└── img/
    ├── logo-serrago-bw.png      # Logo
    ├── hero-serrago.{jpg,webp}  # NEW — 16:9 hero crop вместо видео
    ├── tataki-tonno.{jpg,webp}  # 7 piatti (было 8)
    ├── crudo-misto.{jpg,webp}
    ├── tartare-pesce.{jpg,webp}
    ├── gamberi-pistacchio.{jpg,webp}
    ├── carpaccio-cinghiale.{jpg,webp}
    ├── gamberi-finocchi.{jpg,webp}
    ├── gamberoni-saltati.{jpg,webp}
    ├── chef-*.{jpg,webp}        # 3 Lo Chef
    ├── chefs-table.{jpg,webp}   # 1 parallax
    ├── gallery-*.{jpg,webp}     # 8 Galleria
    └── sala-*.{jpg,webp}        # 4 La Sala
```

26 уникальных image assets (52 файла с webp+jpg парами + 1 logo PNG).
Total размер: 8.0 MB.

## Развёртывание

```bash
cd serrago-v3
python3 -m http.server 8080
# открыть http://localhost:8080
```

Для GitHub Pages:

```bash
git init && git add . && git commit -m "Serrago demo v3"
git remote add origin git@github.com:viktorialiubitskaya-coder/serrago.git
git push -u origin main
# Settings → Pages → Source: main / root
```

## Reviews — атрибуция

Все 5 отзывов взяты с публичных страниц Tripadvisor (verified через web search). Каждый помечен "Recensione Tripadvisor". Без выдуманных имён или дат. Линк "Leggi tutte le recensioni" ведёт на реальную страницу Serrago на TripAdvisor (d24173968).

**В production** — рекомендую wire to live Tripadvisor/Google API через MCP integration или server-side fetch (для ежемесячных обновлений отзывов). Но для demo это **достаточно** — все цитаты verified и атрибутированы.

## Booking form — production handoff

Форма сейчас работает через `mailto:` — открывает email клиент пользователя с pre-filled body. В production нужно:

1. **Заменить mailto на backend POST** (Resend, FormSpree, или Vercel serverless function)
2. **Wire to real email** Giuseppe (заменить `info@ristoranteserrago.it` placeholder)
3. Опционально — auto-confirmation email обратно пользователю
4. Опционально — Telegram/WhatsApp notification Giuseppe о новых запросах (через webhook)

Это **30 минут работы** на production stage — сейчас demo достаточен.

## Что осталось перед отправкой Giuseppe

- [ ] Локальный preview через `python3 -m http.server 8080`
- [ ] Mobile test в Chrome DevTools (375px, 768px)
- [ ] Логотип tinted в terracotta — проверить визуально
- [ ] Hero photo 16:9 — что insegna видна
- [ ] 5 reviews подгружаются и rail скроллится drag-ом
- [ ] Phone CTA в Riserva — кликабельность

## Что нужно от клиента до production

- P.IVA для footer
- Реальный email для booking form
- Domain choice (ristoranteserrago.it или похожий)
- GDPR cookie banner + Privacy Policy + Cookie Policy
- Google Analytics 4 или Plausible setup
- Schema.org Restaurant JSON-LD для SEO
- Open Graph meta tags для соцсетей
