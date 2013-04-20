class postgresql::params {
  $iptables_hosts = hiera_array('postgresql_iptables_hosts', ['0.0.0.0/0'])
  $listen_to = hiera('postgresql_listen_addresses', 'localhost,10.10.10.50')
  $trusted_clients = hiera('postgresql_trusted_clients', '10.10.10.0/24')
  $pgbouncer_max_clients = hiera('pgbouncer_max_clients', '100')
  $pgbouncer_port = hiera('pgbouncer_port', '6432')
  $pgbouncer_pool_size = hiera('pgbouncer_pool_size', '10')
}
