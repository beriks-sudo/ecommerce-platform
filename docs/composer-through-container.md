# Composer через container PHP

## Composer проверяет не только пакеты, но и платформу
Composer — это не «просто пакетный менеджер». Кроме скачивания зависимостей он
проверяет **platform requirements**: версию PHP и нужные extensions (а иногда
constraints, зависящие от runtime). Команда `composer check-platform-reqs`
показывает, совпадают ли требования с текущим PHP.

## Почему local PHP и container PHP дают разный результат
`composer install` через host PHP и через container PHP могут вести себя
по-разному, потому что у них разные version/extensions/ini. Пример: пакет требует
`ext-intl`. Если в одном runtime оно есть, а в другом нет — один Composer честно
остановится на missing extension, другой пропустит проблему, которая позже
вылезет в реальной среде. Поэтому `vendor`, собранный под host PHP, может не
соответствовать платформе приложения.

## Правильная команда для проекта
Composer должен запускаться через тот же PHP, в котором живёт приложение —
сервис `app`:

```
docker compose exec app composer install
```

## Текущий статус (blocker, описан фактами)
На момент написания **Composer не установлен внутри контейнера `app`**:

```
docker compose exec app composer --version
-> executable file not found in $PATH
```

Это осознанное инженерное решение, которое нужно зафиксировать, а не обходить
запуском Composer на host. Варианты на будущее: добавить Composer в образ
(`COPY --from=composer ...` или phar), либо использовать отдельный Composer
image. Решение должно быть записано, чтобы вся команда запускала Composer
одинаково — в container runtime, а не кто-то на host, кто-то через IDE.

## Почему missing vendor — диагностический сигнал
Сейчас `vendor` отсутствует:

```
docker compose exec app test -d vendor && echo exists || echo missing
-> missing
```

Это не повод менять interpreter наугад. Missing `vendor` означает, что Composer
ещё не отрабатывал install в том filesystem, который видит контейнер (здесь —
ещё и потому, что Composer в контейнере не установлен). Сначала разбираемся с
runtime (где Composer, куда смонтирован проект), а не переустанавливаем
инструменты вслепую.
