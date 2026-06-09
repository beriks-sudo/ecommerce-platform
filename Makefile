.DEFAULT_GOAL := help
IMAGE_NAME := ecommerce-php
IMAGE_TAG := dev
IMAGE := $(IMAGE_NAME):$(IMAGE_TAG)
BUILD_MODE ?= local

.PHONY: health help status log diff check history docker-version docker-info docker-hello docker-ps docker-nginx-lifecycle docker-inspect-playbook build build-builder run image-shell build-plain context-check config-check up down ps logs compose-config check

help:
	@echo "make help    Show available commands"
	@echo "make status  Show short repository status"
	@echo "make log     Show recent history"
	@echo "make diff    Show whitespace errors and diff summary"
	@echo "make check   Run safe Docker runtime checks"
	@echo "Available targets:"
	@echo "  make docker-version  - show Docker client/server versions"
	@echo "  make docker-info     - show Docker daemon runtime info"
	@echo "  make docker-hello    - run hello-world smoke container"
	@echo "  make docker-ps       - list containers, including exited"
	@echo "  make docker-inspect-playbook - run safe Docker inspection playbook"
	@echo "  make build           - build runtime image ecommerce-php:dev"
	@echo "  make build-builder   - build only the builder stage"
	@echo "  make run             - run app on http://localhost:8000"
	@echo "  make image-shell     - open shell inside image (diagnostics)"
	@echo "  make build-plain     - build with detailed --progress=plain log"
	@echo "  make context-check   - check build prerequisites before docker build"
	@echo "  make config-check    - check runtime env vars (no secrets printed)"
	@echo "  make check           - run safe Docker runtime checks"

status:
	git status --short

log:
	git log --oneline --decorate -5

diff:
	git diff --check
	git diff --stat

history:
	git log --oneline --decorate -5

docker-version:
	docker version

docker-info:
	docker info

docker-hello:
	docker run --rm hello-world

docker-ps:
	docker ps -a

docker-nginx-lifecycle:
	./bin/nginx-lifecycle.sh

docker-inspect-playbook:
	./bin/container-inspection-playbook.sh

build:
	docker build --build-arg BUILD_MODE=$(BUILD_MODE) --target runtime -t $(IMAGE) -f docker/php/Dockerfile .

build-builder:
	docker build --target builder -t $(IMAGE_NAME):builder -f docker/php/Dockerfile .

run:
	docker run --rm -p 8000:8000 $(IMAGE)

image-shell:
	docker run --rm -it $(IMAGE) sh

build-plain:
	docker build --progress=plain --target runtime -t $(IMAGE) -f docker/php/Dockerfile .

context-check:
	@test -f docker/php/Dockerfile
	@test -f composer.json
	@test -f .dockerignore
	@echo "Context root looks ready for docker build"

config-check:
	APP_ENV=local DB_HOST=mysql DB_PASSWORD=secret bash bin/config-diagnostics.sh

check: context-check build compose-config compose-config health
	docker run --rm $(IMAGE) php -v
	$(MAKE) config-check

.DEFAULT:
	@echo "Unknown target '$@'. Available targets:"
	@$(MAKE) --no-print-directory help
	@exit 1

up:
	docker compose up -d

down:
	docker compose down

ps:
	docker compose ps

logs:
	docker compose logs --tail=100

compose-config:
	./bin/compose-config-check.sh

health:
	./bin/check-health.sh