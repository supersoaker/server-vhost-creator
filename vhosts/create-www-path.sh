#!/bin/bash

# ask for www-domain
echo "Please new www domain:"
read www_domain

# create directories
mkdir -p /var/www/${www_domain}/www/
mkdir -p /var/www/${www_domain}/log/

# ask for sftp user
echo "Please enter sftp user:"
read sftp_user

# set new home directory for sftp user
usermod --home ${www_domain}

# set right directory owner
chown root:sftp /var/www/${www_domain}
chown ${sftp_user}:sftp /var/www/${www_domain}/www
chown ${sftp_user}:sftp /var/www/${www_domain}/log

# set right directory permissions
chmod 755 /var/www/${www_domain}

# ask to set up apache vhosts
while true; do
    read -p "Do you wish to install this program (y/n)?" yn
    case $yn in
        [Yy]* ) set_up_apache_vhost ${www_domain} ${sftp_user}; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

set_up_apache_vhost () 
{
	cp ./apache-vhost.conf /etc/apache2/sites-available/${1}.conf
	sed -i "s/${doc_root}/$1/g" /etc/apache2/sites-available/${1}.conf
	sed -i "s/${server_user}/$2/g" /etc/apache2/sites-available/${1}.conf
}