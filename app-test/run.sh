#!/bin/bash

# Terraform deploying services
terraform_run () {
  echo "================Starting terraform================"

  terraform init && terraform plan  && terraform apply
  echo "================Terraforming Complete============="
}

ansible_run(){
  echo "==================Starting Ansible================"
  ansible-playbook -s main.yml
  echo "================Ansible Complete============="
}

main () {
  terraform_run
  ansible_run  
}

main
