# API проекта

Спецификация разработана по образцу «Swagger Petstore — OpenAPI 3.0» и
материалов GetAnalyst. Файл [openapi.yaml](https://github.com/ZAFSNB/knigamag-lab4/blob/main/api/openapi.yaml) (OpenAPI 3.0.3)
импортируется в SwaggerHub, Postman или Bruno; при создании API включается
Mock-сервер (SwaggerHub — API Auto Mocking).

## Основные сведения

| Параметр | Значение |
| --- | --- |
| Версия спецификации | OpenAPI 3.0.3 |
| Версия API | 1.0.0 |
| Базовый префикс | `/api/v1` |
| Конечных точек | 43 |
| Схем аутентификации | `bearerAuth` (JWT), `webhookSignature` (HMAC-SHA256) |
| Формат ошибки | `Error`: `code`, `message`, `details[]` |

## Разделы спецификации

- **auth** — Регистрация, вход, JWT-токены и профиль
- **catalog** — Каталог книг и справочники
- **reviews** — Отзывы и оценки
- **cart** — Корзина покупателя
- **favorites** — Избранное
- **orders** — Заказы и их статусы
- **payments** — Оплата и webhook платёжного шлюза
- **preorders** — Предзаказы новинок
- **subscriptions** — Подписки на издательства

## Маршруты и соответствие UC

- [Сущность / Таблица БД / Маршрут](https://github.com/ZAFSNB/knigamag-lab4/blob/main/api/routes.md) (рисунок 4)
- [Актор / Use Case / Маршрут / HTTP-запрос / Аутентификация](https://github.com/ZAFSNB/knigamag-lab4/blob/main/api/endpoints.md) (рисунок 5)
- [Тела POST/PUT-запросов и коды HTTP-ответов](https://github.com/ZAFSNB/knigamag-lab4/blob/main/api/endpoints.md)

## Примеры запросов и тестирование

- [Примеры curl-запросов](https://github.com/ZAFSNB/knigamag-lab4/blob/main/api/requests.md)
- [Локальный Mock-сервер](https://github.com/ZAFSNB/knigamag-lab4/blob/main/api/mock_server.py) (`python mock_server.py`)
- [Тесты спецификации](https://github.com/ZAFSNB/knigamag-lab4/blob/main/api/test_mock.py) и [результаты](https://github.com/ZAFSNB/knigamag-lab4/blob/main/api/mock_test_results.md)

### Ссылка на опубликованную документацию API

`https://app.swaggerhub.com/apis/<ACCOUNT>/knigamag-api/1.0.0`

> Замените `<ACCOUNT>` на имя своего аккаунта после импорта `openapi.yaml`
> (тот же заполнитель используется в блоке `servers` спецификации).
