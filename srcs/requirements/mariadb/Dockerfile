# Utilise Debian Bookworm comme image de base
FROM debian:bookworm

# Met à jour les paquets, installe le serveur MariaDB et nettoie le cache APT pour réduire la taille de l'image.
# Crée également le dossier requis pour le socket de MariaDB et lui attribue les bonnes permissions.
RUN apt-get update && apt-get install -y mariadb-server && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/run/mysqld \
    && chown -R mysql:mysql /var/run/mysqld \
    && chmod 777 /var/run/mysqld

# Copie le fichier de configuration personnalisé de MariaDB
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Copie le script de configuration et de démarrage
COPY tools/mariadb_start.sh /usr/local/bin/mariadb_start.sh

# Rend le script de démarrage exécutable
RUN chmod +x /usr/local/bin/mariadb_start.sh

# Expose le port par défaut de MariaDB pour les connexions entrantes
EXPOSE 3306

# Définit le script exécuté au démarrage du conteneur pour initialiser et lancer MariaDB
ENTRYPOINT ["/usr/local/bin/mariadb_start.sh"]
