#!/usr/bin/env bash
set -euo pipefail

NAME="lesson02-nginx"
HOST_PORT="${HOST_PORT:-8081}"

echo "Pull image"
docker pull nginx:alpine

echo "Remove leftover lesson container if it exists"
docker rm -f "$NAME" >/dev/null 2>&1 || true

cleanup() {
  docker rm -f "$NAME" >/dev/null 2>&1 || true
}
trap cleanup EXIT

echo "Run nginx container on host port ${HOST_PORT}"
docker run -d --name "$NAME" -p "${HOST_PORT}:80" nginx:alpine

echo "Observe running container"
docker ps --filter "name=$NAME"

echo "Read recent logs"
docker logs "$NAME" --tail 20

echo "Stop container"
docker stop "$NAME"

echo "Observe stopped container"
docker ps -a --filter "name=$NAME"

echo "Remove stopped container"
docker rm "$NAME"
trap - EXIT