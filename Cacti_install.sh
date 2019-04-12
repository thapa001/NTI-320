#!/bin/bash
# Installes a number of packages, including mariadb, httpd, php and so on

yum -y install cacti  

# The mysql/mariadb client installs with the cacti stack but not the server
# If you want to have multiple cacti nodes, considder using the client and connecting
# to another server

yum -y install mariadb-server   
comment out  line 32 ----> rpm -ql cacti|grep cacti.sql 
comment line 38 --->
-----> on cacti_clinet change the internal ip address of your host.
