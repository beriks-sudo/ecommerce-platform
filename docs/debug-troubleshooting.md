# Debug troubleshooting (по слоям)

Отладка — это договор из нескольких слоёв. Проверяем **сверху вниз, один слой за
раз**, а не меняем все настройки сразу (иначе непонятно, что помогло).

1. **PHP service выбран правильно** — debug идёт через сервис `app` (где PHP),
   а не `nginx`/другой сервис без PHP.
   `docker compose exec app php -v`
2. **Xdebug loaded в container PHP** — расширение реально загружено.
   `docker compose exec app php -m | grep -i xdebug`
3. **xdebug.mode содержит debug** — иначе step debugging выключен.
   `docker compose exec app php -i | grep -i xdebug.mode`
4. **xdebug.client_host достижим из контейнера** — на Docker Desktop это
   `host.docker.internal`; на Linux нужен `extra_hosts: host.docker.internal:host-gateway`
   или адрес gateway. Изнутри контейнера `localhost` — это сам контейнер.
5. **xdebug.client_port совпадает с listener в PhpStorm** — обычно `9003`
   (Xdebug 3). В контейнере и в IDE порт должен быть один.
6. **Firewall не блокирует входящее соединение** — listener PhpStorm на host
   должен принимать соединение от контейнера.
7. **Trigger действительно отправлен** — при `start_with_request=trigger` нужен
   сигнал (`XDEBUG_TRIGGER`, cookie или кнопка/расширение браузера).
8. **Path mappings совпадают** — container path `/var/www/html` сопоставлен с
   host project path (см. docs/path-mappings.md). Частая причина «молчащего»
   breakpoint даже при успешном соединении.

## Текущий статус
Сейчас цепочка обрывается на шаге 2: Xdebug в контейнере не установлен
(см. docs/xdebug-workflow.md). Остальные слои описаны как контракт на будущее.
