#!/bin/bash
#Install snmp and tools
#This is part of the web server and it will be added to the end of the scripting
yum -y install net-snmp net-snmp-utils

#Create a new snmpd.conf
mv /etc/snmp/snmpd.conf /etc/snmp/snmpd.conf.orig
touch /etc/snmp/snmpd.conf

#Edit snmpd.conf file /etc/snmp/snmpd.conf and make sure that network pointing to your internal network

echo '# create myuser in mygroup authenticating with 'public' community string and source network 10.150.0.0/24
com2sec myUser 10.150.0.0/24 public
# myUser is added into the group 'myGroup' and the permission of the group is defined
group    myGroup    v1        myUser
group    myGroup    v2c        myUser
view all included .1
access myGroup    ""    any    noauth     exact    all    all    none' >> /etc/snmp/snmpd.conf

#Enable snmp, start snmp
systemctl enable snmpd
systemctl start snmpd
