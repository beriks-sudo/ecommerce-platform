#!/usr/bin/env bash
set -euo pipefail

docker compose exec app sh -lc '
  id
  for dir in storage bootstrap/cache; do
    echo "Checking $dir"
    test -d "$dir"
    test -w "$dir"
    tmp="$dir/.write-test-$$"
    touch "$tmp"
    rm "$tmp"
  done
'