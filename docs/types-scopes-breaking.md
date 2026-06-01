Type должен описывать смысл изменения для продукта или engineering workflow. feat - новая возможность или новое observable behavior. fix - исправление неправильного behavior. docs - изменение документации без изменения runtime behavior. refactor - изменение структуры кода без изменения внешнего поведения. test - тесты. chore - обслуживание repository, tooling или housekeeping без продуктового behavior. Команда может добавить свои types, но каждый новый type должен иметь критерий, иначе словарь превращается в мусорную корзину.

Это домашка-документ (видимо docs/commit-convention.md). Пишу всё содержимое текстом — копируешь в файл.
Allowed types
feat — новая возможность или новое видимое поведение для пользователя/внешней системы.

Good: feat(catalog): add filtering by brand — понятна область и конкретная новая возможность.
Bad: feat: stuff — не сказано, что появилось; для changelog бесполезно.

fix — исправление неправильного поведения (observable behavior).

Good: fix(payment): round order total before capture — видно область, что чинят и в какой момент.
Bad: chore: fix payment rounding — это fix, а помечено как chore; важное денежное исправление выпадет из release notes и не найдётся при backport.

docs — изменение документации без изменения работы кода (runtime behavior).

Good: docs(release): describe rollback checklist — ясно, что меняется документация про release.
Bad: docs(api): remove required response field — опасно: если из contract убрали обязательное поле, это breaking change, а не просто docs.

refactor — изменение структуры кода без изменения внешнего поведения.

Good: refactor(cart): extract price calculation service — структура поменялась, поведение снаружи то же.
Bad: refactor(api): change response format — смена формата ответа меняет contract, это не refactor, а feat/breaking.

test — добавление или изменение тестов, без продуктового поведения.

Good: test(checkout): cover empty delivery address case — ясно, какой сценарий покрыли.
Bad: test: fix bug — тест не «чинит баг»; если исправлено поведение кода, это fix, а не test.

chore — обслуживание репозитория, тулинга, housekeeping, без продуктового поведения.

Good: chore(repo): ignore local coverage output — типичный housekeeping.
Bad: chore: important bug — если это важный баг, тип должен быть fix; chore спрячет его от release notes.

Общий принцип: type выбирается по impact изменения, а не по директории файла. И каждый новый type должен иметь чёткий критерий, иначе словарь превращается в мусорную корзину.
Allowed scopes (ecommerce repository)
Scope = область ответственности / bounded context, а не имя файла.

catalog — каталог товаров, фильтры, поиск по продуктам
cart — корзина, добавление/удаление позиций
checkout — оформление заказа, доставка, расчёт итога
orders — заказы, статусы, fulfillment
payment — оплата, расчёт сумм, capture, refund
auth — аутентификация, сессии, доступ
api — внешний API contract, response shape, endpoints
repo — конфигурация репозитория, .gitignore, tooling
release — release process, changelog, rollback, версии

Правила: scope должен помогать находить изменения по области. Запрещены имена файлов (OrderService.php) и слишком широкие метки (misc, app, stuff). Если scope не помогает читателю — лучше не ставить вообще, чем создавать ложную точность. Список allowed scopes держим явным, чтобы одно и то же не писали как cart / basket / order-flow.
Breaking changes
Breaking change — изменение, после которого существующий пользователь, клиент API, интеграция, script или deployment может перестать работать. Отмечается через ! после type/scope и/или footer BREAKING CHANGE:. При серьёзном impact используем оба: ! заметен в истории, footer даёт подробности и migration notes.
Пример хорошего сообщения:
feat(api)!: replace checkout response items field

BREAKING CHANGE: `items` is replaced by `lines` in checkout response.
Clients must update response parsing before upgrading.
Пример плохого:
fix(api): update checkout response
Выглядит как безопасный patch, но может сломать клиентские интеграции — сигнала о несовместимости нет.
Важно понимать: breaking change — это не «большой diff». Большой внутренний refactor без смены contract breaking-ом не является. А правка одного имени поля — может быть. Contract — это не только backend API: CLI-команда, Make-таргет, .env переменная, миграция БД, формат файла тоже являются contract.
Почему breaking change связан с SemVer, release notes и review
SemVer. Type определяет version impact: fix → patch, feat → minor, breaking (! / BREAKING CHANGE) → major. Marker говорит release-инструменту поднять версию до major, иначе выйдет minor, которая ломает клиентов.
Release notes. Breaking change должен быть виден сразу и отдельным разделом, потому что клиентам нужно подготовиться (обновить парсинг, применить миграцию). Changelog-генератор выносит такие изменения в отдельную секцию — но только если автор честно поставил marker.
Review. Marker должен быть частью обсуждения в PR: есть ли migration notes, нужен ли compatibility period, можно ли разбить изменение на non-breaking rollout, требуется ли major версия. Поставить ! без объяснения миграции — значит дать сигнал без практической готовности к релизу.
Review checklist
Reviewer проверяет не только код, но и честность release signal:

Type соответствует impact? feat — действительно новое поведение, fix — реально исправление, refactor — без изменения внешнего поведения. Тип выбран по смыслу, а не по папке.
Type не маскирует важное? Денежные/поведенческие исправления не спрятаны под chore или docs.
Scope из allowed списка? Не имя файла, не misc/app. Помогает найти изменение по области.
Коммит атомарный? Под одним type/scope лежит одно логическое изменение, а не смесь UI + README + .gitignore.
Breaking change отмечен? Если меняется любой contract (API, CLI, env, миграция, формат файла) — стоит ! и/или BREAKING CHANGE: footer.
Есть migration explanation? Для breaking — описано, что клиенту делать перед обновлением.
SemVer impact понятен? Из сообщений ясно, какой будет версия: patch / minor / major.
Description через поведение? Сообщение называет результат/поведение, а не действие автора или технику («alter column»).