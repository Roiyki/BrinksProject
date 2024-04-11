Vagrant.configure("2") do |config|
    # Zabbix Server VM
    config.vm.define "zabbix-server" do |server|
      server.vm.box = "ubuntu/bionic64"
      # Configure memory, CPU, and other settings for the server VM
      server.vm.network "forwarded_port", guest: 80, host: 8080
      server.vm.network "private_network", ip: "192.168.50.10"
  
      server.vm.provision "shell", inline: <<-SHELL
        set -e

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
        
        # Installing Docker Packages
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

        # Starting the service and giving the right permissions to the vagrant user
        sudo service docker start
        sudo usermod -aG docker vagrant
        # Install any other necessary dependencies
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