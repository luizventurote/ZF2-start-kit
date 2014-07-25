# Variables
GIT_USER_NAME="luizventurote"
GIT_USER_EMAIL="luiz_17@ymail.com"

# Update
apt-get update

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