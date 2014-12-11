#!/bin/bash
PROJECT_NAME=laravel

function update_apt {
	sudo apt-get update
}

function add_ppa {
	sudo add-apt-repository ppa:$1 -y
	update_apt
}

function install_apache2 {
	sudo apt-get install apache2 -y
	sudo a2enmod expires rewrite
}

function apache2_document_root {
	wget https://raw.githubusercontent.com/khepin/virtualhost/master/host &> /tmp/wget
	sed 's#=project=#'$PROJECT_NAME'#' < host | sed 's#=root_dir=#/vagrant/web#' > $PROJECT_NAME
	rm host
	sudo mv $PROJECT_NAME /etc/apache2/sites-available/$PROJECT_NAME.conf
	sudo a2ensite $PROJECT_NAME
	sudo service apache2 restart
}

function install_mysql {
	PWD=$1
	export DEBIAN_FRONTEND=noninteractive
	sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password '$PWD''
	sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password '$PWD''
	sudo apt-get install -y -E mysql-server libapache2-mod-auth-mysql php5-mysql
	export DEBIAN_FRONTEND=""
}

function install_php {
	add_ppa "ondrej/php5-$1"
	sudo apt-get install -y php5 libapache2-mod-php5 php5-mcrypt php5-cli php5-curl php5-mysql php5-pgsql
	sudo curl -sS https://getcomposer.org/installer | php
	sudo mv composer.phar /usr/local/bin/composer
}

############################################################################################################################
############################################################################################################################
############################################################################################################################
############################################################################################################################
############################################################################################################################
############################################################################################################################
############################################################################################################################
############################################################################################################################
############################################################################################################################
############################################################################################################################
############################################################################################################################

update_apt
install_mysql "abc"
install_apache2
install_php "5.6"
apache2_document_root
