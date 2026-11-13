# -*- coding: utf-8 -*-
"""Тестирование спецификации OpenAPI через локальный Mock-сервер (Задание 4, п. 5).

Запуск: python test_mock.py
Результат: mock_test_results.md
"""
import io
import json
import os
import subprocess
import sys
import time
import urllib.error
import urllib.request

PORT = 8099
BASE = "http://127.0.0.1:%d" % PORT
HERE = os.path.dirname(os.path.abspath(__file__))
TOKEN = {"Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.access"}
SIGN = {"X-Webhook-Signature": "sha256=9f2c..."}

# (описание, метод, путь, заголовки, тело, ожидаемый код, проверка ответа)
CASES = [
    ('Коллекция книг с пагинацией (UC-13)', 'GET', '/api/v1/books', None, None, 200, lambda r: isinstance(r.get('items'), list) and r.get('total') >= 1),
    ('Карточка книги (UC-1)', 'GET', '/api/v1/books/1', None, None, 200, lambda r: r.get('id') == 1),
    ('Несуществующая книга', 'GET', '/api/v1/books/999999', None, None, 404, None),
    ('Неизвестный маршрут', 'GET', '/api/v1/unknown', None, None, 404, None),
    ('Метод не описан в спецификации', 'GET', '/api/v1/auth/register', None, None, 405, None),
    ('Создание книги без JWT (UC-9)', 'POST', '/api/v1/books', None, {'title': 'Чистый код',
 'isbn': '9780132350884',
 'price': 52.0,
 'availability': 'in_stock',
 'description': 'Руководство по написанию чистого кода.',
 'authorId': 1,
 'publisherId': 1,
 'topicId': 1}, 401, None),
    ('Создание книги с JWT', 'POST', '/api/v1/books', TOKEN, {'title': 'Чистый код',
 'isbn': '9780132350884',
 'price': 52.0,
 'availability': 'in_stock',
 'description': 'Руководство по написанию чистого кода.',
 'authorId': 1,
 'publisherId': 1,
 'topicId': 1}, 201, lambda r: r.get('isbn') is not None),
    ('Обновление книги (PUT, тело запроса)', 'PUT', '/api/v1/books/1', TOKEN, {'title': 'Чистый код',
 'isbn': '9780132350884',
 'price': 52.0,
 'availability': 'in_stock',
 'description': 'Руководство по написанию чистого кода.',
 'authorId': 1,
 'publisherId': 1,
 'topicId': 1}, 200, lambda r: r.get('id') == 1),
    ('Регистрация (UC-10)', 'POST', '/api/v1/auth/register', None, {'username': 'maria',
 'email': 'maria@example.com',
 'password': 'Str0ngPass!',
 'phone': '+375291234567'}, 201, lambda r: 'accessToken' in r and r.get('tokenType') == 'Bearer'),
    ('Вход в систему (UC-11)', 'POST', '/api/v1/auth/login', None, {'username': 'maria', 'password': 'Str0ngPass!'}, 200, lambda r: 'refreshToken' in r),
    ('Корзина без JWT (UC-12)', 'GET', '/api/v1/cart', None, None, 401, None),
    ('Корзина с JWT', 'GET', '/api/v1/cart', TOKEN, None, 200, lambda r: isinstance(r.get('items'), list)),
    ('Оформление заказа (UC-2)', 'POST', '/api/v1/orders', TOKEN, {'address': 'Минск, пр. Независимости, 4', 'paymentMethod': 'card'}, 201, lambda r: 'status' in r),
    ('Быстрый заказ гостя (UC-3)', 'POST', '/api/v1/orders/guest', None, {'contactEmail': 'olga@example.com',
 'contactPhone': '+375291112233',
 'address': 'Гродно, ул. Советская, 8',
 'paymentMethod': 'card'}, 201, lambda r: 'number' in r),
    ('Webhook без HMAC-подписи (UC-15)', 'POST', '/api/v1/payments/webhook', None, {'externalId': 'ps-8891', 'orderId': 1024, 'status': 'confirmed', 'signature': 'sha256=9f2c...'}, 401, None),
    ('Webhook с HMAC-подписью', 'POST', '/api/v1/payments/webhook', SIGN, {'externalId': 'ps-8891', 'orderId': 1024, 'status': 'confirmed', 'signature': 'sha256=9f2c...'}, 200, lambda r: r.get('status') == 'confirmed'),
    ('Удаление из избранного (204, UC-5)', 'DELETE', '/api/v1/favorites/5', TOKEN, None, 204, None),
    ('История статусов заказа (UC-7)', 'GET', '/api/v1/orders/1024/status-history', TOKEN, None, 200, lambda r: isinstance(r.get('items'), list)),
]


def call(method, path, headers=None, body=None):
    data = None if body is None else json.dumps(body, ensure_ascii=False).encode("utf-8")
    h = {"Content-Type": "application/json"}
    h.update(headers or {})
    req = urllib.request.Request(BASE + path, data=data, headers=h, method=method)
    try:
        with urllib.request.urlopen(req, timeout=5) as r:
            raw = r.read().decode("utf-8")
            return r.status, (json.loads(raw) if raw else None)
    except urllib.error.HTTPError as e:
        raw = e.read().decode("utf-8")
        return e.code, (json.loads(raw) if raw else None)


def main():
    srv = subprocess.Popen([sys.executable, os.path.join(HERE, "mock_server.py"), str(PORT)],
                           stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    try:
        for _ in range(40):
            try:
                urllib.request.urlopen(BASE + "/api/v1/books", timeout=1).close()
                break
            except Exception:
                time.sleep(0.15)
        rows, passed = [], 0
        for i, (desc, method, path, headers, body, expected, check) in enumerate(CASES, 1):
            code, resp = call(method, path, headers, body)
            ok = code == expected and (check is None or check(resp))
            passed += int(ok)
            rows.append((i, "%s %s" % (method, path), desc, expected, code,
                         "ПРОЙДЕН" if ok else "НЕ ПРОЙДЕН"))
        lines = ["# Результаты тестирования спецификации (Задание 4, п. 5)", "",
                 "Mock-сервер: `api/mock_server.py` (Python 3, без внешних зависимостей). "
                 "Ответы формируются из примеров `api/openapi.yaml`.", "",
                 "**Итого: %d из %d проверок пройдены.**" % (passed, len(CASES)), "",
                 "| № | Запрос | Проверяемое условие | Ожидаемый код | Фактический код | Результат |",
                 "| --- | --- | --- | --- | --- | --- |"]
        for r in rows:
            lines.append("| %d | `%s` | %s | %d | %d | %s |" % r)
        lines += ["", "Покрыты: успешные ответы 200/201/204, ошибки 401 (нет JWT / нет HMAC), "
                  "404 (неизвестный маршрут и неизвестный ресурс), 405 (метод не описан в спецификации), "
                  "а также проверка структуры тел ответов (наличие `items`, `accessToken`, `status`).", ""]
        out = os.path.join(HERE, "mock_test_results.md")
        io.open(out, "w", encoding="utf-8", newline="\n").write("\n".join(lines))
        print("passed %d/%d -> %s" % (passed, len(CASES), out))
        return 0 if passed == len(CASES) else 1
    finally:
        srv.terminate()


if __name__ == "__main__":
    sys.exit(main())
