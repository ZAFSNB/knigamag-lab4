# Примеры запросов к API (Задание 4, п. 6)

Базовый URL локального Mock-сервера: `http://localhost:8080`.  Для SwaggerHub Auto Mocking замените его на URL из `servers` в [openapi.yaml](openapi.yaml). `JWT` — заголовок `Authorization: Bearer <accessToken>`, `HMAC` — заголовок `X-Webhook-Signature: sha256=<подпись>`.

### Поиск книг с фильтрами (UC-1, UC-13)

```bash
curl -X GET "http://localhost:8080/api/v1/books?q=%D0%A7%D0%B8%D1%81%D1%82%D1%8B%D0%B9&sort=price&page=1&perPage=20" \
  -H "Content-Type: application/json"
```

### Регистрация (UC-10)

```bash
curl -X POST "http://localhost:8080/api/v1/auth/register" \
  -H "Content-Type: application/json" \
  -d '{"username": "maria", "email": "maria@example.com", "password": "Str0ngPass!", "phone": "+375291234567"}'
```

### Вход в систему (UC-11)

```bash
curl -X POST "http://localhost:8080/api/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"username": "maria", "password": "Str0ngPass!"}'
```

### Создание книги (UC-9)

```bash
curl -X POST "http://localhost:8080/api/v1/books" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <accessToken>" \
  -d '{"title": "Чистый код", "isbn": "9780132350884", "price": 52.0, "availability": "in_stock", "description": "Руководство по написанию чистого кода.", "authorId": 1, "publisherId": 1, "topicId": 1}'
```

### Обновление книги (UC-9)

```bash
curl -X PUT "http://localhost:8080/api/v1/books/1" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <accessToken>" \
  -d '{"title": "Чистый код", "isbn": "9780132350884", "price": 52.0, "availability": "in_stock", "description": "Руководство по написанию чистого кода.", "authorId": 1, "publisherId": 1, "topicId": 1}'
```

### Добавление в корзину (UC-12)

```bash
curl -X POST "http://localhost:8080/api/v1/cart/items" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <accessToken>" \
  -d '{"bookId": 1, "quantity": 1}'
```

### Оформление заказа (UC-2)

```bash
curl -X POST "http://localhost:8080/api/v1/orders" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <accessToken>" \
  -d '{"address": "Минск, пр. Независимости, 4", "paymentMethod": "card"}'
```

### Быстрый заказ без регистрации (UC-3)

```bash
curl -X POST "http://localhost:8080/api/v1/orders/guest" \
  -H "Content-Type: application/json" \
  -d '{"contactEmail": "olga@example.com", "contactPhone": "+375291112233", "address": "Гродно, ул. Советская, 8", "paymentMethod": "card"}'
```

### Инициация оплаты (UC-2)

```bash
curl -X POST "http://localhost:8080/api/v1/orders/1024/payment" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <accessToken>" \
  -d '{"method": "card"}'
```

### Webhook платёжного шлюза (UC-15)

```bash
curl -X POST "http://localhost:8080/api/v1/payments/webhook" \
  -H "Content-Type: application/json" \
  -H "X-Webhook-Signature: sha256=<подпись>" \
  -d '{"externalId": "ps-8891", "orderId": 1024, "status": "confirmed", "signature": "sha256=9f2c..."}'
```

### Изменение статуса заказа (UC-8)

```bash
curl -X PATCH "http://localhost:8080/api/v1/orders/1024/status" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <accessToken>" \
  -d '{"status": "assembled"}'
```

### Отзыв о книге (UC-6)

```bash
curl -X POST "http://localhost:8080/api/v1/books/1/reviews" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <accessToken>" \
  -d '{"text": "Полезная книга, рекомендую.", "rating": 5}'
```

### Оформление предзаказа (UC-4)

```bash
curl -X POST "http://localhost:8080/api/v1/preorders" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <accessToken>" \
  -d '{"bookId": 2}'
```

### Удаление позиции корзины (UC-12)

```bash
curl -X DELETE "http://localhost:8080/api/v1/cart/items/11" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <accessToken>"
```

## Публикация документации API

1. Создать аккаунт на [SwaggerHub](https://app.swaggerhub.com/home), [Postman](https://www.postman.com) или [Bruno](https://docs.usebruno.com/api-docs/overview).
2. Импортировать `api/openapi.yaml` (Create New API → Import API / Import collection). При создании включить переключатель **Mock Server** (SwaggerHub — API Auto Mocking).
3. Если Mock не включён: SwaggerHub — Integrations → API Auto Mocking; Bruno — Introduction to Mock Servers in Bruno.
4. Выполнить примеры выше и [test_mock.py](test_mock.py), сверить коды ответов.
5. Добавить ссылку на опубликованную документацию в wiki/Pages (страница «API-проекта»), заменив `<ACCOUNT>` в `servers` на имя аккаунта.
