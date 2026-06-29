# Healthcheck design

Каждый probe проверяет реальную готовность роли, а не просто существование
процесса. Docker решает по exit code команды.

## app
Probe: `curl -fsS http://localhost:8000/health.php || exit 1`
Endpoint `public/health.php` проверяет зависимости приложения: доступность по
сети MySQL (порт 3306) и Redis (порт 6379) через сокет. Сокет-проверка не зависит
от PHP-расширений (в образе нет `pdo_mysql`), но доказывает, что app реально
видит свои зависимости.
- expected success: app поднят И видит MySQL и Redis → health.php отдаёт 200 →
  curl возвращает 0 → healthy.
- expected failure: app ещё не готов или БД/Redis недоступны → health.php отдаёт
  503 → `curl -f` возвращает ненулевой код → неудача (копится retries).
Это «полезная» readiness: healthy означает, что app реально может выполнять роль,
а не просто что процесс существует и порт отвечает.

## mysql
Probe: `mysqladmin ping -h localhost`
- success: база отвечает на ping → exit 0 → healthy.
- failure: база ещё поднимается / не отвечает → ненулевой код.

## redis
Probe: `redis-cli ping`
- success: Redis отвечает `PONG` → exit 0 → healthy.
- failure: Redis ещё не готов → ненулевой код.

## Почему важен exit code
Docker смотрит ТОЛЬКО на код возврата probe: 0 = healthy, ненулевой копится
(retries) и переводит контейнер в unhealthy. Текст вывода Docker не парсит.
Поэтому probe должен возвращать 0 строго тогда, когда сервис реально готов.