# Path mappings и workdir

Минимальный interpreter contract проекта (фактические значения, проверяются
скриптом `bin/tooling-summary.sh`):

```
Host project path:        /Users/berik/Developer/education/ecommerce-platform
Container project path:   /var/www/html
Container workdir:        /var/www/html
PHP service name:         app
PHP executable:           /usr/local/bin/php
Composer file expected at: /var/www/html/composer.json
```

## Что это значит
- PhpStorm открывает файлы по **host path**, контейнер видит те же файлы по
  **container path** (`/var/www/html`) через bind mount из compose (`./:/var/www/html`).
- **Path mapping** в IDE должен сопоставлять host path и container path, иначе
  IDE не понимает, где выполняемый файл живёт внутри runtime.
- **Workdir** — каталог, из которого стартует команда внутри контейнера. Должен
  быть корнем проекта (`/var/www/html`), иначе Composer не найдёт
  `composer.json`, а PHPUnit — `phpunit.xml`.

## Проверка
```
docker compose exec app pwd                    # -> /var/www/html
docker compose exec app ls -la composer.json   # -> файл на месте
docker compose exec app which php              # -> /usr/local/bin/php
```

## Failure map
- **Wrong service** — IDE выбрала `nginx`, хотя PHP в `app`.
- **Wrong workdir** — команда стартует из `/`, а не из `/var/www/html`.
- **Missing vendor** — зависимости не установлены в filesystem контейнера.
- **Missing composer.json** — проверь workdir, а не переустанавливай Composer.
- **Path mismatch** — IDE мапит на `/app/...`, а контейнер использует `/var/www/html/...`.
