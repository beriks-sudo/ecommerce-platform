Incident context
Symptom: при оформлении заказа со скидкой итоговая сумма (checkout total) расходится на 0.01 — ошибка округления в расчёте.
Affected version: v1.8.0.
Production line: main (это production-ветка, из неё идёт релиз).
Hotfix flow

Обновиться и создать hotfix-ветку от production line, а не от случайной feature-ветки:

git fetch origin
git switch -c hotfix/checkout-total origin/main

Сделать минимальный fix — только исправление округления, без рефакторинга и новых фич.
Прогнать проверки локально:

make check

Открыть ускоренный PR, получить review (хотя бы один апрув по emergency-процессу).
После апрува влить в protected line (main) по правилам команды (merge / squash / fast-forward).
Зафиксировать release artifact: поставить patch tag и/или добавить release note:

git tag v1.8.1
git push origin v1.8.1

Release note: «Fix checkout total rounding for discounted orders. Patch v1.8.1».
Follow-up
После деплоя hotfix работа не закончена — нужно ответить на вопрос «где ещё живёт этот баг?» и перенести fix в integration line, чтобы он не вернулся в следующем релизе.
Перенос в develop через cherry-pick (флаг -x сохраняет ссылку на исходный commit):
git switch -c follow-up/checkout-total-develop origin/develop
git cherry-pick -x <hotfix-commit-sha>
make check
После проверок открыть PR в develop. Если есть release branch или старые support-версии — там тоже нужен backport / отдельный patch release.
Follow-up обязательно записать (PR, issue или release note), а не держать в голове:
Hotfix source: <sha> in main
Target: develop (next minor release)
Reason: prevent regression in next release train
Checks: make check
Запрет на прямую работу в protected main и force push

Запрещено напрямую коммитить и пушить в main — любое изменение только через hotfix/* или feature-ветку и PR.
Запрещён git push --force (и --force-with-lease) в main и develop — это переписывает общую историю и ломает работу команды.
Срочность incident не отменяет правила: меньше scope и быстрее review — да, но checks, review и проверяемая история обязательны.