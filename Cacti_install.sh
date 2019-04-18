#!/bin/bash
#Installes packages inluding mariadb, httpd and php and so on
#The mysql/mariadb client installs with the cacti stack but not the server
#If we want multiple cacti nodes, consider using the client and connecting to another server

yum -y install cacti  
yum -y install mariadb-server
yum -y install php-process php-gd php mod_php
yum -y install net-snmp net-snmp-utils

#Enabe db, apache and snmp(not cacti yet)
systemctl enable mariadb
systemctl enable httpd
systemctl enable snmpd

#Start db, apache and snmp (not cacti yet)
systemctl start mariadb
systemctl start httpd
systemctl start snmpd

#Set mysql and mariadb password.Password must be secret ****
#Make sql script to create a cacti db and grant the cacti user access to it

mysqladmin -u root password P@ssw0rd1

#Transfer your local timezone info to mysql

mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root -pP@ssw0rd1 mysql

echo "create database cacti;
GRANT ALL ON cacti.* TO cacti@localhost IDENTIFIED BY 'P@ssw0rd1';    #set this to something better than 'cactipass'
FLUSH privileges;

GRANT SELECT ON mysql.time_zone_name TO cacti@localhost;              #added to fix a timezone issue
flush privileges;" > stuff.sql                           

#Run sql script
mysql -u root -pP@ssw0rd1 < stuff.sql

#list the location of the package of cacti sql script
#rpm -ql cacti|grep cacti.sql
#In this case, the output is /usr/share/doc/cacti-1.0.4/cacti.sql, run that to populate your db

mypath=$(rpm -ql cacti|grep cacti.sql)
mysql cacti < $mypath -u cacti -pP@ssw0rd1

#mysql -u cacti -p cacti < /usr/share/doc/cacti-1.0.4/cacti.sql
#Open up apache
sed -i 's/Require host localhost/Require all granted/' /etc/httpd/conf.d/cacti.conf
sed -i 's/Allow from localhost/Allow from all all/' /etc/httpd/conf.d/cacti.conf

#Modify cacti credentials to user cacti P@ssw0rd1
sed -i "s/\$database_username = 'cactiuser';/\$database_username = 'cacti';/" /etc/cacti/db.php
sed -i "s/\$database_password = 'cactiuser';/\$database_password = 'P@ssw0rd1';/" /etc/cacti/db.php

#Fix the php.ini script
cp /etc/php.ini /etc/php.ini.orig
sed -i 's/;date.timezone =/date.timezone = America\/Regina/' /etc/php.ini

systemctl restart httpd.service

#Set up the cacto cron
sed -i 's/#//g' /etc/cron.d/cacti
setenforce 0
systemctl start httpd


