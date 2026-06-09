кто от кого зависит
что считается readiness для каждой зависимости
почему depends_on без healthcheck не равен готовности

app (повар) зависит от mysql (нужна база для данных) и от redis (нужен кэш)
web (официант) зависит от app — без повара ему нечего подавать гостю
mysql и redis ни от кого не зависят — они «базовые», стартуют сами по себе

app -> mysql: нужен SQL connection, readiness = healthy mysql
app -> redis: нужен Redis PING, readiness = healthy redis
web -> app: нужен PHP-FPM порт, readiness = app process running или app health endpoint


о базовый depends_on без условия не гарантирует готовность сервиса. Он не проверяет, принимает ли MySQL SQL-запросы и отвечает ли Redis на PING. Поэтому запись:

services:
app:
depends_on:
- mysql
- redis
означает порядок старта, а не readiness. Это полезно, но недостаточно для спокойного первого запуска. Если нужна более точная модель, у зависимости должен быть healthcheck, а у зависимого сервиса - условие:

services:
app:
depends_on:
mysql:
condition: service_healthy
redis:
condition: service_healthy

mysql:
image: mysql:8.4
healthcheck:
test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
interval: 5s
timeout: 3s
retries: 20
start_period: 20s