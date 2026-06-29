#!/usr/bin/env bash
set -euo pipefail

# Доказывает валидность compose-файла реальной командой docker compose config.
# Используется в `make compose-config` и `make check`.

echo "==> docker compose config -q"
docker compose config -q
echo "✅ compose config валиден (exit 0): ошибок и предупреждений нет"
