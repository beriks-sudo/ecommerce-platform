Я случайно использовал git add . и в staging area попали лишние файлы которые должны попасть в будущий комит

Я выполнил команду git diff --staged и заметил что в будущий комит падает изменение в Makefile хотя он не относится к этому комиту

Я выполнил команду git restore --staged Makefile

Файл Makefile не попадет в коммит, но останется в working tree

Далее я выполнил git commit -m "Homework staging"

После коммита уже выполнил команду git add Makefile чтобы подготовить к следующему комиту про Makefile