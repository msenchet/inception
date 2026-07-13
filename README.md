*This project has been created as part of the 42 curriculum by masenche.*

## Description
This project, **Inception**, aims to broaden knowledge of system administration, virtualization, and infrastructure design by utilizing Docker. It involves setting up a multi-container local stack utilizing Docker Compose to configure and run three services: Nginx (with TLS v1.2/v1.3), WordPress with PHP-FPM, and MariaDB. Each service runs in its own dedicated, isolated container, communicating over a secure custom bridge network with persistent data volumes.

## Project Description & Technical Choices
This system administration project implements a secure, containerized web application infrastructure. The container design adheres to Docker best practices (PID 1 optimization, single concern per container, and environment-based configuration via `.env` file).

### Comparisons

#### 1. Virtual Machines vs Docker
* **Architecture:** Virtual Machines (VMs) run a complete guest operating system on top of a hypervisor, which emulates physical hardware. Docker containers share the host operating system's kernel and isolate application processes using Linux kernel namespaces and cgroups.
* **Performance:** Docker containers are lightweight, consume significantly fewer resources (CPU, RAM, disk space), and boot up in seconds. VMs are heavier, require pre-allocated resources, and take minutes to start.
* **Isolation:** VMs offer stronger isolation because they do not share the host kernel. However, Docker containers provide sufficient process isolation for most deployment scenarios with much lower overhead.

#### 2. Environment Variables & Security
* **Environment Variables:** Used for all application settings and credentials. By storing secrets in a `.env` file which is excluded from version control (via `.gitignore`), we keep credentials secure on the host machine while simplifying container configuration and deployment.

#### 3. Docker Network vs Host Network
* **Host Network:** The container shares the host network namespace directly. While it offers maximum throughput, it completely bypasses container network isolation, allowing port conflicts and exposing internal services directly to the host's interface.
* **Docker Network (Bridge):** Creates an isolated virtual network interface for the container. Services communicate securely using service names as hostnames via Docker's internal DNS. Only explicitly exposed ports (e.g., port 443 for Nginx) are accessible from the host.

#### 4. Docker Volumes vs Bind Mounts
* **Bind Mounts:** Maps a specific, absolute path on the host filesystem directly into the container. It is highly dependent on the host's directory structure, file permissions, and OS.
* **Docker Volumes (Named Volumes):** Managed entirely by the Docker engine. They abstract host paths, handle file permissions automatically, and are easier to back up or share. In this project, named volumes are backed by bind mounts to comply with the host path requirements (`/home/masenche/data/`) while preserving volume abstraction.

---

## Instructions

### Prerequisites
* Docker and Docker Compose installed on the host.
* `/etc/hosts` updated to map `masenche.42.fr` to `127.0.0.1`.

### Build and Launch
Build the Docker images and run the services in the background:
```bash
make
```

### Stop Infrastructure
To stop and remove the containers without deleting persistent data:
```bash
make down
```

### Clean Everything
To clean up stopped containers, network, and intermediate build images:
```bash
make clean
```
To perform a complete clean, including named volumes and data directories:
```bash
make fclean
```

---

## Resources
* [Docker Documentation](https://docs.docker.com/)
* [WordPress CLI commands](https://developer.wordpress.org/cli/commands/)
* [MariaDB Server Administration Guide](https://mariadb.com/kb/en/documentation/)
* [NGINX SSL/TLS Configuration](https://nginx.org/en/docs/http/configuring_https_servers.html)

### AI Usage Disclosure
AI was used to:
1. Generate structural boilerplate files for documentation (`README.md`, `USER_DOC.md`, and `DEV_DOC.md`).
2. Review bash startup scripts for error handling, database availability checks, and robust state management.
