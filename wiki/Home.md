# КнигаМаг — лабораторная работа № 4

**Дисциплина:** Проектирование человеко-машинных интерфейсов.
**Тема:** Стили интеграции программных систем и проектирование API.
**Группа 13 — объем: задания 1–4** (согласно критериям оценивания, задания 5–6 не выполняются).

Проект продолжает лабораторные работы № 1–3: объект проектирования — книжный
онлайн-магазин «КнигаМаг» (knigamag.by). Входными данными являются
требования, варианты использования, SRS и ER-модель лабораторной работы № 3.
Стек: Python 3.12 / Django 5 / Django REST Framework, СУБД PostgreSQL 16.

## Результаты заданий

| Задание | Результат |
| --- | --- |
| 1. Модель требований и реестр вариантов использования | [Модель требований](https://github.com/ZAFSNB/knigamag-lab4/blob/main/requirements/requirements-model.md), [реестр UC](https://github.com/ZAFSNB/knigamag-lab4/blob/main/requirements/use-case-registry.md), [диаграмма UC](https://raw.githubusercontent.com/ZAFSNB/knigamag-lab4/main/assets/uc_diagram.png) |
| 2. Физическая модель базы данных | [Логическая схема](https://github.com/ZAFSNB/knigamag-lab4/blob/main/db/logical-model.md), [физическая ER-диаграмма](https://raw.githubusercontent.com/ZAFSNB/knigamag-lab4/main/assets/er_physical.png), [schema.sql](https://github.com/ZAFSNB/knigamag-lab4/blob/main/db/schema.sql) |
| 3. Маршруты и конечные точки | [Маршруты](https://github.com/ZAFSNB/knigamag-lab4/blob/main/api/routes.md), [соответствие UC и HTTP-методов](https://github.com/ZAFSNB/knigamag-lab4/blob/main/api/endpoints.md) |
| 4. Проектирование и тестирование API | [OpenAPI 3.0](https://github.com/ZAFSNB/knigamag-lab4/blob/main/api/openapi.yaml), [примеры запросов](https://github.com/ZAFSNB/knigamag-lab4/blob/main/api/requests.md), [результаты Mock-тестов](https://github.com/ZAFSNB/knigamag-lab4/blob/main/api/mock_test_results.md) |

## Разделы wiki

- [Главная страница](Home)
- [Функциональные требования](Functional-Requirements)
- [Диаграмма файлов приложения](Application-File-Diagram)
- [Дополнительная спецификация](Additional-Specification)
- [Схема базы данных](Database-Schema)
- [API-проекта](Project-API)
- [Презентация проекта](Project-Presentation)
