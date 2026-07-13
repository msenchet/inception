#!/bin/bash

# On utilise directement la variable d'environnement SQL_PASSWORD transmise via le fichier .env

# Se déplacer dans le dossier du site web
cd /var/www/wordpress

# Attendre que MariaDB soit pleinement opérationnelle
echo "Waiting for MariaDB database to be ready..."
while ! php -r "
\$mysqli = @new mysqli('mariadb', '${SQL_USER}', '${SQL_PASSWORD}', '${SQL_DATABASE}', 3307);
if (\$mysqli->connect_error) {
	exit(1);
}
"; do
	sleep 2
done
echo "MariaDB is ready!"

# Si WordPress n'est pas encore installé
if [ ! -f "wp-config.php" ]; then
	# 1. Télécharger WordPress via wp-cli
	wp core download --allow-root

	# 2. Créer le fichier wp-config.php avec les variables d'environnement de connexion
	wp config create --allow-root \
		--dbname="${SQL_DATABASE}" \
		--dbuser="${SQL_USER}" \
		--dbpass="${SQL_PASSWORD}" \
		--dbhost="mariadb:3307"

	# 3. Installer le site (Configuration de l'administrateur principal)
	wp core install --allow-root \
		--url="${DOMAIN_NAME}" \
		--title="Inception_42" \
		--admin_user="${WP_ADMIN_USER}" \
		--admin_password="${WP_ADMIN_PASSWORD}" \
		--admin_email="${WP_ADMIN_EMAIL}"

	# 4. Créer le premier et le deuxième utilisateur non admin
	wp user create --allow-root \
		"${WP_USER}" "${WP_USER_EMAIL}" \
		--user_pass="${WP_PASSWORD}" \
		--role='author'
	
	wp user create --allow-root \
		"${WP_USER2}" "${WP_USER2_EMAIL}" \
		--user_pass="${WP_PASSWORD2}" \
		--role='author'
	
fi

# S'assurer que le dossier web appartient bien à l'utilisateur PHP (www-data)
chown -R www-data:www-data /var/www/wordpress

# S'assurer que le dossier d'exécution de PHP (pid, sock) existe
mkdir -p /run/php

# Lancer PHP-FPM au premier plan (Foreground) pour Docker
exec php-fpm8.2 -F

