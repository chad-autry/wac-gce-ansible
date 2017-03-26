# wac-gce-ansible
Containerized Ansible for use within Google Compute Engine

* Setup for dynamic inventory
* Uses gcloud to automagically connect to instances

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
