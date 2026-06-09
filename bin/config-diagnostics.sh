#!/usr/bin/env bash
set -euo pipefail

image="${IMAGE:-ecommerce-php:dev}"

docker run --rm \
  -e APP_ENV="${APP_ENV:-local}" \
  -e DB_HOST="${DB_HOST:-mysql}" \
  -e DB_PASSWORD="${DB_PASSWORD:-}" \
  "$image" \
  sh -lc '
    echo "APP_ENV=${APP_ENV:-missing}"
    echo "DB_HOST=${DB_HOST:-missing}"
    if [ -n "${DB_PASSWORD:-}" ]; then
      echo "DB_PASSWORD is set"
    else
      echo "DB_PASSWORD is missing"
      exit 2
    fi
  '
