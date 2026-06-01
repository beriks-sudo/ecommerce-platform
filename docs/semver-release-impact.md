Semantic Versioning использует форму MAJOR.MINOR.PATCH. PATCH означает backward compatible bug fixes. MINOR означает backward compatible functionality. MAJOR означает incompatible API changes. API здесь нужно понимать широко. Это может быть HTTP contract, public PHP package API, CLI arguments, Make target behavior, configuration file, environment variable, database migration expectations или exported file format. Версия отвечает не на вопрос "сколько файлов изменили", а на вопрос "что должен ожидать потребитель после обновления"

MAJOR.MINOR.PATCH простыми словами
Версия в формате MAJOR.MINOR.PATCH (например 1.4.2) — это обещание пользователю, насколько безопасно обновляться. Три цифры = три уровня предупреждения.

MAJOR (первая, 1) — несовместимое изменение, у пользователя что-то сломается. Поднимается, когда нарушен contract. 1.4.2 → 2.0.0
MINOR (средняя, 4) — новая возможность, но старое продолжает работать. Обновляться безопасно. 1.4.2 → 1.5.0
PATCH (последняя, 2) — исправление бага, ничего нового. Самое безопасное обновление. 1.4.2 → 1.4.3

Главный принцип: версия отвечает на вопрос «что сломается у потребителя после обновления», а не «сколько кода поменяли». Поэтому даже крошечное изменение (например, переименование одного поля в API) может быть MAJOR — если оно ломает существующих клиентов.
«API/contract» тут понимается широко: HTTP API, публичный API пакета, аргументы CLI, поведение Make-таргета, конфиг-файлы, env-переменные, миграции БД, формат экспортируемых файлов.
Таблица: commit → impact
Commit messageType / scopeUser impactVersion impactfix(payment): round order total before capturefix / paymentБаг с округлением суммы исправлен; поведение становится корректным, ничего новогоPATCH: 1.4.2 → 1.4.3feat(catalog): add filtering by brandfeat / catalogПоявилась новая возможность (фильтр по бренду); старое работает как преждеMINOR: 1.4.2 → 1.5.0docs(release): add rollback checklistdocs / releaseТолько документация; работа кода не меняетсяНет bump (если не трогает contract)chore(repo): ignore local coverage outputchore / repoHousekeeping репозитория; пользователь ничего не замечаетНет bumpfeat(api)!: replace checkout response items fieldfeat / api (breaking)Поле items заменено на lines; старые клиенты ломаются, нужна миграция парсингаMAJOR: 1.4.2 → 2.0.0
Правило «самый сильный signal wins»
Версия для релиза считается не по последнему коммиту, а по всему диапазону коммитов с прошлого тега:
git log --oneline v1.4.0..HEAD
Из всего набора берётся самый сильный сигнал — он и определяет bump. Сила сигналов по возрастанию: docs/chore/test/refactor (обычно ничего) → fix (patch) → feat (minor) → breaking (major).
Пример. В релизе есть:
feat(catalog): add brand filters
fix(cart): keep quantity after refresh
docs(release): add rollback checklist
Самый сильный — feat, значит релиз 1.4.2 → 1.5.0 (minor).
Но если бы среди тех же коммитов был хоть один breaking:
feat(api)!: replace checkout response items field
fix(cart): keep quantity after refresh
то релиз обязан быть major (1.4.2 → 2.0.0), даже если всё остальное — мелкие фиксы. Один breaking перевешивает любое количество fix и feat.
Смысл правила: пользователю важно знать про самый опасный эффект обновления. Если хоть что-то ломает совместимость, версия обязана это показать.
Connection to Module 05
В release flow версия определяется только после release review, а не до проверки:

Release manager смотрит коммиты с прошлого тега: git log --oneline v1.4.0..HEAD.
Читает их как список изменений продукта, ищет breaking changes, сверяет changelog с реальным diff.
По правилу «самый сильный signal wins» решает, какой будет next version и почему (reasoning документируется).
Только после этого ставит tag: git tag v1.5.0.

Tag — это акт обещания: «этот commit является release-версией с таким impact». Git не проверяет правильность тега; ошибку ловят review, release checklist, CI и changelog. Поэтому tag ставится после release decision, а не наоборот.
Connection to Module 06
В Module 06 один и тот же репозиторий может одновременно вести mainline-релиз и support-patch, поэтому version reasoning должен быть явным:

Hotfix → patch release. Срочное исправление production обычно поднимает только PATCH в support line: 1.4.2 → 1.4.3. Это сигнал «безопасное исправление, без новых фич и без ломающих изменений».
Backport → отдельный patch для старой версии. Если fix переносят в поддерживаемую старую линию (например support/1.7), там выпускают свой patch tag: v1.7.6. По нему support team понимает, какая версия содержит исправление.
Breaking changes в support line обычно не переносят без отдельного решения: они подняли бы major и нарушили обещание совместимости для клиентов старой версии.

То есть SemVer показывает разницу между «маленькое безопасное исправление для старой версии» (patch) и «новый release train» (minor/major) — и не даёт случайно протащить feature или breaking change в patch.