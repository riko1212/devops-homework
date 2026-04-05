#!/bin/bash

sudo apt-get update
sudo apt-get install -y bc

check_installed() {
    if command -v "$1" >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

if check_installed docker; then
    echo "Docker is already installed: $(docker --version)"
else
    sudo apt-get install -y ca-certificates curl gnupg lsb-release
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
fi

if check_installed docker-compose; then
    echo "Docker Compose is already installed: $(docker-compose --version)"
else
    sudo apt-get install -y docker-compose-plugin
    sudo ln -sf /usr/libexec/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose
fi

PYTHON_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))' 2>/dev/null)
if [[ $(echo "$PYTHON_VERSION >= 3.9" | bc -l 2>/dev/null) -eq 1 ]]; then
    echo "Python is already installed: $PYTHON_VERSION"
else
    sudo apt-get install -y python3 python3-pip
fi

if python3 -m django --version >/dev/null 2>&1; then
    echo "Django is already installed: $(python3 -m django --version)"
else
    pip3 install --upgrade pip
    pip3 install django
fi