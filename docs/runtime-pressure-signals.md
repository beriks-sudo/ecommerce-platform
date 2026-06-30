Сигналы давления на runtime

Разные сигналы — разные слои. Для каждого есть команда проверки.

- OOM (нехватка памяти, процесс убит):
  docker inspect <container> --format '{{.State.OOMKilled}} {{.State.ExitCode}}'
- Высокий CPU (медленные ответы, долгие сборки):
  docker stats --no-stream   (смотреть колонку CPU %)
- Slow I/O (зависающие install/build, медленная база, рывки логов):
  docker stats --no-stream   (большой BLOCK I/O)
- Slow response (app долго отвечает):
  docker compose logs --tail=80 app + docker stats
- High memory growth (память растёт со временем — возможна утечка):
  docker stats --no-stream   (MEM USAGE растёт от запуска к запуску)
- Пустой вывод stats при не поднятом стеке:
  docker compose ps          (контейнеры не запущены — это не ошибка stats)

docker stats показывает слой runtime и подсказывает направление, но не профайлер:
какой PHP-метод или SQL виноват — выясняется в следующем слое.