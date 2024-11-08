#!/bin/bash
set -e

# Informações de depuração
echo "PATH: $PATH"
which cp
ls -la /usr/bin/cp
ldd /usr/bin/cp

# Criar diretórios necessários
mkdir -p /host-dist/libs
mkdir -p /host-dist/Login/log

# Copiar o arquivo JAR para o diretório de destino
cp /opt/l2/LoginServer.jar /host-dist/libs/LoginServer.jar

# Iniciar a tarefa do Login Server
cd /host-dist/login/
./LoginServerTask.sh
