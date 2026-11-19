FROM php:8.5-fpm-alpine

# PHP extensions Laravel needs beyond the image defaults
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions pdo_pgsql bcmath intl zip pcntl

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

WORKDIR /var/www/html

# Source is bind-mounted in docker-compose.yml; this copy makes the image usable on its own too
COPY . .
RUN if [ ! -d vendor ]; then composer install --no-interaction --prefer-dist; fi \
    && chown -R www-data:www-data storage bootstrap/cache

EXPOSE 9000
CMD ["php-fpm"]
