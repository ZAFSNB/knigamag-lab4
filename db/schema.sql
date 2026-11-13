-- =====================================================================
-- КнигаМаг — физическая модель базы данных
-- Лабораторная работа № 4, задание 2. СУБД: PostgreSQL 16
-- Стек: Python 3.12 / Django 5 / Django REST Framework
-- Источник: ER-диаграмма лабораторной работы № 3 (уточнена).
-- =====================================================================

BEGIN;

CREATE TABLE users_role (
    id SERIAL PRIMARY KEY,
    name VARCHAR(30) NOT NULL UNIQUE,
    permissions JSONB NOT NULL DEFAULT '{}'::jsonb
);
COMMENT ON TABLE users_role IS 'Роль (ЛР3); PostgreSQL 16';

CREATE TABLE users_user (
    id SERIAL PRIMARY KEY,
    username VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(254) NOT NULL UNIQUE,
    phone VARCHAR(20),
    role_id INT NOT NULL REFERENCES users_role(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
COMMENT ON TABLE users_user IS 'Пользователь (ЛР3); PostgreSQL 16';

CREATE TABLE users_refreshtoken (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users_user(id) ON DELETE CASCADE,
    token_hash VARCHAR(255) NOT NULL UNIQUE,
    expires_at TIMESTAMPTZ NOT NULL,
    revoked BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
COMMENT ON TABLE users_refreshtoken IS 'Refresh-токен (ЛР4); PostgreSQL 16';

CREATE TABLE catalog_author (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    biography TEXT
);
COMMENT ON TABLE catalog_author IS 'Автор (ЛР3); PostgreSQL 16';

CREATE TABLE catalog_publisher (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    address VARCHAR(255)
);
COMMENT ON TABLE catalog_publisher IS 'Издательство (ЛР3); PostgreSQL 16';

CREATE TABLE catalog_topic (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);
COMMENT ON TABLE catalog_topic IS 'Тематика (ЛР3); PostgreSQL 16';

CREATE TABLE catalog_book (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    isbn VARCHAR(13) NOT NULL UNIQUE,
    price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    rating NUMERIC(3,2) NOT NULL DEFAULT 0,
    availability VARCHAR(20) NOT NULL DEFAULT 'in_stock',
    description TEXT,
    author_id INT NOT NULL REFERENCES catalog_author(id),
    publisher_id INT NOT NULL REFERENCES catalog_publisher(id),
    topic_id INT NOT NULL REFERENCES catalog_topic(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
COMMENT ON TABLE catalog_book IS 'Книга (ЛР3); PostgreSQL 16';

CREATE TABLE catalog_review (
    id SERIAL PRIMARY KEY,
    book_id INT NOT NULL REFERENCES catalog_book(id) ON DELETE CASCADE,
    user_id INT NOT NULL REFERENCES users_user(id),
    text TEXT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    created_at DATE NOT NULL DEFAULT CURRENT_DATE,
    moderated BOOLEAN NOT NULL DEFAULT FALSE
);
COMMENT ON TABLE catalog_review IS 'Отзыв (ЛР3); PostgreSQL 16';

CREATE TABLE catalog_favorite (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users_user(id) ON DELETE CASCADE,
    book_id INT NOT NULL REFERENCES catalog_book(id) ON DELETE CASCADE,
    added_at DATE NOT NULL DEFAULT CURRENT_DATE,
    UNIQUE (user_id, book_id)
);
COMMENT ON TABLE catalog_favorite IS 'Избранное (ЛР3); PostgreSQL 16';

CREATE TABLE catalog_subscription (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users_user(id) ON DELETE CASCADE,
    publisher_id INT NOT NULL REFERENCES catalog_publisher(id),
    email VARCHAR(254) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (user_id, publisher_id)
);
COMMENT ON TABLE catalog_subscription IS 'Подписка (ЛР3); PostgreSQL 16';

CREATE TABLE catalog_preorder (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users_user(id),
    book_id INT NOT NULL REFERENCES catalog_book(id),
    status VARCHAR(20) NOT NULL DEFAULT 'awaiting',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    arrived_at TIMESTAMPTZ,
    UNIQUE (user_id, book_id)
);
COMMENT ON TABLE catalog_preorder IS 'Предзаказ (ЛР4); PostgreSQL 16';

CREATE TABLE orders_cart (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL UNIQUE REFERENCES users_user(id) ON DELETE CASCADE,
    total NUMERIC(10,2) NOT NULL DEFAULT 0
);
COMMENT ON TABLE orders_cart IS 'Корзина (ЛР3); PostgreSQL 16';

CREATE TABLE orders_cartitem (
    id SERIAL PRIMARY KEY,
    cart_id INT NOT NULL REFERENCES orders_cart(id) ON DELETE CASCADE,
    book_id INT NOT NULL REFERENCES catalog_book(id),
    quantity INT NOT NULL CHECK (quantity > 0),
    UNIQUE (cart_id, book_id)
);
COMMENT ON TABLE orders_cartitem IS 'Позиция корзины (ЛР3); PostgreSQL 16';

CREATE TABLE orders_order (
    id SERIAL PRIMARY KEY,
    number VARCHAR(20) NOT NULL UNIQUE,
    user_id INT REFERENCES users_user(id),
    contact_email VARCHAR(254),
    contact_phone VARCHAR(20),
    address VARCHAR(255) NOT NULL,
    total NUMERIC(10,2) NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'pending_payment',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CHECK (user_id IS NOT NULL OR contact_email IS NOT NULL)
);
COMMENT ON TABLE orders_order IS 'Заказ (ЛР3); PostgreSQL 16';

CREATE TABLE orders_orderitem (
    id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES orders_order(id) ON DELETE CASCADE,
    book_id INT NOT NULL REFERENCES catalog_book(id),
    quantity INT NOT NULL CHECK (quantity > 0),
    price NUMERIC(10,2) NOT NULL
);
COMMENT ON TABLE orders_orderitem IS 'Позиция заказа (ЛР3); PostgreSQL 16';

CREATE TABLE orders_orderstatushistory (
    id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES orders_order(id) ON DELETE CASCADE,
    status VARCHAR(30) NOT NULL,
    changed_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    changed_by INT REFERENCES users_user(id)
);
COMMENT ON TABLE orders_orderstatushistory IS 'История статусов (ЛР4); PostgreSQL 16';

CREATE TABLE orders_payment (
    id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES orders_order(id),
    amount NUMERIC(10,2) NOT NULL,
    method VARCHAR(30) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    external_id VARCHAR(100),
    paid_at TIMESTAMPTZ
);
COMMENT ON TABLE orders_payment IS 'Платёж (ЛР3); PostgreSQL 16';

-- Индексы для поиска, фильтрации и выборок по внешним ключам (ФТ-1, ФТ-2)
CREATE INDEX idx_book_title ON catalog_book (title);
CREATE INDEX idx_book_author ON catalog_book (author_id);
CREATE INDEX idx_book_publisher ON catalog_book (publisher_id);
CREATE INDEX idx_book_topic ON catalog_book (topic_id);
CREATE INDEX idx_book_price ON catalog_book (price);
CREATE INDEX idx_book_availability ON catalog_book (availability);
CREATE INDEX idx_review_book ON catalog_review (book_id);
CREATE INDEX idx_favorite_user ON catalog_favorite (user_id);
CREATE INDEX idx_subscription_publisher ON catalog_subscription (publisher_id);
CREATE INDEX idx_preorder_status ON catalog_preorder (status);
CREATE INDEX idx_cartitem_cart ON orders_cartitem (cart_id);
CREATE INDEX idx_order_user ON orders_order (user_id);
CREATE INDEX idx_order_status ON orders_order (status);
CREATE INDEX idx_orderitem_order ON orders_orderitem (order_id);
CREATE INDEX idx_statushistory_order ON orders_orderstatushistory (order_id);
CREATE INDEX idx_payment_order ON orders_payment (order_id);
CREATE INDEX idx_refreshtoken_user ON users_refreshtoken (user_id);

COMMIT;
