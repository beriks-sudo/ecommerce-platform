Trunk based development начинается не с запрета branches. Он начинается с идеи, что у команды есть одна короткая здоровая линия интеграции. В большинстве современных Git repositories этой линией является main. Все значимые изменения быстро возвращаются в trunk, чтобы команда постоянно видела общий продукт, а не несколько расходящихся будущих версий.

Неверная beginner-интуиция звучит так: "если мы trunk based, значит все push прямо в main". Это опасное упрощение. Зрелый trunk может принимать изменения через short-lived branches, pull requests, merge requests, required checks и review. Важна не физическая невозможность создать branch, а короткая жизнь branch и быстрый возврат изменения в общую линию.


short branch -> PR/MR -> checks/review -> trunk -> deploy or release

Unhealthy pseudo-trunk:
homework-v3-08-02-trunk-based-development lives 3 weeks
team keeps rebasing and resolving drift
CI is ignored
merge lands near release date
production risk appears late

Команда готова к trunk based, когда может ответить "да" по каждому пункту:

- [ ] Branch lifetime — ветки короткоживущие (1–2 дня), а не недели.
- [ ] PR size — PR маленький, изменение можно понять, проверить и откатить
  за один review.
- [ ] CI speed — CI быстрый, его результата ждут до merge, а не игнорируют.
- [ ] Flaky tests ownership — у нестабильных тестов есть owner, который их
  чинит; красный сигнал означает действие, а не шум.
- [ ] Review latency — есть договорённость о времени реакции на PR (часы,
  а не неделя), иначе короткие ветки превращаются в долгие.
- [ ] Feature flags / exposure gates — есть способ влить код в trunk, но
  держать незавершённое поведение выключенным; deploy и exposure —
  разные решения.
- [ ] Monitoring — после деплоя видно эффект изменения (метрики, логи,
  ошибки), чтобы заметить проблему быстро.
- [ ] Rollback — откат дешёвый и описан: предыдущий known-good артефакт,
  revert через PR или flag-off за минуты.

## Required gates

Каждое изменение проходит проверяемые барьеры до попадания в trunk:

1. Local `make check` — author preflight: тесты и линтер локально перед PR.
   Отсекает очевидные ошибки, чтобы CI и review не тратили время на базовое.
2. CI — required status checks (тесты, lint, build). Красный CI блокирует
   merge в protected main.
3. Review approval — reviewer смотрит diff и risk, апрувит маленькое
   понятное изменение.
4. Protected main — direct push запрещён; изменения только через PR;
   failing checks блокируют merge.
5. Rollback note — для изменения известно, как откатиться (предыдущий
   артефакт / revert / flag-off) до того, как его выкатывают.

Принцип: trunk получает только то, что автор уже проверил и что прошло
gates, а не то, что брошено в pipeline на удачу.

## When not to use yet

Trunk based рискован и пока преждевременен, если выполнено хотя бы одно из:

1. CI медленный и flaky — результата нельзя дождаться или ему нельзя верить,
   поэтому красный сигнал игнорируют, и сломанное попадает в main.
   Сначала: ускорить и стабилизировать checks.
2. Review занимает дни/неделю — ветки вынужденно живут долго и копят merge
   debt. Сначала: уменьшить PR и договориться о времени реакции.
3. Нет способа скрыть незавершённое поведение — нет feature flags и нет
   slicing, поэтому merge незавершённого = риск показать его в production.
   Сначала: ввести flags или резать задачи на mergeable шаги.
4. Дорогой rollback / неизвестно, что выкатилось — при плохом деплое нет
   быстрого отката и нет связи tag ↔ commit ↔ deploy. Сначала: написать
   rollback playbook и наладить release tracking.

Процесс выбирают под готовность команды, а не наоборот. Если какой-то
constraint выполнен, честнее сначала его закрыть, а уже потом называть
процесс trunk based.

## Feature slicing example

Большую фичу "new checkout" не вливаем одной веткой на три недели, а режем
на маленькие mergeable шаги. Каждый шаг проходит свой review и CI, поведение
скрыто за выключенным флагом до явного включения:

1. Add checkout service skeleton behind disabled flag
   (каркас, флаг выключен — пользователь ничего не видит).
2. Add validation for shipping address
   (валидация адреса, всё ещё за флагом).
3. Add payment timeout handling
   (обработка таймаута оплаты, отдельный маленький diff).
4. Enable new checkout for internal users
   (включаем флаг только для внутренних пользователей).
5. Expand flag to 10 percent
   (постепенно расширяем exposure, следим за monitoring).