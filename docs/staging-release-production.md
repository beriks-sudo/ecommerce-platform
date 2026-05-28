“Одна из самых дорогих путаниц в корпоративном Git - смешивать branch и environment. Branch - это линия истории в Git. Environment - это место, где приложение запущено. Они могут называться похожими словами, но отвечают за разные слои системы. release/1.8.0 может быть Git branch, который указывает на commit abc123. Staging environment может запускать artifact, собранный из abc123. Production environment может запускать другой artifact, собранный из tag v1.7.9. Git хранит commits и refs. Environment запускает код вместе с config, variables, secrets, database state и внешними сервисами”

develop
-> staging candidate
-> staging environment
-> release/1.8.0
-> main
-> tag v1.8.0
-> production artifact

Smoke checks отвечают на вопрос "приложение вообще живо?". QA scenarios проверяют критичные пользовательские потоки. Acceptance notes помогают product owner или release owner понять, что именно смотрели. В будущем Laravel проекте сюда добавятся migrations, seed data, queues, cache, frontend build и routes. Сейчас важно не знать все эти инструменты заранее, а привыкнуть к traceability.

Неправильное использование staging встречается часто. Туда деплоят все подряд, не записывая version. QA проверяет одну сборку, а production получает другую. Баг чинят руками на сервере, не создавая commit. Зеленый CI принимают за ручную acceptance, хотя CI не проверял продуктовый сценарий. Staging secrets хранят так же свободно, как локальные dev variables. Все это разрушает доверие к pre-production проверке.

Staging тоже имеет цену. Его нужно поддерживать, обновлять данные, защищать доступы, чинить flaky checks и очищать после экспериментов. Если команда не готова владеть staging, отдельная среда становится дорогой витриной. Но когда rollback дорогой, QA обязателен, релизы идут окнами или продукт зависит от внешних интеграций, staging может предотвратить гораздо более дорогой production incident.

Связь с make здесь простая. Локальный make check не говорит "release готов". Он снижает шум до публикации. Staging checks отвечают за другой вопрос: конкретный candidate работает в pre-production условиях и готов идти дальше по release process или нет.

release/1.8.0: release-blocking fixes, version bump, release notes и небольшие documentation updates, новые features туда не добавляют.


Production лучше связывать с tag или immutable artifact, построенным из tagged commit:
Под капотом release/1.8.0 является branch ref, а v1.8.0 является tag ref. Branch может двигаться во время stabilization: сегодня он указывает на R, завтра на F1, послезавтра на F2. Tag должен фиксировать конкретный release commit. Поэтому фраза "production на latest main" слабая. Branch двигается, а release должен быть повторяемым фактом.
tag: v1.8.0
commit: f2a9c10
artifact: app:v1.8.0
environment: production
release notes: v1.8.0
rollback target: v1.7.9
Такая запись помогает расследовать incident, писать release notes, выполнять rollback и отвечать пользователю или бизнесу конкретно. Без tag или точного SHA команда начинает гадать: "кажется, выпускали после того merge", "вроде это был latest main", "на staging было почти то же самое".