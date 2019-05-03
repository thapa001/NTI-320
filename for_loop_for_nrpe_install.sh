for servername in $( gcloud compute instances list | awk '{print $1}' | sed "1 d" | grep -v nagios-a );  do 
    gcloud compute ssh --zone us-east4-c mailatpradip8@$servername --command='yum -y install wget && wget 
done
