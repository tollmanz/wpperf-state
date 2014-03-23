# Ensure proper permissions for /var/www

## Only set for non-local. This fails locally due to shared directory issues
{% if grains['id'] != 'wpperflocal' %}
/var/www:
  file.directory:
    - user: www-data
    - group: www-data
    - dir_mode: 755
    - file_mode: 644
    - recurse:
      - user
      - group
      - mode
    - require_in:
      - service: nginx
{% endif %}

# Nginx and configs

/etc/init.d/nginx:
  file.managed:
    - source: salt://config/nginx/init-nginx
    - user: root
    - group: root
    - mode: 755

/var/ngx_pagespeed_cache:
  file.directory:
    - user: www-data
    - group: www-data
    - mode: 755
    - require_in:
      - cmd: nginx

/var/cache/nginx:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - require_in:
      - cmd: nginx

/root/nginx-compile.sh:
  file.managed:
    - source: salt://config/nginx/compile-nginx.sh
    - user: root
    - group: root
    - mode: 755

nginx:
  cmd.run:
    - name: sh nginx-compile.sh
    - cwd: /root/
    - unless: nginx -v 2>&1 | grep "1.5.12"
    - require:
      - file: /root/nginx-compile.sh
      - user: www-data
      - group: www-data

/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://config/nginx/nginx.conf
    - user: www-data
    - group: www-data
    - mode: 644
    - template: jinja

/etc/nginx/mime.types:
  file.managed:
    - source: salt://config/nginx/mime.types
    - user: www-data
    - group: www-data
    - mode: 644
    - require_in:
      - service: nginx

/etc/nginx/fastcgi_params:
  file.managed:
    - source: salt://config/nginx/fastcgi_params
    - user: www-data
    - group: www-data
    - mode: 644
    - require_in:
      - service: nginx

nginx-conf:
  file.recurse:
    - name: /etc/nginx/conf
    - user: www-data
    - group: www-data
    - dir_mode: 755
    - file_mode: 644
    - makedirs: True
    - source: salt://config/nginx/conf
    - include_empty: True
    - template: jinja
    - require_in:
      - service: nginx

nginx-conf.d:
  file.recurse:
    - name: /etc/nginx/conf.d
    - user: www-data
    - group: www-data
    - dir_mode: 755
    - file_mode: 644
    - makedirs: True
    - source: salt://config/nginx/conf.d
    - include_empty: True
    - template: jinja
    - require_in:
      - service: nginx

nginx-sites-enabled:
  file.recurse:
    - name: /etc/nginx/sites-enabled
    - user: www-data
    - group: www-data
    - dir_mode: 755
    - file_mode: 644
    - makedirs: True
    - source: salt://config/nginx/sites-enabled
    - include_empty: True
    - template: jinja
    - require_in:
      - service: nginx

/var/log/nginx/error.log:
  file.managed:
    - user: www-data
    - group: www-data
    - mode: 644
    - makedirs: True

/var/cache/nginx/client_temp:
  file.directory:
    - user: www-data
    - group: www-data
    - mode: 755
    - makedirs: True