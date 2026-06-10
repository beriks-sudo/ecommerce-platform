#!/usr/bin/env bash

echo "=== compose config ==="
docker compose config

echo "=== compose ps ==="
docker compose ps

echo "=== HTTP с host ==="
curl -i "http://localhost:${APP_PORT:-8080}" || echo "нет HTTP-ответа (app не запущен или не готов)"

echo "=== DNS внутри app ==="
docker compose exec -T app getent hosts mysql || echo "getent нет или mysql не найден"
docker compose exec -T app getent hosts redis || echo "getent нет или redis не найден"

echo "=== TCP внутри app ==="
docker compose exec -T app nc -zv mysql 3306 || echo "nc нет или порт закрыт"
