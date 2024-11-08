#!/bin/bash
set -e

# Informações de depuração
echo "PATH: $PATH"
which cp
ls -la /usr/bin/cp
ldd /usr/bin/cp

# Criar diretórios necessários
mkdir -p /host-dist/libs
mkdir -p /host-dist/game/log

# Copiar o arquivo JAR para o diretório de destino
cp /opt/l2/GameServer.jar /host-dist/libs/GameServer.jar

# Iniciar a tarefa do Game Server
cd /host-dist/game/
./GameServerTask.sh
