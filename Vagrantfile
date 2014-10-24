Vagrant::Config.run do |config|
  config.vm.box       = 'precise32'
  config.vm.box_url   = 'http://files.vagrantup.com/precise32.box'
  config.vm.host_name = 'abc'

  # Update puppet to version 3.2.2 before using puppet provisioning.
  $puppet_update_script = <<SCRIPT
wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb
dpkg -i puppetlabs-release-precise.deb
apt-get update
puppet resource package puppetmaster ensure=latest
SCRIPT

  config.vm.provision :shell, :inline => $puppet_update_script

  $node_symlink_script = <<SCRIPT
mkdir /tmp/node_modules
ln -s /tmp/node_modules /vagrant/frontend/node_modules
SCRIPT

  config.vm.provision :shell, :inline => $node_symlink_script

  config.vm.provision :puppet,
    :manifests_path => 'puppet/manifests',
    :module_path    => 'puppet/modules'
end
