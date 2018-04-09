FROM rhel
LABEL maintainer="kdevensen@gmail.com"
ENV HOME=/opt/workspace
RUN yum install -y --setopt=tsflags=nodocs --disablerepo='*' --enablerepo='rhel-7-server-rpms' \
		openssl \
        openssh-server && \
    yum clean all && \
    rm -rf /var/cache/yum/*

RUN mkdir /home/default && \
    useradd -u 2000 default && \
    echo ${WETTY_PASSWORD} | passwd default --stdin && \
    chown default:default /home/default

RUN /usr/bin/ssh-keygen -A -N '' && \
    chmod -R a+r /etc/ssh/* && \
    rm /run/nologin && \
    /usr/sbin/setcap 'cap_net_bind_service=+ep' /usr/sbin/sshd

EXPOSE 22
WORKDIR /home/default
USER default

CMD ["/usr/sbin/sshd", "-D", "-p", "22", "-E", "/home/default/ssh.log"]
