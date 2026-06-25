# USER_DOC.md — User Documentation

This guide explains how to use, run, and check the services provided by the Inception stack.

## 1. Services Provided by the Stack
* **NGINX:** The secure entrypoint for all traffic. It listens on port 443 only and implements TLS v1.2/v1.3 protocols to serve the website securely.
* **WordPress + PHP-FPM:** The content management system (CMS) running PHP scripts to power the blog/website.
* **MariaDB:** The database backend storing WordPress posts, users, configurations, and metadata.

## 2. Starting and Stopping the Project

### Start the project
Run the following command at the root of the project:
```bash
make
```
This builds the required custom images, creates directories on the host, and starts all containers in the background.

### Stop the project
To stop and shut down the containers while preserving data:
```bash
make down
```

---

## 3. Accessing the Website and Administration Panel

### DNS configuration (First time only)
You must ensure that your host's local resolution file resolves `masenche.42.fr` to your local environment. Add the following line to `/etc/hosts`:
```text
127.0.0.1    masenche.42.fr
```

### Accessing the Web Interface
* **Public Site:** Open your browser and navigate to: `https://masenche.42.fr`
* **WordPress Admin Panel:** Navigate to: `https://masenche.42.fr/wp-admin`

*Note: Since the SSL certificate is self-signed for development purposes, your browser will display a security warning. You can safely proceed by bypassing the warning (e.g., clicking "Advanced" -> "Proceed to masenche.42.fr").*

---

## 4. Locating and Managing Credentials
Credentials and passwords are NOT committed to version control. They are stored locally on the host machine:
* **Docker Secrets Directory:** Located at `secrets/` at the root of the project.
  * `secrets/db_password.txt` contains the password for the database user.
  * `secrets/db_root_password.txt` contains the MariaDB root password.
  * `secrets/credentials.txt` contains a summary of user credentials.
* **Environment Configuration:** Located at `srcs/.env` (contains non-secret variables and admin email/usernames).

To change credentials, modify these files and rebuild the containers:
```bash
make re
```

---

## 5. Checking that the Services are Running Correctly

You can verify the status of the containers using standard Docker commands:

### List running containers
```bash
docker ps
```
All three containers (`nginx`, `wordpress`, `mariadb`) should have a status of `Up`.

### View container logs
If a service is not behaving as expected, check its logs:
```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```
