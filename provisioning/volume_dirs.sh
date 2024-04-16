#!/bin/bash
echo "Provisioning script #2 is running"

sudo mkdir -p /var/lib/docker/volumes/postgres/
sudo mkdir -p /var/lib/docker/volumes/zabbix/
sudo mkdir -p /var/lib/docker/volumes/graf_data/
sudo mkdir -p /var/lib/docker/volumes/graf_config/