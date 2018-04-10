FROM rhel
LABEL maintainer="kdevensen@gmail.com" contributor="rafaelcba@gmail.com"
ENV HOME=/opt/workspace
RUN yum install -y --setopt=tsflags=nodocs --disablerepo='*' --enablerepo='rhel-7-server-rpms' \
		openssl \
        openssh-clients \
        openssh-server && \
    yum clean all && \
    rm -rf /var/cache/yum/*

RUN useradd -u 2000 default && \
    echo ${WETTY_PASSWORD} | passwd default --stdin

RUN /usr/bin/ssh-keygen -A -N '' && \
    chmod -R a+r /etc/ssh/* && \
    rm /run/nologin && \
    /usr/sbin/setcap 'cap_net_bind_service=+ep' /usr/sbin/sshd

EXPOSE 22

USER default
RUN /usr/bin/ssh-keygen -q -t rsa -N ''

CMD ["/usr/sbin/sshd", "-D", "-p", "22", "-E", "/home/default/ssh.log"]
