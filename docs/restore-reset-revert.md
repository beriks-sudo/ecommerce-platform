Working tree - это твои файлы сейчас. Staging area - это подготовленная корзина будущего commit. Local repository хранит commits у тебя на машине. Published history - это commits, которые уже отправлены в remote и могут быть базой для чужой работы

В feature branch разработчик может заметить, что случайно добавил debug log. Если log еще не staged, подойдет restore. Если staged вместе с полезным файлом, подойдет restore --staged и новый аккуратный add. Если плохой commit уже в shared branch, команда делает revert через PR. В Module 05 мы видели protected main; этот урок объясняет, почему protected main лечится новым проверенным commit, а не локальным переписыванием прошлого.

Я не использую git reset --hard потому что я снимаю файл со staging или просто переделываю локальный комит

