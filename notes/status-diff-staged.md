# status, diff, diff --staged: три вопроса перед commit

Перед каждым commit в локальном repository нужно задать три разных вопроса.
Они выглядят похоже, но смотрят на разные слои: HEAD, staging area и working
tree. Одна команда не заменяет другую.

## Три вопроса

### git status — какие файлы изменены и где они находятся?

`git status` отвечает на вопрос о состоянии путей. Он показывает, какие файлы
изменены, какие новые, какие удалены, и в каком слое сейчас лежит изменение:
в staging area (готово к commit) или только в working tree (еще не
подготовлено). Содержимое строк он не показывает.

### git diff — что изменено в working tree, но еще не подготовлено?

`git diff` без аргументов сравнивает staging area и working tree. Он отвечает
на вопрос: какие правки я сделал в файлах, но еще не добавил через `git add`.
Это diff "того, что не подготовлено".

### git diff --staged — что попадет в следующий commit?

`git diff --staged` сравнивает HEAD и staging area. Он отвечает на вопрос: что
именно будет сохранено, если я прямо сейчас выполню `git commit`. Это diff
будущего commit, и его нужно прочитать до сохранения истории.

## Схема сравнения

```
HEAD  ──────────────►  staging area  ──────────────►  working tree
       git diff --staged                git diff
```

- `git diff --staged` сравнивает HEAD и staging area.
- `git diff` сравнивает staging area и working tree.
- `git status` не показывает содержимое строк, но показывает положение путей
  относительно этих трех слоев.

## Почему после git add обычный git diff может стать пустым

`git add README.md` копирует текущее содержимое файла из working tree в
staging area. После этого working tree и staging area совпадают, и обычному
`git diff` сравнивать нечего — он показывает пустой результат.

Изменение не исчезло. Оно переехало в staging area и теперь видно через
`git diff --staged`. Пустой `git diff` после `git add` не означает чистый
repository; он означает только, что в working tree не осталось
неподготовленных правок относительно index.

Проверить руками:

```
printf "\nUse make check before commit.\n" >> README.md
git diff                 # изменение видно здесь
git add README.md
git diff                 # пусто — working tree совпал с index
git diff --staged        # изменение видно здесь
```

## Почему staged diff нужно читать перед commit

`git status` скажет `M README.md`, но не покажет, что внутри файла. Туда
может попасть случайный пароль, debug-строка, черновой комментарий или
изменение из другой задачи. `make check` ловит whitespace и базовые
формальные проблемы, но не знает, относится ли строка к текущей задаче.

`git diff --staged` — это локальный review будущего commit. Если staged diff
читается как одна мысль и совпадает с будущим сообщением commit, граница
commit понятна. Если в staged diff видны лишние файлы или разные темы,
staging нужно пересобрать до `git commit`, а не после review.

## Рабочий порядок перед commit

```
make status
make diff
git diff --staged
make check
git commit -m "..."
```