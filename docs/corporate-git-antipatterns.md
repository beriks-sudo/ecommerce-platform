# Corporate Git anti-patterns — ecommerce-platform

Каждый anti-pattern — это сломанный контракт: команда обещает одно, а система
позволяет другое. Каталог нужен не для поиска виноватых, а для выбора
следующего безопасного улучшения. Каждая запись проверяема.

## 1. Direct commits to protected line

- Symptom: коммиты появляются прямо в main без PR.
- Broken contract: review contract (изменения должны проходить ревью).
- Risk: непроверенный код в production-ready линии, нет второго взгляда.
- Root cause: branch protection не включён или admin bypass стал нормой.
- Corrective action: protected main, direct push запрещён, изменения только через PR.
- Owner: release owner.
- Verification signal: история main не содержит коммитов вне merge через PR.

## 2. Long-lived feature branches without integration

- Symptom: ветка живёт неделями, регулярно тянет полпроекта.
- Broken contract: integration contract (изменения интегрируются часто).
- Risk: merge debt, большой diff, поздние конфликты у самого релиза.
- Root cause: большой scope, нет slicing и feature flags.
- Corrective action: резать работу на маленькие PR, прятать незавершённое за флагом.
- Owner: автор задачи + tech lead.
- Verification signal: медианный возраст ветки падает, PR становятся проверяемыми.

## 3. Broken CI ignored

- Symptom: CI красный, но merge продолжается, red воспринимается как фон.
- Broken contract: quality gate (зелёный CI обязателен до merge).
- Risk: сломанное попадает в общую линию, доверие к проверкам теряется.
- Root cause: flaky-тесты без owner, у красного сигнала нет последствий.
- Corrective action: required status checks блокируют merge, назначить owner flaky-тестам.
- Owner: CI owner / tech lead.
- Verification signal: merge невозможен при красном CI; доля flaky-тестов снижается.

## 4. Release branch as second develop

- Symptom: после freeze в release/1.4 продолжают мерджить новые features.
- Broken contract: stabilization contract (release/* принимает только стабилизацию).
- Risk: candidate не стабилизируется, QA проверяет движущуюся цель.
- Root cause: нет release owner и нет allowed changes rule.
- Corrective action: защитить release/*, разрешить только blocker fixes, требовать approval owner.
- Owner: release owner.
- Verification signal: release diff после freeze содержит только одобренные фиксы.

## 5. Hotfix not backported

- Symptom: hotfix задеплоен, tag поставлен, но backport task не заведён.
- Broken contract: support contract (fix живёт во всех нужных линиях).
- Risk: следующий релиз приносит старый баг обратно.
- Root cause: incident закрыли по факту deploy, без backport checklist.
- Corrective action: backport checklist до закрытия incident (affected versions, target lines, validation, done signal).
- Owner: incident owner.
- Verification signal: fix присутствует в future line и нужных support lines, отмечен done.

## 6. Environment branch confusion

- Symptom: команда говорит "проверили staging branch", без указания версии.
- Broken contract: traceability contract (известно, какой commit где запущен).
- Risk: неизвестен deployed commit, невозможен надёжный rollback при incident.
- Root cause: смешаны branch, pipeline, artifact и environment.
- Corrective action: записывать deployed SHA / artifact id для каждой среды.
- Owner: DevOps / release owner.
- Verification signal: deployment records staging и production содержат commit SHA.

## 7. No rollback plan

- Symptom: при плохом деплое команда импровизирует, как откатиться.
- Broken contract: operational readiness contract (откат известен заранее).
- Risk: затяжной outage, паника при инциденте.
- Root cause: rollback path не описан до production decision.
- Corrective action: фиксировать rollback в release notes (previous artifact / revert / flag-off) до выкатки.
- Owner: release owner.
- Verification signal: у каждого релиза есть проверенный rollback note до деплоя.

## 8. Branch naming without rules

- Symptom: есть develop, release/*, hotfix/*, но без owner и правил.
- Broken contract: onboarding contract (имя ветки = понятное поведение).
- Risk: overhead без пользы; новичок видит названия, но не видит процесса.
- Root cause: скопировали prefixes из чужой компании без constraints.
- Corrective action: для каждой роли задать owner, allowed changes, checks, tag и backport rule — или убрать неиспользуемые префиксы.
- Owner: release owner.
- Verification signal: каждая существующая линия имеет документированный контракт.

## 9. Tags without checks and notes

- Symptom: tags ставятся вручную до прохождения checks, без release notes.
- Broken contract: release traceability (tag = проверенный released snapshot).
- Risk: tag указывает на невыпущенный/непроверенный commit, теряется смысл версии.
- Root cause: нет tag rule в release flow.
- Corrective action: tag только после checks и приёмки owner, на точный commit, с привязанными release notes.
- Owner: release owner.
- Verification signal: каждый tag связан с зелёным CI и release notes.



- direct commits to protected line
- long-lived feature branches without integration
- broken CI ignored
- release branch as second develop
- hotfix not backported
- environment branch confusion
- no rollback plan
- branch naming without rules
  Days 1-7:
- document current flow
- list protected lines and real bypasses
- add make check to PR checklist
- require CI on main if checks are stable enough

Days 8-20:
- protect release/*
- define release owner and allowed changes
- add hotfix backport checklist
- record deployed SHA for staging and production

Days 21-30:
- measure branch lifetime
- split the largest active PRs
- remove unused branch prefixes
- update onboarding docs and repository settings


What not to do:
New rule: no branches older than 2 days.
No feature flags.
No test stabilization.
No review capacity.
No plan for existing large branches.


How to verify improvement:
Goal: reduce late integration risk.
Step 1: measure active branch age.
Step 2: split new work into smaller PRs.
Step 3: add feature flags for unfinished behavior.
Step 4: set expected branch lifetime after team can comply.
Signal: median branch age decreases and PR size becomes reviewable.