# Divolte 
#
# Divolte Documentation:
# www.divolte.io
#

FROM java:8-jre

#
# Prerequisite: Create some folders for later usage
#
RUN mkdir -p /opt/divolte

#
# Download and Install Divolte
#
RUN curl -o divolte-collector-0.6.0.tar.gz http://divolte-releases.s3-website-eu-west-1.amazonaws.com/divolte-collector/0.6.0/distributions/divolte-collector-0.6.0.tar.gz && \
    tar zxpf divolte-collector-0.6.0.tar.gz -C /opt/divolte

#
# Configuration changes using divolte-collector.conf
#
ADD conf/divolte-collector.conf /opt/divolte/divolte-collector-0.6.0/conf/divolte-collector.conf
ADD conf/logback.xml /opt/divolte/divolte-collector-0.6.0/conf/logback.xml
RUN chown root:root /opt/divolte/divolte-collector-0.6.0/conf/divolte-collector.conf
RUN chown root:root /opt/divolte/divolte-collector-0.6.0/conf/logback.xml

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -qqy apt-transport-https locales krb5-user netcat && apt-get -qq clean

RUN locale-gen "en_US.UTF-8"
RUN echo "LC_ALL=\"en_US.UTF-8\"" >> /etc/default/locale

ENV KDC_HOST=${KDC_HOST:-kdc-kadmin}
ENV REALM ${REALM:-EXAMPLE.COM}
ENV KADMIN_PRINCIPAL ${KADMIN_PRINCIPAL:-kadmin/admin}
ENV KADMIN_PASSWORD ${KADMIN_PASSWORD:-MITiys4K5}

COPY configureKerberosClient.sh /opt/divolte/
COPY start.sh /opt/divolte/

#
# Expose the Divolte Collector click simulation web page
#
EXPOSE 8290

CMD ["/opt/divolte/start.sh"]