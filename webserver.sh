#!bin/bash
apt install software-properties-common
add-apt-repository -y  ppa:nginx/stable
apt-get update
apt-get install -y nginx php7.2-fpm git php7.2-mysql mysql-client-5.7 s3fs 

#mounting-s3
echo access:secret > /etc/passwd-s3fs
chmod 640 /etc/passwd-s3fs
mkdir /website
s3fs pesbukbucket /website -o passwd_file=/etc/passwd-s3fs -o uid=0 -o gid=0 -o allow_other -o url=https://s3-ap-southeast-1.amazonaws.com
chmod -R 644 /website/*
chmod 755 /website/css /website/img /website/js
sed -i 's/database_name_here/nama-db/g' /website/config.php
sed -i 's/username_here/nama-pengguna/g' /website/config.php
sed -i 's/password_here/katasandi/g' /website/config.php
sed -i 's/localhost/alamat/g' /website/config.php
sed -i 's/\r$//g' /website/config.php

#nginx
rm -f /etc/nginx/sites-available/default
rm -f /etc/nginx/sites-enabled/default
cp /project2cilsy-master/pesbuk.conf /etc/nginx/sites-available
ln -s /etc/nginx/sites-available/pesbuk.conf /etc/nginx/sites-enabled/
systemctl restart php7.2-fpm
systemctl restart nginx.service


#mysql
mysql -h alamat -u nama-pengguna -p"katasandi" -e "CREATE DATABASE nama-db;"
mysql -h alamat -u nama-pengguna -p"katasandi" -e "GRANT ALL ON nama-db.* TO 'nama-pengguna'@'%';"
mysql -h alamat -u nama-pengguna -p"katasandi" -e "FLUSH PRIVILEGES;"
cd /website
mysql -h alamat -u nama-pengguna -p"katasandi" nama-db < dump.sql
