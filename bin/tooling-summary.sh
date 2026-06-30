#!/usr/bin/env bash
set -euo pipefail

# Сводка PHP-tooling контейнерного runtime.
# Только наблюдение: read-only команды, без install/migrate/seed и прочих
# скрытых изменений состояния.

SERVICE="app"
WORKDIR="/var/www/html"

echo "PHP interpreter service: ${SERVICE}"
echo "Expected container workdir: ${WORKDIR}"
echo

echo "== php -v (container runtime) =="
docker compose exec -T "${SERVICE}" php -v

echo
echo "== pwd (container workdir) =="
docker compose exec -T "${SERVICE}" pwd

echo
echo "== composer (read-only) =="
docker compose exec -T "${SERVICE}" composer --version \
  || echo "composer не установлен в контейнере '${SERVICE}' (см. docs/composer-through-container.md)"
