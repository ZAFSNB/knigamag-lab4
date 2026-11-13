# Project Name

**КнигаМаг (knigamag.by)** — REST API книжного онлайн-магазина.
Лабораторная работа № 4 по курсу «Проектирование человеко-машинных интерфейсов»,
группа 13, задания 1–4.

# Description

Проект продолжает лабораторные работы № 1–3 и описывает программный интерфейс
книжного онлайн-магазина «КнигаМаг». Репозиторий содержит модель требований
(Актор → User Story → Use Case), реестр вариантов использования, логическую
и физическую модели базы данных для PostgreSQL 16, SQL-схему, таблицы маршрутов и
конечных точек, спецификацию OpenAPI 3.0 с телами POST/PUT-запросов и кодами
HTTP-ответов, а также локальный Mock-сервер с автотестами. Документация
оформлена в семи страницах `wiki/` и их зеркале `docs/` для GitHub Pages.

# Installation

```bash
git clone https://github.com/ZAFSNB/knigamag-lab4.git knigamag
cd knigamag
python -m venv .venv && .venv\Scripts\activate     # Windows
# pip install -r requirements.txt   # появится вместе с backend-кодом (задание 6)
psql -U postgres -d knigamag -f db/schema.sql          # физическая модель БД
python api/mock_server.py 8080                         # локальный Mock API
python api/test_mock.py                                # проверка спецификации
python -m http.server 8000 --directory docs            # локальный просмотр Pages
```

Альтернатива без установки: импортировать `api/openapi.yaml` в
[SwaggerHub](https://app.swaggerhub.com/home), [Postman](https://www.postman.com)
или [Bruno](https://docs.usebruno.com/api-docs/overview) и включить Auto Mocking.

# Sub modules

| Подмодуль | Описание | Ссылка |
| --- | --- | --- |
| `backend` | Django 5 + DRF, приложения `users`, `catalog`, `orders`; реализация эндпоинтов из `openapi.yaml` | планируется (`<URL>/backend`) |
| `web` | Веб-приложение 1440 px по макетам лабораторной работы № 2 | планируется (`<URL>/web`) |
| `mobile` | Мобильное приложение 375 × 670 px по макетам лабораторной работы № 2 | планируется (`<URL>/mobile`) |

В объём заданий 1–4 входит проектирование и документирование API, поэтому
подмодули на данном этапе описаны, но исходный код приложений не разворачивается
(инфраструктура и развёртывание относятся к заданию 6, которое для группы 13
не требуется).

# Usage

1. Откройте [wiki/Home.md](wiki/Home.md) — навигация по семи разделам документации.
2. Изучите [api/openapi.yaml](api/openapi.yaml) в Swagger UI / SwaggerHub / Postman / Bruno.
3. Выполните примеры из [api/requests.md](api/requests.md) против Mock-сервера.
4. Для создания схемы БД примените [db/schema.sql](db/schema.sql) к PostgreSQL 16.
5. Сайт GitHub Pages собирается из каталога `docs/` (структура повторяет wiki).
6. Порядок публикации на GitHub (репозиторий, Pages, Wiki) — в
   [PUBLISHING.md](PUBLISHING.md); автоматическая проверка — `.github/workflows/ci.yml`.

# Contributing

Автор: студент группы 13, БГУ, ФПМИ (ФИО подставляется в отчёт).
Выполнены задания 1–4: анализ и дополнение требований ЛР 3, реестр UC,
логическая и физическая модели БД, `20` маршрутов/сущностей,
спецификация OpenAPI 3.0 (43 конечных точек), Mock-сервер и 18 автоматических
проверок, README, семь страниц wiki и зеркало GitHub Pages.
