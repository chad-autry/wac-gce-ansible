FROM chadautry/wac-ansible:latest 

# Remove the ssh client, we use gcloud instead
RUN apk del openssh-client

ENV \
  GCLOUD_SDK_VERSION="148.0.1" \
  GCLOUD_SDK_SHASUM="c90bccc35bb3fb5f0a3f286277bc33acbe2517ff"

ENV \
  GCLOUD_SDK_URL="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_SDK_VERSION}-linux-x86_64.tar.gz" \
  GCLOUD_SDK_FILENAME="google-cloud-sdk-${GCLOUD_SDK_VERSION}.tar.gz"

ADD ${GCLOUD_SDK_URL} ${GCLOUD_SDK_FILENAME}

RUN \
  (echo "${GCLOUD_SDK_SHASUM}  ${GCLOUD_SDK_FILENAME}" | sha1sum -c -) && \
  tar xf "${GCLOUD_SDK_FILENAME}"
  
# Copy gce.py to /etc/ansible/hosts

# Edit gce.py with sed (single line change) to provide needed info with ansible_host

# Add localhost file to /etc/ansible/hosts

# Copy and make executable the shell scripts that mimic ssh and sftp with gcloud
