FROM php:8.2-cli

# Install dependencies
RUN apt-get update && apt-get install -y \
    unzip git libxml2-dev \
    && docker-php-ext-install mbstring xml json fileinfo gmp

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app
COPY . .

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

EXPOSE 8080
CMD ["php", "-S", "0.0.0.0:8080", "-t", "."]
