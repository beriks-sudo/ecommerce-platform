## Release path

    feature/* -> develop -> release/1.4 -> main -> tag v1.4.0
                            |
                            +-> fixes return to develop

Изменение интегрируется в develop, стабилизируется в release/1.4, уходит в
main и помечается тегом. Фиксы, сделанные во время стабилизации, обязательно
возвращаются в develop, чтобы следующий релиз их не потерял.

## Hotfix path

    tag v1.4.0 -> hotfix/payment-timeout -> main -> tag v1.4.1
                                          \-> develop or next release / support line

Обязательна обратная стрелка: hotfix после деплоя возвращается в future line
(develop) или support line. Если fix остался только в production line, он
почти гарантированно пропадёт в следующем релизе и баг вернётся.

## Decision section — ecommerce-platform сейчас

Текущие assumptions: команда 1 человек, релизы частые, rollback дешёвый,
CI надёжный, поддерживается только текущая версия.

Что нужно сейчас:
- main — protected production-ready линия с обязательными checks.
- feature/* — короткие ветки для изоляции задач.
- PR review + CI — gates перед попаданием в main.
- make check — локальный preflight автора.
- tags — для named releases, чтобы фиксировать точный released commit.

Что пока лишнее и почему:
- develop — нет нескольких разработчиков и параллельной интеграции будущей
  версии; production всё равно деплоится из main после PR, отдельная
  integration line только добавит синхронизацию без пользы.
- release/* (долгие) — нет внешней QA-приёмки и release train, нечего
  стабилизировать отдельной долгоживущей веткой.
- support lines / backport tracking — старые версии не поддерживаются,
  клиентов на предыдущих версиях нет, backport-ить некуда.

Вывод: для текущего размера и нужд достаточно GitHub Flow + tags. Брать
полный Git Flow сейчас значит платить цену (синхронизация develop и release
веток) без снижения реального риска.

## Signals to move to fuller Git Flow

Переход к более полному Git Flow оправдан, когда появится хотя бы одно:

1. Появилась внешняя QA-приёмка — нужна стабилизация release candidate, пока
   future work продолжается → оправдан release/*.
2. Клиенты остаются на предыдущих версиях — нужно выпускать patch releases для
   старых версий → оправданы support lines и backport tracking.
3. Rollback стал дорогим или требует audit trail (или compliance требует
   evidence для production approvals) → нужны явные release branches, tags с
   notes и зафиксированные approvals.

Дополнительно: появление нескольких разработчиков и scheduled release train —
сигнал, что develop как integration line начинает окупаться.

## Risks of copying Git Flow blindly

Копировать набор веток из чужой компании опасно — это даёт overhead без пользы.

Пример 1: лишний develop.
Команда заводит develop, feature/*, release/*, hotfix/*, но production deploy
всё равно всегда идёт из main после PR. develop существует, но реально не
используется как integration line — он только расходится с main, и его надо
синхронизировать. Цена (лишние merges, drift) оплачена, польза — нулевая.

Пример 2: release/* без freeze discipline.
Команда создаёт release/* "как у взрослых", но туда продолжают мерджить новые
features месяцами. Ветка живёт долго и принимает feat — то есть превращается
во второй develop. Stabilization, ради которого её завели, не происходит;
зато добавились merge paths и риск потерять fix между линиями. А если при
этом hotfix создаётся редко и backport checklist отсутствует, фиксы тихо
теряются. Главный признак проблемы: команда не может объяснить, какой риск
снижает каждая линия.