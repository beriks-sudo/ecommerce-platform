# Release notes v1.5.0

## Tag
`v1.5.0`

## Summary
Релиз добавляет фильтрацию каталога по бренду и исправляет потерю количества
товара в корзине после обновления страницы. Совместимое обновление, без breaking
changes.

## Included changes
- Added: фильтрация каталога по бренду.
- Fixed: сохранение количества в корзине после refresh.
- Operational: обновлены ignore-правила репозитория.

## SemVer impact
Minor release: `1.4.x → 1.5.0`.
Самый сильный сигнал в выпуске — `feat` (новая совместимая возможность),
breaking changes отсутствуют, поэтому растёт MINOR, а не PATCH или MAJOR.

## Checks
- `make check`
- QA smoke: ручная проверка оформления заказа (checkout flow)

## Risks
- Низкий. Изменения совместимы, новых обязательных миграций нет.
- Возможный регресс: фильтр каталога под нагрузкой — покрыть smoke-проверкой.

## Rollback
Если checkout smoke падает — повторно задеплоить artifact версии `v1.4.0`.

## Owner
Release manager: <username>.