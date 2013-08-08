#Symfony 2 Vagrant Development setup


## Installation
####This setup is based and tested with Ubuntu Precise 64 bit base box, with Vagrant 1.0.5 version (should be vorking with 1.1)

* Install Vagrant using using the [installation instructions](http://docs.vagrantup.com/v2/installation/index.html)
* Clone this repository

    ```$ git clone https://github.com/irmantas/symfony2-vagrant.git```
    
* install git submodules
    ```$ git submodule update --init```

* run vagrant (for the first time it should take up to 10-15 min)
    ```$ vagrant up```
    
* Web server is accessible with http://33.33.33.100 (IP address can be changed in Vagrantfile)

* PhpMyAdmin is accessible with http://33.33.33.100/phpmyadmin

* Vagrant automatically setups database with this setup:

    * Username: symfony
    * Password: symfony-vagrant
    * Database: symfony

## Installed components

* [Nginx](http://nginx.org/en/) using puppet module from [example42](https://github.com/example42/puppet-nginx)
* [MySQL](http://www.mysql.com/) using puppet module from [example42](https://github.com/example42/puppet-mysql)
* [PHP-FPM](http://php-fpm.org/) (PHP 5.4)
* [PhpMyAdmin](http://www.phpmyadmin.net/home_page/index.php)
* [MongoDB](http://www.mongodb.org/)
* [Redis](http://redis.io/)
* [GiT](http://git-scm.com/)
* [Composer](http://getcomposer.org) installed globaly (use ```$ composer self-update``` to get the newest version)
* [Vim](http://www.vim.org/)
* [PEAR](http://pear.php.net/)
* [cURL](http://curl.haxx.se/)
* [Node.js](http://nodejs.org/)
* [npm](https://npmjs.org/)
* [less](http://lesscss.org/)
* [OpenJDK](http://openjdk.java.net/)
* [sass](http://sass-lang.com/)
* [Compass](http://compass-style.org/)
* [Imagic](http://www.imagemagick.org/script/index.php)
* [Capistrano](https://github.com/capistrano/capistrano)
* [Capifony](http://capifony.org/)
* [phpqatools](http://phpqatools.org/) using puppet module from ([https://github.com/rafaelfelix/puppet-phpqatools](https://github.com/rafaelfelix/puppet-phpqatools))
* [memcached](http://memcached.org/)

## Thanks to

* [example42](https://github.com/example42) - for great nginx\mysql templates
* [caramba1337](https://github.com/caramba1337) - for great ideas
* [kertz](https://github.com/kertz) - for great ideas
* [Markus Fischer](https://github.com/mfn) - for contribution

## Hints
####Startup speed
To speed up the startup process use ```$ vagrant up --no-provision``` (thanks to [caramba1337](https://github.com/caramba1337))

####Install Symfony Standard edition
* SSH to vagrant ```$ vagrant ssh```
* Clone symfony standard edition to somewhere temporary
    
    ```$ git clone https://github.com/symfony/symfony-standard.git /tmp/symfony```
    
* Move symfony repository to server document root

    ```$ mv /tmp/symfony/.git /vagrant/www/```

* Reset repository to restore project files
    
    ```$ cd /vagrant/www && git reset --hard HEAD```

* Install dependencies

    ```$ cd /vagrant/www && composer update```
    
* Edit ```web/app_dev.php``` to allow host

## TODO
You tell me
