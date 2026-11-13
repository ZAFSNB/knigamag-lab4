# Логическая схема базы данных (Задание 2, рисунок 2)

Логическая ER-модель лабораторной работы № 3 (14 сущностей) уточнена до 17 таблиц.
Добавлены `catalog_preorder` (ФТ-6 — предзаказ), `orders_orderstatushistory`
(US-8 — история статусов) и `users_refreshtoken` (UC-11, UC-14 — JWT).
В `catalog_book` введено поле `availability` (ФТ-2, ФТ-6), в `orders_order` —
nullable `user_id` и контакты гостя (ФТ-5). Типы приведены к **PostgreSQL 16**.

| Сущность | Таблица БД | Поле | Описание | Тип данных |
| --- | --- | --- | --- | --- |
| Роль | users_role | id (PK) | Идентификатор роли | SERIAL |
|  |  | name | Название роли: guest, customer, manager, admin | VARCHAR(30) |
|  |  | permissions | Набор прав роли | JSONB |
| Пользователь | users_user | id (PK) | Идентификатор пользователя | SERIAL |
|  |  | username | Логин | VARCHAR(150) |
|  |  | password_hash | Хэш пароля (Argon2) | VARCHAR(255) |
|  |  | email | Электронная почта | VARCHAR(254) |
|  |  | phone | Телефон | VARCHAR(20) |
|  |  | role_id (FK) | Ссылка на роль | INT |
|  |  | created_at | Дата регистрации | TIMESTAMPTZ |
| Refresh-токен | users_refreshtoken | id (PK) | Идентификатор записи | SERIAL |
|  |  | user_id (FK) | Владелец токена | INT |
|  |  | token_hash | Хэш refresh-токена | VARCHAR(255) |
|  |  | expires_at | Срок действия | TIMESTAMPTZ |
|  |  | revoked | Признак отзыва | BOOLEAN |
|  |  | created_at | Дата выдачи | TIMESTAMPTZ |
| Автор | catalog_author | id (PK) | Идентификатор автора | SERIAL |
|  |  | first_name | Имя | VARCHAR(100) |
|  |  | last_name | Фамилия | VARCHAR(100) |
|  |  | biography | Биография | TEXT |
| Издательство | catalog_publisher | id (PK) | Идентификатор издательства | SERIAL |
|  |  | name | Название | VARCHAR(200) |
|  |  | address | Юридический адрес | VARCHAR(255) |
| Тематика | catalog_topic | id (PK) | Идентификатор тематики | SERIAL |
|  |  | name | Название тематики | VARCHAR(100) |
| Книга | catalog_book | id (PK) | Идентификатор книги | SERIAL |
|  |  | title | Название книги | VARCHAR(255) |
|  |  | isbn | ISBN | VARCHAR(13) |
|  |  | price | Цена, BYN | NUMERIC(10,2) |
|  |  | rating | Средняя оценка | NUMERIC(3,2) |
|  |  | availability | Наличие: in_stock / out_of_stock / preorder | VARCHAR(20) |
|  |  | description | Описание | TEXT |
|  |  | author_id (FK) | Автор | INT |
|  |  | publisher_id (FK) | Издательство | INT |
|  |  | topic_id (FK) | Тематика | INT |
|  |  | created_at | Дата добавления в каталог | TIMESTAMPTZ |
| Отзыв | catalog_review | id (PK) | Идентификатор отзыва | SERIAL |
|  |  | book_id (FK) | Книга | INT |
|  |  | user_id (FK) | Автор отзыва | INT |
|  |  | text | Текст отзыва | TEXT |
|  |  | rating | Оценка от 1 до 5 | INT |
|  |  | created_at | Дата отзыва | DATE |
|  |  | moderated | Признак модерации | BOOLEAN |
| Избранное | catalog_favorite | id (PK) | Идентификатор записи | SERIAL |
|  |  | user_id (FK) | Покупатель | INT |
|  |  | book_id (FK) | Книга | INT |
|  |  | added_at | Дата добавления | DATE |
| Подписка | catalog_subscription | id (PK) | Идентификатор подписки | SERIAL |
|  |  | user_id (FK) | Покупатель | INT |
|  |  | publisher_id (FK) | Издательство | INT |
|  |  | email | Адрес рассылки | VARCHAR(254) |
|  |  | created_at | Дата оформления | TIMESTAMPTZ |
| Предзаказ | catalog_preorder | id (PK) | Идентификатор предзаказа | SERIAL |
|  |  | user_id (FK) | Покупатель | INT |
|  |  | book_id (FK) | Книга | INT |
|  |  | status | awaiting / arrived / charged / cancelled | VARCHAR(20) |
|  |  | created_at | Дата оформления | TIMESTAMPTZ |
|  |  | arrived_at | Дата поступления тиража | TIMESTAMPTZ |
| Корзина | orders_cart | id (PK) | Идентификатор корзины | SERIAL |
|  |  | user_id (FK) | Владелец корзины | INT |
|  |  | total | Сумма корзины | NUMERIC(10,2) |
| Позиция корзины | orders_cartitem | id (PK) | Идентификатор позиции | SERIAL |
|  |  | cart_id (FK) | Корзина | INT |
|  |  | book_id (FK) | Книга | INT |
|  |  | quantity | Количество | INT |
| Заказ | orders_order | id (PK) | Идентификатор заказа | SERIAL |
|  |  | number | Номер заказа | VARCHAR(20) |
|  |  | user_id (FK) | Покупатель (NULL для гостя) | INT |
|  |  | contact_email | E-mail гостя (ФТ-5) | VARCHAR(254) |
|  |  | contact_phone | Телефон гостя | VARCHAR(20) |
|  |  | address | Адрес доставки | VARCHAR(255) |
|  |  | total | Сумма заказа | NUMERIC(10,2) |
|  |  | status | pending_payment / paid / assembled / in_delivery / delivered / cancelled | VARCHAR(30) |
|  |  | created_at | Дата создания | TIMESTAMPTZ |
| Позиция заказа | orders_orderitem | id (PK) | Идентификатор позиции | SERIAL |
|  |  | order_id (FK) | Заказ | INT |
|  |  | book_id (FK) | Книга | INT |
|  |  | quantity | Количество | INT |
|  |  | price | Цена на момент покупки | NUMERIC(10,2) |
| История статусов | orders_orderstatushistory | id (PK) | Идентификатор записи | SERIAL |
|  |  | order_id (FK) | Заказ | INT |
|  |  | status | Установленный статус | VARCHAR(30) |
|  |  | changed_at | Дата изменения | TIMESTAMPTZ |
|  |  | changed_by (FK) | Менеджер | INT |
| Платёж | orders_payment | id (PK) | Идентификатор платежа | SERIAL |
|  |  | order_id (FK) | Заказ | INT |
|  |  | amount | Сумма платежа | NUMERIC(10,2) |
|  |  | method | Способ оплаты (card) | VARCHAR(30) |
|  |  | status | pending / confirmed / declined | VARCHAR(20) |
|  |  | external_id | Идентификатор в платёжном шлюзе | VARCHAR(100) |
|  |  | paid_at | Дата подтверждения | TIMESTAMPTZ |

**Обозначения:** PK — первичный ключ, FK — внешний ключ (ссылки перечислены в
[физической ER-диаграмме](../assets/er_physical.png) и в [schema.sql](schema.sql)).

[Физическая модель и SQL](schema.sql) · [Схема БД в wiki](../wiki/Database-Schema.md)
