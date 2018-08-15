#!/bin/bash

if [ "$ENABLE_KERBEROS" = "yes" ]; then
  /opt/divolte/configureKerberosClient.sh
  export DIVOLTE_JAVA_OPTS="-Djava.security.krb5.conf=/etc/krb5.conf -Dsun.security.krb5.debug=true"
fi

if [ -z "$DIVOLTE_HDFS_SINK_WORKING_DIR" ]; then
	# No specific dir set use default and create it if not exists
	if [ ! -d /tmp/working ]; then
		mkdir -p /tmp/working
	fi
else
	#make sure dir exists
	if [ ! -d "$DIVOLTE_HDFS_SINK_WORKING_DIR" ]; then
		mkdir -p "$DIVOLTE_HDFS_SINK_WORKING_DIR"
	fi
fi

if [ -z "$DIVOLTE_HDFS_SINK_PUBLISH_DIR" ]; then
	# No specific dir set use default and create it if not exists
	if [ ! -d /tmp/processed ]; then
		mkdir -p /tmp/processed
	fi
else
	#make sure dir exists
	if [ ! -d "$DIVOLTE_HDFS_SINK_PUBLISH_DIR" ]; then
		mkdir -p "$DIVOLTE_HDFS_SINK_PUBLISH_DIR"
	fi
fi

/opt/divolte/divolte-collector/bin/divolte-collector
