create branch -> commit -> push -> pull request -> review/checks -> merge to protected main -> deploy

GitHub protected branches позволяют требовать pull request review, status checks, linear history, ограничения push и другие правила: https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches. Rulesets расширяют эту модель и позволяют применять наборы правил к branches и tags: https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets. Эти настройки являются платформенной частью контракта, который ты описываешь словами в homework

- Branch is short-lived and based on current main
- make check passes locally
- CI is green
- Reviewer understands scope and risk
- No direct push to main
- Rollback or revert path is written
- Release impact is clear

make check, git diff --check, passing CI, review approval, protected main


После этого PR description отвечает на вопросы reviewer: зачем изменение, какой scope, какие checks прошли, какой риск, как откатиться, есть ли release impact. Если изменение видимое, нужны screenshots или короткое описание поведения. Если изменение касается migration, background job, API или config, это нужно назвать явно. В Git course мы пока пишем workflow docs, но привычка к risk note закладывается здесь.

Хороший PR checklist не должен быть формальностью на десять галочек. Он должен останавливать реальные ошибки. Например:

- Branch is short-lived and based on current main
- make check passes locally
- CI is green
- Reviewer understands scope and risk
- No direct push to main
- Rollback or revert path is written
- Release impact is clear
  Неправильная версия: main protected на бумаге, но admin постоянно нажимает bypass, потому что CI flaky. Это не ускорение, а разрушение сигнала. Правильная реакция: назначить CI owner, стабилизировать tests, временно карантинировать flaky check с явным issue, но не превращать bypass в normal path. Если правило постоянно обходится, оно либо неверно выбрано, либо не поддержано инфраструктурой.

PR discipline также защищает от слишком больших changes. Reviewer не должен угадывать, что скрыто в PR на 70 files. Если diff большой, автор делит работу на smaller PRs или заранее пишет план review. Это особенно важно для будущих Laravel проектов: один PR может трогать routes, controllers, policies, migrations, frontend components и tests. Без discipline review превращается в просмотр глазами, а не в инженерную проверку.

Protected main не отменяет доверие в команде. Он делает доверие воспроизводимым. Новый разработчик, опытный maintainer и release owner работают через одинаковый gate. Когда все зеленое и review завершен, merge не зависит от личной памяти. Когда что-то красное, команда видит конкретный stop signal и разбирает причину.