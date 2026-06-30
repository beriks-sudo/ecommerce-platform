PhpStorm Docker connection

## Модель
PhpStorm — это Docker client, а не отдельный runtime. Контейнеры создаёт и
останавливает Docker Engine (daemon). IDE обращается к Engine как клиент —
так же, как `docker` CLI из терминала. Одна реальность видна из двух мест:
терминал (`docker compose ps`) и Services tool window в IDE.

## Какой Docker context ожидается локально
Активный context на этой машине — desktop-linux (Docker Desktop):

      docker context ls
      NAME              DOCKER ENDPOINT
      default           unix:///var/run/docker.sock
      desktop-linux *   unix:///Users/berik/.docker/run/docker.sock

IDE должна использовать тот же Engine, что и терминал, — desktop-linux.

## Socket / context указывают IDE, куда обращаться
context — это сохранённый адрес Docker API (Unix socket демона). Если IDE
настроена на другой context (например default), чем активный в терминале
(desktop-linux), она достучится до другого socket и покажет другую/пустую
картину, хотя проект исправен.

## Local проще remote
Local connection: Engine на этой машине (Docker Desktop на macOS). PhpStorm на
host, файлы проекта на локальном диске, контейнеры запускает локальный Engine.
Remote добавляет сеть, безопасность Docker API, маппинг путей host↔remote —
для старта не нужен. Docker API даёт сильные полномочия, наружу не публикуем.

## Test Connection
Проверяет только одно: IDE достучалась до Docker Engine по выбранной настройке.
Он НЕ подтверждает PHP interpreter, Composer, тесты или Xdebug — это следующие
слои, настраиваются отдельно.