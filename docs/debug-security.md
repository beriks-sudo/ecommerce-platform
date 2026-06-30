# Debug security: почему Xdebug не production default

Xdebug — инструмент локальной разработки. Включать его по умолчанию в production
нельзя сразу по нескольким причинам.

## Раскрытие внутреннего состояния
Xdebug отдаёт через debug-протокол внутреннее состояние приложения: значения
переменных, содержимое стека вызовов, контекст выполнения. В production это
утечка чувствительной информации.

## Performance overhead
Step debugging замедляет выполнение, особенно при `start_with_request=yes`, когда
Xdebug пытается стартовать сессию на каждом запросе. На проде это лишняя нагрузка.

## Лишняя сетевая поверхность
Xdebug открывает исходящие соединения на debug-порт (9003) к адресу `client_host`.
В production это дополнительный сетевой вектор и риск, которого быть не должно.

## Привязка к laptop разработчика
`xdebug.client_host` указывает на конкретную машину разработчика
(`host.docker.internal` = его host). В production это бессмысленно и хрупко.

## Как проект отделяет local debug от production
- Конфигурация Xdebug (`docker/php/conf.d/xdebug.ini`) — **local-only** и не
  входит в production runtime по умолчанию.
- Расширение Xdebug ставится только в local-сборке образа, не в production.
- Debug включается осознанно (`start_with_request=trigger` + path mappings),
  документируется и не является дефолтом среды.
