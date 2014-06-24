#!/bin/bash

#install puppet agent
wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb
dpkg -i puppetlabs-release-precise.deb
apt-get update -y
apt-get install puppet -y
puppet config set certname `hostname` 
puppet config set server master 
