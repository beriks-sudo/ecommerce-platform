# Когда уместен docker compose exec SERVICE sh

exec заходит внутрь ЖИВОГО контейнера, чтобы проверить конкретную гипотезу.
Используем после logs, а не вместо них.

## Уместные случаи
- Проверить environment variables:
  docker compose exec app sh -c 'env | grep DB_HOST'
- Проверить path / bind mount:
  docker compose exec app sh -c 'ls -la /var/www/html'
- Проверить версию runtime внутри контейнера:
  docker compose exec app php -v
- Проверить network name resolution до соседнего сервиса:
  docker compose exec app getent hosts mysql

## Когда НЕ использовать
- Контейнер stopped — внутри нет живого процесса, exec не подключится.
  Тогда смотрим: docker compose ps -a, docker logs <container>, docker inspect.
- exec не заменяет logs. Сначала читаем stdout/stderr, потом, при гипотезе, заходим.
- Не чиним руками внутри: правка исчезнет при recreate. Меняем файлы проекта.

