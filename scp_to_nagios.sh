#!/bin/bash
bash generate_config.sh $1 $2
gcloud compute scp $1.cfg mailatpradip8@nagios-a:/etc/nagios/servers
usermod -a -G nagios mailatpradip8
chmod 775 /etc/nagios/servers
usermod -a -G nagios mailatpradip
gcloud compute ssh mailatpradip8@nagios-a --command='sudo /usr/sbin/nagios -v /etc/nagios/nagios.cfg'
