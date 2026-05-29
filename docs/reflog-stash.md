git reflog показывает историю перемещений ссылок в твоем локальном репозитории. Это не история проекта для команды, а журнал твоих локальных действий. Через него можно найти commit, на который раньше указывал HEAD, и создать от него ветку. Правильная восстановительная привычка: не делать новых хаотичных команд, а остановиться, посмотреть git status, затем git reflog, затем зафиксировать найденную точку безопасной веткой.

Рабочий пример
git status --short
git reflog -10
git switch -c recovery/found-work HEAD@{2}
make check

git status --short
git stash push -m "wip checkout validation before hotfix"
git status --short
git switch hotfix/checkout-total
make check
git switch feature/checkout-validation
git stash list
git stash apply stash@{0}

Stash полезен при срочном context switch: QA нашел production bug, а у разработчика есть незавершенная локальная работа. Он временно убирает WIP, переключается на hotfix branch, делает проверку, возвращается и применяет stash. Но если hotfix занимает больше времени, WIP лучше сохранить в отдельной ветке и commit, чтобы не держать важную работу в локальном stack.

stash используется для временного сохранения изменений, но не объяснил, почему он не должен заменять commit. локальности stash, отсутствии описания намерений и возможности review.