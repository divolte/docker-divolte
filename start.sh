#!/bin/bash

if [ "$ENABLE_KERBEROS" = "yes" ]; then
  /opt/divolte/configureKerberosClient.sh
  export DIVOLTE_JAVA_OPTS="-Djava.security.krb5.conf=/etc/krb5.conf -Dsun.security.krb5.debug=true"
fi

DIVOLTE_HDFS_SINK_WORKING_DIR=${DIVOLTE_HDFS_SINK_WORKING_DIR:-/tmp/working}
mkdir -p "$DIVOLTE_HDFS_SINK_WORKING_DIR"

DIVOLTE_HDFS_SINK_PUBLISH_DIR=${DIVOLTE_HDFS_SINK_PUBLISH_DIR:-/tmp/processed}
mkdir -p "$DIVOLTE_HDFS_SINK_PUBLISH_DIR"

/opt/divolte/divolte-collector/bin/divolte-collector
