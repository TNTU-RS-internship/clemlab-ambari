FROM ubuntu:22.04 AS builder

RUN apt-get update && apt-get install -y \
    git \
    maven \
    openjdk-8-jdk \
    python3 \
    curl

WORKDIR /tmp
RUN git clone https://github.com/TNTU-RS-internship/clemlab-ambari
WORKDIR /tmp/clemlab-ambari

RUN mvn -B install package jdeb:jdeb "-Dmaven.clover.skip=true" "-DskipTests" "-Dstack.distribution=ODP" "-Drat.ignoreErrors=true" -Dpython.ver="python >= 2.6" -Dfindbugs.skip=true -DnewVersion=2.7.9.0 -Dviews -Plinux "-Dodp.release.number=134" -Djdk.version=1.8 --projects ambari-server --also-make

FROM ubuntu:22.04
COPY --from=builder /tmp/clemlab-ambari/ambari-server/target/*.deb /tmp/

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    openssl \
    python3-distro \
    python2 \
    openjdk-8-jdk \
    postgresql \
    curl

RUN apt install -y /tmp/*.deb

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

RUN ambari-server setup --silent --java-home $JAVA_HOME --skip-view-extraction

CMD ["ambari-server", "start"]

EXPOSE 8080