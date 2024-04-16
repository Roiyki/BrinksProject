#!/bin/bash
echo "Provisioning script #4 is running"
# setting git repository
if [ ! -d "project" ]; then
    mkdir project
fi
cd ./project
sudo apt install -y git
if [ ! -d "BrinksProject" ]; then
    git clone https://github.com/Roiyki/BrinksProject.git
else
    echo "Directory 'BrinksProject' already exists. Skipping cloning."
fi
cd BrinksProject/dockerconf
ln -s /home/vagrant/local/.env /home/vagrant/project/BrinksProject/dockerconf/.env
# Starting the Docker-Compose
docker-compose up -d