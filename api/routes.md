# Маршруты API (Задание 3, рисунок 4)

Маршруты спроектированы на основе материалов «Проектирование REST API на примере
интернет-магазина», «Пример проектирования REST API библиотеки» (GetAnalyst)
и «Материалы по REST API, Postman и Swagger». Приняты соглашения: префикс
версии `/api/v1`, имена ресурсов во множественном числе, идентификаторы в пути,
фильтры и пагинация в query-параметрах.

| Сущность | Таблица БД | Маршрут |
| --- | --- | --- |
| Книга | catalog_book | /api/v1/books |
| Автор | catalog_author | /api/v1/authors |
| Издательство | catalog_publisher | /api/v1/publishers |
| Тематика | catalog_topic | /api/v1/topics |
| Отзыв | catalog_review | /api/v1/books/{bookId}/reviews |
| Избранное | catalog_favorite | /api/v1/favorites |
| Подписка | catalog_subscription | /api/v1/subscriptions |
| Предзаказ | catalog_preorder | /api/v1/preorders |
| Корзина | orders_cart | /api/v1/cart |
| Позиция корзины | orders_cartitem | /api/v1/cart/items |
| Заказ | orders_order | /api/v1/orders |
| Позиция заказа | orders_orderitem | /api/v1/orders/{orderId}/items |
| История статусов заказа | orders_orderstatushistory | /api/v1/orders/{orderId}/status-history |
| Платёж | orders_payment | /api/v1/payments |
| Пользователь | users_user | /api/v1/users |
| Роль | users_role | /api/v1/roles |
| Refresh-токен | users_refreshtoken | /api/v1/auth/refresh |
| Регистрация | users_user | /api/v1/auth/register |
| Аутентификация | users_user, users_refreshtoken | /api/v1/auth/login |
| Webhook оплаты | orders_payment | /api/v1/payments/webhook |

[Соответствие вариантов использования конечным точкам](endpoints.md) ·
[Спецификация OpenAPI](openapi.yaml)
