include postgresql

if ! defined(Package['git']) {
  package { 'git': ensure => installed, }
}

if ! defined(Package['curl']) {
  package { 'curl': ensure => installed, }
}

if ! defined(Package['python-pip']) {
  package { 'python-pip': ensure => installed, }
}

