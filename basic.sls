vim:
  pkg.installed

# Python is required for MySQL provisioning

python:
  pkg.installed:
    - name: python-dev

python-mysqldb:
  pkg.installed:
    - require:
      - pkg: python

# Set the hostname

/etc/hostname:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: {{ grains['id'] }}
  cmd.wait:
    - name: /etc/init.d/hostname.sh
    - watch:
      - file: /etc/hostname

# Hosts file

/etc/hosts:
  file.managed:
    - source: salt://config/hosts/hosts
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - file: /etc/hostname

# Needed for compiling packages from source

sudo:
  pkg.installed

libssl-dev:
  pkg.installed

libpcre3:
  pkg.installed

libpcre3-dev:
  pkg.installed

zlib1g-dev:
  pkg.installed

build-essential:
  pkg.installed

checkinstall:
  pkg.installed

expect:
  pkg.installed

# Version control

git:
  pkg.installed

subversion:
  pkg.installed

# Basic groups

group-ssh:
  group.present:
    - name: ssh

# Security

# Add the iptables rules

iptables:
  pkg.installed:
    - name: iptables

/etc/iptables.up.rules:
  file.managed:
    - source: salt://config/iptables/iptables.up.rules
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - pkg: iptables
  cmd.wait:
    - name: iptables-restore < /etc/iptables.up.rules
    - watch:
      - file: /etc/iptables.up.rules

# Be sure to reload the iptables rules on reload

/etc/network/interfaces:
  file.append:
    - text:
      - ""
      - "# Restore iptables on reboot"
      - "pre-up iptables-restore < /etc/iptables.up.rules"

# Add a directory to hold receipts

/srv/receipts:
  file.directory:
    - user: deploy
    - group: deploy
    - mode: 755
    - makedirs: True
    - require:
      - user: deploy

# Add testing framework

siege:
  pkg.installed