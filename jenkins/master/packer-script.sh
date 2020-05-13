#!/bin/bash

sudo yum update -y
wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
sudo yum install -y amazon-cloudwatch-agent.rpm
sudo systemctl enable amazon-cloudwatch-agent

sudo chown root:root /tmp/amazon-cloudwatch-agent.json
sudo mv /tmp/amazon-cloudwatch-agent.json /opt/aws/amazon-cloudwatch-agent/etc/

sudo amazon-linux-extras install -y corretto8 nginx1
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
sudo yum install -y jenkins
sudo systemctl enable jenkins
sudo systemctl enable nginx

sudo chown root:root /tmp/nginx-jenkins.conf
sudo mv /tmp/nginx-jenkins.conf /etc/nginx/conf.d/jenkins.conf
sudo chown root:root /tmp/nginx.conf
sudo mv /tmp/nginx.conf /etc/nginx