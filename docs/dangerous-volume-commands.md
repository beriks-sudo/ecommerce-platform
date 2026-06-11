что обычный docker compose down не удаляет named volumes
что docker compose down -v может удалить данные базы
почему down -v не входит в make check и обычный workflow
когда reset допустим только осознанно

docker compose down      → закрыть ресторан на ночь. СКЛАД (volume) ЦЕЛ → база сохранилась
docker compose down -v    → закрыть И ВЫВЕЗТИ СКЛАД НА СВАЛКУ → данные базы УНИЧТОЖЕНЫ
down -v — это не уборка, а осознанный сброс.