Коммит считается опубликованным когда произвели команду git push -u origin ветка

Когда ты делаешь обычный push, Git проверяет, является ли новый tip продолжением старого tip. Если да, push fast-forward и история растет вперед. Force push заставляет remote ссылку перепрыгнуть на другую историю. Технически это возможно, но социально и процессно это уже изменение общего основания.

git switch -c revert/remove-broken-discount
git revert abc1234
make check
git status --short
git push -u origin branch

"Когда переписывание истории допустимо только по командному договору".