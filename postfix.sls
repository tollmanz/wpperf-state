postfix-debconf:
  debconf.set_file:
    - source: salt://config/postfix/debconf-set-selections

postfix:
  pkg.installed:
    - name: postfix
  service.running:
    - require:
      - pkg: postfix

postfix-config:
  cmd.wait:
    - name: /usr/sbin/postconf -e "inet_interfaces = loopback-only"
    - watch:
      - pkg: postfix