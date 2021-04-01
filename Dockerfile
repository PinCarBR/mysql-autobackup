FROM debian:10.9-slim
ARG FREQUENCY=weekly
ARG MYSQLSH_PKG=mysql-shell_8.0.23-1debian10_amd64.deb

RUN mkdir /opt/bkp_scripts
COPY ./scripts/* /opt/bkp_scripts

RUN set -ex && \
    apt-get update && \
    apt-get update && \
    apt-get install -y \
        wget \
        gzip && \
    wget -qO /tmp/${MYSQLSH_PKG} https://dev.mysql.com/get/Downloads/MySQL-Shell/${MYSQLSH_PKG} && \
    dpkg -i /tmp/${MYSQLSH_PKG} || true && \
    apt-get -f -y install && \
    rm -rf /tmp/${MYSQLSH_PKG} && \
    chmod a+x /opt/bkp_scripts/*
