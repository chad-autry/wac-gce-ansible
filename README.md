# wac-gce-ansible
Containerized Ansible for use within Google Compute Engine

* Setup for dynamic inventory
* Uses gcloud to automagically connect to instances

# Manual instructions
Haven't figured out how to get authorization working within a container from Google Cloud Shell. Here are instructions for manually installing Ansible on Google Cloud shell and setting it up with automatic authorization.

1. Clone ansible
2. Make inventory directory
3. copy gce.py to inventory directory
4. execute sed
5. wget localhost to inventory
6. wget gcloudSshWrapper
7. Install required pythong packages
7. setup profile with variables (source profile so don't need to restart)

```
cd ~/
clone https://github.com/ansible/ansible.git
cd ansible
mkdir inventory
cp ./contrib/inventory/gce.py ./inventory
sed -i "s/'ansible_ssh_host': ssh_host/'ansible_ssh_host': inst.name + ':ZONE_DELIMITER:' + inst.extra['zone'].name/" ~/ansible/inventory/gce.py
cd inventory
wget https://raw.githubusercontent.com/chad-autry/wac-gce-ansible/master/localhost
cd ../bin
wget https://raw.githubusercontent.com/chad-autry/wac-gce-ansible/master/gcloudSshWrapper
chmod 700 ~/ansible/bin/gcloudSshWrapper
sudo pip install -r ~/ansible/requirements.txt --target=$HOME/ansible/lib
sudo pip install apache_libcloud --target=$HOME/ansible/lib
```

Copy the following environment into your .profile (change the project name), and source your profile
```
export ANSIBLE_GATHERING=explicit
export ANSIBLE_HOST_KEY_CHECKING=false
export ANSIBLE_RETRY_FILES_ENABLED=false
export ANSIBLE_SSH_PIPELINING=True
export ANSIBLE_SSH_EXECUTABLE="$HOME/ansible/bin/gcloudSshWrapper"
export ANSIBLE_INVENTORY=$HOME/ansible/inventory
PATH=$HOME/ansible/bin:$PATH
export PYTHONPATH=$HOME/ansible/lib
export GCE_PROJECT=<project_name>
```

### Status
[![Build Status](https://travis-ci.org/chad-autry/wac-gce-ansible.svg?branch=master)](https://travis-ci.org/chad-autry/wac-gce-ansible)
[![Docker Hub](https://img.shields.io/badge/docker-ready-blue.svg)](https://registry.hub.docker.com/u/chadautry/wac-gce-ansible/)

# Example
* Use one of the [default directory layouts](http://docs.ansible.com/ansible/playbooks_best_practices.html#directory-layout) for playbooks and files.
* Mount the top directory as /var/ansible. It is used as the working directory of the container.
* Pass in the GCE project name as an environment variable
* '-e DEVSHELL_CLIENT_PORT=$DEVSHELL_CLIENT_PORT' is required to get the credentials
* '--net host' is both required to get the credentials and connect out as ansible
```shell
docker run -it -e GCE_PROJECT=<project> -e DEVSHELL_CLIENT_PORT=$DEVSHELL_CLIENT_PORT --net host -v $(pwd):/var/ansible chadautry/wac-gce-ansible <playbook>
```
