# DEV_DOC.md — Developer Documentation

This document describes how to set up, build, and manage the Inception development environment.

## 1. Setting Up the Environment from Scratch

### Prerequisites
* A Linux-based environment (or VM) with Docker (Engine & Compose) installed.
* GNU Make.

### Directory Structure setup
Ensure your workspace matches the expected layout:
```text
.
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        ├── nginx/
        └── wordpress/
```

### Environment Configuration
1. Configure the local environment file `srcs/.env` (and `.env` at the root) with your host domain, credentials (database password, database root password, WordPress admin credentials, etc.), and system configurations.
2. Make sure the `.env` file is ignored by Git (already listed in `.gitignore`).

---

## 2. Building and Launching the Project
The project uses a `Makefile` to simplify operations:

* **Build and Run:** Run `make` to initialize the database directories, build custom Dockerfiles, and launch the containers in the background.
* **Stop Container Lifecycle:** Run `make down` to cleanly stop containers and tear down the network.
* **Rebuild:** Run `make re` to perform a clean rebuild of all containers and services.

---

## 3. Management and Troubleshooting Commands

### inspect container configuration
```bash
docker inspect <container_name>
```

### Enter a Container's Shell
To inspect the internals of a service (e.g., WordPress configuration or database files):
```bash
docker exec -it wordpress bash
docker exec -it mariadb bash
docker exec -it nginx bash
```

### Inspect the Docker Network
To see how the containers are connected and their internal IP addresses:
```bash
docker network inspect inception_network
```

### Inspect Named Volumes
```bash
docker volume ls
docker volume inspect srcs_mariadb_data
docker volume inspect srcs_wordpress_data
```

---

## 4. Persistent Storage and Data Directories
The services persist data outside of the container's volatile filesystem. The named volumes are defined to bind-mount to the host's directory structure:

* **MariaDB Database Files:** Stored on the host in `/home/masenche/data/mariadb` and mounted to `/var/lib/mysql` inside the `mariadb` container.
* **WordPress Website Files:** Stored on the host in `/home/masenche/data/wordpress` and mounted to `/var/www/wordpress` inside both the `wordpress` and `nginx` containers.

*Note: In the Makefile, `make fclean` will delete these host data directories, resetting the database and website files back to a clean state.*

---

## 5. LIEN ENTRE HOTE ET VM

Objectif:
Utiliser une clé SSH présente sur la machine hôte depuis une VM.
La clé privée reste uniquement sur l'hôte.
Dans l'hôte:
1/ Récupérer l'IP de l'hôte:
```bash
ifconfig | awk '/inet 10\./ {print $2}'
```

2/ Créer un relais TCP sur un port entre 1024 et 49151:
```bash
socat TCP-LISTEN:<port>,reuseaddr,fork UNIX-CONNECT:$SSH_AUTH_SOCK
```

3/ ⚠️Laisser ce terminal ouvert.

Dans la VM:
1/ Installer socat sur la machine virtuelle:
```bash
sudo apt install socat
```

2/ Supprimer l'ancien socket (si existant):
```bash
rm -f /tmp/ssh-agent.sock
```

3/ Créer un socket local qui pointe vers l'hôte:
```bash
socat UNIX-LISTEN:/tmp/ssh-agent.sock,fork TCP:<IP_hôte>:<port>
```

4/ ⚠️Laisser ce terminal ouvert.

5/ Activer l'agent SSH dans la VM dans un nouveau terminal:
```bash
export SSH_AUTH_SOCK=/tmp/ssh-agent.sock
```


Tester la connexion:
1/ Vérifier que la VM voit la clé :
```bash
ssh-add -l
```

2/ Tester la connexion SSH:
```bash
ssh -T <site_du_repo>
```

3/ Si l'authentification fonctionne :
```bash
git clone <repo_git>
```


4/ Vous pouvez stopper les socat côté hôte et VM (le lien sera rompu).

