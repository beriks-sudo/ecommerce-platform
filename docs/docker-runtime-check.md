# Docker runtime check

## My OS and installation path

Какая OS используется: Linux, macOS или Windows/WSL2.
Что установлено: Docker Engine или Docker Desktop.
Если Windows: где лежит проект, в Linux filesystem WSL или в /mnt/c.
Если macOS/Windows в рабочей компании: проверена ли политика по Docker Desktop license.

## What the checks prove

Что доказывает docker version.
Что доказывает docker info.
Что доказывает docker run --rm hello-world.
Почему hello-world может завершиться и это нормально.
Что показывает docker ps -a.

## Make targets

Какие Docker targets добавлены в Makefile.
Почему make check не делает destructive cleanup.
Зачем объявлен .PHONY.
Что делает .DEFAULT для неизвестного target.

## First error map

Как ты отличаешь command not found, unavailable daemon, permission denied к Docker socket и network/registry problem.
Если у тебя была реальная ошибка установки, опиши ее в формате Command, Where, Error, Checked, Next step.