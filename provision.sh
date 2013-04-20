#!/bin/bash

if [ -e "/etc/.configured" ] ; then
    echo "VM appears configured ; not provisioning"
    exit 0
fi

if ! grep "smartclip.local" /etc/hosts ; then
    echo "10.10.10.50 smartclip.local" >> /etc/hosts
fi

# puppetlabs repo
if [ ! -e "/etc/apt/sources.list.d/puppetlabs.list" ] ; then
    wget -q "http://apt.puppetlabs.com/puppetlabs-release-precise.deb" -O /tmp/puppetlabs.deb
    dpkg -i /tmp/puppetlabs.deb
fi

# update apt
apt-get -y update 2>&1 > /dev/null
apt-get -y install vim screen python-setuptools python-dev python-pip build-essential

echo "Configuring client"

apt-get install -y puppet-common
# create the initial puppet.conf ; needed to sync puppet role facts
mkdir -p /etc/puppet
echo "[main]
  pluginsync = true
  ssldir = /etc/puppet/ssl
" > /etc/puppet/puppet.conf
# run the initial sync in the foreground
puppet agent -t

# mark instance as configured
touch /etc/.configured
echo "Configuration complete."

exit 0
