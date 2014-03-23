# Setup DB

ttf-db:
  mysql_user.present:
    - name: {{ pillar['db']['wordpress']['user']['name'] }}
    - password: {{ pillar['db']['wordpress']['user']['password'] }}
    - host: localhost
    - require:
      - service: mysql
      - pkg: python-mysqldb
  mysql_database.present:
    - name: {{ pillar['db']['wordpress']['name'] }}
    - require:
      - service: mysql
      - pkg: python-mysqldb
  mysql_grants.present:
    - grant: all privileges
    - database: {{ pillar['db']['wordpress']['name'] }}.*
    - user: {{ pillar['db']['wordpress']['user']['name'] }}
    - require:
      - service: mysql
      - pkg: python-mysqldb

# Setup the folders for the site

/var/www/{{ pillar['site_url'] }}:
  file.directory:
    - user: www-data
    - group: www-data
    - mode: 755
    - makedirs: True
    - require_in:
      - service: nginx

/var/www/{{ pillar['site_url'] }}/uploads:
  file.directory:
    - user: www-data
    - group: www-data
    - mode: 755
    - makedirs: True

/var/www/{{ pillar['site_url'] }}/logs:
  file.directory:
    - user: www-data
    - group: www-data
    - mode: 755
    - makedirs: True
    - require_in:
      - service: nginx

# Setup site log files

/var/www/{{ pillar['site_url'] }}/logs/access.log:
  file.managed:
    - user: www-data
    - group: www-data
    - mode: 644
    - makedirs: True
    - require_in:
      - service: nginx

/var/www/{{ pillar['site_url'] }}/logs/error.log:
  file.managed:
    - user: www-data
    - group: www-data
    - mode: 644
    - makedirs: True
    - require_in:
      - service: nginx

/var/www/{{ pillar['site_url'] }}/logs/php-error.log:
  file.managed:
    - user: www-data
    - group: www-data
    - mode: 644
    - makedirs: True
    - require_in:
      - service: nginx

# Setup wp-config.php

/var/www/{{ pillar['site_url'] }}/wp-config.php:
  file.managed:
    - user: www-data
    - group: www-data
    - mode: 644
    - template: jinja
    - source: salt://config/wpperf/wp-config.php
    - require:
      - file: /var/www/{{ pillar['site_url'] }}