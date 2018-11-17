#!/bin/bash
set -e

# render a template configuration file
# expand variables + preserve formatting
render_template() {
  eval "echo \"$(cat $1)\""
}

gcloud auth activate-service-account --key-file=$GCP_SERVICE_ACCOUNT_FILE
gcloud config set project $GCP_PROJECT

#template out the inventory file since it requires the project
render_template /usr/var/ansible/inventory.gcp.yml.template > /etc/ansible/hosts/inventory.gcp.yml


exec "$@"
