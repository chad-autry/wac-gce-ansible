FROM chadautry/wac-ansible:latest 
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
  
 TODO gce.py gce.ini
 TODO gcloud compute ssh aliased as ssh, 
     edited gce.py to connect to instance name instead of ip?
     edited gce.py to set --zone hostvar?
 TODO gcloud compute copy aliased as sftp
ENV PYTHONPATH /ansible/lib
