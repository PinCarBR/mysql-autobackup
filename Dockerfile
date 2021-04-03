FROM debian:10.9-slim
ARG FREQUENCY=weekly
ARG SCRIPTS_LOCATION=/opt/mysql/scripts
ARG MYSQLSH_PKG_URL=https://dev.mysql.com/get/Downloads/MySQL-Shell/mysql-shell_8.0.23-1debian10_amd64.deb

RUN set -ex && \
    apt-get update && \
    apt-get install -y \
        wget \
        cron

RUN wget -qO /tmp/mysql-shell.deb ${MYSQLSH_PKG_URL} && \
    dpkg -i /tmp/mysql-shell.deb || true && \
    apt-get -f -y install && \
    rm -rf /tmp/mysql-shell.deb

RUN mkdir -p ${SCRIPTS_LOCATION}
COPY ./scripts/* ${SCRIPTS_LOCATION}
RUN chmod a+x ${SCRIPTS_LOCATION}/* && \
    ln -s ${SCRIPTS_LOCATION}/backup-db /bin/backup-db && \
    cp ${SCRIPTS_LOCATION}/backup-db /etc/cron.$FREQUENCY/backup-db
    

COPY ./entrypoint.sh /
RUN chmod a+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]