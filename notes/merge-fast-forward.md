git log --oneline --decorate --graph -8

# Merge: fast-forward vs merge commit

Merge — это не одна операция, а семейство сценариев. Git выбирает между
ними автоматически, и форма результата зависит не от команды `git merge`,
а от формы commit graph в момент слияния. Эта заметка фиксирует руками
два сценария: fast-forward и настоящий merge commit с двумя родителями.

## Граф после двух merge

```
*   4243f99 (HEAD -> homework-v3-03-03-merge-fast-forward) Merge branch 'practice/merge-source' into homework-v3-03-03-merge-fast-forward
|\
| * 9b90ad0 (practice/merge-source) Add practice file for merge commit demo
* | aeac82e Add practice file on homework branch to diverge history
|/
* 8aa0b91 (practice/ff-source) Add practice file for fast-forward merge demo
* 718e3c9 Add placeholder for merge fast-forward notes
* 17e160d (master) Add review checklist with make status, diff, history and check
* 242251b Add Makefile with status, diff, history and check targets
* 98a7774 Add notes on writing good commit messages
```

В графе видно две разные формы:

- Низ — прямая вертикальная линия. Это результат первого, fast-forward
  merge: история осталась линейной, нового commit не появилось.
- Верх — `Y`-форма с развилкой и слиянием. Commit `4243f99` имеет
  **двух родителей** (`aeac82e` и `9b90ad0`). Это и есть merge commit.

## Почему первый merge был fast-forward

Перед первым merge история выглядела так:

```
homework  →  A
              \
               B  ←  practice/ff-source
```

`homework` указывал на commit `A` (placeholder заметки). От него я создал
ветку `practice/ff-source`, добавил commit `B` (файл `ff-source.txt`), и
вернулся в `homework`. На `homework` за это время **ничего не изменилось**.

Это ключевое условие fast-forward: целевая ветка не ушла вперед
относительно точки расхождения. Тогда Git не нужно ничего сливать. Он
просто двигает указатель `homework` с `A` на `B`, и история остается
линейной. Никакого нового commit не создается — merge commit'а нет,
параллельных линий тоже нет.

Git напечатал в выводе:

```
Updating 718e3c9..8aa0b91
Fast-forward
```

Слово `Fast-forward` означает буквально "перемотка вперед". Указатель
ветки перепрыгнул на новую позицию, как будто эти commit'ы все время
были в `homework`.

## Почему второй merge создал merge commit

Перед вторым merge история уже расходилась:

```
              D  ←  practice/merge-source
             /
homework  →  B
             \
              C  ←  homework (новый commit на homework)
```

Я создал `practice/merge-source` от `B`, сделал в ней commit `D` (файл
`merge-source.txt`). Потом вернулся в `homework` и сделал **свой
собственный commit `C`** (файл `merge-target.txt`). Теперь у двух веток
общий предок `B`, но они разошлись: каждая ушла в свою сторону.

Fast-forward здесь невозможен. Указатель `homework` стоит на `C`, и
`practice/merge-source` указывает на `D`. Чтобы объединить эти линии,
нужен новый commit, который ссылается **на оба** конца как на родителей.
Git создает его автоматически:

```
Merge made by the 'ort' strategy.
```

Этот merge commit `4243f99` хранит результат слияния содержимого `C` и
`D`, и в его метаданных два parent'а. Поэтому в графе появилась
`Y`-форма: две линии сошлись в одну точку.

## Правило одной строкой

Fast-forward возможен, когда между текущей веткой и веткой-источником
**нет расхождения**: целевая ветка — прямой предок источника. Если на
целевой ветке появился хотя бы один commit, которого нет в источнике,
Git обязан создать merge commit, чтобы зафиксировать обе линии истории.

## Corporate note

В учебном repository удобно делать merge напрямую из локальной ветки в
`main` или в homework branch. В команде так не работают.

Feature branch проходит через pull request: автор открывает PR из своей
ветки в `main` (или `develop`), запускается CI с тестами и линтерами,
другой разработчик читает diff и оставляет комментарии. Только после
зеленого CI и approve ветка попадает в `main` — обычно через merge
commit или squash, на стороне платформы (GitHub, GitLab), а не локально.

`main` в таких проектах — это **protected branch**: прямой `git push`
в нее запрещен на уровне настроек репозитория. Это защищает историю от
случайных commit'ов, обходящих review, и гарантирует, что в `main`
попадает только то, что прошло CI.

Локальный merge, который мы делаем в этом задании, — это упрощенная
модель. Механика та же (fast-forward vs merge commit зависит от формы
графа), но в команде merge — это финальный шаг pipeline'а, а не первое
действие после коммита.