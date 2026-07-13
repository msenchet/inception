# Utiliser l'avant-dernière version stable de Debian
FROM debian:bookworm

# Installer NGINX et OpenSSL, puis nettoyer le cache pour optimiser la taille de l'image
RUN apt-get update && apt-get install -y nginx openssl && rm -rf /var/lib/apt/lists/*

# Copier le fichier de configuration personnalisé à l'emplacement de NGINX
COPY conf/nginx.conf /etc/nginx/sites-available/default

# Copier le script de démarrage et lui donner les droits d'exécution
COPY tools/nginx_start.sh /var/www/nginx_start.sh
RUN chmod +x /var/www/nginx_start.sh

# Exposer le port 443
EXPOSE 443

# Définir le script comme commande de démarrage du conteneur
ENTRYPOINT ["/var/www/nginx_start.sh"]
