FROM alpine:3.8

ENV ANSIBLE_VERSION=2.7.1

RUN set -xe \
    && echo "****** Install system dependencies ******" \
    && apk add --no-cache --progress python py-pip openssl \
		ca-certificates git openssh sshpass \
	&& apk --update add --virtual build-dependencies \
		python-dev libffi-dev openssl-dev build-base \
	\
	&& echo "****** Install ansible and python dependencies ******" \
    && pip install --upgrade pip \
	&& pip install ansible==${ANSIBLE_VERSION} boto boto3 requests google-auth \
    \
    && echo "****** Remove unused system librabies ******" \
	&& apk del build-dependencies \
	&& rm -rf /var/cache/apk/* 

WORKDIR /var/ansible

ENV ANSIBLE_GATHERING explicit
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_SSH_PIPELINING True
ENV ANSIBLE_INVENTORY_ENABLED "gcp_compute, host_list, script, yaml, ini, auto"
ENV PATH /opt/ansible/bin:$PATH

ENTRYPOINT ["ansible-playbook"]
