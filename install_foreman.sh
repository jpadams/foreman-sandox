#!/bin/bash

#install puppet agent
wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb
dpkg -i puppetlabs-release-precise.deb
apt-get update -y
apt-get install puppet -y
puppet config set certname master.example.com

#stage foreman-installer
echo "deb http://deb.theforeman.org/ precise 1.5" > /etc/apt/sources.list.d/foreman.list
echo "deb http://deb.theforeman.org/ plugins 1.5" >> /etc/apt/sources.list.d/foreman.list
wget -q http://deb.theforeman.org/foreman.asc -O- | apt-key add -
apt-get update && apt-get install foreman-installer -y

#fudge some domainname stuff
sed -i "s/master/master.example.com master/" /etc/hosts

#install the thing
foreman-installer

