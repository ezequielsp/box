#!/usr/bin/env bash

echo "--- Good morning, master. Let's get to work. Installing now. ---"

sudo locale-gen pt_BR.UTF-8

echo "--- Updating packages list ---"
sudo apt-get update

echo "--- MySQL time ---"
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password pass'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password pass'

echo "--- Installing base packages ---"
sudo apt-get install -y vim curl python-software-properties

echo "--- Package For PHP 5.6 ---"
sudo add-apt-repository -y ppa:ondrej/php5-5.6

echo "--- Updating packages list ---"
sudo apt-get update

echo "--- Installing PHP-specific packages ---"
sudo apt-get install -y php5 apache2 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt php5-intl mysql-server-5.5 php5-mysql php5-sqlite git-core

echo "--- Installing Node and Npm ---"
sudo apt-get install -y nodejs npm curl openssl

echo "--- Installing and configuring Xdebug ---"
sudo apt-get install -y php5-xdebug

cat << EOF | sudo tee -a /etc/php5/mods-available/xdebug.ini
xdebug.scream=1
xdebug.cli_color=1
xdebug.show_local_vars=1
EOF

echo "--- Enabling mod-rewrite ---"
sudo a2enmod rewrite

echo "--- What developer codes without errors turned on? Not you, master. ---"
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini

echo "-- Configure Apache"
sudo sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
sudo sed -i 's/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www/' /etc/apache2/sites-enabled/000-default.conf

echo "--- Composer is the future. But you knew that, did you master? Nice job. ---"
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Enable Swaping Memory
sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
sudo /sbin/mkswap /var/swap.1
sudo /sbin/swapon /var/swap.1

echo "-- Clonando Dev --"
git clone https://github.com/ezequielsp/dev.git
cd dev
sudo mv dev /usr/local/bin/
cd ..
echo "-- Removendo diretorio --"
rm -rf dev
sudo chmod +x /usr/local/bin/dev

echo "--- Restarting Apache ---"
sudo service apache2 restart

cd /var/www
php -v
