FROM anapsix/alpine-java:8_jdk

LABEL maintainer="byte@byteflux.net"

ENV DOCKER_VERSION=18.06.1-ce \
    MAVEN_VERSION=3.5.4

RUN apk add --update openssh git curl patch && \
    ssh-keygen -A && \
    sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config && \
    mkdir -p /var/lib/jenkins/.ssh && \
    ln -s /var/lib/jenkins/.ssh /root/ && \
    chmod og-rwx /var/lib/jenkins/.ssh && \
    curl -o docker.tgz "https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_VERSION.tgz" && \
    tar xzf docker.tgz --strip-components=1 -C /usr/bin && \
    rm docker.tgz && \
    mkdir -p /var/lib/jenkins/.docker && \
    ln -s /var/lib/jenkins/.docker /root/ && \
    mkdir /opt/maven && \
    curl -o maven.tgz "https://www-us.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz" && \
    tar xzf maven.tgz --strip-components=1 -C /opt/maven && \
    ln -s /opt/maven/bin/mvn /usr/bin/ && \
    rm maven.tgz && \
    mkdir -p /var/lib/jenkins/.m2 && \
    ln -s /var/lib/jenkins/.m2 /root/ && \
    ln -s /var/lib/jenkins/.gitconfig /root/ && \
    git config --global user.name Jenkins && \
    git config --global user.email jenkins@worker && \
    ln -s /opt/jdk/bin/* /usr/bin/ && \
    rm /var/cache/apk/*

WORKDIR /var/lib/jenkins

CMD ["/usr/sbin/sshd", "-D"]