# Публикация проекта на GitHub

Лабораторная работа № 4, группа 13 (задания 1–4).
Целевой репозиторий: **https://github.com/ZAFSNB/knigamag-lab4/** (public).
Локальный репозиторий уже инициализирован и содержит коммиты; осталось создать
удалённый репозиторий, включить Pages и загрузить Wiki.

## Готовая команда

```powershell
winget install --id GitHub.cli                     # один раз, затем перезапустить терминал
gh auth login --web --git-protocol https           # авторизация в браузере
powershell -ExecutionPolicy Bypass -File scripts\publish_github.ps1 -Owner ZAFSNB -Repo knigamag-lab4 -Visibility public
```

Сценарий создаст репозиторий, отправит код, включит Pages из `main:/docs`
и загрузит 7 страниц Wiki. Если Wiki ещё не создавалась, он выведет подсказку:
нужно один раз открыть `https://github.com/ZAFSNB/knigamag-lab4/wiki`, создать
страницу Home и запустить сценарий повторно.

## Что уже есть в репозитории

| Каталог | Назначение |
| --- | --- |
| `requirements/`, `db/`, `api/` | результаты заданий 1–4 |
| `assets/` | три диаграммы PlantUML (`.puml` + `.png`) |
| `wiki/` | 7 страниц Markdown — источник для GitHub Wiki |
| `docs/` | зеркало wiki + `index.md`, `_config.yml`, `presentation.md`, `assets/` — источник для Pages |
| `.github/workflows/ci.yml` | проверка OpenAPI, SQL, ссылок и 18 Mock-тестов при каждом push |
| `scripts/publish_github.ps1` | сценарий публикации (репозиторий + Pages + Wiki) |

Ссылки в `wiki/` и `docs/` уже содержат адрес `ZAFSNB/knigamag-lab4`.
Если репозиторий будет переименован, измените константы `REPO_OWNER` / `REPO_NAME`
в `gen_lab4.py` и перегенерируйте проект; сценарий публикации дополнительно
умеет заменять устаревшие заполнители `__OWNER__` / `__REPO__`.

## Вариант А. Один сценарий (рекомендуется)

1. Установить [GitHub CLI](https://cli.github.com/) (или `winget install --id GitHub.cli`)
   и перезапустить терминал.
2. Выполнить в корне репозитория команду из раздела «Готовая команда» выше.
   При отсутствии авторизации сценарий сам откроет браузер для `gh auth login`.
3. Если Wiki ещё не создавалась: открыть `https://github.com/ZAFSNB/knigamag-lab4/wiki`,
   нажать **Create the first page**, сохранить `Home`, затем запустить сценарий повторно —
   он загрузит все 7 страниц.

## Вариант Б. Вручную

1. `Settings → Pages → Build and deployment`: **Deploy from a branch**,
   branch `main`, folder `/docs`, **Save**. Сайт: `https://ZAFSNB.github.io/knigamag-lab4/`.
2. `Settings → Pages` не требует workflow: Jekyll сам применит `docs/_config.yml`
   (тема `jekyll-theme-cayman`).
3. Wiki: создать первую страницу в веб-интерфейсе, затем клонировать
   `https://github.com/ZAFSNB/knigamag-lab4.wiki.git`, скопировать туда `wiki/*.md`,
   сделать commit и push. Имена файлов — это имена страниц wiki.
4. Ссылки уже заполнены, дополнительных правок перед загрузкой не требуется.

## После публикации

- **Репозиторий**: `https://github.com/ZAFSNB/knigamag-lab4`
- **Pages**: `https://ZAFSNB.github.io/knigamag-lab4/` (сборка 1–2 минуты).
- **Wiki**: 7 страниц — Home, Functional-Requirements, Application-File-Diagram,
  Additional-Specification, Database-Schema, Project-API, Project-Presentation.
- **CI**: вкладка Actions, workflow `CI` — 18/18 Mock-тестов, 31 path / 43 операции
  в OpenAPI, 17 таблиц и 17 индексов в SQL, проверка локальных ссылок docs.
- В `api/openapi.yaml` замените `<ACCOUNT>` в `servers` на свой логин SwaggerHub
  (или удалите эту запись, оставив `localhost:8080` и `api.knigamag.by`).
- В отчёте `Лабораторная_работа_4_Отчёт_ОнлайнМагазин.docx` заполните ФИО на титуле.

## Примечание

`docs/` публикуется как отдельный сайт, поэтому ссылки на файлы репозитория
(`requirements/`, `db/`, `api/`) ведут на GitHub (`/blob/main/...`), а изображения
берутся из `docs/assets/`. Wiki является отдельным git-репозиторием, поэтому её
изображения ссылаются на `raw.githubusercontent.com` основного репозитория.
