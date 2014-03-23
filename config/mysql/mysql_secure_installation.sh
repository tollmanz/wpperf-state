#!/bin/sh
mysql --user=root --execute="DELETE FROM mysql.user WHERE User='';"
mysql --user=root --execute="DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
mysql --user=root --execute="DROP DATABASE test;"
mysql --user=root --execute="DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'"
mysql --user=root --execute="UPDATE mysql.user SET Password=PASSWORD('{{ pillar['db']['root']['password'] }}') WHERE User='root';"
mysql --user=root --execute="FLUSH PRIVILEGES;"