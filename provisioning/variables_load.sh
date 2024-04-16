#!/bin/bash
echo "Provisioning script #1 is running"
ENV_FILE_PATH="/home/vagrant/local/.env"
if [ -f "$ENV_FILE_PATH" ]; then
    source "$ENV_FILE_PATH"
    echo ".env file loaded successfully."
           # Export environment variables to /etc/environment
    env_vars=(
        "POSTGRES_USER=$POSTGRES_USER"
        "POSTGRES_PASSWORD=$POSTGRES_PASSWORD"
        "POSTGRES_DB=$POSTGRES_DB"
        "POSTGRES_INITDB_ARGS=$POSTGRES_INITDB_ARGS"
        "ZBX_HISTORYSTORAGETYPES=$ZBX_HISTORYSTORAGETYPES"
        "ZBX_DEBUGLEVEL=$ZBX_DEBUGLEVEL"
        "ZBX_HOUSEKEEPINGFREQUENCY=$ZBX_HOUSEKEEPINGFREQUENCY"
        "ZBX_MAXHOUSEKEEPERDELETE=$ZBX_MAXHOUSEKEEPERDELETE"
        "ZBX_SERVER_HOST=$ZBX_SERVER_HOST"
        "ZBX_POSTMAXSIZE=$ZBX_POSTMAXSIZE"
        "PHP_TZ=$PHP_TZ"
        "ZBX_MAXEXECUTIONTIME=$ZBX_MAXEXECUTIONTIME"
    )

    for var in "${env_vars[@]}"; do
        echo "$var" | sudo tee -a /etc/environment
    done
sudo reboot
sleep 60
else
    echo "Error: .env file not found at $ENV_FILE_PATH"
fi