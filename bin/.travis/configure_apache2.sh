#!/bin/sh

sudo apt-get update
sudo apt-get install -y --force-yes apache2-mpm-prefork

# Custom phpenv for travis to use the php version currently installed
echo "export PATH=$HOME/.phpenv/bin:$PATH" | sudo tee -a /etc/apache2/envvars > /dev/null
#echo "$(curl -fsSL https://raw.github.com/gist/16d751c979fdeb5a14e3/gistfile1.txt)" | sudo tee /etc/apache2/conf.d/phpconfig > /dev/null
sudo cp bin/.travis/apache2/phpenv /etc/apache2/conf.d/phpconfig

# vhost
sed s?%basedir%?$TRAVIS_BUILD_DIR? bin/.travis/apache2/behat_vhost | sudo tee /etc/apache2/sites-available/behat > /dev/null

# modules enabling
sudo a2enmod rewrite
sudo a2enmod actions


# sites disabling & enabling
sudo a2dissite default
sudo a2ensite behat

# restart
sudo service apache2 restart
