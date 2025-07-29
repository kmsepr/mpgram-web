FROM php:8.2-cli

# Install system dependencies including oniguruma
RUN apt-get update && apt-get install -y \
    unzip git libxml2-dev libonig-dev \
    && docker-php-ext-install mbstring xml json fileinfo gmp

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /app

# Copy all project files
COPY . .

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

EXPOSE 8080

# Run the PHP built-in server
CMD ["php", "-S", "0.0.0.0:8080", "-t", "."]