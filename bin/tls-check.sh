#!/usr/bin/env bash
  set -euo pipefail

  echo "→ HTTP должен редиректить на HTTPS:"
  curl -I http://ecommerce.localho.st

  echo "→ HTTPS ответ (с -k, игнор trust):"
  curl -kI https://ecommerce.localho.st