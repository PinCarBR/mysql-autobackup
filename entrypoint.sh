#!/bin/bash

printenv | grep "MYSQL" > /etc/environment

cron -f