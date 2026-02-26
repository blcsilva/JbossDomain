FROM quay.io/wildfly/wildfly:latest

USER root

# ==============================
# JOLOKIA AGENT
# ==============================
RUN mkdir -p /opt/jolokia

COPY jolokia-2.5.1/agents/jolokia-agent-jvm-javaagent.jar \
     /opt/jolokia/jolokia-agent.jar

RUN chmod 644 /opt/jolokia/jolokia-agent.jar

# ==============================
# GELF MODULE
# ==============================
RUN mkdir -p /opt/jboss/wildfly/modules/system/layers/base/biz/paluch/logging/main

COPY logstash-gelf-1.15.1.jar \
     jedis-2.9.0.jar \
     commons-pool2-2.4.3.jar \
     module.xml \
     /opt/jboss/wildfly/modules/system/layers/base/biz/paluch/logging/main/

# ==============================
# DOMAIN CONFIG
# ==============================
COPY domain.xml \
     /opt/jboss/wildfly/domain/configuration/domain.xml

# ==============================
# WAIT SCRIPT
# ==============================
COPY wait-for-it.sh /opt/wait-for-it.sh
RUN chmod +x /opt/wait-for-it.sh

# ==============================
# USERS
# ==============================
RUN /opt/jboss/wildfly/bin/add-user.sh admin Admin#123 --silent && \
    /opt/jboss/wildfly/bin/add-user.sh jboss Jboss@123 --silent

# ==============================
# JAVA OPTS
# ==============================
ENV JAVA_OPTS=""
ENV JAVA_OPTS_APPEND="\
-javaagent:/opt/jolokia/jolokia-agent.jar=port=8778,host=0.0.0.0 \
-Djava.util.logging.manager=org.jboss.logmanager.LogManager"

USER jboss
