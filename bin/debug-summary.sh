#!/usr/bin/env bash
set -euo pipefail

# Сводка runtime/debug контейнерного PHP.
# Только наблюдение: read-only команды, без изменения состояния среды.

SERVICE="app"

echo "PHP debug summary (service: ${SERVICE})"
echo

echo "== php -v =="
docker compose exec -T "${SERVICE}" php -v

echo
echo "== php -m (модули) =="
docker compose exec -T "${SERVICE}" php -m

echo
echo "== Xdebug settings (php -i) =="
docker compose exec -T "${SERVICE}" php -i | grep -i xdebug || echo "Xdebug не загружен в контейнере (см. docs/xdebug-workflow.md)"
