FROM alpine:latest
ARG FREQUENCY=weekly

COPY ./scripts/* /etc/periodic/$FREQUENCY

RUN chmod a+x /etc/periodic/$FREQUENCY/*
