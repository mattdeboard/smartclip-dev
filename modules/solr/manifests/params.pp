class solr::params {
  $solr_dir = hiera('solr_dir', '/opt/solr')
  $solr_tarball = hiera('solr_tarball', '/tmp/solr-4.2.1.tgz')
  $package_bucket = hiera('solr_package_bucket', 'smartclip/files')
  $aws_access_key = hiera('solr_aws_access_key', 'AKIAJSGXKT7SEOHKBXNA')
  $aws_secret_key = hiera('solr_aws_secret_key', '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')
}
