<h1 style="color: grey;">JUMIA PHONE VALIDATOR</h1>

## Overview
The Jumia Phone Validator is an application that involves largely two major applications -- Validator-frontend and Validator-backend. The former was built on a nodejs and latter built on Java.

At the heart of every Nodejs Application is a package.json file and the exact replica at every Java Application is a pom.xml especially for an application that is built with a Maven tool. The pom being Project Object Model. 

The pom.xml sits at the sole meeting point of the Jumia Phone Validator where configurations of the front-end can be specified to run the whole package of dependencies to make the application work.

The task involves largely three main sections of tools  -- Ansible for the configuration management, Terraform for Infrastructure and Kubernetes and all its standing dependencies such as Docker.

## Ansible 
Ansible as a tool doesnt not support windows installation. A windows subsystem for Linux was installad for automation with the AWS. With the assumption that WSL is being installed in the master node, you export the necessary keys as given from the AWS cloud. In the folder, ANSIBLE, and subfolder - **_ansible_provisioning_tasks.yml_** being the heart of the provisioning of the Ansible, one can run the command below to provision resources of the AWS cloud as specified clearly in the file above in italics. 

## installation
```bash
ansible-playbook ansible-provisioning_tasks.yml --tags provision -v
```
The above command provisions the resources with tags as specified. Optional tags are also given like provision, info, docker and provisioning to provide the necessary infrastructure for deployment. 


## Terraform
The terraform provisioning lifecycle was used for the provision of resources and jenkins pipelines were written in the folder for Continous Integration.
```bash
terraform init
terraform validate
terraform plan
terraform apply
terraform destroy
```
## Kubernetes

Kubernetes was provisioned with the help of Helm Charts as packaging manager and the necessary provision as specified in the Values, Templates etc. 

Below, shows a working Jumia Phone Validator deployed and showing how Names, Phone, Country and Phone Validity are being queried from the database **jumia_phone_validator** .


![working_project](./showcase/video.gif)
