#!/bin/bash
#Install create-repo
#Make your own repo dir 
yum -y install createrepo  
mkdir -p /repos/centos/7/extras/x86_64/Packages/
#copy from build
#suggested to copy from build server to NFS and create share for other servers
#or can cp to home, scp to cloud cli, and scp to repo-server
#create the rpm on build server and then copy to home directory of build server
#cp /root/rpmbuild/RPMS/x86_64/helloworld-0.1-1.el7.x86_64.rpm /home/mailatpradip8/
#chown it to be owned by you
#chown mailatpradip8 /home/mailatpradip8/helloworld-0.1-1.el7.x86_64.rpm
#go to google cloud command line
#gcloud compute scp mailatpradip8@buildserver:/home/mailatpradip8/helloworld-0.1-1.el7.x86_64.rpm .
#Did you mean zone [us-west1-a] for instance: [build-a] (Y/n)?  n
#gcloud compute scp helloworld-0.1-1.el7.x86_64.rpm mailatpradip8@buildserver:/home/mailatpradip8/
#Did you mean zone [us-west1-a] for instance: [build-a] (Y/n)?  n
#gcloud compute scp helloworld-0.1-1.el7.x86_64.rpm mailatpradip8@reposerver:/home/mailatpradip8/
#Did you mean zone [us-west1-a] for instance: [repo-serv] (Y/n)?  n
#Replace helloworld with our own package
cp helloworld-0.1-1.el7.x86_64.rpm /repos/centos/7/extras/x86_64/Packages
#Update after every change
createrepo --update /repos/centos/7/extras/x86_64/Packages/
#Install apache so we can serve our own repo over the web
yum -y install httpd  
#disable selinux
setenforce 0
systemctl enable httpd
systemctl start httpd
#create symbolic link between repo centos and web centos
#var/www/centos points to repos
#hard link of our repo
ln -s  /repos/centos /var/www/html/centos
#Always copy config files to .bak before editing 
#Make a copy of our original httpd.conf
cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.bak 
#We can manually vim or run sed lines to run apache
vim /etc/httpd/conf/httpd.conf
#Configure apache 
sed -i '144i     Options All' /etc/httpd/conf/httpd.conf 
sed -i '145i    # Disable directory index so that it will index our repos' /etc/httpd/conf/httpd.conf
sed -i '146i     DirectoryIndex disabled' /etc/httpd/conf/httpd.conf
sed -i 's/^/#/' /etc/httpd/conf.d/welcome.conf  
#sed -i 's/^/#/' /etc/httpd/conf.d/welcome.conf disable the default welcome page in the recommended way
#-R makes recursive chown
chown -R apache:apache /repos/
systemctl restart httpd
#At this point we should be able to see our repository structure when we direct the website
#last step is to configure our new yum repository on a client
