/var/log/mysql:
  file.directory:
    - user: mysql
    - group: mysql
    - dir_mode: 775
    - file_mode: 664
    - recurse:
        - user
        - group
        - mode

mysql:
  pkg.installed:
    - name: mysql-server-5.5
  service.running:
    - name: mysql
    - reload: True
    - watch:
      - file: /etc/my.cnf
    - require:
      - file: /etc/my.cnf
      - file: /usr/local/bin/my_mysql_secure_installation.sh

/etc/my.cnf:
  file.managed:
    - source: salt://config/mysql/my.cnf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require_in:
      - pkg: mysql

/usr/local/bin/my_mysql_secure_installation.sh:
  cmd:
    - wait
    - watch:
      - pkg: mysql-server-5.5
  file:
    - managed
    - source: salt://config/mysql/mysql_secure_installation.sh
    - owner: root
    - group: root
    - mode: 755
    - template: jinja