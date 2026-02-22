FROM quay.io/wildfly/wildfly:latest

USER root

COPY ./skywalking-agent/ /opt/skywalking-agent/
RUN mkdir -p /opt/skywalking-agent/logs && \
    chmod 775 /opt/skywalking-agent/logs

# Criação do diretório do módulo GELF no caminho correto
RUN mkdir -p /opt/jboss/wildfly/modules/system/layers/base/biz/paluch/logging/main


# Copia os JARs necessários para o módulo
COPY logstash-gelf-1.15.1.jar \
     /opt/jboss/wildfly/modules/system/layers/base/biz/paluch/logging/main/

COPY jedis-2.9.0.jar \
     /opt/jboss/wildfly/modules/system/layers/base/biz/paluch/logging/main/

COPY commons-pool2-2.4.3.jar \
     /opt/jboss/wildfly/modules/system/layers/base/biz/paluch/logging/main/

# Copia o module.xml que define o módulo
COPY module.xml \
     /opt/jboss/wildfly/modules/system/layers/base/biz/paluch/logging/main/

# Copia o domain.xml com a configuração de logging ajustada
COPY domain.xml \
    /opt/jboss/wildfly/domain/configuration/domain.xml

# Script auxiliar de espera
COPY wait-for-it.sh /opt/wait-for-it.sh




# Criação de usuários administrativos e de domínio
RUN /opt/jboss/wildfly/bin/add-user.sh admin Admin#123 --silent
RUN /opt/jboss/wildfly/bin/add-user.sh jboss Jboss@123 --silent

# Permissões para o script
RUN chmod +x /opt/wait-for-it.sh



USER root

