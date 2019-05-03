for servername in $( gcloud compute instances list | awk '{print $1}' | sed "1 d" | grep -v nagios-a );  do 
    gcloud compute ssh --zone us-east4-c mailatpradip8@$servername --command=' sudo yum -y install wget && sudo wget https://raw.githubusercontent.com/thapa001/NTI-320/master/NagiosClientConfig.sh
done
