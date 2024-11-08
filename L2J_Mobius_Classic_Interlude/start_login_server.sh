#!/bin/bash
set -e

# Informações de depuração
echo "PATH: $PATH"
which cp
ls -la /usr/bin/cp
ldd /usr/bin/cp

# Executar os comandos necessários para o Login Server
cp /opt/l2/LoginServer.jar /host-dist/libs/LoginServer.jar
mkdir -p /host-dist/Login/log
cd /host-dist/login/
./LoginServerTask.sh
