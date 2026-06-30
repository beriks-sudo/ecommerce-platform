# Remote PHP interpreter contract

В этом проекте источник правды для PHP runtime — **Compose-сервис `app`**, а не
PHP на host. PhpStorm должен использовать remote interpreter, указывающий внутрь
этого сервиса.

## Какой Compose service является PHP interpreter
- **Service:** `app`
- **PHP version (runtime):** PHP 8.5.7 (cli)
- Проверка: `docker compose exec app php -v`

## Где внутри контейнера лежит PHP executable
- **PHP executable:** `/usr/local/bin/php` (на PATH как `php`)
- Проверка: `docker compose exec app which php`

## Container workdir
- **Workdir:** `/var/www/html`
- Проверка: `docker compose exec app pwd`

## Host path ↔ container path
- **Host project path:** `/Users/berik/Developer/education/ecommerce-platform`
- **Container project path:** `/var/www/html`
- Связаны bind mount'ом из compose (`./:/var/www/html`). Path mapping в IDE
  должен сопоставлять эти два пути.

## Почему IDE не должна незаметно выбирать local PHP
На host стоит отдельный PHP (Homebrew, `/opt/homebrew/bin/php`), у которого
другой набор extensions, `php.ini`, env и пути. Если IDE запускает инструменты
через local PHP, она проверяет НЕ тот runtime, в котором живёт приложение
(сервис `app`). Тогда подсказки, Composer и тесты перестают быть надёжным
сигналом. Поэтому interpreter в PhpStorm должен указывать в сервис `app`.
