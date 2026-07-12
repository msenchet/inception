#!/bin/bash

# On utilise directement les variables d'environnement SQL_PASSWORD et SQL_ROOT_PASSWORD transmises via le fichier .env

# Initialisation et configuration uniquement au premier démarrage
if [ -n "${SQL_DATABASE}" ] && [ ! -d "/var/lib/mysql/${SQL_DATABASE}" ]; then
    if [ ! -d "/var/lib/mysql/mysql" ]; then
        mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null
    fi

    # Démarrage temporaire de MariaDB pour exécuter la configuration SQL
    mysqld_safe --user=mysql --datadir=/var/lib/mysql &
        
    while ! mysqladmin ping --silent; do
        sleep 1
    done

    # Sécurisation et création de la base de données / utilisateur
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
    mysql -u root -p"${SQL_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
    mysql -u root -p"${SQL_ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
    mysql -u root -p"${SQL_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';"
    mysql -u root -p"${SQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"
    
    # Arrêt du service temporaire
    mysqladmin -u root -p"${SQL_ROOT_PASSWORD}" shutdown
fi

# Lancer MariaDB au premier plan pour Docker
exec mysqld_safe --user=mysql --datadir=/var/lib/mysql

