#!/bin/bash
set -e

# Informações de depuração
echo "PATH: $PATH"
which cp
ls -la /usr/bin/cp
ldd /usr/bin/cp

# Criar diretórios necessários
mkdir -p /host-dist/data/libs
mkdir -p /host-dist/data/game/log

# Verificar se /host-dist/data/libs foi criado
ls -la /host-dist/data

# Copiar o arquivo JAR para o diretório de destino
cp /opt/l2/GameServer.jar /host-dist/data/libs/GameServer.jar

# Iniciar a tarefa do Game Server
cd /scripts/
ls -la
./GameServerTask.sh
