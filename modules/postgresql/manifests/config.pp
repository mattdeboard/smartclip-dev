class postgresql::config inherits postgresql::params {
  $iptables_hosts = $postgresql::params::iptables_hosts
  $listen_to = $postgresql::params::listen_to
  $trusted_clients = $postgresql::params::trusted_clients

  file { '/etc/default/pgbouncer':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    content => template('postgresql/pgbouncer.default'),
    notify  => Service['pgbouncer'],
  }
  file { '/etc/pgbouncer/pgbouncer.ini':
    ensure  => present,
    owner   => 'postgres',
    group   => 'postgres',
    mode    => 0640,
    content => template('postgresql/pgbouncer.ini.erb'),
    notify  => Service['pgbouncer'],
  }  
  file { '/etc/pgbouncer/userlist.txt':
    ensure => present,
    owner => 'postgres',
    group => 'postgres',
    mode => 0644,
    content => template('postgresql/userlist.txt'),
    notify => Service['pgbouncer']
  }
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }

  # iptables
  file { '/tmp/.arcus.iptables.rules.postgresql':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0600,
    content => template('postgresql/iptables.erb'),
  }
  file { '/etc/postgresql/9.1/main/postgresql.conf':
    ensure => present,
    owner => 'postgres',
    group => 'postgres',
    mode => 0644,
    content => template('postgresql/postgresql.conf.erb'),
    require => File['/tmp/.arcus.iptables.rules.postgresql'],
  }
  file { '/etc/postgresql/9.1/main/pg_hba.conf':
    ensure => present,
    owner => 'postgres',
    group => 'postgres',
    mode => 0644,
    content => template('postgresql/pg_hba.conf.erb'),
    require => File['/etc/postgresql/9.1/main/postgresql.conf'],
    notify => Service['postgresql']
  }
  
}
