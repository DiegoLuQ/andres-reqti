FROM php:8.2-apache

# Instalar dependencias del sistema y extensiones de PHP
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    zip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo pdo_mysql mysqli zip \
    && a2enmod rewrite

# Corregir el aviso del ServerName y configurar el DocumentRoot
# Ajusta /public si tu index.php está dentro de una carpeta public
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf \
    && sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# Establecer permisos para que Apache pueda escribir
RUN chown -R www-data:www-data /var/www/html

WORKDIR /var/www/html