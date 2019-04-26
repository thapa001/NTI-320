#!/bin/bash
#Install all the packages
yum install -y nagios-nrpe-server nagios-plugins nrpe nagios-plugins-load nagios-plugins-ping nagios-plugins-disk nagios-plugins-http nagios-plugins-procs wget
wget -O /usr/lib64/nagios/plugins/check_mem.sh https://raw.githubusercontent.com/nic-instruction/NTI-320/master/nagios/check_mem.sh
chmod +x /usr/lib64/nagios/plugins/check_mem.sh
systemctl enable nrpe
systemctl start nrpe
sed -i 's/allowed_hosts=127.0.0.1/allowed_hosts=127.0.0.1, 10.150.0.2/g' /etc/nagios/nrpe.cfg

#Got a make changes on the vim /etc/nagios/nrpe.cfg and the original lines looks like below. 
#command[check_users]=/usr/lib64/nagios/plugins/check_users $ARG1$
#command[check_load]=/usr/lib64/nagios/plugins/check_load $ARG1$
#command[check_disk]=/usr/lib64/nagios/plugins/check_disk $ARG1$
#command[check_swap]=/usr/lib64/nagios/plugins/check_swap $ARG1$
#command[check_cpu_stats]=/usr/lib64/nagios/plugins/check_cpu_stats.sh $ARG1$

#For updating new lines we need to do sed each lines 
sed -i 's,#command\[check_users\]=/usr/lib64/nagios/plugins/check_users \$ARG1\$,command[check_users]=/usr/lib64/nagios/plugins/check_users -w 5 -c 10,g' /etc/nagios/nrpe.cfg
sed -i 's:#command\[check_load\]=/usr/lib64/nagios/plugins/check_load \$ARG1\$:command[check_load]=/usr/lib64/nagios/plugins/check_load -w 15,10,5 -c 30,25,20:g' /etc/nagios/nrpe.cfg
sed -i 's,#command\[check_disk\]=/usr/lib64/nagios/plugins/check_disk \$ARG1\$,command[check_disk]=/usr/lib64/nagios/plugins/check_disk -w 20% -c 10%,g' /etc/nagios/nrpe.cfg
sed -i 's,#command\[check_swap\]=/usr/lib64/nagios/plugins/check_swap \$ARG1\$,command[check_swap]=/usr/lib64/nagios/plugins/check_swap -w 20% -c 10%,g' /etc/nagios/nrpe.cfg
sed -i 's:#command\[check_cpu_stats\]=/usr/lib64/nagios/plugins/check_cpu_stats.sh \$ARG1\$:command[check_cpu_stats]=/usr/lib64/nagios/plugins/check_cpu_stats.sh -w 70,40,30 -c 90,50,40:g' /etc/nagios/nrpe.cfg
sed -i 's,#command\[check_mem\]=/usr/lib64/nagios/plugins/custom_check_mem -n \$ARG1\$,command[check_mem]=/usr/lib64/nagios/plugins/check_mem.sh -w 80 -c 90,g' /etc/nagios/nrpe.cfg
systemctl restart nrpe

#Manually viming.
#command[check_users]=/usr/lib64/nagios/plugins/check_users -w 5 -c 10
#command[check_load]=/usr/lib64/nagios/plugins/check_load -w 15,10,5 -c 30,25,20
#command[check_disk]=/usr/lib64/nagios/plugins/check_disk -w 20% -c 10%
#command[check_swap]=/usr/lib64/nagios/plugins/check_swap -w 20% -c 10%
#command[check_cpu_stats]=/usr/lib64/nagios/plugins/check_cpu_stats.sh -w 70,40,30 -c 90,50,40
#systemctl restart nrpe

