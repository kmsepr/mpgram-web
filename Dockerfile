FROM php:8.2-cli

# Install system dependencies
RUN apt-get update && apt-get install -y \
    unzip git libxml2-dev libonig-dev patch \
    && docker-php-ext-install mbstring xml json fileinfo gmp

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/mpgram

# Copy the application
COPY . .

# Install PHP dependencies and apply patches
RUN composer install --no-dev --optimize-autoloader \
 && patch -p0 -N < patches/InternalDoc.php.patch || true \
 && patch -p0 -N < patches/Files.php.patch || true \
 && patch -p0 -N < patches/UpdateHandler.php.patch || true

# Expose port and run PHP built-in server
EXPOSE 8080
CMD ["php", "-S", "0.0.0.0:8080", "-t", "."]