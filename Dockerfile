FROM thenatureofsoftware/ubuntu-arm64:16.04

MAINTAINER larmog https://github.com/larmog

ENV DEBIAN_FRONTEND noninteractive
ENV VERSION 1.8.0_121-b13
ENV JAVA_JDK=8 \
    JAVA_UPDATE=121 \
    JAVA_BUILD=13 \
    JAVA_HOME="/opt/jdk" \
    PATH=$PATH:${PATH}:/opt/jdk/bin \
    JAVA_OPTS="-server"

# Download and install Java
RUN apt-get -y update \
  && apt-get install -y curl \
  && curl -sSL --header "Cookie: oraclelicense=accept-securebackup-cookie;" "http://download.oracle.com/otn-pub/java/jdk/${JAVA_JDK}u${JAVA_UPDATE}-b${JAVA_BUILD}/e9e7ea248e2c4826b92b3f075a80e441/jdk-${JAVA_JDK}u${JAVA_UPDATE}-linux-arm64-vfp-hflt.tar.gz" | tar -xz \
  && echo "" > /etc/nsswitch.conf && \
  mkdir -p /opt && \
  mv jdk1.${JAVA_JDK}.0_${JAVA_UPDATE} /opt/jdk-${JAVA_JDK}u${JAVA_UPDATE}-b${JAVA_BUILD} && \
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
