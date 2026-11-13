# Публикация проекта на GitHub

Лабораторная работа № 4, группа 13 (задания 1–4). Репозиторий уже подготовлен:
осталось создать удалённый репозиторий, включить Pages и загрузить Wiki.

## Что уже есть в репозитории

| Каталог | Назначение |
| --- | --- |
| `requirements/`, `db/`, `api/` | результаты заданий 1–4 |
| `assets/` | три диаграммы PlantUML (`.puml` + `.png`) |
| `wiki/` | 7 страниц Markdown — источник для GitHub Wiki |
| `docs/` | зеркало wiki + `index.md`, `_config.yml`, `presentation.md`, `assets/` — источник для Pages |
| `.github/workflows/ci.yml` | проверка OpenAPI, SQL, ссылок и 18 Mock-тестов при каждом push |
| `scripts/publish_github.ps1` | сценарий публикации (репозиторий + Pages + Wiki) |

Ссылки в `wiki/` и `docs/` используют заполнители `__OWNER__` и `__REPO__`.
Сценарий публикации заменяет их на реальные значения.

## Вариант А. Один сценарий (рекомендуется)

1. Установить [GitHub CLI](https://cli.github.com/) (или `winget install --id GitHub.cli`)
   и перезапустить терминал.
2. Выполнить в корне репозитория:

   ```powershell
   powershell -ExecutionPolicy Bypass -File scripts\publish_github.ps1 -Owner ВАШ_ЛОГИН -Repo knigamag-lab4
   ```

   Сценарий при необходимости откроет браузер для `gh auth login`.
3. Если Wiki ещё не создавалась: открыть `https://github.com/ВАШ_ЛОГИН/knigamag-lab4/wiki`,
   нажать **Create the first page**, сохранить `Home`, затем запустить сценарий повторно —
   он загрузит все 7 страниц.

## Вариант Б. Вручную

1. `Settings → Pages → Build and deployment`: **Deploy from a branch**,
   branch `main`, folder `/docs`, **Save**. Сайт: `https://ВАШ_ЛОГИН.github.io/РЕПОЗИТОРИЙ/`.
2. `Settings → Pages` не требует workflow: Jekyll сам применит `docs/_config.yml`
   (тема `jekyll-theme-cayman`).
3. Wiki: создать первую страницу в веб-интерфейсе, затем клонировать
   `https://github.com/ВАШ_ЛОГИН/РЕПОЗИТОРИЙ.wiki.git`, скопировать туда `wiki/*.md`,
   сделать commit и push. Имена файлов — это имена страниц wiki.
4. Перед ручной загрузкой замените `__OWNER__` / `__REPO__` на свои значения
   в `README.md`, `wiki/*.md`, `docs/*.md` (исключая `.github/workflows/ci.yml`,
   `PUBLISHING.md` и сам сценарий — в них заполнители должны остаться),
   иначе ссылки и проверка CI не пройдут.

## После публикации

- **Pages**: `https://ВАШ_ЛОГИН.github.io/РЕПОЗИТОРИЙ/` (сборка 1–2 минуты).
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
