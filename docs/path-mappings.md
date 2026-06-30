# Path mappings (Xdebug)

PhpStorm открывает файлы на host, контейнер выполняет те же файлы по своему пути
(bind mount `./:/var/www/html`). Xdebug сообщает IDE путь в координатах
контейнера, поэтому без сопоставления breakpoint не сработает.

```
Host project path:       /Users/berik/Developer/education/ecommerce-platform
Container project path:  /var/www/html
Example container file:  /var/www/html/public/index.php
Example host file:       /Users/berik/Developer/education/ecommerce-platform/public/index.php
```

## Что это значит
- Path mapping в PhpStorm должен сопоставлять host project path и
  `/var/www/html`. Тогда breakpoint в host-файле IDE правильно соотносит со
  строкой, которую выполняет контейнер.
- Если mapping неверный (например IDE мапит на `/app/...`, а контейнер реально
  использует `/var/www/html/...`), debug-сессия может подключиться, но breakpoint
  будет «серым» / не сработает.

## Проверка
```
docker compose exec app pwd                         # -> /var/www/html
docker compose exec app ls -la public/index.php     # реальный файл проекта
```
