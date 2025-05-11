#!/bin/bash
apt update -y
apt install -y git ansible
git clone https://github.com/fabrice-git-hub/ec5.git /home/admin/ec5
cd /home/admin/ec5/ansible
ENVIRONMENT_NAME=${TF_WORKSPACE}
ansible-playbook -i "localhost," -c local playbook.yml