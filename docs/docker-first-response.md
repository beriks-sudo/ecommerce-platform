reproduce -> ps -> logs -> config -> exec with hypothesis -> inspect -> change source of truth -> recreate service
1. reproduce — воспроизвести проблему
   docker compose up -d app
2. ps — посмотреть состояние
   docker compose ps
3. logs — прочитать stdout/stderr
   docker compose logs --tail=100 app
4. config — проверить итоговый конфиг
   docker compose config
5. exec with hypothesis — зайти внутрь с конкретной гипотезой (только если жив)
   docker compose exec app sh
6. inspect — низкоуровневые детали
   docker inspect <container>
7. change source of truth — поправить файл проекта (compose / .env.example / код)
8. recreate service — пересоздать
   docker compose up -d --build app