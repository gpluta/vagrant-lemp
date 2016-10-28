#@IgnoreInspection BashAddShebang
# Add MongoDB repository
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
#update apt
sudo apt-get update

# install nginx
echo "installing nginx..."
sudo apt-get install nginx -y
echo "nginx version is:"
nginx -v

# install php-fpm (php7) and php-mysql
echo "Installing php-fpm and php-mysql";
sudo apt-get install php-fpm php-mysql -y

sudo bash -c "cat > /etc/nginx/sites-enabled/default" << EOF
server {
    listen 80;
    listen [::]:80 http2;
    server_name default_server;

    root /vagrant/public;
    index index.php index.html;

    location ~ \.php$ {
        # regex to split \$uri to \$fastcgi_script_name and \$fastcgi_path
        fastcgi_split_path_info ^(.+\.php)(/.+)$;

        # Check that the PHP script exists before passing it
        try_files \$fastcgi_script_name =404;

        # Bypass the fact that try_files resets \$fastcgi_path_info
        # see: http://trac.nginx.org/nginx/ticket/321
        set \$path_info \$fastcgi_path_info;
        fastcgi_param PATH_INFO \$path_info;

        fastcgi_index index.php;
        include fastcgi.conf;

        fastcgi_pass unix:/run/php/php7.0-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF

sudo systemctl restart nginx

# prepare mysql installation anserws
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password P@ssw0rd'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password P@ssw0rd'

# install MySQL
echo "installing mysql-server"
sudo apt-get install mysql-server -y
echo "mysql version is:"
mysql --version

#configure MySQL
#sudo rm /etc/mysql/my.cnf
sudo bash -c "cat > /etc/mysql/my.cnf" << EOF
!includedir /etc/mysql/conf.d/
!includedir /etc/mysql/mysql.conf.d/
# start your overrides
[mysql]
bind-address = 0.0.0.0

EOF

#####
##### Somehow comment out `skip-external-locking' from /etc/mysql/mysql.conf.d/mysqld.cnf
#####

sudo mysql -u root -pP@ssw0rd -e "create database WEBAPP";
mysql -u root -pP@ssw0rd -e "CREATE USER 'webappuser'@'localhost' IDENTIFIED BY 'P@ssw0rd'";
mysql -u root -pP@ssw0rd -e "GRANT ALL PRIVILEGES ON WEBAPP.* TO 'webappuser'@'localhost'";

mysql -u root -pP@ssw0rd -e "CREATE USER 'webappuser'@'10.0.2.2' IDENTIFIED BY 'P@ssw0rd'";
mysql -u root -pP@ssw0rd -e "GRANT ALL PRIVILEGES ON WEBAPP.* TO 'webappuser'@'10.0.2.2'";
mysql -u root -pP@ssw0rd -e "FLUSH PRIVILEGES";

sudo systemctl restart mysql
sudo systemctl enable mysql
