#!/bin/bash
bash generate_config.sh $1 $2
gcloud compute scp $1.cfg mailatpradip@nagios-a:/etc/nagios/servers
usermod -a -G nagios mailatpradip
chmod 775 /etc/nagios/servers
usermod -a -G nagios mailatpradip
gcloud compute ssh mailatpradip@nagios-a --command='sudo /usr/sbin/nagios -v /etc/nagios/nagios.cfg'
