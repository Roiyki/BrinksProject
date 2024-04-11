Vagrant.configure("2") do |config|
    # Zabbix Server VM
    config.vm.define "zabbix-server" do |server|
      server.vm.box = "ubuntu/bionic64"
      # Configure memory, CPU, and other settings for the server VM
      server.vm.network "private_network", ip: "192.168.50.10"
  
      server.vm.provision "shell", inline: <<-SHELL
        # Install Docker and Docker Compose
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