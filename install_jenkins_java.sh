#!/bin/bash

# Change to root user
sudo su

# Update all package repositories
dnf update -y

# Add Jenkins repo
wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Install Java
dnf install java-17-amazon-corretto -y

# Install Jenkins
dnf install jenkins -y

# Install Terraform
yum install -y yum-utils shadow-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
yum -y install terraform

# Enable and start jenkins
systemctl enable jenkins
systemctl start jenkins



