Crash report

Команда:
docker compose up -d app

Где выполнялось:
repo root, branch feature/docker-first-response

Наблюдаемый статус:
app exited with code 1, mysql и redis running
(факт — из docker compose ps)

Релевантные logs:
docker compose logs --tail=80 app
последние строки: "could not find driver" / "DB connection refused"
(факт — из логов)

Вероятный слой:
application env — приложение не видит DB_HOST / нет нужного драйвера
(гипотеза, не подтверждена)

Следующий шаг:
проверить env внутри (docker compose exec app sh -c 'env | grep DB_'),
