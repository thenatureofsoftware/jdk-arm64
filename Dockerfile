FROM thenatureofsoftware/ubuntu-arm64:xenial

MAINTAINER larmog https://github.com/larmog

ENV DEBIAN_FRONTEND noninteractive
ENV VERSION 1.9.0_ea-b157
ENV JAVA_JDK=9 \
    JAVA_UPDATE="EA" \
    JAVA_BUILD=157 \
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
  ln -s /opt/jdk/jre/bin/java /usr/bin/java && \
  echo "hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4" >> /etc/nsswitch.conf && \
  rm -rf $JAVA_HOME/jre/bin/jjs \
       $JAVA_HOME/jre/bin/keytool \
       $JAVA_HOME/jre/bin/orbd \
       $JAVA_HOME/jre/bin/pack200 \
       $JAVA_HOME/jre/bin/policytool \
       $JAVA_HOME/jre/bin/rmid \
       $JAVA_HOME/jre/bin/rmiregistry \
       $JAVA_HOME/jre/bin/servertool \
       $JAVA_HOME/jre/bin/tnameserv \
       $JAVA_HOME/jre/bin/unpack200 \
       $JAVA_HOME/man \
  rm /opt/jdk/src.zip && \
  apt-get -y remove curl openssl ca-certificates && \
  apt-get -y autoremove && apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /etc/ssl
