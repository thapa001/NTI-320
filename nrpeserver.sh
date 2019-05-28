#!/bin/bash
#Install rpm tools, compiling tools and source tools
yum -y install rpm-build make gcc git   
#Make directory structure of rpm
mkdir -p /root/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS} 
#Change the directory as a root
cd ~/
#Set the rpmbuild path into .rpmmacro file
echo '%_topdir %(echo $HOME)/rpmbuild' > ~/.rpmmacros  
cd ~/rpmbuild/SOURCES
# Not needed but to better automate what is needed.
git clone https://github.com/nic-instruction/NTI-320.git
cd NTI-320/
cp NTI-320/rpm-info/hellow_world_from_source/helloworld-0.1.tar.gz .
cp NTI-320/rpm-info/hello_world_from_source/helloworld.spec .
cp NTI-320/rpm-info/hello_world_from_source/hello.spec .
mv hello.spec ../SPECS
cd ..
#Builds rpm 
rpmbuild -v -bb --clean SPECS/hello.spec
yum -y install RPMS/x86_64/helloworld-0.1-1.el7.x86_64.rpm 

   


