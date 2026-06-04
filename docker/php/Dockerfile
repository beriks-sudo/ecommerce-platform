FROM php:8.5-cli-alpine

WORKDIR /var/www/html
COPY composer.json ./

RUN php -v

COPY . .
CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]