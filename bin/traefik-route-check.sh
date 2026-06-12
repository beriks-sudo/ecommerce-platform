#!/usr/bin/env bash
set -euo pipefail

for url in \
  http://ecommerce.localho.st \
  http://admin.ecommerce.localho.st \
  http://api.ecommerce.localho.st \
  http://traefik.ecommerce.localho.st/dashboard/
do
  echo "Checking $url"
  if ! curl -fsSI "$url" | head -n 1; then
    host="${url#http://}"
    host="${host%%/*}"
    echo "Direct loopback fallback for $host"
    curl -fsSI -H "Host: $host" http://127.0.0.1 | head -n 1
  fi
done


