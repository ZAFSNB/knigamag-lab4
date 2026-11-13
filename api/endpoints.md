# Конечные точки API (Задание 3, рисунок 5)

Варианты использования сопоставлены с HTTP-методами, которые обращаются
к маршрутам из [routes.md](routes.md). Всего **43 конечных точек**.

| Актор | Use Case | Маршрут | HTTP-запрос | Аутентификация |
| --- | --- | --- | --- | --- |
| Гость | UC-10 | /api/v1/auth/register | POST | нет |
| Покупатель, менеджер, администратор | UC-10, UC-11 | /api/v1/auth/login | POST | нет |
| Покупатель, менеджер, администратор | UC-14 | /api/v1/auth/refresh | POST | нет |
| Покупатель, менеджер, администратор | UC-14 | /api/v1/auth/logout | POST | да (JWT) |
| Покупатель, менеджер, администратор | UC-10 | /api/v1/users/me | GET | да (JWT) |
| Администратор | UC-11 | /api/v1/roles | GET | да (JWT) |
| Гость, покупатель | UC-1, UC-13 | /api/v1/books | GET | нет |
| Администратор | UC-9 | /api/v1/books | POST | да (JWT) |
| Гость, покупатель | UC-1 | /api/v1/books/{bookId} | GET | нет |
| Администратор | UC-9 | /api/v1/books/{bookId} | PUT | да (JWT) |
| Администратор | UC-9 | /api/v1/books/{bookId} | DELETE | да (JWT) |
| Гость, администратор | UC-16 | /api/v1/authors | GET | нет |
| Администратор | UC-16 | /api/v1/authors | POST | да (JWT) |
| Гость, администратор | UC-16 | /api/v1/publishers | GET | нет |
| Администратор | UC-16 | /api/v1/publishers | POST | да (JWT) |
| Гость, администратор | UC-16 | /api/v1/topics | GET | нет |
| Администратор | UC-16 | /api/v1/topics | POST | да (JWT) |
| Гость, покупатель | UC-6 | /api/v1/books/{bookId}/reviews | GET | нет |
| Покупатель | UC-6 | /api/v1/books/{bookId}/reviews | POST | да (JWT) |
| Администратор | UC-6 | /api/v1/reviews/{reviewId} | PATCH | да (JWT) |
| Покупатель | UC-12 | /api/v1/cart | GET | да (JWT) |
| Покупатель | UC-12 | /api/v1/cart/items | POST | да (JWT) |
| Покупатель | UC-12 | /api/v1/cart/items/{itemId} | PUT | да (JWT) |
| Покупатель | UC-12 | /api/v1/cart/items/{itemId} | DELETE | да (JWT) |
| Покупатель | UC-12 | /api/v1/cart | DELETE | да (JWT) |
| Покупатель | UC-5 | /api/v1/favorites | GET | да (JWT) |
| Покупатель | UC-5 | /api/v1/favorites | POST | да (JWT) |
| Покупатель | UC-5 | /api/v1/favorites/{favoriteId} | DELETE | да (JWT) |
| Покупатель | UC-2 | /api/v1/orders | POST | да (JWT) |
| Гость | UC-3 | /api/v1/orders/guest | POST | нет |
| Покупатель, менеджер | UC-7 | /api/v1/orders | GET | да (JWT) |
| Покупатель, менеджер | UC-7 | /api/v1/orders/{orderId} | GET | да (JWT) |
| Покупатель, менеджер | UC-7 | /api/v1/orders/{orderId}/items | GET | да (JWT) |
| Покупатель, менеджер | UC-7 | /api/v1/orders/{orderId}/status-history | GET | да (JWT) |
| Менеджер | UC-8 | /api/v1/orders/{orderId}/status | PATCH | да (JWT) |
| Покупатель | UC-2 | /api/v1/orders/{orderId}/payment | POST | да (JWT) |
| Покупатель, менеджер | UC-7 | /api/v1/payments/{paymentId} | GET | да (JWT) |
| Платёжный шлюз | UC-15 | /api/v1/payments/webhook | POST | HMAC-подпись |
| Покупатель | UC-4 | /api/v1/preorders | GET | да (JWT) |
| Покупатель | UC-4 | /api/v1/preorders | POST | да (JWT) |
| Покупатель | UC-4 | /api/v1/preorders/{preorderId} | DELETE | да (JWT) |
| Покупатель | UC-4 | /api/v1/subscriptions | POST | да (JWT) |
| Покупатель | UC-4 | /api/v1/subscriptions/{subscriptionId} | DELETE | да (JWT) |

## Тела запросов POST / PUT / PATCH и коды HTTP-ответов (Задание 4, п. 4)

Для каждой операции с телом запроса в [openapi.yaml](openapi.yaml) определены
`requestBody` со схемой и примером, а также перечень кодов ответа с описанием
их смысла. Значения «да (JWT)» в колонке аутентификации соответствуют схеме
`bearerAuth`, «HMAC-подпись» — схеме `webhookSignature`.

| Метод | Маршрут | Схема тела запроса | Дополнительные коды ответа |
| --- | --- | --- | --- |
| POST | /api/v1/auth/register | RegisterRequest | 409, 422 |
| POST | /api/v1/auth/login | LoginRequest | 401, 422 |
| POST | /api/v1/auth/refresh | RefreshRequest | 401, 422 |
| POST | /api/v1/auth/logout | RefreshRequest | — |
| POST | /api/v1/books | BookCreate | 403, 409, 422 |
| PUT | /api/v1/books/{bookId} | BookCreate | 403, 404, 409, 422 |
| POST | /api/v1/authors | AuthorCreate | 403, 422 |
| POST | /api/v1/publishers | PublisherCreate | 403, 422 |
| POST | /api/v1/topics | TopicCreate | 403, 409, 422 |
| POST | /api/v1/books/{bookId}/reviews | ReviewCreate | 403, 404, 409, 422 |
| PATCH | /api/v1/reviews/{reviewId} | ReviewModeration | 403, 404, 422 |
| POST | /api/v1/cart/items | CartItemCreate | 404, 409, 422 |
| PUT | /api/v1/cart/items/{itemId} | CartItemUpdate | 404, 422 |
| POST | /api/v1/favorites | FavoriteCreate | 404, 409, 422 |
| POST | /api/v1/orders | OrderCreate | 409, 422 |
| POST | /api/v1/orders/guest | GuestOrderCreate | 422 |
| PATCH | /api/v1/orders/{orderId}/status | OrderStatusUpdate | 403, 404, 409, 422 |
| POST | /api/v1/orders/{orderId}/payment | PaymentInit | 404, 409, 422, 502 |
| POST | /api/v1/payments/webhook | PaymentWebhook | 409, 422, 502 |
| POST | /api/v1/preorders | PreorderCreate | 404, 409, 422 |
| POST | /api/v1/subscriptions | SubscriptionCreate | 404, 409, 422, 429 |

### Справочник кодов HTTP-ответов

| Код | Смысл |
| --- | --- |
| 200 | Запрос выполнен, ресурс возвращён или обновлён |
| 201 | Ресурс успешно создан |
| 204 | Ресурс удалён, тело ответа отсутствует |
| 400 | Некорректный JSON или неверные параметры запроса |
| 401 | Отсутствует, истёк или недействителен JWT-токен |
| 403 | Роль пользователя не имеет права на операцию |
| 404 | Ресурс или связанная сущность не найдены |
| 409 | Конфликт: нарушена уникальность или бизнес-правило |
| 422 | Ошибка валидации полей тела запроса |
| 429 | Превышена частота запросов (рассылка, webhook) |
| 500 | Внутренняя ошибка сервера |
| 502 | Платёжный шлюз недоступен |
| 503 | Сервис поиска временно недоступен |

Ошибки возвращаются в едином формате схемы `Error`
(`code`, `message`, `details[]`), что позволяет клиенту обрабатывать отказы
предсказуемо. Примеры запросов: [requests.md](requests.md).
Результаты тестирования: [mock_test_results.md](mock_test_results.md).
