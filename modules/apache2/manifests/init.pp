# == Class: apache2
#
# Installs and configures apache2
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  class { apache2: }
#    or
#  include apache2
#
# === Authors
#
# Arcus <support@arcus.io>
#
# === Copyright
#
# Copyright 2012 Arcus, unless otherwise noted.
#
class apache2 ($apache_port = $apache2::params::apache_port) inherits apache2::params {

  class { 'apache2::package': }
  class { 'apache2::config':
    apache_port => $apache_port,
    require => Class['apache2::package'],
  }
  class { 'apache2::service':
    require => [ Class['apache2::config'], Class['apache2::package'] ],
  }
}
