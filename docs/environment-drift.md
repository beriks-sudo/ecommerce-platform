# Environment drift: два реальных риска

## Риск 1 — IDE и terminal в разных Docker context
На этой машине есть два context (фактический список выводит
`docker context ls`, его же печатает `bin/phpstorm-runtime-notes.sh`):

```
default          -> unix:///var/run/docker.sock
desktop-linux *  -> unix:///Users/berik/.docker/run/docker.sock   (активный)
```

Если PhpStorm подключится к `default`, а терминал работает в `desktop-linux`
(или наоборот), они будут смотреть на разные socket и могут показывать разные
контейнеры. Тогда кажется, что «проект пропал», хотя сломан только путь IDE
к Engine. Проверка: `docker context ls`, `docker version`, `docker info`.

## Риск 2 — IDE запускает PHP через host PHP, а приложение в container PHP
Приложение работает в сервисе `app` (образ `php:8.5-alpine`, с установленным
`pdo_mysql`). На host стоит отдельный Homebrew PHP — проверяется командами
`which php` и `php -v`:

```
which php  -> /opt/homebrew/bin/php
php -v     -> PHP 8.5.6 (cli)   # другой php.ini, другой набор расширений
```

Если в PhpStorm не выбрать remote PHP interpreter внутри контейнера, Composer
и тесты пойдут через host PHP. Тогда «зелёный» результат в IDE перестаёт
совпадать с поведением в контейнере (другие расширения/ini/пути). Это
environment drift. Лечится выбором container PHP как interpreter (следующий урок).
