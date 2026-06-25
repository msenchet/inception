FROM debian:bookworm

# Installer PHP-FPM, PHP-MySQL et curl pour récupérer wp-cli
RUN apt-get update && apt-get install -y \
    php8.2-fpm \
    php8.2-mysql \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Télécharger et installer l'outil wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Créer le dossier racine pour WordPress et lui donner les droits
RUN mkdir -p /var/www/wordpress && chown -R www-data:www-data /var/www/wordpress

#Copier la configuration PHP-FPM
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

# Copier le script de démarrage
COPY tools/wordpress_start.sh /usr/local/bin/wordpress_start.sh
RUN chmod +x /usr/local/bin/wordpress_start.sh

# Exposer le port 9000
EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/wordpress_start.sh"]
