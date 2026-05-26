<<<<<<< HEAD
Базовый текст 3
=======
Базовый текст 2
>>>>>>> practice/conflict-incoming

# Conflict explanation — Module 04, Lesson 5

## Что означают markers
В конфликтном файле Git записывает обе версии и помечает их служебными строками:

    marker: <<<<<<< HEAD                          — версия текущей ветки (target), куда вливаем
    marker: =======                               — separator между двумя версиями
    marker: >>>>>>> practice/conflict-incoming    — incoming side, версия вливаемой ветки

Префикс `marker:` стоит специально, чтобы `git diff --check` не принял этот
учебный пример за незакрытый конфликт.

## Почему возник conflict
Conflict был в <ВСТАВЬ имя файла, например docs/base-text.md>.
Обе ветки изменили одну и ту же строку: текущая ветка (HEAD) записала туда
"Базовый текст 3", а ветка practice/conflict-incoming записала "Базовый текст 2".
Так как изменён один и тот же участок, Git остановил автоматическое слияние —
он не может решить за человека, какое из двух значений верное.

## Намерение каждой стороны
- Текущая (HEAD): версия с содержанием "Базовый текст 3".
- Incoming (practice/conflict-incoming): версия с содержанием "Базовый текст 2".

## Итоговое решение
Итог сохраняет обе строки, чтобы не потерять содержание ни одной из сторон:

    Базовый текст 2
    Базовый текст 3

Маркеры (<<<<<<<, =======, >>>>>>>) удалены, обе версии не оставлены как
конфликтный блок — собран единый корректный вариант с обоими значениями.

## Проверка после решения
    make check
    git status --short
    git diff --check

git diff --check дополнительно ловит оставшиеся conflict markers в diff.

## Пример review comment
> Conflict был в <ВСТАВЬ имя файла>.
> Из текущей ветки (HEAD) сохранил строку "Базовый текст 3".
> Из incoming (practice/conflict-incoming) сохранил строку "Базовый текст 2".
> Объединил обе строки, чтобы не потерять содержание ни одной стороны.
> Проверено через make check, git status --short и git diff --check.

## Контракт Module 04
- SSH work URL: origin  git@github.com:beriks-sudo/ecommerce-platform.git (fetch)

- HTTPS review URL: https://github.com/beriks-sudo/ecommerce-platform.git