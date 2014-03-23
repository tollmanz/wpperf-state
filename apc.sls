# APC for opcode caching

/etc/php5/fpm/conf.d/20-apc.ini:
  file.managed:
    - source: salt://config/apc/20-apc.ini
    - user: root
    - group: root
    - mode: 777
    - template: jinja
    - require:
      - pkg: php5-fpm