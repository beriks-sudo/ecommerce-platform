Risk matrix команд очистки

| Команда | Что затрагивает | Риск | Что проверить до запуска | Разрешена как default? |
  |---------|-----------------|------|--------------------------|------------------------|
| docker builder prune | build cache | низкий (медленнее следующая сборка) | нужен ли кэш для скорости | осторожно |
| docker image prune | dangling (висячие) образы | низкий–средний | нет ли нужных безымянных образов | осторожно | 
| docker container prune | все stopped контейнеры | потеря логов падения | docker compose ps -a, нужны ли логи | осторожно |
| docker volume prune | неиспользуемые volumes | DATA LOSS | docker volume ls, есть ли там данные | нет | 
| docker system prune -a | всё неиспользуемое + ВСЕ образы | долгий ребилд/перекачка | docker image ls, скорость восстановления | нет |
| docker system prune -a --volumes | то же + volumes | DATA LOSS | docker volume ls, backup базы | нет |
| docker compose down -v | контейнеры + сети + volumes проекта | DATA LOSS (база) | есть ли данные в mysql_data, backup | нет |

Для volume prune, system prune -a --volumes и compose down -v риск — потеря
данных, и как default они запрещены. Обычный image prune трогает только dangling
образы, а prune -a удаляет все образы, не используемые running-контейнерами.