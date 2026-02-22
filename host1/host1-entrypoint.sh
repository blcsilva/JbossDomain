#!/bin/bash

# Inicia o Host Controller em modo domínio
/opt/jboss/wildfly/bin/domain.sh \
  --host-config=$HOST_CONFIG \
  -Djboss.domain.master.address=domain-controller \
  -b 0.0.0.0 -bmanagement 0.0.0.0 &

HC_PID=$!

# Espera até que o server-one apareça
for i in {1..12}; do
  SERVER_PID=$(jps -v | grep -F "[Server:server-one]" | awk '{print $1}')
  if [ -n "$SERVER_PID" ]; then
    echo "PID do server-one encontrado: $SERVER_PID"
    break
  fi
  echo "Aguardando server-one... tentativa $i"
  sleep 10
done

# Só roda o attach se encontrou o PID
if [ -n "$SERVER_PID" ]; then
  /opt/skywalking-agent/tools/attach.sh $SERVER_PID \
    /opt/skywalking-agent/skywalking-agent.jar \
    "skywalking.collector.backend_service=skywalking-oap:11800" \
    "skywalking.agent.service_name=$NODE_NAME"
else
  echo "Não foi possível identificar o PID do server-two."
fi

# Mantém o Host Controller em foreground
wait $HC_PID
