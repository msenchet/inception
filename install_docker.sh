#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "=== Updating package index and installing dependencies ==="
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg

echo "=== Adding Docker's official GPG key ==="
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "=== Adding Docker repository ==="
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "=== Updating package list with Docker repo ==="
sudo apt-get update

echo "=== Installing Docker Engine and Docker Compose ==="
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "=== Starting and enabling Docker service ==="
sudo systemctl enable docker
sudo systemctl start docker

echo "=== Adding user $USER to the docker group ==="
sudo usermod -aG docker $USER

echo "=== Docker installation completed successfully! ==="
echo "Note: To apply the group changes without logging out, run: newgrp docker"
echo "To verify the installation, run: docker compose version"
