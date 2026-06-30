# Xdebug workflow (local-only)

## Debugging vs logs
Logs — это следы постфактум: приложение пишет в stdout/файл, что произошло, и ты
читаешь их после выполнения. Step debugging через Xdebug **останавливает код в
момент выполнения** на breakpoint: видно живое состояние — переменные, стек
вызовов, можно шагать построчно. Logs отвечают «что происходило», debugger —
«что именно сейчас в этой строке».

## Модель: кто где живёт
- **Xdebug** — это PHP-расширение, живёт **внутри container PHP** (сервис `app`,
  тот же runtime, где работает приложение).
- **PhpStorm** — listener **на host**: слушает входящие debug-соединения.
- **Соединение исходящее: Xdebug (контейнер) → PhpStorm (host).** PhpStorm не
  «заходит» в контейнер — наоборот, контейнер сам открывает соединение к IDE.

## Порт
Порт по умолчанию для **Xdebug 3 — 9003** (в старом Xdebug 2 был 9000).
`xdebug.client_port` в контейнере и listener port в PhpStorm должны совпадать.

## Ожидаемая local-only конфигурация
См. `docker/php/conf.d/xdebug.ini`:

```ini
xdebug.mode=debug
xdebug.start_with_request=trigger
xdebug.client_host=host.docker.internal
xdebug.client_port=9003
```

`host.docker.internal` — адрес host-машины из контейнера (Docker Desktop).
`start_with_request=trigger` — debug стартует по сигналу, а не на каждый запрос.

## Текущий статус (blocker, описан фактами)
На момент написания **Xdebug в контейнере `app` не установлен**:

```
docker compose exec app php -m | grep -i xdebug
-> (пусто)
```

Это допустимый статус: я не выдумываю успешную настройку. Dockerfile ради
blind install не ломаю. Чтобы активировать отладку позже, нужно:
1. установить Xdebug в образе (`pecl install xdebug` + `docker-php-ext-enable xdebug`
   в `docker/php/Dockerfile`, только для local-сборки);
2. смонтировать/включить `docker/php/conf.d/xdebug.ini` в local-окружении;
3. настроить path mappings и listener в PhpStorm (см. docs/path-mappings.md,
   docs/debug-troubleshooting.md).

Конфигурация и troubleshooting описаны заранее как контракт.
