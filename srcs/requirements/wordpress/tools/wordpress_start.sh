#!/bin/bash

# Attendre un court instant que MariaDB soit opérationnelle
sleep 10

# Se déplacer dans le dossier du site web
cd /var/www/wordpress

# Si WordPress n'est pas encore installé
if [ ! -f "wp-config.php" ]; then
    # 1. Télécharger WordPress via wp-cli
    wp core download --allow-root

    # 2. Créer le fichier wp-config.php avec les variables d'environnement
    wp config create --allow-root \
        --dbname="${SQL_DATABASE}" \
        --dbuser="${SQL_USER}" \
        --dbpass="${SQL_PASSWORD}" \
        --dbhost="mariadb:3306"

    # 3. Installer le site (Configuration de l'admin principal requis sans le mot "admin")
    wp core install --allow-root \
        --url="${DOMAIN_NAME}" \
        --title="Inception_42" \
        --admin_user="wp_super_user" \
        --admin_password="${SQL_ROOT_PASSWORD}" \
        --admin_email="masenche@student.42.fr"

    # 4. Créer le second utilisateur classique (requis par le sujet)
    wp user create --allow-root \
        "wp_normal_user" "normal@example.com" \
        --user_pass="${SQL_PASSWORD}" \
        --role='author'
fi

# S'assurer que le dossier d'exécution de PHP existe
mkdir -p /run/php

# Lancer PHP-FPM au premier plan (Foreground) pour Docker
exec php-fpm8.2 -F
