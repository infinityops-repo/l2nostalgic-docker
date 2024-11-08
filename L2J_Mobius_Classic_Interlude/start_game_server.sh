#!/bin/bash
set -e

# Informações de depuração
echo "PATH: $PATH"
which cp
ls -la /usr/bin/cp
ldd /usr/bin/cp

# Executar os comandos necessários para o Game Server
cp /opt/l2/GameServer.jar /host-dist/libs/GameServer.jar
mkdir -p /host-dist/game/log
cd /host-dist/game/
./GameServerTask.sh
