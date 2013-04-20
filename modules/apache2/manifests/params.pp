class apache2::params {
  $iptables_hosts = hiera_array('apache2_iptables_hosts', ['0.0.0.0/0'])
  $apache_port = hiera('apache2_port', '80')
}
