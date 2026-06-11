# Writable paths

Laravel должен иметь право писать в несколько папок. Для dev-контейнера особенно важны:

## storage
Сюда Laravel пишет logs, cache, sessions, compiled views и иногда uploads.
Если пользователь контейнера не может писать в storage — приложение падает с
ошибками вроде "permission denied" или "failed to open stream".

## bootstrap/cache
Здесь Laravel хранит сгенерированные файлы конфигурации, маршрутов и пакетов.
Если папка не writable — ошибка вида "Please provide a valid cache path".

## Как проверяем
Проверять запись нужно ИЗНУТРИ контейнера app (там реально пишет приложение),
а не только на host. Скрипт bin/check-writable-paths.sh делает это безопасно:
показывает id (UID/GID контейнера), проверяет, что папки существуют (test -d) и
доступны на запись (test -w), пробует создать и удалить временный файл.
Скрипт ничего не ломает: не делает chmod -R 777, chown -R, prune или down -v.

## Примечание про учебный проект
Проект учебный, без полноценного Laravel skeleton. Папки storage, bootstrap/cache
и public созданы вручную (.gitkeep / минимальный index.php), чтобы dev-контейнер
стартовал и проверку прав можно было выполнить.
