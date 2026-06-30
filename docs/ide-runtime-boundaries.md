# Границы runtime: host / Docker / ещё не настроено

| Слой | Что сюда входит | Статус |
|------|-----------------|--------|
| Host side | PhpStorm UI, файлы проекта, Git, терминал | есть |
| Docker side | Docker Engine, images, containers, Compose services (app, web, mysql, redis, traefik) | есть, подключено |
| Not configured yet | remote PHP interpreter, Composer через container PHP, тесты, Xdebug | НЕ настроено |

Docker connection открывает только доступ к Engine. Чтобы PHP-команды (Composer,
тесты) шли внутри контейнера, нужно отдельно выбрать remote PHP interpreter
в сервисе `app`. Это ещё не сделано.
