 #!/usr/bin/env bash
  set -euo pipefail

  service="${1:-app}"

  docker compose ps
  docker compose logs --tail=100 "$service"