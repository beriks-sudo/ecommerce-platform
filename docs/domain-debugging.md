# Domain debugging ladder

Доменный маршрут состоит из нескольких слоёв. Диагностика идёт по лестнице
**снизу вверх** — а не по догадкам «сертификат сломан». Сначала проверяем нижнюю
ступень, и только когда она в порядке, поднимаемся выше.

1. **DNS** — имя ведёт на локальную машину (`127.0.0.1`)?
   `dig +short admin.ecommerce.localho.st` (или `nslookup`).
   Если имя не резолвится — Traefik ещё даже не участвует, проблема в DNS.

2. **Connect** — Traefik слушает порты `80`/`443` на хосте?
   `curl -I http://admin.ecommerce.localho.st`.
   `connection refused` → Traefik не запущен или порт занят.

3. **Route** — правило `Host(...)` совпало с роутером?
   `404` от Traefik → запрос дошёл, но ни один роутер не сматчил host/entrypoint.

4. **Service** — Traefik дошёл до контейнера и его внутреннего порта?
   `502` → проблема в Docker-сети или неправильный internal port сервиса.

5. **TLS trust** — клиент доверяет сертификату?
   `curl -kI https://...` отвечает, а `curl -I https://...` падает → дело
   в доверии (self-signed), а не в маршруте. Это самый верхний слой, поэтому
   проверяется последним: пока не сложился рабочий HTTPS-маршрут, спрашивать
   про доверие к сертификату бессмысленно.

## Полезные команды

```bash
dig +short admin.ecommerce.localho.st
curl -I  http://admin.ecommerce.localho.st     # connect + redirect
curl -kI https://admin.ecommerce.localho.st    # HTTPS-ответ, игнор trust
docker compose ps
docker compose logs traefik
docker compose config
openssl s_client -connect admin.ecommerce.localho.st:443 \
  -servername admin.ecommerce.localho.st
```

> Не лечить проблему через `docker compose down -v` или `prune`. Удаление
> volumes не починит несовпавший `Host(...)`, очистка images не сделает
> сертификат доверенным. Сначала найти ступень, где рвётся цепочка, — потом
> менять конфиг.
