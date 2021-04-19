#!/bin/bash

printenv | grep -e MYSQL -e REMOTE > /etc/environment

cron -f
