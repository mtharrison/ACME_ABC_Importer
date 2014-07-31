$script = <<SCRIPT
sudo apt-get update
sudo apt-get install ruby1.9.3 -y
echo mysql-server mysql-server/root_password password strangehat | sudo debconf-set-selections
echo mysql-server mysql-server/root_password_again password strangehat | sudo debconf-set-selections
sudo apt-get install mysql-server -y
SCRIPT

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.network :private_network, ip: "192.168.33.25"

  config.vm.provision "shell", inline: $script
end
