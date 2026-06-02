create release/1.4 from approved base
freeze scope
fix blockers only
run checks and QA
tag v1.4.0
merge or cherry-pick release fixes back to future line
close or keep support decision

detect incident
identify affected release tag or production SHA
create hotfix/<issue> from that line
apply focused fix
run checks and focused validation
review with incident owner
tag patch release
deploy
backport to future and support lines
record result

# Release & support model — ecommerce-platform

Документ связывает release branch, hotfix и support line в одну модель:
кто владеет линиями, какие изменения разрешены, как ставятся теги и как
фиксы возвращаются в будущие версии.

## Assumptions

- Команда маленькая, релизы по named releases.
- Rollback дешёвый, CI надёжный.
- Сейчас поддерживается только текущая версия (support line как пример).
- Hotfix обязан возвращаться в future line.

## Lines and allowed changes

| Line | Role | Allowed changes | Owner |
|---|---|---|---|
| main | текущая production-ready линия | approved future work + patch merges | release owner |
| release/1.4 | stabilization / patch-линия конкретной версии | только blocker fixes, release docs, version bump | release owner |
| support/1.3 | старая поддерживаемая minor-версия | только security и critical bug fixes | support owner |

Если release/* принимает новые features — это уже не stabilization line.
Если support/* принимает обычные features — это форк продукта, а не support.

## Release branch as stabilization line

release/1.4 — это линия стабилизации, а не "ветка, куда всё мержится".

- Allowed changes: blocker fixes, release documentation, final checks,
  version bump, иногда configuration adjustments. Новые feat запрещены.
- Owner: release owner (создаёт ветку, объявляет freeze, решает что blocker).
- Checks перед tag: make check + (в реальном проекте) smoke checks,
  regression suite, migration dry-run, frontend build, security scan,
  release notes review, rollback rehearsal.
- Tag rule: tag ставится ТОЛЬКО после прохождения checks и приёмки release
  owner, на точный стабилизированный commit. Ветка двигается — tag фиксирует
  snapshot.
- Back-merge rule: фиксы из release/1.4 обязаны вернуться в future line
  (main) через merge или cherry-pick ДО закрытия ветки.
- Close rule: после tag и back-merge ветка закрывается или превращается в
  support line по отдельному решению.

Lifecycle:

    create release/1.4 from approved base
    freeze scope
    fix blockers only
    run checks and QA
    tag v1.4.0
    merge/cherry-pick release fixes back to future line
    close or keep as support

## Release path

    feature/* -> develop/main -> release/1.4 -> main -> tag v1.4.0
                                 |
                                 +-> fixes return to future line

Правильный порядок тега: candidate стабилизирован -> checks прошли ->
release owner принял -> tag на точный commit -> release notes связаны с tag.

## Hotfix path

    incident
      -> identify affected release tag / production SHA
      -> hotfix/<issue> from that line
      -> focused minimal fix
      -> checks + focused validation
      -> review with incident owner
      -> tag patch release (v1.4.1)
      -> deploy
      -> backport to future and support lines
      -> record result

Обязательна обратная стрелка: hotfix возвращается в future line (main) и в
support lines. Если fix остался только в production patch — следующий релиз
вернёт старый баг.

Решения в hotfix:
- Кто решает affected versions: incident owner.
- Как выбирается base: от affected release tag / production SHA, а не от
  случайной feature-ветки.
- Какие checks обязательны: make check + focused validation (или явно
  названный emergency subset, не "пропустить из-за срочности").
- Когда ставится patch tag: после fix, checks и review incident owner.
- Scope: минимальный. Соседний баг — отдельная задача, если incident owner
  явно не включил его в emergency scope.

## Backport checklist (до закрытия incident)

Backport — защита от повторного появления бага, а не декоративный шаг.
Incident нельзя закрывать, пока не пройден checklist:

- [ ] Affected versions определены (где ещё живёт баг).
- [ ] Target lines выбраны (main, release/*, support/* по support policy).
- [ ] Validation per line: в каждой целевой ветке прогнан make check.
- [ ] Release notes / patch tag обновлены для каждой линии.
- [ ] Owner назначен.
- [ ] Done signal: явное подтверждение, что fix есть во всех нужных линиях.

## Release branch vs second develop

release/1.4 отличается от второго develop направлением scope:
- develop растёт — принимает новые features, движется к будущей версии.
- release/1.4 заморожен — принимает только стабилизирующие изменения,
  чтобы зафиксировать candidate и поставить tag.
  Если в release/* мержат features, он теряет смысл стабилизации и становится
  вторым develop: QA начинает проверять "движущуюся цель".

## When this model fits

- Release branch оправдан при отдельной фазе стабилизации: weekly/monthly
  release, enterprise train, app store approval, customer acceptance,
  regulated window.
- При continuous deployment с дешёвым rollback release branch может быть лишним.
- Support lines нужны только если поддерживается больше одной версии
  (клиенты на предыдущих minor, regulated patches). Если их нет — не
  выдумывать; если есть — без owner и backport rule они опасны.