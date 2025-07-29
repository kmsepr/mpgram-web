FROM php:8.2-cli

# Install required PHP extensions and tools
RUN apt-get update && apt-get install -y \
    unzip git libxml2-dev libonig-dev libgd-dev libffi-dev patch \
    && docker-php-ext-install mbstring xml json fileinfo gmp iconv ffi gd \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/mpgram

# Copy application files
COPY . .

# Set long session lifetime
RUN echo "session.gc_maxlifetime=8640000" > /usr/local/etc/php/conf.d/mpgram.ini

# Copy your actual config values (optional)
# COPY api_values.php ./
# COPY config.php ./

# Install dependencies and apply patches
RUN composer install --no-dev --optimize-autoloader \
 && patch -p0 -N < patches/InternalDoc.php.patch || true \
 && patch -p0 -N < patches/Files.php.patch || true \
 && patch -p0 -N < patches/UpdateHandler.php.patch || true

# Expose port
EXPOSE 8080

# Start the app
CMD ["php", "-S", "0.0.0.0:8080", "-t", "."]