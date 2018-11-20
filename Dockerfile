FROM alpine:3.8

ENV ANSIBLE_VERSION=2.7.0
ENV CLOUD_SDK_VERSION=224.0.0

ENV PATH /google-cloud-sdk/bin:$PATH

RUN set -xe \
    && echo "****** Install system dependencies ******" \
    && apk add --no-cache --progress \
        curl \
        python \
        py-crcmod \
        bash \
        libc6-compat \
        openssh-client \
        git \
        gnupg \
        py-pip \
        openssl \
        ca-certificates \
        openssh \
        sshpass \
	&& apk --update add --virtual build-dependencies \
		python-dev libffi-dev openssl-dev build-base \
	\
	&& echo "****** Install ansible and python dependencies ******" \
    && pip install --upgrade pip \
	&& pip install ansible==${ANSIBLE_VERSION} boto boto3 requests google-auth \
    \
    && echo "****** Install gcloud ******" \
    && curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    ln -s /lib /lib64 && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image \
    && echo "****** Remove unused system librabies ******" \
	&& apk del build-dependencies \
	&& rm -rf /var/cache/apk/* 

WORKDIR /var/ansible

ENV ANSIBLE_GATHERING explicit
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_SSH_PIPELINING True
ENV ANSIBLE_INVENTORY_ENABLED "gcp_compute, host_list, script, yaml, ini, auto"
ENV ANSIBLE_SSH_EXECUTABLE="/bin/gcloudSshWrapper"

ENV PATH /opt/ansible/bin:$PATH

# Copy and make executable the shell script that mimics ssh with gcloud
COPY gcloudSshWrapper /bin/gcloudSshWrapper
RUN chmod 700 /bin/gcloudSshWrapper

# Copy and make executable the entrypoint script
COPY entrypoint.sh /bin/entrypoint.sh
RUN chmod 700 /bin/entrypoint.sh

# Add localhost file to /etc/ansible/hosts
COPY localhost /etc/ansible/hosts/localhost

# Add gcp plugin template
COPY inventory.gcp.yml.template /usr/var/ansible/inventory.gcp.yml.template

ENTRYPOINT ["entrypoint.sh"]
