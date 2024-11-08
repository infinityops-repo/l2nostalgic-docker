#!/bin/bash
set -e

# Informações de depuração
echo "PATH: $PATH"
which cp
ls -la /usr/bin/cp
ldd /usr/bin/cp

# Criar diretórios necessários
echo "Criando diretórios /host-dist/data/libs e /host-dist/data/login/log"
mkdir -p /host-dist/data/libs
mkdir -p /host-dist/data/login/log

# Verificar se /host-dist/data/libs foi criado
echo "Verificando diretórios criados em /host-dist/data"
ls -la /host-dist/data

# Copiar o arquivo JAR para o diretório de destino
echo "Copiando LoginServer.jar para /host-dist/data/libs/"
cp /opt/l2/LoginServer.jar /host-dist/data/libs/LoginServer.jar

# Iniciar a tarefa do Login Server
echo "Navegando para /scripts/ e executando LoginServerTask.sh"
cd /scripts/
ls -la
./LoginServerTask.sh
