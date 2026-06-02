# Workflow decision matrix — ecommerce-platform

Workflow выбирается не по моде, а по constraints команды. Документ сравнивает
четыре сценария, чтобы итоговое решение для ecommerce-platform звучало как
вывод из ограничений, а не как мнение.

## Scenario 1: Solo learning project

- Team size: 1 разработчик.
- Release cadence: on demand, нерегулярно.
- CI maturity: базовый, но надёжный (быстрый make check, простой CI).
- Review latency: нет внешнего review (self-review).
- Rollback cost: низкий — откат это пересоздание/redeploy за минуты.
- Deploy model: ручной, по желанию.
- Regulatory needs: нет.
- Support model: только текущая версия.
- Recommended workflow: protected main + короткие feature-ветки + PR-привычка.
- Required gates: make check, self-review через PR, базовый CI.
- Why not heavier: develop, release/* и support лишь добавят синхронизацию,
  реальный риск при одном человеке они не снижают.
- When to evolve: появился второй разработчик или регулярные релизы.

## Scenario 2: Small SaaS team

- Team size: 3-8 разработчиков.
- Release cadence: daily или weekly.
- CI maturity: высокая — checks быстрые и надёжные.
- Review latency: часы (договорённость реагировать в тот же день).
- Rollback cost: низкий-средний — redeploy предыдущего артефакта за минуты.
- Deploy model: merge в main триггерит deploy после прохождения checks.
- Regulatory needs: нет.
- Support model: только текущая версия.
- Recommended workflow: GitHub Flow или trunk based.
- Required gates: protected main, PR review, CI, make check, rollback note.
- Why not heavier: release branches замедлят daily delivery, а старые версии
  не поддерживаются — стабилизационная линия не нужна.
- When to evolve: появился QA window или поддержка предыдущих версий.

## Scenario 3: Enterprise release train

- Team size: ~30 разработчиков.
- Release cadence: monthly train (запланированные релизы).
- CI maturity: средняя — checks есть, но flaky-тесты иногда требуют
  вмешательства owner.
- Review latency: до дня, есть очереди на review.
- Rollback cost: высокий — связан с data migration и downtime.
- Deploy model: environment promotion (staging -> production с approval).
- Regulatory needs: внутренние approvals, но без строгого регулятора.
- Support model: текущая + предыдущая minor-версия.
- Recommended workflow: Git Flow / release branches + tags + backport tracking.
- Required gates: protected main, CI, review approval, release/* с freeze и
  release owner, tags с release notes, backport checklist, QA sign-off.
- Why not heavier (regulated): нет внешнего регулятора и audit evidence
  требований, поэтому protected environments с evidence пока избыточны.
- When to evolve: появился внешний регулятор, compliance требует evidence,
  или окружений станет больше с раздельными deploy-владельцами.

## Scenario 4: Regulated product

- Team size: 30+, несколько команд.
- Release cadence: контролируемые release windows.
- CI maturity: высокая, но с обязательными security/compliance проверками.
- Review latency: дни — нужны multiple approvals.
- Rollback cost: очень высокий — миграции данных, audit trail, customer impact.
- Deploy model: environment promotion с protected environments и approvals.
- Regulatory needs: обязательны approvals, audit evidence, change windows.
- Support model: несколько поддерживаемых версий (security patches на каждую).
- Recommended workflow: Git Flow + release branches + support lines +
  protected environments + promotion gates.
- Required gates: всё из enterprise + protected environments, документированные
  approvals, evidence для production, change-window discipline, rollback rehearsal.
- Why not heavier: тяжелее уже некуда в рамках курса — здесь риск максимальный,
  поэтому максимальная явность процесса оправдана.
- When to evolve: пересмотр при изменении регуляторных требований или при
  упрощении (если часть продукта выходит из-под регулирования).

## Decision for ecommerce-platform (now)

Текущие constraints: маленькая команда, релизы по named releases, CI надёжный,
rollback дешёвый, поддерживается только текущая версия, регуляторики нет.

- Достаточный workflow сейчас: protected main + короткие feature-ветки +
  PR review + make check + CI, плюс tags для named releases.
- Обязательные gates: protected main (direct push запрещён), PR review,
  CI (red блокирует merge), локальный make check, rollback note, tag на
  проверенный commit с release notes.
- Что пока лишнее: develop, долгие release/*, support lines — нет нескольких
  разработчиков, внешней QA, release train и поддержки старых версий, поэтому
  цена этих линий не окупается.

Signals для пересмотра (записаны заранее, чтобы не спорить после роста):
1. Появилась внешняя QA-приёмка / нужен стабильный candidate → ввести
   release/* + release owner + freeze rule.
2. Клиенты остаются на предыдущих minor-версиях → ввести support/* +
   backport checklist.
3. Rollback стал дорогим / появился audit или compliance requirement →
   ввести protected environments, promotion gates и evidence для approvals.
   (Дополнительно: рост команды и переход на release train оправдают develop.)

## Warning: branch names without rules

Имя ветки — это инструмент управления изменениями, а не символ зрелости.
Создать develop, release/* и hotfix/* без owner, allowed changes, required
checks, tag rule и backport rule — значит получить overhead без пользы:
ветки выглядят солидно, но реальный риск не снижается, а fixes теряются
между линиями. Сначала constraint и причина, потом имя ветки и правила вокруг
неё — никогда наоборот.