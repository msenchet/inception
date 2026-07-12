#!/bin/bash

# Créer le dossier pour stocker les certificats SSL s'il n'existe pas
mkdir -p /etc/nginx/ssl

# Générer le certificat auto-signé TLS v1.2/v1.3
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=FR/ST=Charente/L=Angouleme/O=42/OU=42/CN=masenche.42.fr/UID=masenche"

# Lancer NGINX au premier plan pour que le conteneur ne s'arrête pas immédiatement
exec nginx -g "daemon off;"
