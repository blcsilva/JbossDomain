#!/bin/bash

if [ $# -lt 2 ]; then
  echo "Uso: $0 <PID> <agent-jar> [agent-args]"
  exit 1
fi

PID=$1
AGENT_JAR=$2
shift 2
AGENT_ARGS=$@

# Concatena todos os argumentos em uma única string separada por vírgula
ARGS=$(echo $AGENT_ARGS | tr ' ' ',')

echo "Executando attach no PID $PID com agente $AGENT_JAR"
OUTPUT=$(jcmd $PID JVMTI.agent_load $AGENT_JAR "$ARGS")
echo "$OUTPUT"

if echo "$OUTPUT" | grep -q "return code: 0"; then
  echo "Agente anexado com sucesso ao processo $PID"
else
  echo "Falha ao anexar agente ao processo $PID"
fi
