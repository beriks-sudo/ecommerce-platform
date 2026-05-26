main:
direct push: forbidden
force push: forbidden
pull request: required
merge request: required
approvals: at least 1
required checks: green before merge

feature branch -> PR/MR -> review -> required checks -> protected main


SSH доступ к repository не отменяет branch protection. SSH подтверждает, кто выполняет Git operation и есть ли у account доступ к repository. Protected branch policy проверяется позже на сервере, когда push пытается обновить конкретный protected ref. Поэтому authenticated user может получить отказ на direct push в main, хотя git fetch и push в feature branch работают нормально.

“make check` не только находит ошибки, но и уменьшает нагрузку на reviewer и remote checks. Также важно упомянуть, что локальные проверки ускоряют работу, а remote checks защищают общую ветку.”

Если check красный, правильная реакция:

1. Открыть log check.
2. Найти failing command.
3. Воспроизвести локально, если возможно.
4. Исправить причину.
5. Запустить make check.
6. Push новый commit.

В PHP/Laravel проектах required checks часто запускают Composer install, PHPStan или Psalm, Pint, PHPUnit, frontend build и smoke checks. В Docker курсе та же дисциплина появится как make up, make logs, make check. В deployment темах checks станут частью release confidence. Module 05 расширит текущую модель до corporate flow: integration line, staging, release branch, tag и production decision.

https://github.com/beriks-sudo/ecommerce-platform.git
git@github.com:beriks-sudo/ecommerce-platform.git