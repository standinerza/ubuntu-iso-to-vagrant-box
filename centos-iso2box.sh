#!/bin/bash
#Install necessary package 

yum -y update
yum -y groupinstall "Development Tools" 

#Import key Vagrant from Github

for i in /root /home/vagrant; do

  mkdir -p $i/.ssh;
  wget --no-check-certificate https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant -O $i/.ssh/id_rsa;
  wget --no-check-certificate https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -O $i/.ssh/id_rsa.pub;
  chmod 600 $i/.ssh/id_*;
  cat $i/.ssh/id_rsa.pub > $i/.ssh/authorized_keys;
done

#Change ownership of the key file 
chown -R vagrant.vagrant /home/vagrant/.ssh

#Let Vagrant user using sudo without password 
echo 'vagrant ALL=(ALL) NOPASSWD: ALL' >>/etc/sudoers

#Reboot the server

#Install kernel-header and wget 
yum -y install vim kernel-devel wget bzip2 tar gcc 

#Mount VirtualBox Guest and Install it 
mount /dev/cdrom /mnt
sh /mnt/ VBoxLinuxAdditions.run

#Clean up 
yum -y install yum-utils 
package-cleanup -y --oldkernels --count=1
yum -y autoremove
yum -y remove yum-utils 
yum clean all
rm -rf /tmp/*
rm -f /var/log/wtmp /var/log/btmp
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
cat /dev/null > ~/.bash_history && history -c