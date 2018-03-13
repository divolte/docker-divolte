# Divolte
#
# Divolte Documentation:
# www.divolte.io
#

FROM openjdk:8-jre-slim

#
# Prerequisite: Create some folders for later usage
#
RUN mkdir -p /opt/divolte

#
# Configuration
#

ARG BUILD_DATE
ARG DIVOLTE_VERSION=0.7.0

LABEL org.label-schema.name="Divolte ${DIVOLTE_VERSION}" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.version=$DIVOLTE_VERSION

#
# Install dependencies
#

RUN apt-get update && \
	apt-get install -y curl krb5-user && \ 
	apt-get clean -y

#
# Download and Install Divolte
#
RUN curl -o divolte-collector-${DIVOLTE_VERSION}.tar.gz http://divolte-releases.s3-website-eu-west-1.amazonaws.com/divolte-collector/${DIVOLTE_VERSION}/distributions/divolte-collector-${DIVOLTE_VERSION}.tar.gz && \
    tar zxpf divolte-collector-${DIVOLTE_VERSION}.tar.gz -C /opt/divolte && \
    mv /opt/divolte/divolte-collector-${DIVOLTE_VERSION}/ /opt/divolte/divolte-collector

#
# Configuration changes using divolte-collector.conf
#
ADD conf/divolte-collector.conf /opt/divolte/divolte-collector/conf/divolte-collector.conf
ADD conf/logback.xml /opt/divolte/divolte-collector/conf/logback.xml
RUN chown root:root /opt/divolte/divolte-collector/conf/divolte-collector.conf && \
    chown root:root /opt/divolte/divolte-collector/conf/logback.xml

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
