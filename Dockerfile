# Dockerfile para PHP 8.1 com Apache
from php:8.1-apache

# Instalar dependências do sistema e extensões PHP
run apt-get update && apt-get install -y \
    libicu-dev \
    libzip-dev \
    unzip \
    git \
    zip \
    && docker-php-ext-install intl pdo pdo_mysql zip

# Ativar mod_rewrite do Apache
run a2enmod rewrite

# Definir fuso horário
run echo "date.timezone=America/Sao_Paulo" > /usr/local/etc/php/conf.d/timezone.ini

# Definir diretório de trabalho
workdir /var/www/html

# Copiar e descompactar app.zip
copy app.zip /var/www/html
run unzip /var/www/html/app.zip -d /var/www/html && rm /var/www/html/app.zip

# Definir permissões
run chown -R www-data:www-data /var/www/html

# Composer
copy --from=composer:latest /usr/bin/composer /usr/bin/composer

# Definir página inicial padrão
run echo '<IfModule mod_dir.c>\n    DirectoryIndex login.php index.php\n</IfModule>' > /etc/apache2/conf-available/custom-dir.conf \
    && a2enconf custom-dir

# Expor porta
expose 80
