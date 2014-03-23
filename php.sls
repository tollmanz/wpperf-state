# PHP5-FPM and configs

php5-fpm:
  pkg.installed:
    - pkgs:
      - php5-fpm
      - php5-common
      - php5-mysql
      - php-pear
      - php5-mcrypt
      - php5-imap
      - php-apc
      - php5-xdebug
      - php5-memcached
      - php5-imagick
      - php5-curl
      - php5-gd
  service.running:
    - require:
      - pkg: php5-fpm
    - watch:
      - file: /etc/php-fpm.d/www.conf
      - file: /etc/php5/fpm/conf.d/20-memcached.ini
      - file: /etc/php5/fpm/conf.d/20-apc.ini
      - file: /etc/php.ini
      - cmd: php5dismod-xdebug

php5-cli:
  pkg.installed

/etc/php-fpm.d/www.conf:
  file.managed:
    - source: salt://config/php/www.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: php5-fpm

/etc/php.ini:
  file.managed:
    - source: salt://config/php/php.ini
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: php5-fpm

php5dismod-xdebug:
  cmd.run:
    - name: sudo php5dismod xdebug
    - watch:
      - pkg: php5-fpm
    - stateful: True

# WP-CLI

wp-cli:
  cmd.run:
    - name: curl https://raw.github.com/wp-cli/wp-cli.github.com/master/installer.sh | bash
    - unless: which wp
    - user: deploy
    - require:
      - pkg: php5-fpm
      - pkg: php5-cli
      - pkg: git
  file.symlink:
    - name: /usr/bin/wp
    - target: /home/deploy/.wp-cli/bin/wp