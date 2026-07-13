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

## 3. Accessing the Website and Administration Panel

### DNS configuration (first time only)

You must ensure that your host's local resolution file resolves `masenche.42.fr` to your local environment. Add the following line to `/etc/hosts`:

```
127.0.0.1    masenche.42.fr
```

### Accessing the Web Interface

* **Public Site:** Open your browser and navigate to: `https://masenche.42.fr`
* **WordPress Admin Panel:** Navigate to: `https://masenche.42.fr/wp-admin`

> **Note:** Since the SSL certificate is self-signed for development purposes, your browser will display a security warning. You can safely proceed by bypassing the warning (e.g., clicking "Advanced" → "Proceed to masenche.42.fr").

## 4. Locating and Managing Credentials

Credentials and passwords are **NOT** committed to version control. They are stored locally on the host machine in the environment configuration file:

* **Environment Configuration:** Located at `srcs/.env` (and replicated at `.env` at the root), which contains both stack configurations and credentials (database passwords, administrator passwords, etc.).

To change credentials, modify the `srcs/.env` file and rebuild the containers:

```bash
make re
```

## 5. Checking that the Services Are Running Correctly

You can verify the status of the containers using standard Docker commands.

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

## 6. Database Administration (MariaDB)

To inspect the database frontend or verify data persistence during evaluation, you can interact directly with the MariaDB container.

### Enter the MariaDB interactive console

Run the following command from your host terminal to log into the database using your environment credentials:

```bash
docker exec -it mariadb mysql -u masenche -puserpass123 inception
```

### Show tables inside the database

Once connected to the `MariaDB [inception]>` prompt, you can list all existing tables (including standard WordPress tables) by running:

```sql
SHOW TABLES;
```

⚠️ Do not forget the trailing semicolon (`;`), otherwise the terminal will wait for input.

### Create a new table

To test or demonstrate on-the-fly table creation inside the database console, execute:

```sql
CREATE TABLE wp_test (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Inspect the created table

To verify that your custom table exists and view its structural columns:

```sql
DESCRIBE wp_test;
```

To exit the MariaDB monitor and return to your shell, type:

```sql
exit
```
