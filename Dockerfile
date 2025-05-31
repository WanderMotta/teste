# Dockerfile para PHP 8.1 com Apache
FROM php:8.1-apache

# Instalar dependências do sistema e extensões PHP
RUN apt-get update && apt-get install -y \
    libicu-dev \
    libzip-dev \
    unzip \
    git \
    zip \
    && docker-php-ext-install intl pdo pdo_mysql zip

# Ativar mod_rewrite do Apache
RUN a2enmod rewrite

# Definir fuso horário
RUN echo "date.timezone=America/Sao_Paulo" > /usr/local/etc/php/conf.d/timezone.ini

# Definir diretório de trabalho
WORKDIR /var/www/html

# Copiar e descompactar app.zip
COPY app.zip /var/www/html
RUN unzip /var/www/html/app.zip -d /var/www/html && rm /var/www/html/app.zip

# Definir permissões
RUN chown -R www-data:www-data /var/www/html

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Definir página inicial padrão
RUN echo '<IfModule mod_dir.c>\n    DirectoryIndex login.php index.php\n</IfModule>' > /etc/apache2/conf-available/custom-dir.conf \
    && a2enconf custom-dir

# Expor porta
EXPOSE 80

# nginx.conf para proxy reverso com HTTPS
events {}

http {
    server {
        listen 80;
        server_name _;
        return 301 https://$host$request_uri;
    }

    server {
        listen 443 ssl;
        server_name _;

        ssl_certificate /etc/nginx/certs/cert.pem;
        ssl_certificate_key /etc/nginx/certs/key.pem;

        location / {
            proxy_pass http://php-apache:80;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
