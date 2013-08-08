Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }


class system-update {

    exec { 'apt-get update':
        command => 'apt-get update',
    }
}

class dev-packages {

    include gcc
    include wget

    $devPackages = [ "vim", "curl", "git", "nodejs", "npm", "capistrano", "rubygems", "openjdk-7-jdk", "libaugeas-ruby" ]
    package { $devPackages:
        ensure => "installed",
        require => Exec['apt-get update'],
    }

    exec { 'install less using npm':
        command => 'npm install less -g',
        require => Package["npm"],
    }

    exec { 'install capifony using RubyGems':
        command => 'gem install capifony',
        require => Package["rubygems"],
    }

    exec { 'install sass with compass using RubyGems':
        command => 'gem install compass',
        require => Package["rubygems"],
    }

    exec { 'install capistrano_rsync_with_remote_cache using RubyGems':
        command => 'gem install capistrano_rsync_with_remote_cache',
        require => Package["capistrano"],
    }
}

class nginx-setup {
    
    include nginx

    package { "python-software-properties":
        ensure => present,
    }

    file { '/etc/nginx/sites-available/default':
        owner  => root,
        group  => root,
        ensure => file,
        mode   => 644,
        source => '/vagrant/files/nginx/default',
        require => Package["nginx"],
    }

    file { "/etc/nginx/sites-enabled/default":
        notify => Service["nginx"],
        ensure => link,
        target => "/etc/nginx/sites-available/default",
        require => Package["nginx"],
    }
}

class { "mysql":
    root_password => 'auto',
}

mysql::grant { 'symfony':
    mysql_privileges => 'ALL',
    mysql_password => 'symfony-vagrant',
    mysql_db => 'symfony',
    mysql_user => 'symfony',
    mysql_host => 'localhost',
}

class php-setup {

    $php = ["php5-fpm", "php5-cli", "php5-dev", "php5-gd", "php5-curl", "php-apc", "php5-mcrypt", "php5-xdebug", "php5-sqlite", "php5-mysql", "php5-memcache", "php5-intl", "php5-tidy", "php5-imap", "php5-imagick"]

    exec { 'add-apt-repository ppa:ondrej/php5':
        command => '/usr/bin/add-apt-repository ppa:ondrej/php5',
        require => Package["python-software-properties"],
    }

    exec { 'apt-get update for ondrej/php5':
        command => '/usr/bin/apt-get update',
        before => Package[$php],
        require => Exec['add-apt-repository ppa:ondrej/php5'],
    }

    package { "mongodb":
        ensure => present,
        require => Package[$php],
    }

    package { $php:
        notify => Service['php5-fpm'],
        ensure => latest,
    }

    package { "apache2.2-bin":
        notify => Service['nginx'],
        ensure => purged,
        require => Package[$php],
    }

    package { "imagemagick":
        ensure => present,
        require => Package[$php],
    }

    package { "libmagickwand-dev":
        ensure => present,
        require => Package["imagemagick"],
    }

    package { "phpmyadmin":
        ensure => present,
        require => Package[$php],
    }

    exec { 'pecl install mongo':
        notify => Service["php5-fpm"],
        command => '/usr/bin/pecl install --force mongo',
        logoutput => "on_failure",
        require => Package[$php],
        before => [File['/etc/php5/cli/php.ini'], File['/etc/php5/fpm/php.ini'], File['/etc/php5/fpm/php-fpm.conf'], File['/etc/php5/fpm/pool.d/www.conf']],
        unless => "/usr/bin/php -m | grep mongo",
    }

    file { '/etc/php5/cli/php.ini':
        owner  => root,
        group  => root,
        ensure => file,
        mode   => 644,
        source => '/vagrant/files/php/cli/php.ini',
        require => Package[$php],
    }

    file { '/etc/php5/fpm/php.ini':
        notify => Service["php5-fpm"],
        owner  => root,
        group  => root,
        ensure => file,
        mode   => 644,
        source => '/vagrant/files/php/fpm/php.ini',
        require => Package[$php],
    }

    file { '/etc/php5/fpm/php-fpm.conf':
        notify => Service["php5-fpm"],
        owner  => root,
        group  => root,
        ensure => file,
        mode   => 644,
        source => '/vagrant/files/php/fpm/php-fpm.conf',
        require => Package[$php],
    }

    file { '/etc/php5/fpm/pool.d/www.conf':
        notify => Service["php5-fpm"],
        owner  => root,
        group  => root,
        ensure => file,
        mode   => 644,
        source => '/vagrant/files/php/fpm/pool.d/www.conf',
        require => Package[$php],
    }

    service { "php5-fpm":
        ensure => running,
        require => Package["php5-fpm"],
    }

    service { "mongodb":
        ensure => running,
        require => Package["mongodb"],
    }
}

class composer {
    exec { 'install composer php dependency management':
        command => 'curl -s http://getcomposer.org/installer | php -- --install-dir=/usr/bin && mv /usr/bin/composer.phar /usr/bin/composer',
        creates => '/usr/bin/composer',
        require => [Package['php5-cli'], Package['curl']],
    }

    exec { 'composer self update':
        command => 'composer self-update',
        require => [Package['php5-cli'], Package['curl'], Exec['install composer php dependency management']],
    }
}

class memcached {
    package { "memcached":
        ensure => present,
    }
}

class { 'apt':
    always_apt_update    => true
}

Exec["apt-get update"] -> Package <| |>

include system-update
include dev-packages
include nginx-setup
include php-setup
include composer
include phpqatools
include memcached
include redis
