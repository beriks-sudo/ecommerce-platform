Заметка о backup volume

Volume: ecommerce-platform_mysql_data

Какие данные могут там жить:
данные MySQL (база ecommerce): таблицы, индексы, миграции, тестовые данные.
Сейчас занимает ~227 MB.

Как проверить имя:
docker volume ls | grep mysql_data
docker system df -v   (покажет размер volume)

Идея backup/export:
- логический дамп базы:
  docker compose exec mysql sh -c 'mysqldump -u root -p"$MYSQL_ROOT_PASSWORD" ecommerce' > backup.sql
- или архив самого volume:
  docker run --rm -v ecommerce-platform_mysql_data:/data -v "$PWD":/backup alpine \
  tar czf /backup/mysql_data.tgz -C /data .

Когда удаление допустимо:
только когда осознанно нужен чистый старт базы И есть свежий backup
(или данные точно не нужны). Не как способ «остановить проект».

План восстановления:
- из дампа: поднять стек (docker compose up -d), затем
  docker compose exec -T mysql sh -c 'mysql -u root -p"$MYSQL_ROOT_PASSWORD" ecommerce' < backup.sql
- из архива: создать volume и распаковать tgz обратно в /data.