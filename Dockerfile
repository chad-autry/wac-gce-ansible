FROM chadautry/wac-ansible:latest 

# Remove the ssh client, we use gcloud instead
RUN apk del openssh-client

# Install and clean up gcloud
ENV \
  GCLOUD_SDK_VERSION="148.0.1" \
  GCLOUD_SDK_SHASUM="c90bccc35bb3fb5f0a3f286277bc33acbe2517ff"

ENV \
  GCLOUD_SDK_URL="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_SDK_VERSION}-linux-x86_64.tar.gz" \
  GCLOUD_SDK_FILENAME="google-cloud-sdk-${GCLOUD_SDK_VERSION}.tar.gz"

ADD ${GCLOUD_SDK_URL} /etc/${GCLOUD_SDK_FILENAME}

RUN \
  (echo "${GCLOUD_SDK_SHASUM}  /etc/${GCLOUD_SDK_FILENAME}" | sha1sum -c -) && \
  tar xf "/etc/${GCLOUD_SDK_FILENAME}" && \
  rm /etc/${GCLOUD_SDK_FILENAME}
  
# Copy gce.py to /etc/ansible/hosts
RUN mkdir -p /etc/ansible/hosts && \
  cp /opt/ansible/contrib/inventory/gce.py /etc/ansible/hosts/ && \
  chmod 700 /etc/ansible/hosts/gce.py

# Edit gce.py with sed (single line change) to provide needed info with ansible_host
RUN sed -i "s/'ansible_ssh_host': ssh_host/'ansible_ssh_host': inst.name + ':ZONE_DELIMITER:' + inst.extra['zone'].name/" /etc/ansible/hosts/gce.py

# Add localhost file to /etc/ansible/hosts
COPY localhost /etc/ansible/hosts

# Copy and make executable the shell script that mimics ssh with gcloud
COPY ssh /bin/ssh
RUN chmod 700 /bin/ssh
