# Variables
MYSQL_PASSWORD="root"
GIT_USER_NAME="luizventurote"
GIT_USER_EMAIL="luiz_17@ymail.com"

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
	sudo apt-get install -y python-software-properties build-essential
	sudo add-apt-repository ppa:ondrej/php5-oldstable -y
	sudo apt-get update
	sudo apt-get install -y php5
	libapache2-mod-php5 \
    php5-mysql \
    php5-curl \
    php5-xsl \
    php5-cli

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