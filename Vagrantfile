# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.provision :shell, :path => "provision.sh"

  config.vm.define :smartclip do |sc_config|
    sc_config.vm.host_name = "smartclip.local"
    sc_config.vm.network :hostonly, "10.10.10.50"
    sc_config.vm.customize ["modifyvm", :id, "--memory", 1024]
    sc_config.vm.forward_port 8000, 8000 # apache
    sc_config.vm.forward_port 22, 2300 # sshd
    sc_config.ssh.forward_agent = true
    sc_config.vm.share_folder("smartclip", "/opt/apps",
                              "~/smartclip-dev/submodules")
    sc_config.vm.share_folder("files", "/etc/puppet/files",
                              "~/smartclip-dev/files")
    sc_config.vm.provision :puppet do |puppet|
      puppet.module_path = "modules"
      puppet.manifests_path = "manifests"
      puppet.manifest_file = "smartclip.pp"
    end
  end
end
  
  
