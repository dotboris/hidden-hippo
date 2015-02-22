# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = 'hashicorp/precise64'

  config.vm.provision 'shell', inline: <<-SHELL
    sudo apt-get update
    sudo apt-get install -y ruby1.9.1-dev git
    gem install bundler
  SHELL

  config.vm.provision 'shell', inline: <<-SHELL
    cd /vagrant
    bundle install
  SHELL
end
