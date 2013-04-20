include apache2
include postgresql

$apps_dir = "/opt/apps"
$bashrc = "/home/vagrant/.bashrc"
$venv_home = "/opt/envs"
$venv_name = "smartclip"

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
