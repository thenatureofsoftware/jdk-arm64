FROM thenatureofsoftware/ubuntu-arm64:xenial

MAINTAINER larmog https://github.com/larmog

ENV DEBIAN_FRONTEND noninteractive
ENV VERSION 1.9.0_ea-b161
ENV JAVA_JDK=9 \
    JAVA_UPDATE="EA" \
    JAVA_BUILD=161 \
    JAVA_HOME="/opt/jdk" \
    PATH=$PATH:${PATH}:/opt/jdk/bin \
    JAVA_OPTS="-server"

# Download and install Java
RUN apt-get -y update \
  && apt-get install -y curl \
  && curl -sSL --header "Cookie: oraclelicense=accept-securebackup-cookie;" "http://www.java.net/download/java/jdk${JAVA_JDK}/archive/${JAVA_BUILD}/binaries/jdk-${JAVA_JDK}-ea+${JAVA_BUILD}_linux-arm64-vfp-hflt_bin.tar.gz" | tar -xz \
  && echo "" > /etc/nsswitch.conf && \
  mkdir -p /opt && \
  mv jdk-${JAVA_JDK} /opt/jdk-${JAVA_JDK}u${JAVA_UPDATE}-b${JAVA_BUILD} && \
  ln -s /opt/jdk-${JAVA_JDK}u${JAVA_UPDATE}-b${JAVA_BUILD} /opt/jdk && \
  ln -s /opt/jdk/bin/java /usr/bin/java && \
  echo "hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4" >> /etc/nsswitch.conf && \
  rm -rf $JAVA_HOME/jre/bin/jjs \
       $JAVA_HOME/bin/keytool \
       $JAVA_HOME/bin/orbd \
       $JAVA_HOME/bin/pack200 \
       $JAVA_HOME/bin/policytool \
       $JAVA_HOME/bin/rmid \
       $JAVA_HOME/bin/rmiregistry \
       $JAVA_HOME/bin/servertool \
       $JAVA_HOME/bin/tnameserv \
       $JAVA_HOME/bin/unpack200 \
       $JAVA_HOME/man \
  rm /opt/jdk/src.zip && \
  apt-get -y remove curl openssl ca-certificates && \
  apt-get -y autoremove && apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /etc/ssl
