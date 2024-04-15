Vagrant.configure("2") do |config|
    config.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
    end
    # Zabbix Server VM
    config.vm.define "zabbix-server" do |server|
      server.vm.box = "ubuntu/bionic64"
      # Configuring networking setinngs
      server.vm.network "forwarded_port", guest: 8080, host: 8888
      server.vm.network "forwarded_port", guest: 80, host: 8090
      server.vm.network "forwarded_port", guest: 3000, host: 3000
      server.vm.network "private_network", ip: "192.168.50.10"
      #Creating linked directories between docker volumes and local directories
      config.vm.synced_folder "/var/lib/docker/volumes/postgres/", "/var/lib/postgresql/data/pgdata"
      config.vm.synced_folder "/var/lib/docker/volumes/zabbix/", "zabbix_alertscripts:/usr/lib/zabbix/alertscripts"
      config.vm.synced_folder "/var/lib/docker/volumes/graf_data/", "grafana_data:/var/lib/grafana"
      config.vm.synced_folder "/var/lib/docker/volumes/graf_config/", "grafana_config:/etc/grafana"
      #Starting the provisioning commands
      server.vm.provision "shell", inline: <<-SHELL
        # Load environment variables from .env file
        require 'dotenv'
        Dotenv.load
        
        # Load environment variables from .env file
        export $(cat .env | xargs)
        
        source /c/Brinks/BrinksProject/.env
        # Set automatic exit when an error comes up when running the vm
        set -e
        # Making directories to store volumes of the containers on the host machine 
        sudo mkdir -p /var/lib/docker/volumes/postgres/
        sudo mkdir -p /var/lib/docker/volumes/zabbix/
        sudo mkdir -p /var/lib/docker/volumes/graf_data/
        sudo mkdir -p /var/lib/docker/volumes/graf_config/
        # Installing docker's official GPG key:
        sudo apt-get update
        sudo apt-get install -y ca-certificates curl
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc

        #Adding the repository to Apt sources:
        echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
          $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
          sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update
        
        # Installing Docker and Docker-compose Packages
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        sudo apt install -y docker-compose
        sudo apt-get update

        # Starting the service and giving the right permissions to the vagrant user
        sudo service docker start
        sudo usermod -aG docker vagrant

        # setting git repository
        mkdir project
        cd ./project
        sudo apt install -y git
        git clone https://github.com/Roiyki/BrinksProject.git
        cd BrinksProject/dockerconf

        # Starting the Docker-Compose
        docker-compose up -d

        # Wait for PostgreSQL container to initialize (adjust sleep time as needed)
        sleep 10
        
        #Creating a pgcrypto extension for my postgresql password and altering it
        docker exec $(docker ps -qf "name=postgres-server") psql -U $POSTGRES_USER -d zabbix -c "CREATE EXTENSION IF NOT EXISTS pgcrypto;
        ALTER USER '$POSTGRES_USER' PASSWORD '$POSTGRES_PASSWORD' VALID UNTIL 'infinity';"
        
        exit
        #Copying from my database the file that determines the user that is allowed to sign into the database and the login protocol
        docker cp $(docker ps -qf "name=postgres-server"):/var/lib/postgresql/data/pg_hba.conf ~/pg_hba.conf

        # Modify pg_hba.conf file to use "trust" authentication to allow my user
        sed -i '$ s/scram-sha-256/trust/' ~/pg_hba.conf

        # Copy pg_hba.conf file back to the container after changing it
        CONTAINER_ID=$(docker ps -qf "name=postgres-server")
        docker cp ~/pg_hba.conf $CONTAINER_ID:/var/lib/postgresql/data/pg_hba.conf

        # Restart the PostgreSQL container to apply changes
        docker restart $CONTAINER_ID
      SHELL
    end
  
    # Zabbix Agent VM
    config.vm.define "zabbix-agent" do |agent|
      agent.vm.box = "ubuntu/bionic64"
      # Configure memory, CPU, and other settings for the agent VM
      agent.vm.network "private_network", ip: "192.168.50.11"
  
      agent.vm.provision "shell", inline: <<-SHELL
        # Install Zabbix Agent and configure it to send metrics to the Zabbix Server VM
      SHELL
    end
  end