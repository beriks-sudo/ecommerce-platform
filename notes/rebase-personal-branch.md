# Rebase личной ветки

Контролируемый rebase на тренировочных личных ветках `practice/rebase-base` и
`practice/rebase-topic`. Цель — увидеть, что rebase создаёт новые commits поверх
новой базы, зафиксировать before/after и отдельно проговорить, где этот приём
безопасен, а где ломает чужую работу.

## Подготовка

Обе тренировочные ветки созданы от одной исходной точки homework branch
(commit `69f0622` — `Add more infromation about git show and readable history`):

- `practice/rebase-base` — добавлен `practice/rebase-base.txt`, commit
  `task 4 add rebase` (SHA `11cc8bc`).
- `practice/rebase-topic` — добавлен `practice/rebase-topic.txt`, commit
  `task 7 add rebase topic` (старый SHA `623c17c`).

В этой точке история разошлась: у `base` и `topic` общий parent `69f0622`,
но каждая ветка ушла в свою сторону.

## Before rebase

`git rev-parse --short HEAD` (на `practice/rebase-topic`): **`623c17c`**

`git log --oneline --decorate --graph --all -10`:

```
* 623c17c (HEAD -> practice/rebase-topic) task 7 add rebase topic
| * 11cc8bc (practice/rebase-base) task 4 add rebase
|/
* 69f0622 (origin/main, origin/HEAD, main, homework-v3-03-04-rebase-personal-branch) Add more infromation about git show and readable history
* 15f400c Add history for review
* 25241f4 Add good-commit notes
* 6fc433f Как убрать лишнее из staging area и разделить изменения
* df3143b Схема чтения git status, git diff и git diff --staged
* 438d669 Add about atomic commit
```

Две параллельные линии от общего parent — классическая diverged history.

## Команда

```
git switch practice/rebase-topic
git branch --show-current
git rebase practice/rebase-base
git log --oneline --decorate --graph -8
make check
```

## After rebase

`git rev-parse --short HEAD` (на `practice/rebase-topic`): **`1063249`**

`git log --oneline --decorate --graph -8`:

```
* 1063249 (HEAD -> homework-v3-03-04-rebase-personal-branch, practice/rebase-topic) task 7 add rebase topic
* 11cc8bc (practice/rebase-base) task 4 add rebase
* 69f0622 (origin/main, origin/HEAD, main) Add more infromation about git show and readable history
* 15f400c Add history for review
* 25241f4 Add good-commit notes
* 6fc433f Как убрать лишнее из staging area и разделить изменения
* df3143b Схема чтения git status, git diff и git diff --staged
* 438d669 Add about atomic commit
```

История стала линейной: `topic` теперь сидит поверх `base`, общего parent
`69f0622` больше не видно как точки расхождения. После этого
`practice/rebase-topic` был fast-forward merged в
`homework-v3-03-04-rebase-personal-branch`, поэтому HEAD homework branch
указывает на тот же commit `1063249`.

## Почему у topic commit новый hash

Старый topic был `623c17c`, новый — `1063249`. Имя коммита и сообщение те же,
но это технически другой объект.

SHA коммита считается от его содержимого: tree (снимок файлов), **SHA родителя**,
автор и committer вместе с датами, сообщение. При rebase Git берёт diff каждого
старого коммита и применяет его поверх новой базы. У получившегося коммита:

- другой parent (`11cc8bc` вместо `69f0622`),
- другой committer date (момент replay, а не момент исходного коммита).

Любого одного из этих изменений уже достаточно, чтобы хеш получился другой.
Старый `623c17c` никуда не пропадает мгновенно — он живёт в reflog какое-то
время и доступен через `git reflog`, но в актуальной истории ветки его уже нет.

## Safe zone

Личная локальная ветка, которая ещё не запушена и на которой никто не
базируется. Здесь rebase — нормальный инструмент:

- ветка существует только у тебя на машине,
- никто не fetched её коммиты,
- никто не оставил review,
- никто не построил свою ветку поверх неё.

Переписывание истории в этой зоне ничью работу не ломает: ломать просто нечего.
`practice/rebase-base` и `practice/rebase-topic` в этой работе — ровно такой
случай.

## Danger zone

Сюда rebase без отдельного командного договора нести нельзя:

- `main` (обычно protected),
- `develop`,
- `release/*`,
- `staging`,
- shared feature branch, на которой работает несколько человек,
- ветка с открытым Pull Request и чужими review comments,
- ветка, от которой кто-то уже начал свою работу.

Опубликованная история — это командный контракт. После rebase такой ветки твоя
локальная цепочка коммитов расходится с тем, что уже скачали коллеги: у них
остаются старые коммиты, у тебя — новые с другими хешами. Дальше — diverged
history, повторные конфликты и необходимость force update, который перетирает
ссылку на remote.

`--force-with-lease` безопаснее голого `--force`, потому что проверяет, что
remote всё ещё на ожидаемом SHA, и не даст молча затереть чужой push. Но lease
защищает от гонки, а не от самого решения переписать общую историю. Если на
ветку уже опираются другие — правильный beginner-ответ "не переписывать", а
обсудить процесс (revert, fix branch, hotfix flow).

В этой homework force push не делается сознательно.

## Зачем `make check` после rebase

Rebase — это replay diff'ов, а не повторное "осмысленное" применение изменений.
Git склеивает текст, но не понимает смысл кода. Возможны две неприятности:

1. **Текстовые конфликты** — Git остановит rebase и попросит решить вручную.
   Их видно, и их сложно пропустить.
2. **Семантические конфликты** — текст склеился чисто, конфликта нет, но код
   сломан. Типичный пример: в `base` кто-то переименовал функцию, а в `topic`
   ты добавил её вызов под старым именем. Diff применился, файл собрался,
   но программа упала на запуске или на тесте.

`make check` (тесты + линтер) — единственный способ убедиться, что состояние
после rebase валидно не только с точки зрения git, но и с точки зрения
работающего кода. Без этого ты пушишь ветку, которую git считает чистой, а
runtime — сломанной.

## Контрольный вопрос (исправленный ответ)

**Почему после rebase у commits меняются hashes?**

Hash коммита считается от его содержимого и метаданных, в число которых входит
SHA родителя и committer date. При rebase Git создаёт новые коммиты поверх
новой базы — у них другой parent и новый committer date, поэтому SHA получается
другой, даже если изменения в файлах и сообщение коммита идентичны.
