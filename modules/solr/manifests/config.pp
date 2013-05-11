class solr::config inherits solr::params {
  $solr_dir = $solr::params::solr_dir

  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }

  file { '/etc/supervisor/conf.d/solr.conf':
    ensure => present,
    owner => root,
    group => root,
    mode => 0644,
    content => template('solr/supervisor.conf.erb'),
    require => Package['supervisor'],
    notify => Exec['solr::config::update_supervisor']
  }

  file { '/opt/solr/example/solr/collection1/conf/schema.xml':
    ensure => present,
    owner => 'vagrant',
    group => 'vagrant',
    mode => 0644,
    source => '/tmp/vagrant-puppet/modules-0/solr/files/schema.xml',
    notify => Exec['solr::config::restart_solr']    
  }

  file { '/opt/solr/example/solr/collection1/conf/solrconfig.xml':
    ensure => present,
    owner => 'vagrant',
    group => 'vagrant',
    mode => 0644,
    source => '/tmp/vagrant-puppet/modules-0/solr/files/solrconfig.xml',
    notify => Exec['solr::config::restart_solr']    
  }

  exec { 'solr::config::update_supervisor':
    command     => 'supervisorctl update',
    user        => root,
    refreshonly => true,
    require => Package['supervisor']
  }

  exec { 'solr::config::restart_solr':
    command     => 'supervisorctl restart solr',
    user        => root,
    refreshonly => true,
    require => Package['supervisor']
  }
}
