FROM python:3.7.0-alpine3.8

RUN apk update 
RUN apk add --no-cache \
    'ansible>2.7' --update-cache --repository http://nl.alpinelinux.org/alpine/edge/main
RUN pip install requests google-auth
WORKDIR /var/ansible

ENV PATH /opt/ansible/bin:$PATH

ENTRYPOINT ["ansible-playbook"]
