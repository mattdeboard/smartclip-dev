class solr::package inherits solr::params {
  $archive = $solr::params::solr_tarball
  $dir = $solr::params::solr_dir
  $bucket = $solr::params::package_bucket
  $aws_access_key = $solr::params::aws_access_key
  $aws_secret_key = $solr::params::aws_secret_key

  Exec {
    path => "${::path}",
    logoutput => on_failure,
  }

  if ! defined(Package['openjdk-7-jdk']) { package { 'openjdk-7-jdk': ensure => installed, } }
  if ! defined(Package['s3cmd']) { package { 's3cmd': ensure => installed, } }
  if ! defined(Package['curl']) { package { 'curl': ensure => installed, } }
  if ! defined(Package['supervisor']) { package { 'supervisor': ensure => installed, } }
  if ! defined(File['/etc/s3cfg.maint']) {
    file { '/etc/s3cfg.maint':
      alias   => 'solr::config::s3cfg',
      ensure  => present,
      content => template('solr/s3cfg.erb'),
      owner   => root,
      group   => root,
      mode    => 0644,
    }
  }

  exec { "solr::package::get_solr":
    creates => $archive,
    command => "s3cmd -c /etc/s3cfg.maint get s3://$bucket/apache/solr-4.2.1.tgz $archive",
    timeout => 0,
    require => [ Package['s3cmd'], File['/etc/s3cfg.maint'] ],
    notify => Exec['solr::package::untar_solr'],
    unless => "test -f /opt/solr/example/start.jar"
  }

  file { "/opt/solr":
    ensure => directory,
    owner => 'vagrant',
    group => 'vagrant',
    mode => 0644,
  }

  file { "/var/log/solr":
    ensure => directory,
    owner => root,
    group => root,
    mode => 0644,
  }

  exec { "solr::package::untar_solr":
    refreshonly => true,
    command => "tar -xzf $archive -C $dir --strip 1"
  }

}
