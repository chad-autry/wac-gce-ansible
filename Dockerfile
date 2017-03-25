FROM chadautry/wac-ansible:latest 
RUN apk del openssh-client

RUN \
  mkdir ansible && \
  curl -fsSL http://releases.ansible.com/ansible/ansible-2.2.1.0.tar.gz -o ansible.tar.gz && \
  tar -xzf ansible.tar.gz -C ansible --strip-components 1 && \
  rm -fr ansible.tar.gz /ansible/docs /ansible/examples /ansible/packaging

WORKDIR /ansible/playbooks

ENV ANSIBLE_GATHERING explicit
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_SSH_PIPELINING True
ENV PATH /ansible/bin:$PATH
ENV PYTHONPATH /ansible/lib
