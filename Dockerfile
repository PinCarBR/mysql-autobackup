FROM percona/percona-xtrabackup:8.0.13
ARG FREQUENCY=weekly

RUN mkdir /opt/backup_scripts
COPY ./scripts/* /opt/backup_scripts

RUN set -ex && \
    chmod a+x /opt/backup_scripts/*
