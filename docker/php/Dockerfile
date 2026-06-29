FROM composer:2 AS builder

WORKDIR /app

COPY composer.json ./
RUN composer install --no-dev --no-interaction --prefer-dist

COPY . .

FROM php:8.5-cli-alpine AS runtime

# curl нужен для healthcheck (probe дергает /health.php),
# pdo_mysql — для readiness-проверки реального подключения к БД в public/health.php
RUN apk add --no-cache curl \
    && docker-php-ext-install pdo_mysql

ARG BUILD_MODE=production
ENV APP_DIR=/var/www/html

WORKDIR ${APP_DIR}

COPY --from=builder /app ${APP_DIR}

RUN echo "Build mode: ${BUILD_MODE}"

CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]