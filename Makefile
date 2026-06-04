.DEFAULT_GOAL := help
IMAGE_NAME := ecommerce-php
IMAGE_TAG := dev
IMAGE := $(IMAGE_NAME):$(IMAGE_TAG)
.PHONY: docker-nginx-lifecycle docker-inspect-playbook help status log diff check help docker-version docker-info docker-hello docker-ps check build run image-shell


help:
	@echo "make help    Show available commands"
	@echo "make status  Show short repository status"
	@echo "make log     Show recent history"
	@echo "make diff    Show whitespace errors and diff summary"
	@echo "make check   Run basic Git checks"
	@echo "Available targets:"
	@echo "  make docker-version  - show Docker client/server versions"
	@echo "  make docker-info     - show Docker daemon runtime info"
	@echo "  make docker-hello    - run hello-world smoke container"
	@echo "  make docker-ps       - list containers, including exited"
	@echo "  make check           - run safe Docker runtime checks"
	@echo "  make docker-inspect-playbook - run safe Docker inspection playbook"


status:
	git status --short

log:
	git log --oneline --decorate -5

diff:
	git diff --check
	git diff --stat

check:
	@$(MAKE) docker-version docker-hello
	git status --short
	git diff --check

.DEFAULT:
	@echo "Unknown target '$@'. Available targets:"
	@$(MAKE) --no-print-directory help
	@exit 1
	@$(MAKE) help
	@echo ""
	@echo "Unknown target: $@"
	@exit 2

history:
	git log --oneline --decorate -5


.DEFAULT_GOAL := help




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
	docker build -t $(IMAGE) -f docker/php/Dockerfile .

run:
	docker run --rm -p 8000:8000 $(IMAGE)

image-shell:
	docker run --rm -it $(IMAGE) sh