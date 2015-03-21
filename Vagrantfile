# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = 'ubuntu/trusty32'

  config.vm.network 'forwarded_port', guest: 5432, host: 5432
  config.vm.network 'forwarded_port', guest: 28018, host: 28018

  config.vm.provision 'shell', inline: <<-SHELL
    apt-get update
    apt-get install -y build-essential \
                       ruby1.9.1-dev \
                       git \
                       mongodb-server=1:2.4.9-1ubuntu2
    gem install bundler
  SHELL

  config.vm.provision 'shell', privileged: false, inline: <<-SHELL
    cd /vagrant
    bundle install
  SHELL
end
