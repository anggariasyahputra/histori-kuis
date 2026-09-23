# Build Client Stage
FROM node:alpine AS node-builder
WORKDIR /app
COPY frontend/package*.json ./
RUN npm install
COPY frontend .
RUN cp -n .env.example .env && \
    npm run build

# Laravel Stage
FROM php:8.2-fpm-alpine AS php-laravel

# Install pre-compiled PHP extensions & Nginx (much faster than compiling from source)
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN apk add --no-cache nginx \
    && install-php-extensions gd intl opcache pdo_mysql zip ftp redis

WORKDIR /var/www/college-quiz-app
COPY backend .

# Install Composer dependencies
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
RUN composer install --no-cache --optimize-autoloader --no-dev && \
    php artisan config:clear && \
    php artisan event:clear && \
    php artisan route:clear && \
    php artisan view:clear && \
    rm -f storage/logs/laravel.log && \
    rm -rf storage/framework/sessions/* && \
    php artisan optimize && \
    rm /usr/local/bin/composer

# Copy the built frontend assets to the Laravel public directory
COPY --from=node-builder /app/dist /var/www/college-quiz-app/public
COPY --from=node-builder /app/dist/index.html /var/www/college-quiz-app/resources/views/index.blade.php

# Grant permissions
RUN chown -R www-data:www-data /var/www/college-quiz-app/storage /var/www/college-quiz-app/bootstrap/cache
RUN chown -R 775 /var/www/college-quiz-app/storage/logs

# Handle uploads
RUN mkdir -p /var/www/college-quiz-app/storage/uploads && \
    chown -R www-data:www-data /var/www/college-quiz-app/storage/uploads && \
    chmod -R 775 /var/www/college-quiz-app/storage/uploads

# Extra stuff: config, logging,...
COPY ./docker/php/php.ini /usr/local/etc/php/php.ini
COPY ./docker/nginx/default.conf /etc/nginx/http.d/default.conf
COPY ./docker/cronjob /etc/crontabs/root
COPY ./docker/php/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
COPY ./docker/php/docker-php-ext-opcache.ini /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini

# Handle php-fpm via unix socket
RUN mkdir -p /var/run/php-fpm && \
    chown -R www-data:www-data /var/run/php-fpm

EXPOSE 80

CMD ["sh", "-c", "php-fpm & nginx -g 'daemon off;' & crond -f"]
