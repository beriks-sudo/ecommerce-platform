Безопасное обслуживание Docker

Обслуживание начинается со списка, а не с удаления — как чтение логов перед restart.

## Порядок
1. inventory — посмотреть, что занимает место
   make cleanup-inventory
2. classify object — это пересобираемое (image, build cache) или данные (volume)?
3. check risk — что именно удалит команда, можно ли потерять данные/логи
4. backup/export if data — если в объекте данные (volume базы), сначала backup
5. choose narrow command — удалить конкретное, а не «всё лишнее» наугад
6. record result — записать, что и почему удалено

## Правило
docker system prune -a, docker volume prune и docker compose down -v —
потенциально разрушительные действия, а не рутинная уборка. Их не делают
дефолтом и не прячут в make check / make doctor