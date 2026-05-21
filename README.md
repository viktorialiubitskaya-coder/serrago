# Ristorante Serrago — Demo Site v2

Полная пересборка сайта на основе 67 реальных фото из Instagram.

## Что нового по сравнению с v1

| Метрика | v1 | v2 |
|---|---|---|
| Уникальных фото | 6 | 24 |
| Дублей между секциями | 6 (50% галереи) | 0 |
| Watermark/обработки видны | Да | Нет |
| Секций с контентом | 7 | 10 |
| Секция "Lo Chef" | нет | есть |
| Секция "La Sala" | нет | есть |
| Chef's Table parallax | видео-плейсхолдер | фото с Giuseppe в кухне |
| Логотип в nav | текст | реальный лого Serrago |

## Структура файлов

```
serrago-v2/
├── index.html                     # Главная страница (1509 строк)
├── process_serrago_photos.sh      # Batch script для пересборки фото из исходников
├── manifest_final.json            # Документация какое фото где используется
├── README.md                      # Этот файл
└── img/
    ├── logo-serrago-bw.png        # Логотип B&W с прозрачностью (4KB)
    ├── hero_bg.mp4                # ОТСУТСТВУЕТ — взять из v1
    │
    ├── tataki-tonno.{jpg,webp}    # 8 piatti для карусели
    ├── crudo-misto.{jpg,webp}
    ├── tartare-pesce.{jpg,webp}
    ├── gamberi-pistacchio.{jpg,webp}
    ├── carpaccio-cinghiale.{jpg,webp}
    ├── gamberi-finocchi.{jpg,webp}
    ├── gamberoni-saltati.{jpg,webp}
    ├── tonno-sesamo.{jpg,webp}
    │
    ├── chef-giuseppe.{jpg,webp}   # 3 фото для секции "Lo Chef"
    ├── pesce-fresco.{jpg,webp}
    ├── plating-service.{jpg,webp}
    │
    ├── chefs-table.{jpg,webp}     # 1 parallax фото
    │
    ├── gallery-salumi-mare.{jpg,webp}   # 8 фото для галереи
    ├── gallery-degustazione.{jpg,webp}
    ├── gallery-zucchine-arrotolate.{jpg,webp}
    ├── gallery-pesce-pietra.{jpg,webp}
    ├── gallery-crudo-totale.{jpg,webp}
    ├── gallery-polpette-baccala.{jpg,webp}
    ├── gallery-gambero-pomodorini.{jpg,webp}
    ├── gallery-polipo-fichi.{jpg,webp}
    │
    └── sala-terrazza-insegna.{jpg,webp} # 4 фото для секции "La Sala"
        sala-interno-bonsai.{jpg,webp}
        sala-terrazza-lunga.{jpg,webp}
        sala-tavoli.{jpg,webp}
```

## Развёртывание

### Вариант 1: Github Pages (как делала с другими demo)

```bash
# Из директории serrago-v2:
git init
git add .
git commit -m "Serrago demo v2 — editorial layout"
git remote add origin git@github.com:viktorialiubitskaya-coder/serrago.git
git push -u origin main
# Включить GitHub Pages в Settings → Pages → Source: main / root
```

### Вариант 2: Локальный preview

```bash
cd serrago-v2
python3 -m http.server 8080
# Открыть http://localhost:8080
```

### КРИТИЧНО: добавить видео

Файл `img/hero_bg.mp4` НЕ включён в этот пакет — скопировать из старой версии v1.
Если видео отсутствует, hero показывает чёрный экран.

## Пересборка фото из источников

Если получишь новые фото или захочешь поменять выборку:

```bash
# 1. Скопируй все исходники в source/
mkdir source
cp ~/path/to/dish_*.jpg source/

# 2. Запусти скрипт
bash process_serrago_photos.sh

# 3. Скрипт перезапишет img/ с 24 готовыми парами .jpg + .webp
```

Скрипт требует ImageMagick:
- Mac: `brew install imagemagick`
- Linux: `sudo apt install imagemagick`

## Изменения относительно v1 (что было — что стало)

### Удалено
- Старая секция Galleria (12 фото с 6 дублями)
- TikTok-кнопка в социальных контактах (вела в никуда)
- Атрибуция manifesto "— Ristorante Serrago, Praia a Mare" (заменена на "— Filosofia Serrago")

### Добавлено
- **Секция "Lo Chef"** — асимметричная композиция с фото Giuseppe + 2 side-фото (cucina, plating)
- **Секция "La Sala"** — 4 фото террасы/интерьера в asymmetric grid
- **Chef's Table parallax** — фото вместо placeholder-видео (бокал вина + Giuseppe за работой)
- **Логотип в nav** — реальный лого Serrago (B&W PNG с CSS-фильтрами для золотистого тона)
- **WebP fallback** — каждое фото есть в .jpg И .webp (через `<picture>` элементы) — модерные браузеры экономят ~50% трафика

### Изменено
- Galleria переделана в **editorial asymmetric layout** (6-column grid с разными размерами cells)
- Описания блюд переписаны под реальные блюда (не выдуманные)
- Mobile меню добавлены ссылки на новые секции

## Размеры/производительность

- Total HTML: 1509 строк (~62KB)
- Total изображения: ~7.4MB (48 файлов, .jpg + .webp)
- Logo: 4KB PNG
- Видео hero_bg.mp4: размер зависит от того что в v1

С WebP и lazy loading реальный first-paint payload для desktop hero — ~200-300KB.

## Контрольный чек перед отправкой клиенту

- [ ] Запустить локально и проверить что все 24 фото загружаются
- [ ] Проверить hero видео (скопировать из v1)
- [ ] Проверить mobile responsive в Chrome DevTools (375px, 768px, 1280px)
- [ ] Проверить что WhatsApp deeplink работает (тест prenotazione)
- [ ] Проверить лого видно и tinting работает (золотистый цвет)
- [ ] Проверить парallax секцию (фото фиксируется при скролле)
- [ ] Открыть в Safari (некоторые backdrop-filter тонкости)

## Что осталось доработать перед production (не для demo)

- Хостинг: VHosting/SiteGround (как для других итальянских клиентов)
- Кастомный домен (ristoranteserrago.it или похожий)
- GDPR cookie banner + Privacy Policy + Cookie Policy
- P.IVA в footer (Giuseppe должен предоставить)
- Open Graph meta tags для соцсетей
- Sitemap.xml + robots.txt
- Google Analytics или Plausible
- Schema.org Restaurant JSON-LD для SEO
