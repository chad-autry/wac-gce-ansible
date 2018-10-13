FROM python:3.7.0-alpine3.8

RUN apk update add --no-cache \
    ansibl
RUN pip install requests google-auth
WORKDIR /var/ansible

ENV PATH /opt/ansible/bin:$PATH

ENTRYPOINT ["ansible-playbook"]
