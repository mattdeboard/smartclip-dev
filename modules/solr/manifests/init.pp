class solr () inherits solr::params {
  class { 'solr::package': } 
  class { 'solr::config':
    require => Class['solr::package']
  }
}
