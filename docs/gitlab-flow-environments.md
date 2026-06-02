- Branch (ветка) — Git ref, ссылка на линию коммитов. Это история кода.
  Отвечает на вопрос "какая линия истории". Сама по себе нигде не запущена.
- Pipeline — процесс, который берёт commit, собирает его и прогоняет проверки
  (тесты, lint, build). Отвечает на вопрос "прошёл ли этот commit проверки".
- Artifact — результат сборки pipeline, зафиксированная "коробка" с готовым
  кодом. Именно её деплоят. Отвечает на вопрос "что именно мы выкатываем".
- Environment (среда) — место, где запущен конкретный artifact: review app,
  dev, staging, production. Отвечает на вопрос "что сейчас работает где".

Связь между ними: branch -> pipeline собирает commit -> получается artifact ->
artifact запускается в environment. Имя ветки не равно работающей среде:
ветка `production` может указывать на commit, который нигде не запущен.


feature/* -> MR -> pipeline/review app -> main -> staging -> approval -> production

Это барьеры при продвижении artifact между средами (отдельно от merge gate,
который пускает код в main).

Перед staging проверяется:
- pipeline main зелёный (CI прошёл);
- artifact собран из известного commit (SHA зафиксирован);
- готовность принять среду на acceptance/smoke проверку.

Перед production проверяется:
- тот же artifact уже проверен на staging (а не новая сборка);
- QA / release owner дал явный approval;
- известен rollback path (на какой предыдущий artifact откатываться);
- права на deploy в protected environment у того, кто выкатывает.

Merge gate (review, CI, protected main) и deployment gate (staging acceptance,
production approval) — разные решения. "Код хороший" не равно "можно на боевой".

## Environment branch variant

Иногда команда заводит ветки `staging` или `production`, чтобы среда
деплоилась из соответствующей ветки (deployment branch model).

Когда может понадобиться: если платформа деплоит автоматически из ветки, или
нужно явно отделять, какой commit "назначен" в среду, или окружений много и
команда хочет видеть назначение через ветки.

Какой drift risk это добавляет: ветка `production` — это просто ссылка на
commit, а не работающая среда. Возникает риск расхождения (drift): ветка
`production` указывает на один commit, а production environment реально
запущен на artifact из другого commit. Тогда branch model выглядит солидно,
а deployed state непроверяем. Если выбираешь этот вариант, обязательно
зафиксируй: кто двигает ветку, какие approvals нужны, как artifact
продвигается между средами, и сверяй deployed SHA со ссылкой ветки.
Три типичные ошибки от смешения branch / pipeline / artifact / environment:

1. "QA проверила staging branch" без указания версии.
   Проблема: непонятно, какой именно commit/artifact проверен. При инциденте
   неизвестно, что откатывать. Фикс: всегда привязывать проверку к SHA или
   artifact id — "QA одобрила artifact из commit 8f31c2a на staging".

2. Создали ветку `production` и считают, что это и есть production.
   Проблема: ветка может указывать на commit, который нигде не запущен, а
   среда работает на другом artifact. Фикс: различать ветку (история) и
   environment (что реально запущено); сверять deployed SHA.

3. В production задеплоили новую сборку, а не тот artifact, что проверяли.
   Проблема: на staging проверяли одну "коробку", а в production уехала
   другая (пересобрали из main заново) — проверка staging обесценена. Фикс:
   продвигать тот же самый artifact между средами, а не пересобирать.