#!/bin/bash
/zookeeper-3.4.14/bin/zkServer.sh start
nohup sudo -u postgres postgres -D /var/lib/postgresql/data &
cd druid; java `cat conf/druid/single/jvm.config | xargs` -cp conf/druid/_common:conf/druid:conf/druid/single:lib/*:/usr/local/Cellar/hadoop/2.7.2/libexec/etc/hadoop io.druid.cli.ServerRunnable coordinator overlord > log/log.log
