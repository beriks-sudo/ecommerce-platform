 set -euo pipefail

  # Диагностические подсказки для PhpStorm Docker connection.
  # Только наблюдение: никаких prune / down -v / удаления файлов.

  echo "== Docker contexts (звёздочка = активный) =="
  docker context ls

  echo
  echo "== Docker version (нужны и Client, и Server) =="
  docker version --format 'Client: {{.Client.Version}} | Server: {{.Server.Version}}'

  echo
  echo "Подсказки:"
  echo "- PhpStorm должен использовать тот же context, что активен здесь."
  echo "- Нет секции Server -> IDE тоже не достучится до Engine."
  echo "- Test Connection проверяет только доступ к Engine, не PHP interpreter."
  Потом:
  chmod +x bin/phpstorm-runtime-notes.sh
