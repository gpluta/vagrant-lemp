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

# configure nginx (see "nginx_config")
sudo rm /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
sudo ln -s /vagrant/vagrant_bootstrap/nginx_config /etc/nginx/sites-enabled
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
sudo rm /etc/mysql/my.cnf
sudo ln -s /vagrant/vagrant_bootstrap/mysqld_conf /etc/mysql/my.cnf
sudo mysql -u root -pP@ssw0rd -e "create database WEBAPP";
mysql -u root -pP@ssw0rd -e "CREATE USER 'webappuser'@'localhost' IDENTIFIED BY 'P@ssw0rd'";
mysql -u root -pP@ssw0rd -e "GRANT ALL PRIVILEGES ON WEBAPP.* TO 'webappuser'@'localhost'";

mysql -u root -pP@ssw0rd -e "CREATE USER 'webappuser'@'10.0.2.2' IDENTIFIED BY 'P@ssw0rd'";
mysql -u root -pP@ssw0rd -e "GRANT ALL PRIVILEGES ON WEBAPP.* TO 'webappuser'@'10.0.2.2'";
mysql -u root -pP@ssw0rd -e "FLUSH PRIVILEGES";

sudo systemctl restart mysql

#install MongoDB
sudo apt-get install -y mongodb-org
sudo cp /vagrant/vagrant_bootstrap/mongodb.service /etc/systemd/system/
sudo systemctl start mongodb
sudo systemctl status mongodb
#enable MongoDB on system startup
sudo systemctl enable mongodb
