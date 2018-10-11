FROM python:3.7.0-alpine3.8

RUN apk add --no-cache \
    ansible
WORKDIR /var/ansible

ENV PATH /opt/ansible/bin:$PATH

ENTRYPOINT ["ansible-playbook"]
