#!/bin/bash
bash generate_config.sh $1 $2
gcloud compute scp --zone us-east4-c $1.cfg mailatpradip8@nagios-a:/etc/nagios/servers
usermod -a -G nagios mailatpradip8
chmod 777 /etc/nagios/servers
usermod -a -G nagios mailatpradip8
gcloud compute ssh --zone us-east4-c mailatpradip8@nagios-a --command='sudo /usr/sbin/nagios -v /etc/nagios/nagios.cfg'
