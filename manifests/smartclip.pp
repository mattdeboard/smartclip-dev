include postgresql

$apache_port = "8001"
$apps_dir = "/opt/apps"
$bashrc = "/home/vagrant/.bashrc"
$venv_base = "$venv_home/$venv_name"
$venv_home = "/opt/envs"
$venv_name = "smartclip"
$wsgi_script = "/etc/puppet/files/smartclip_wsgi.py"

class { "apache2":
  apache_port => $apache_port
}

if ! defined(Package['git']) {
  package { 'git': ensure => installed, }
}

if ! defined(Package['curl']) {
  package { 'curl': ensure => installed, }
}

if ! defined(Package['python-pip']) {
  package { 'python-pip': ensure => installed, }
}

exec { 'install_venvwrapper':
  onlyif => "/usr/bin/test -z `pip freeze | grep virtualenvwrapper`",
  command => "/usr/bin/pip install virtualenvwrapper",
  require => Package['python-pip']
}

file { $bashrc:
  ensure => present,
  owner => 'vagrant',
  group => 'vagrant',
  mode => 0644,
  content => template('/tmp/vagrant-puppet/manifests/vagrant_bashrc.erb')
}

file { $venv_home:
  ensure => directory,
  owner => 'vagrant',
  group => 'vagrant',
  mode => 0644
}

file { '/etc/apache2/conf.d/smartclip.conf':
  ensure => present,
  owner => root,
  group => root,
  mode => 0644,
  content => template('/tmp/vagrant-puppet/manifests/smartclip.conf.erb'),
  require => Package['apache2'],
  notify => Service['apache2']
}

