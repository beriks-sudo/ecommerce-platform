# Branching strategy contract — ecommerce-platform

Этот документ описывает branching strategy не как набор имён веток, а как
проверяемый контракт команды: кто куда мерджит, какие проверки обязательны,
кто принимает release и куда возвращается hotfix.

## Assumptions

Контракт написан под конкретный учебный проект, а не как универсальный стандарт:

- Team size: маленькая команда (один-несколько разработчиков).
- Release frequency: релизы по named releases, тег ставится по решению release owner.
- Checks maturity: базовые проверки — `make check` локально и CI в PR; тяжёлого
  QA sign-off пока нет.
- Rollback model: rollback дешёвый — повторный деплой предыдущего known-good
  артефакта или revert через PR.
- Support model: старые версии не поддерживаются (нет support line / backport
  в legacy), но hotfix обязан вернуться в `main`.

## Branch roles

### main
- Role: protected production-ready integration line.
- Owner: release owner.
- Allowed source: approved PR из `feature/*`, `release/*` или `hotfix/*`.
- Required checks: `make check`, CI, review approval.
- Merge rule: только через PR; direct push запрещён; failing checks блокируют merge.
- Release meaning: commit в `main` можно tag-нуть и задеплоить.

### feature/*
- Role: изоляция отдельной задачи.
- Owner: автор задачи.
- Allowed source: создаётся от актуального `main`.
- Required checks: `make check` локально перед PR; CI в PR.
- Merge rule: merge в `main` только через PR с review approval; ветка короткоживущая.
- Release meaning: сам по себе не релизится — становится релизом только после
  merge в `main`.

### release/*
- Role: stabilization line для конкретного named release.
- Owner: release owner.
- Allowed source: создаётся от `main`; принимает только `fix`, `docs`,
  `chore(release)`.
- Required checks: `make check`, CI, review approval.
- Merge rule: новые `feat` после freeze запрещены; разрешены только
  стабилизирующие изменения.
- Release meaning: tag ставится с этой линии; back-merge обратно в `main`
  обязателен, чтобы стабилизация не потерялась.

### hotfix/*
- Role: emergency fix для production.
- Owner: incident owner (с approval release owner).
- Allowed source: создаётся от production line (`main` или последнего release tag).
- Required checks: `make check`, CI, ускоренный review (focused review, не bypass).
- Merge rule: minimal scope, merge в protected line через PR.
- Release meaning: получает patch tag; обязан вернуться в `main` (см. Hotfix rule).

## Change flow: from feature/* to main

Текстовая схема движения обычного изменения:

    1. Создать ветку от актуального main:
       git switch -c feature/<task> origin/main
    2. Сделать изменение, локально прогнать make check.
    3. Открыть PR в main.
    4. Пройти gates: CI (зелёный) + review approval.
    5. Merge в protected main (direct push запрещён).
    6. Release decision (release owner): можно ли тегать/деплоить этот commit?
       - да → git tag vX.Y.Z + deploy
       - нет → ждать следующего named release

Принцип: общая линия (main) меняется только после прохождения проверяемых gates.

## Hotfix rule

Отдельное правило для emergency fix, потому что обычный flow слишком медленный
для production-инцидента:

- От какой линии: hotfix создаётся от production line — `main` или последнего
  release tag, а не от случайной feature-ветки.

      git switch -c hotfix/<incident> origin/main

- Кто принимает: incident owner делает minimal fix, release owner даёт
  ускоренный approval. Review — focused, не bypass: дисциплина при инциденте
  важнее, а не наоборот.
- Checks: обязательно `make check` и CI (или явно названный emergency subset),
  пропускать проверки из-за срочности нельзя.
- Куда возвращается: после merge и patch tag (например `v1.8.1`) hotfix
  обязан вернуться в `main`. Поскольку support line в этом проекте нет,
  единственная цель back-merge — чтобы следующий релиз не принёс старый баг
  обратно. Это записывается (PR / release note), а не держится в памяти.

## Rollback assumptions

- Как команда понимает released commit: released commit — это тот, на котором
  стоит release tag и который задеплоен. Связь tag ↔ commit ↔ deploy
  проверяема (tag в репозитории, запись в deployment log / release notes).
- Что делать при плохом deploy: rollback дешёвый, поэтому первый шаг —
  повторный деплой предыдущего known-good артефакта (предыдущий tag, например
  `v1.4.0`). Если откат на артефакт невозможен — revert проблемного изменения
  через PR (с теми же gates), а не прямой push в main.
- Решение об откате принимает release owner; rollback path должен быть описан
  в release notes выпуска заранее, до production decision.

## Local checks before review

Перед открытием PR автор прогоняет preflight локально — это не заменяет
platform gates, но ловит проблемы до review:

- `make check` — тесты и линтер проекта (зелёные перед PR).
- `git status --short` — увидеть, что именно попадёт в коммит; неожиданные
  файлы (.env, *.log, tmp/) сначала разобрать, не делать `git add .` вслепую.
- `git diff --check` — поймать whitespace-ошибки и оставшиеся конфликтные маркеры.

## Forbidden scenarios

### 1. Direct push в main в обход PR
Кто-то пушит правку прямо в `main`, минуя review и CI («там же мелочь»).
Останавливает: правило main → Merge rule (только через PR, direct push
запрещён, failing checks блокируют merge). Общая линия не меняется без gates.

### 2. Merge новой feature в release/* после freeze
В стабилизирующую `release/1.4` пытаются влить новую `feat`, потому что
«успеем в этот выпуск». Останавливает: правило release/* → Allowed source и
Merge rule (после freeze разрешены только fix/docs/chore(release), новые feat
запрещены). Это не даёт release-ветке превратиться во «второй develop».

### 3. Hotfix не вернулся в main
Production исправлен patch-тегом, но fix остался только в hotfix-линии.
Останавливает: правило hotfix/* → Hotfix rule (обязательный back-merge в main
с записью в PR/release note), иначе следующий релиз вернёт старый баг.