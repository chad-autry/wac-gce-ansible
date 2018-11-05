FROM python:3.7.0-alpine3.8

ENV BUILD_PACKAGES \
  bash \
  curl \
  tar \
  openssh-client \
  sshpass \
  git \
  python \
  py-boto \
  py-dateutil \
  py-httplib2 \
  py-jinja2 \
  py-paramiko \
  py-pip \
  py-yaml \
  ca-certificates
RUN apk --update add --virtual build-dependencies \
      gcc \
      musl-dev \
      libffi-dev \
      openssl-dev \
      python-dev
RUN apk update 
RUN apk upgrade musl --no-cache --update-cache --repository http://nl.alpinelinux.org/alpine/edge/main
RUN pip python-keyczar docker-py install requests google-auth ansible>=2.7
RUN apk del build-dependencies
RUN rm -rf /var/cache/apk/*
WORKDIR /var/ansible

ENV ANSIBLE_GATHERING explicit
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_SSH_PIPELINING True
ENV ANSIBLE_INVENTORY_ENABLED "gcp_compute, host_list, script, yaml, ini, auto"
ENV PATH /opt/ansible/bin:$PATH

ENTRYPOINT ["ansible-playbook"]
