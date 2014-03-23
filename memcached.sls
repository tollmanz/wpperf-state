# Memcached for object caching

memcached:
  pkg.installed:
    - name: memcached
  service.running:
    - require:
      - pkg: memcached
    - watch:
      - file: /etc/memcached.conf

# Memcached PHP PECL extension configuration file

/etc/php5/fpm/conf.d/20-memcached.ini:
  file.managed:
    - source: salt://config/memcached/20-memcached.ini
    - user: root
    - group: root
    - mode: 777
    - require:
      - pkg: php5-fpm
      - pkg: memcached

# Memcached daemon configuration file

/etc/memcached.conf:
  file.managed:
    - source: salt://config/memcached/memcached.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: php5-fpm
      - pkg: memcached