Support line - это ветка или серия release branches, где команда поддерживает старую версию ограниченным набором изменений. В нее не должны случайно попадать новые features, большие refactoring и изменения поведения, которые не были обещаны клиентам этой версии. Главная задача support line - получать важные fixes с минимальным риском.

Связь с Module 05 прямая. Там release branch стабилизировал конкретную версию перед production. После выпуска часть таких линий может стать support line, если команда обязалась поддерживать patch releases. Например, support/1.7 получает security и critical bug fixes, пока develop уже движется к 1.9.


Source fix: <sha> from main.
Target: support/1.7.
Reason: checkout rounding bug affects 1.7 customers.
Scope: calculation fix only, no feature changes.
Checks: make check.
Release: v1.7.6 patch candidate.

Backport начинается с решения, а не с команды. Сначала нужно понять, affected ли старая версия, есть ли support obligation и можно ли перенести fix без новых features. Затем создается branch от support line, применяется минимальное изменение, чаще всего через git cherry-pick -x, запускаются checks, открывается PR в support branch и готовится patch release marker.

Хороший backport note содержит source commit, target support line, причину, риск, checks и release note. Это позволяет reviewer не гадать, почему старую ветку снова трогают. Backport должен быть маленьким: чем меньше patch, тем меньше риск сломать старую версию.

Контрольный вопрос: Почему support line нельзя автоматически обновлять всем содержимым develop?
Простыми словами: потому что develop — это будущая версия, и в нём лежит куча всего, что старой версии не нужно и даже вредно.
Если влить весь develop в support line, туда заедут:

новые features — клиент на старой версии их не заказывал, и они меняют поведение продукта;
migrations (изменения схемы базы) — клиент на старой версии физически не может их принять;
большие refactoring и несовместимые изменения — они ломают совместимость, которую команда обещала держать для этой версии.

Задача support line — получить только нужный fix с минимальным риском, а не весь release train. Поэтому переносят не «всё подряд», а одно выбранное исправление через cherry-pick, и проверяют его на старой ветке.
Это как раз то, чего не хватило твоему ответу на 90%: ты верно сказал про «ограниченный набор изменений», но не назвал конкретно, что именно опасно тащить — migrations и несовместимые изменения.
Если домашка — backport runbook (по аналогии с прошлым уроком)
На случай, что задание будет такое же по форме («создай ветку, создай docs/backport.md, опиши...»), вот готовое содержимое. Скопируешь в файл сам.
Support context

develop → будущая версия 1.9
main → текущий production 1.8.x
support/1.7 → поддерживаемая старая версия (legacy / enterprise клиенты)

Support line — это активная линия ответственности, а не архив. Она получает только критичные fixes (security, critical bugs), без новых фич и миграций.
Решение перед backport (это делается до любой git-команды)

Affected ли версия 1.7 — есть ли в ней тот же баг / уязвимый путь?
Есть ли обязательство поддерживать 1.7 (support obligation)?
Можно ли перенести fix без новых зависимостей и без новых features?

Если баг не существует в 1.7 — backport не нужен, иначе создашь риск без пользы.
Backport flow
git fetch origin
git switch -c backport/checkout-total-1.7 origin/support/1.7
git cherry-pick -x <fix-commit-sha>
make check
git status --short
Если код разошёлся и cherry-pick не ложится механически (в новой версии есть helper, которого нет в старой; тесты лежат в другом месте; другая конфигурация) — делается ручной минимальный fix с ссылкой на source commit в PR. История всё равно должна объяснять происхождение исправления.
Backport PR / note
Source fix: <sha> from main
Target: support/1.7
Reason: checkout rounding bug affects 1.7 customers
Scope: calculation fix only, no feature changes
Checks: make check
Release: v1.7.6 patch candidate
Patch release
После merge поставить patch tag, чтобы support team знала, какую версию рекомендовать:
git tag v1.7.6
git push origin v1.7.6
Запреты

Нельзя merge develop в support line — затащит features и migrations.
Backport должен быть маленьким: чем меньше patch, тем меньше риск сломать старую версию.
Нельзя backport без проверки affected version и без make check на самой support-ветке (тесты новой версии могут не покрывать старую конфигурацию).