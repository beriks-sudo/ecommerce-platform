# Тесты через container PHP

## Почему test runner должен использовать тот же remote interpreter
Тесты проверяют код в конкретной среде: версия PHP, extensions, env, пути,
database hostname, рабочая директория. Приложение живёт в сервисе `app`, поэтому
PHPUnit/Pest в PhpStorm должны запускаться через **тот же remote interpreter**,
что Composer и CLI. Иначе запуск из IDE и из терминала имеют разный смысл, и
«зелёный» результат на host PHP может быть ложным — проверен не тот runtime.

## Команда запуска из контейнера
Ожидаемая команда (когда тестовый фреймворк появится):

```
docker compose exec app vendor/bin/phpunit
# или
docker compose exec app vendor/bin/pest
```

## Какие ошибки бывают при запуске через неправильный PHP
- **wrong workdir** — запуск не из `/var/www/html` → не найден `phpunit.xml`.
- **wrong service** — выбран `nginx` или другой сервис без PHP.
- **local PHP** — не виден нужный extension (например `pdo_mysql`), которого нет
  на host.
- **wrong env / db host** — тест ищет базу на `localhost`, хотя внутри Docker
  нужен service name `mysql`.

Если тесты падают в IDE, но проходят в терминале — первый вопрос не про
framework, а про interpreter / workdir / env / path mappings.

## Текущий статус (blocker, описан фактами)
Тестовый фреймворк (PHPUnit/Pest) в проекте **ещё не установлен** (`vendor`
отсутствует, см. docs/composer-through-container.md). Я не притворяюсь, что тесты
прошли. Контракт на будущее зафиксирован:

- ожидаемый interpreter: сервис `app` (PHP 8.5.7);
- рабочая директория: `/var/www/html`;
- будущая команда: `docker compose exec app vendor/bin/phpunit`.

Документ полезен уже сейчас: он фиксирует контракт до появления тестов.
