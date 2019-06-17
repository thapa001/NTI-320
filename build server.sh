#!/bin/bash

# install the correct programs for building & dependencies needed:
yum -y install rpm-build make gcc git

# to wget things from the web 
yum -y install wget

# Create the directory structure we'll use for our build process:
mkdir -p -v /root/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

cd ~/
 # Set the rpmbuild path in an .rpmmacros file
echo '%_topdir %(echo $HOME)/rpmbuild' > ~/.rpmmacros
cd ~/rpmbuild/SOURCES

repo_server="testingrepo"
#####INTERNAL IP#####
repo_ip=$(gcloud compute instances list | grep $repo_server | awk '{ print $4 }' | tail -1)

echo "[nti-320]
name=Extra Packages for Centos from NTI-320 7 - $basearch
#baseurl=http://download.fedoraproject.org/pub/epel/7/$basearch <- example epel repo
# Note, this is putting repodata at packages instead of 7 and our path is a hack around that.
baseurl=http://$repo_ip/centos/7/extras/x86_64/Packages/
enabled=1
gpgcheck=0
" >> /etc/yum.repos.d/NTI-320.repo 


#git clone
#cp NTI-320/rpm-info/hello_world_from_source/helloworld-0.1.tar.gz .
#.sh
#.spec
#mv .spec ../SPECS
#cd ..

# to_build
#rpmbuild -v -bb --clean SPECS/hello.spec


#yum -y install RPMS/x86_64/helloworld-0.1-1.el7.x86_64.rpm
