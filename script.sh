#!/usr/bin/env bash

# Variables
MYSQL_PASSWORD="root"
GIT_USER_NAME="your_user_name"
GIT_USER_EMAIL="your_user_email"

# Update
apt-get update

# Install Server
if [ ! -f /etc/apache2/apache2.conf ]; then

	# Install MySQL
	echo "-------- Install MySQL --------"
  	echo "mysql-server-5.5 mysql-server/root_password password $MYSQL_PASSWORD" | debconf-set-selections
  	echo "mysql-server-5.5 mysql-server/root_password_again password $MYSQL_PASSWORD" | debconf-set-selections
  	apt-get -y install mysql-client mysql-server-5.5

  	# Install Apache2
	echo "-------- Install Apache2 --------"
	apt-get -y install apache2
	
	# Install PHP 5.4
	echo "-------- Install PHP --------"
	sudo apt-get install python-software-properties -y
	sudo add-apt-repository ppa:ondrej/php5 -y
	sudo apt-get update
	sudo apt-get install php5 -y
	sudo apt-get install libapache2-mod-php5 php5-mysql php5-curl php5-xsl php5-cli -y

	# Enable mod_rewrite
  	a2enmod rewrite
  	echo "Module rewrite enabled"

  	# Restart services
  	service apache2 restart
fi

# Install Git
if [ -z `which git` ]; then

	echo "-------- Install Git --------"
	apt-get install git -y

	# Configing git user name and email
	sudo -i -u vagrant git config --global color.ui always
	sudo -i -u vagrant git config --global user.name $GIT_USER_NAME
	sudo -i -u vagrant git config --global user.email $GIT_USER_EMAIL
	echo "Git user name: $GIT_USER_NAME"
	echo "Git user email: $GIT_USER_EMAIL"
fi

# Install Zend Skeleton Application
echo "-------- Install Zend Skeleton Application --------"
cd /var/www/html
git clone https://github.com/zendframework/ZendSkeletonApplication app
cd app

echo "-------- Start Composer --------"
php composer.phar self-update
php composer.phar install

# Server configuration
cd /etc/apache2/sites-available
rm 000-default.conf
echo "<VirtualHost *:80>
	
	# ServerName   my.domain.com
	ServerAdmin webmaster@localhost
	DocumentRoot /var/www/html/app/public

	# Log
	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined

	# Rewrite
	RewriteEngine off
	<Location />
        RewriteEngine On
        RewriteCond %{REQUEST_FILENAME} -s [OR]
        RewriteCond %{REQUEST_FILENAME} -l [OR]
        RewriteCond %{REQUEST_FILENAME} -d
        RewriteRule ^.*$ - [NC,L]
        RewriteRule ^.*$ /index.php [NC,L]
    </Location>

</VirtualHost>" >> 000-default.conf

# Restart services
service apache2 restart

echo "=== INSTALLATION COMPLETED ==="