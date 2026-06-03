# Docker runtime readiness

## Host and project location

Какая OS является host. macOS
Где лежит project path. /Documents/Education/ecommerce-platform
Если Windows/WSL2: лежит ли проект внутри Linux filesystem WSL.
Почему pwd и git status проверяются перед Docker-командами. чтобы проверить в какой папке мы находимся и какой статус и гита

## Runtime chain

Объясни цепочку terminal -> Docker CLI -> Docker daemon -> registry/local image cache -> container -> foreground process.

Главная идея: ты не заходишь на кухню

Когда ты пишешь docker run ..., происходит вот что:

ТЫ (terminal)
→ официант (Docker CLI)         — принял заказ, сам не готовит
→ кухня (Docker daemon)         — делает всю работу
→ склад (registry/Docker Hub)   — если продукта нет в холодильнике
→ блюдо готовится (container)
→ тебе приносят тарелку (вывод в terminal)

≈
Отдельно объясни, почему terminal не работает напрямую внутри container.
Ты сам на кухню не заходишь. Ты только сделал заказ и получил тарелку. Поэтому фраза «terminal зашёл в контейнер» —
неправильная. Terminal просто показал тебе результат.

## Readiness checks

Что доказывает make docker-version.
Client:
Version:           29.4.3
API version:       1.54
Go version:        go1.26.2
Git commit:        055a478
Built:             Wed May  6 17:06:34 2026
OS/Arch:           darwin/arm64
Context:           desktop-linux

Server: Docker Desktop 4.74.0 (227015)
Engine:
Version:          29.4.3
API version:      1.54 (minimum version 1.40)
Go version:       go1.26.2
Git commit:       56be731
Built:            Wed May  6 17:09:05 2026
OS/Arch:          linux/arm64
Experimental:     false
containerd:
Version:          v2.2.3
GitCommit:        77c84241c7cbdd9b4eca2591793e3d4f4317c590
runc:
Version:          1.3.5
GitCommit:        v1.3.5-0-g488fc13e
docker-init:
Version:          0.19.0
GitCommit:        de40ad0
Что доказывает make docker-info.
Client:
Version:    29.4.3
Context:    desktop-linux
Debug Mode: false
Plugins:
agent: Docker AI Agent Runner (Docker Inc.)
Version:  v1.57.0
Path:     /Users/berik/.docker/cli-plugins/docker-agent
ai: Docker AI Agent - Ask Gordon (Docker Inc.)
Version:  v1.20.2
Path:     /Users/berik/.docker/cli-plugins/docker-ai
buildx: Docker Buildx (Docker Inc.)
Version:  v0.33.0-desktop.1
Path:     /Users/berik/.docker/cli-plugins/docker-buildx
compose: Docker Compose (Docker Inc.)
Version:  v5.1.4
Path:     /Users/berik/.docker/cli-plugins/docker-compose
debug: Get a shell into any image or container (Docker Inc.)
Version:  0.0.47
Path:     /Users/berik/.docker/cli-plugins/docker-debug
desktop: Docker Desktop commands (Docker Inc.)
Version:  v0.3.0
Path:     /Users/berik/.docker/cli-plugins/docker-desktop
dhi: CLI for managing Docker Hardened Images (Docker Inc.)
Version:  v0.0.3
Path:     /Users/berik/.docker/cli-plugins/docker-dhi
extension: Manages Docker extensions (Docker Inc.)
Version:  v0.2.31
Path:     /Users/berik/.docker/cli-plugins/docker-extension
init: Creates Docker-related starter files for your project (Docker Inc.)
Version:  v1.4.0
Path:     /Users/berik/.docker/cli-plugins/docker-init
mcp: Docker MCP Plugin (Docker Inc.)
Version:  v0.42.1
Path:     /Users/berik/.docker/cli-plugins/docker-mcp
model: Docker Model Runner (Docker Inc.)
Version:  v1.1.37
Path:     /Users/berik/.docker/cli-plugins/docker-model
offload: Docker Offload (Docker Inc.)
Version:  v0.5.89
Path:     /Users/berik/.docker/cli-plugins/docker-offload
pass: Docker Pass Secrets Manager Plugin (beta) (Docker Inc.)
Version:  v0.0.27
Path:     /Users/berik/.docker/cli-plugins/docker-pass
sandbox: Docker Sandbox (Docker Inc.)
Version:  v0.12.0
Path:     /Users/berik/.docker/cli-plugins/docker-sandbox
sbom: View the packaged-based Software Bill Of Materials (SBOM) for an image (Anchore Inc.)
Version:  0.6.0
Path:     /Users/berik/.docker/cli-plugins/docker-sbom
scout: Docker Scout (Docker Inc.)
Version:  v1.21.0
Path:     /Users/berik/.docker/cli-plugins/docker-scout

Server:
Containers: 23
Running: 21
Paused: 0
Stopped: 2
Images: 18
Server Version: 29.4.3
Storage Driver: overlayfs
driver-type: io.containerd.snapshotter.v1
Logging Driver: json-file
Cgroup Driver: cgroupfs
Cgroup Version: 2
Plugins:
Volume: local
Network: bridge host ipvlan macvlan null overlay
Log: awslogs fluentd gcplogs gelf journald json-file local splunk syslog
CDI spec directories:
/etc/cdi
/var/run/cdi
Discovered Devices:
cdi: docker.com/gpu=webgpu
Swarm: inactive
Runtimes: io.containerd.runc.v2 runc
Default Runtime: runc
Init Binary: docker-init
containerd version: 77c84241c7cbdd9b4eca2591793e3d4f4317c590
runc version: v1.3.5-0-g488fc13e
init version: de40ad0
Security Options:
seccomp
Profile: builtin
cgroupns
Kernel Version: 6.12.76-linuxkit
Operating System: Docker Desktop
OSType: linux
Architecture: aarch64
CPUs: 10
Total Memory: 7.75GiB
Name: docker-desktop
ID: 5e42eed4-5a33-4246-852c-2356f3d81ef9
Docker Root Dir: /var/lib/docker
Debug Mode: false
HTTP Proxy: http.docker.internal:3128
HTTPS Proxy: http.docker.internal:3128
No Proxy: hubproxy.docker.internal
Labels:
com.docker.desktop.address=unix:///Users/berik/Library/Containers/com.docker.docker/Data/docker-cli.sock
Experimental: false
Insecure Registries:
hubproxy.docker.internal:5555
::1/128
127.0.0.0/8
Live Restore Enabled: false
Firewall Backend: iptables
Что доказывает make docker-hello.
docker run --rm hello-world

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
1. The Docker client contacted the Docker daemon.
2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
   (arm64v8)
3. The Docker daemon created a new container from that image which runs the
   executable that produces the output you are currently reading.
4. The Docker daemon streamed that output to the Docker client, which sent it
   to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
$ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
https://hub.docker.com/

For more examples and ideas, visit:
https://docs.docker.com/get-started/
Что показывает make docker-ps.
Почему make check остается safe check.
Запускает все функции для проверки багов и ошибок
## First-run notes

Если hello-world скачивался впервые, объясни строки pull/download/digest своими словами.
скачивает с сервера и ложит к нам локально, в последующем запускается уже у нас локально
Если image уже был локально, объясни роль local image cache.
уже не ищет на серверах, а просто запускает из локального образа

## Boundaries

Почему successful hello-world не доказывает работу будущего Laravel app.
это просто проверка базового докер контейнера и он не имеет отношения к нашему будущему app
Почему port mapping еще нужно будет проверять отдельно.
может быть порт уже занят
Почему не нужно запускать destructive cleanup как реакцию на непонятную ошибку.
требуется сначала разобраться со всем