#!/bin/bash

# Inicia o WildFly em modo domínio
/opt/jboss/wildfly/bin/domain.sh \
  --host-config=$HOST_CONFIG \
  -Djboss.domain.master.address=domain-controller \
  -b 0.0.0.0 -bmanagement 0.0.0.0 &

# Espera o server-two aparecer (até 12 tentativas, 10s cada)
for i in {1..12}; do
  SERVER_PID=$(jps -v | grep -F "[Server:server-two]" | awk '{print $1}')
  if [ -n "$SERVER_PID" ]; then
    echo "PID do server-two encontrado: $SERVER_PID"
    break
  fi
  echo "Aguardando server-two... tentativa $i"
  sleep 10
done

# Só roda o attach se encontrou o PID
if [ -n "$SERVER_PID" ]; then
  echo "Chamando attach.sh para PID $SERVER_PID..."
  /opt/skywalking-agent/tools/attach.sh $SERVER_PID \
    /opt/skywalking-agent/skywalking-agent.jar \
    "skywalking.collector.backend_service=skywalking-oap:11800,skywalking.agent.service_name=$NODE_NAME"
else
  echo "Não foi possível identificar o PID do server-two."
fi

# Mantém o processo em foreground
wait
