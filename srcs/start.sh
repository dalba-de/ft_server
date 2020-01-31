######################################
##									##
##		Update	& Install tools 	##
##									##
######################################

apt update
apt install -y nginx mariadb-server php-fpm php-mysql curl unzip

######################################
##									##
##			Setup Nginx				##
##									##
######################################

service nginx start
mv /root/nginx.conf /etc/nginx/sites-available/localhost
ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/
cp /root/index.html /var/www/html/

######################################
##									##
##			Setup MariaDB			##
##									##
######################################

service mysql start
echo "CREATE DATABASE wordpress;" | mysql -u root
echo "GRANT ALL ON wordpress.* TO 'root'@'localhost' IDENTIFIED BY 'password' WITH GRANT OPTION;" | mysql -u root
echo "FLUSH PRIVILEGES;" | mysql -u root

######################################
##									##
##			  Setup SSL				##
##									##
######################################

mkdir ~/mkcert && cd ~/mkcert
curl -LO https://github.com/FiloSottile/mkcert/releases/download/v1.4.1/mkcert-v1.4.1-linux-amd64
mv mkcert-v1.4.1-linux-amd64 mkcert
chmod +x mkcert
./mkcert -install
./mkcert localhost

######################################
##									##
##			Setup Wordpress			##
##									##
######################################

cd /var/www/html
curl -LO https://es.wordpress.org/latest-es_ES.zip
unzip latest-es_ES.zip
rm latest-es_ES.zip
mv /root/wp-config.php /var/www/html/wordpress/

######################################
##									##
##		  Setup phppmyadmin			##
##									##
######################################

cd /var/www/html
curl -LO https://files.phpmyadmin.net/phpMyAdmin/4.9.4/phpMyAdmin-4.9.4-all-languages.zip
unzip phpMyAdmin-4.9.4-all-languages.zip
rm phpMyAdmin-4.9.4-all-languages.zip
mv phpMyAdmin-4.9.4-all-languages phpmyadmin
mv /root/config.inc.php /var/www/html/phpmyadmin/

######################################
##									##
##		  	Allow Users 			##
##									##
######################################

chown -R www-data:www-data /var/www/*
chmod -R 755 /var/www/*

######################################
##									##
##		  	Start Server 			##
##									##
######################################

service php7.3-fpm start
service nginx restart