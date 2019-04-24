# wac-gce-ansible
Containerized Ansible for use with Google Compute Engine

* Uses gcp_compute inventory plugin for dynamic inventory (requires service account)
* Uses same service account with installed gcloud to automagically connect to instances
* Uses instance labels to create Ansible groups

### Status
[![Build Status](https://travis-ci.org/chad-autry/wac-gce-ansible.svg?branch=master)](https://travis-ci.org/chad-autry/wac-gce-ansible)
[![Docker Hub](https://img.shields.io/badge/docker-ready-blue.svg)](https://registry.hub.docker.com/u/chadautry/wac-gce-ansible/)

# Setup
* [Create a service account](https://cloud.google.com/iam/docs/creating-managing-service-accounts)
* Grant the service account the Compute Admin, Compute OS Admin Login, Compute OS Login, and Service Account User IAM Roles
* [Create and download json credentials](https://cloud.google.com/iam/docs/creating-managing-service-account-keys)

# Example
* Use one of the [default directory layouts](http://docs.ansible.com/ansible/playbooks_best_practices.html#directory-layout) for playbooks and files.
* Mount the top directory as /var/ansible. It is used as the working directory of the container.
* Mount the directory which contains the service account file
* Pass in the GCE project id as an environment variable
** Note: The ID might not be the name, it might be the name with some additional digits appended

```shell
docker run -it --rm -v <playbook_directory>:/var/ansible -v /<service_account_directory>:/srcs -e GCP_SERVICE_ACCOUNT_FILE='/srcs/<service_account_json_credentials_name>' -e GCP_PROJECT='<project>' chadautry/wac-gce-ansible ansible-playbook /var/ansible/site.yml
```
