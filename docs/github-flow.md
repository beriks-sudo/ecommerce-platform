# Pull Request workflow — ecommerce-platform

Документ описывает, как изменение проходит путь от ветки до production:
именование веток, последовательность действий, чек-лист PR, обязательные
проверки, релиз с откатом и ограничения процесса.

## Branch naming (правило именования веток)

Имя ветки = тип работы + короткое описание задачи через дефис:

    <type>/<short-description>

Разрешённые типы:
- `feature/*` — новая возможность. Пример: `feature/cart-empty-state`
- `fix/*` — исправление бага. Пример: `fix/checkout-total-rounding`
- `hotfix/*` — срочное исправление production. Пример: `hotfix/payment-timeout`
- `release/*` — стабилизация выпуска. Пример: `release/1.5`
- `chore/*` — обслуживание репозитория. Пример: `chore/update-gitignore`

Правила: только латиница в нижнем регистре, слова через дефис, без пробелов
и имён файлов. Ветка создаётся от актуального `main` (hotfix — от main или
release tag). Ветка короткоживущая.

## Flow (последовательность действий)

Путь изменения от ветки до main:

1. Создать ветку от актуального main:
   `git switch -c feature/<task> origin/main`
2. Сделать маленькое изменение.
3. Локальный preflight: `make check`, `git status --short`, `git diff --check`.
4. Закоммитить осознанные файлы (не `git add .`), сообщение по Conventional Commits.
5. Запушить ветку и открыть PR в main.
6. Пройти gates: CI зелёный + review approval.
7. Merge в protected main (direct push запрещён).
8. Release decision: тегать/деплоить или ждать следующего named release.

## Pull Request checklist (чек-лист PR)

Перед запросом review автор проверяет:

- [ ] PR маленький, одно логическое изменение (атомарность).
- [ ] Заголовок PR по Conventional Commits (`type(scope): description`).
- [ ] Описание PR: что менялось, зачем, какой risk.
- [ ] `make check` пройден локально (зелёный).
- [ ] `git status --short` — в PR только нужные файлы, нет .env/логов/tmp.
- [ ] `git diff --check` — нет whitespace-ошибок и конфликтных маркеров.
- [ ] Breaking change отмечен (`!` / `BREAKING CHANGE`) если ломает contract.
- [ ] Указан rollback path, если изменение рискованное.
- [ ] Ветка создана от актуального main, конфликтов нет.

## Required checks (необходимые проверки)

Изменение не попадает в main, пока не пройдёт все барьеры:

1. Local `make check` — author preflight (тесты, линтер) до PR.
2. CI — required status checks; красный CI блокирует merge.
3. Review approval — минимум один апрув, reviewer смотрит diff и risk.
4. Protected main — direct push запрещён, failing checks блокируют merge.

Принцип: в main попадает только проверенное и прошедшее gates, а не
«брошенное в pipeline на удачу».

## Release & rollback (релиз и откат)

Release:
- Released commit — это commit, на котором стоит release tag и который
  задеплоен. Связь tag ↔ commit ↔ deploy проверяема (tag в репозитории,
  запись в deployment log / release notes).
- Tag ставит release owner после прохождения проверок:
  `git tag v1.5.0 && git push origin v1.5.0`.

Rollback (при плохом деплое):
- Первый шаг — повторный деплой предыдущего known-good артефакта
  (предыдущий tag, например `v1.4.0`). Откат дешёвый.
- Если откат на артефакт невозможен — revert проблемного изменения через PR
  (с теми же gates), а не прямой push в main.
- Решение об откате принимает release owner; rollback path описан в release
  notes заранее, до production decision.

