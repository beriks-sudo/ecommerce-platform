# Docker CLI operational playbook

## Command question map

Свяжи pull, run, ps, ps -a, logs, inspect, exec, stop, rm с вопросами, на которые они отвечают.
pull     -> есть ли image локально, нужно ли скачать его из registry?
run      -> создать и запустить container из image
ps       -> что running прямо сейчас?
ps -a    -> что running и что уже exited?
logs     -> что писал foreground process?
inspect  -> какие metadata/config/state знает Docker?
exec     -> выполнить command внутри running container context
stop     -> попросить container/process остановиться
rm       -> удалить stopped container instance

## Observe before action

Опиши ladder: observe, identify, read logs, inspect facts, exec only if running, act, verify, cleanup.
observe  -> docker ps -a
identify -> name, image, command, status, ports
read     -> docker logs <container>
inspect  -> docker inspect <container> when facts are unclear
enter    -> docker exec only if container is running and inspection needs it
act      -> stop, recreate, change config, free port
verify   -> ps, logs, curl, browser, make check
cleanup  -> remove temporary stopped containers you own

Объясни, почему blind restart слабее чтения evidence.
Эта лестница не запрещает restart. Она запрещает blind restart. Restart может быть правильным действием, если process завис, config уже исправлен или нужно перезапустить сервис после изменения. Но restart до чтения logs превращает диагностику в угадывание.

Пример: container exited сразу после запуска. Если ты сразу запускаешь его снова, ты можешь снова получить exit, но не понять причину. Если сначала сделать docker ps -a, ты увидишь status и command. Затем docker logs <name> может показать missing env, permission problem, syntax error или обычное успешное завершение короткого process.
## First evidence

Что ты читаешь в docker ps -a.
“docker ps без флага показывает running containers. docker ps -a показывает также exited и created containers. На beginner-уровне почти всегда полезно смотреть -a, потому что короткий foreground process мог уже завершиться.”
Что показывает docker logs.
показывает stdout/stderr foreground process. Это не все файлы внутри container и не magical debug. Если process пишет ошибку в stdout/stderr, ты увидишь ее. Если приложение пишет logs в файл внутри container, docker logs может не показать нужные details, и тогда придется разбираться, как приложение настроено. Но для Docker beginner-модели stdout/stderr - главный observable output.
Почему exited state нужно связывать с foreground process и exit code.
Если status Exited (0), это может быть штатное завершение. Если Exited (1) или другой ненулевой код, нужно читать logs. Если status Up, но browser не открывает приложение, смотри PORTS: возможно, port не опубликован или опубликован не тот host port.

## Inspect and exec boundaries

Какие facts можно достать через docker inspect --format.
docker inspect lesson03-inspect-nginx --format '{{.State.Status}}'
docker inspect lesson03-inspect-nginx --format '{{.Config.Image}}'
docker inspect lesson03-inspect-nginx --format '{{json .NetworkSettings.Ports}}'
docker inspect lesson03-inspect-nginx --format '{{.State.ExitCode}}'
Почему docker exec работает только для running container.
Если container не running, exec не сработает. Это логично: некуда выполнять command, если runtime context уже остановлен. Для stopped container сначала читают logs и inspect, а не пытаются "зайти внутрь".
Почему exec не должен быть способом постоянной настройки.
Главная граница exec: он полезен для inspection, но плох как способ постоянного изменения среды. Проверить версию nginx - нормально. Посмотреть env - нормально, если не печатаешь секреты в публичный отчет. Установить пакет руками и считать, что теперь проект настроен, - плохая практика. Такая правка не попадет в image или config.
## Cleanup boundaries

Чем отличаются rm, rmi, volume rm, builder prune и system prune.
Какие cleanup-действия разрешены в этой homework.
Какие cleanup-действия запрещены как первый response.