FROM php:8.2-apache

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    unzip \libzip-dev \curl \git \libpng-dev \libjpeg-dev \libfreetype6-dev \libicu-dev \libxml2-dev \libonig-dev \
    && rm -rf /var/lib/apt/lists/*

# Instalar extensões PHP
RUN docker-php-ext-install pdo_mysql mbstring intl pdo json curl zip

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configurar diretório de trabalho
WORKDIR /var/www/html

# Copiar e descompactar aplicação (se existir)
COPY app.zip /var/www/html/
RUN if [ -f "app.zip" ]; then \
        unzip app.zip && rm app.zip; \
    fi

# Copiar composer.json e composer.lock (se existirem)
COPY composer.json ./
COPY composer.loc[k] ./

# Instalar dependências PHP via Composer
RUN if [ -f "composer.json" ]; then \
        composer install --no-dev --optimize-autoloader; \
    fi

# Configurar Apache
RUN a2enmod rewrite
RUN echo "DirectoryIndex index.php login.php" > /etc/apache2/conf-available/custom-directoryindex.conf \
    && a2enconf custom-directoryindex

# Configurar permissões
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Expor porta
EXPOSE 80

# Comando de inicialização
CMD ["apache2-foreground"]
