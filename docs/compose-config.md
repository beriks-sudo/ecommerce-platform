# docker compose config — статус

Конфигурация проекта валидна. Канонический compose-файл — `compose.yaml`
(Compose Spec, без устаревшего ключа `version`). Все переменные имеют значения
по умолчанию (`${VAR:-default}`), поэтому `docker compose config` проходит даже
без локального `.env`.

## Проверка

```bash
$ docker compose config -q ; echo "exit=$?"
exit=0
```

`docker compose config` завершается с кодом 0 без ошибок и предупреждений, в том
числе на чистом клоне ветки. Blocker'ов нет.

## Если запускать по явному имени файла

```bash
docker compose -f compose.yaml config -q   # exit 0
```
