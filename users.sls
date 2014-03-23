group-deploy:
  group.present:
    - name: deploy

user-deploy:
  user.present:
    - name: deploy
    - password: ''
    - groups:
      - sudo
      - deploy
    - require:
      - group: deploy

group-www-data:
  group.present:
    - name: www-data

user-www-data:
  user.present:
    - name: www-data
    - groups:
      - www-data
    - require:
      - group: www-data

group-mysql:
  group.present:
    - name: mysql

user-mysql:
  user.present:
    - name: mysql
    - groups:
      - mysql
    - require:
      - group: mysql