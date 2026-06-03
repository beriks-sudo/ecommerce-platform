#!/usr/bin/env bash
set -euo pipefail

NAME="lesson03-inspect-nginx"
HOST_PORT="${HOST_PORT:-8081}"

cleanup() {
  docker rm -f "$NAME" >/dev/null 2>&1 || true
}

echo "Prepare clean temporary container name"
cleanup
trap cleanup EXIT

echo "Run temporary nginx container"
docker run -d --name "$NAME" -p "${HOST_PORT}:80" nginx:alpine

echo "Observe with ps"
docker ps --filter "name=$NAME"

echo "Read logs"
docker logs "$NAME" --tail 20

echo "Inspect selected facts"
docker inspect "$NAME" --format 'status={{.State.Status}} image={{.Config.Image}}'
docker inspect "$NAME" --format 'ports={{json .NetworkSettings.Ports}}'

echo "Exec only because container is running"
docker exec "$NAME" nginx -v

echo "Stop and remove temporary container"
docker stop "$NAME"
docker rm "$NAME"
trap - EXIT