#!bin/bash
apt install software-properties-common
add-apt-repository -y  ppa:nginx/stable
apt-get update
apt-get install -y nginx php7.2-fpm git php7.2-mysql mysql-client-5.7 s3fs 
echo access:secret > /etc/passwd-s3fs
chmod 640 /etc/passwd-s3fs
mkdir /website
s3fs pesbukbucket /website -o passwd_file=/etc/passwd-s3fs -o uid=0 -o gid=0 -o allow_other -o url=https://s3-ap-southeast-1.amazonaws.com
chmod -R 644 /website/*
chmod 755 /website/css /website/img /website/js

#mysql
mysql -h alamat -u username -p"password" -e "CREATE DATABASE database;"
mysql -h alamat -u username -p"password" -e "GRANT ALL ON database.* TO 'username'@'%';"
mysql -h alamat -u username -p"password" -e "FLUSH PRIVILEGES;"
cd /website
mysql -h alamat -u username -p"password" database < dump.sql
