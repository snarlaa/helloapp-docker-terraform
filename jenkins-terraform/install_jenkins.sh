#! /bin/bash

yum update -y

sudo yum install -y yum-utils && sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo && sudo yum -y install terraform

yum install git -y

wget -O /etc/yum.repos.d/jenkins.repo     https://pkg.jenkins.io/redhat-stable/jenkins.repo

rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

yum upgrade -y

yum install jenkins java-1.8.0-openjdk-devel -y

systemctl daemon-reload
  
systemctl start jenkins
  

