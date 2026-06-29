Healthcheck design

## app
Probe: curl -fsS http://localhost:8000/ || exit 1
- expected success: PHP-сервер (php -S :8000) отвечает 200 → curl возвращает 0 → healthy.
- expected failure: сервер ещё не поднялся / не отвечает → curl возвращает ненулевой код → неудача.

## mysql
Probe: mysqladmin ping -h localhost
- success: база отвечает на ping → exit 0.
- failure: база ещё поднимается → ненулевой код.

## Почему важен exit code
Docker смотрит ТОЛЬКО на код возврата probe: 0 = healthy, ненулевой копится
(retries) и переводит контейнер в unhealthy. Текст вывода Docker не парсит.
Поэтому probe должен возвращать 0 строго тогда, когда сервис реально готов.