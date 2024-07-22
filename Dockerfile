FROM ubuntu:22.04
LABEL maintainer="juraitclash@gmail.com"
RUN  <<EOF
apt update -y
apt upgrade -y
apt install openjdk-8-jdk -y
apt install maven -y
apt install nodejs npm -y
apt install yarn -y
apt install python3 -y
apt install postgresql -y
apt update -y
apt upgrade -y
EOF
WORKDIR /app
COPY . /app
ENTRYPOINT ["mvn", "-pl", "ambari-server", "-am", "-B", "install", "package", "jdeb:jdeb", "-Djdk.version=1.8",
"-Declipselink.version=2.7.11", "-Dmaven.clover.skip=true", "-DskipTests", "-Dstack.distribution=ODP",
"-Drat.ignoreErrors=true", "-Dpython.ver=python>=2.6", "-Dfindbugs.skip=true", "-DnewVersion=2.7.9.0",
"-DbuildNumber=7ee807e194f55e732298abdb8c672413f267c2f344cc573c50f76803fe38f5e1708db3605086048560dfefa6a2cda1ac6e704ee1686156fd1e9acce1dc60def7",
"-Dviews"]
RUN <<EOF
apt update -y
apt upgrade -y
ambari-server setup -silent
ambari-server start
EOF
EXPOSE 8080
