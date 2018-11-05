FROM alpine:3.8

RUN apk update 
RUN apk upgrade musl --no-cache --update-cache --repository http://nl.alpinelinux.org/alpine/edge/main
RUN apk add --no-cache \
    'ansible>2.7' --update-cache --repository http://nl.alpinelinux.org/alpine/edge/main
#RUN apk add --no-cache py3-py
#RUN pip install requests google-auth
WORKDIR /var/ansible

ENV ANSIBLE_GATHERING explicit
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_SSH_PIPELINING True
ENV ANSIBLE_INVENTORY_ENABLED "gcp_compute, host_list, script, yaml, ini, auto"
ENV PATH /opt/ansible/bin:$PATH

ENTRYPOINT ["ansible-playbook"]
