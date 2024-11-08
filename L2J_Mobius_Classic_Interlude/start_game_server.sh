#!/bin/bash
set -e

# Informações de depuração
echo "PATH: $PATH"
which cp
ls -la /usr/bin/cp
ldd /usr/bin/cp

# Criar diretórios necessários
echo "Criando diretórios /host-dist/data/libs e /host-dist/data/game/log"
mkdir -p /host-dist/data/libs
mkdir -p /host-dist/data/game/log

# Verificar se /host-dist/data/libs foi criado
echo "Verificando diretórios criados em /host-dist/data"
ls -la /host-dist/data

# Copiar o arquivo JAR para o diretório de destino
echo "Copiando GameServer.jar para /host-dist/data/libs/"
cp /opt/l2/GameServer.jar /host-dist/data/libs/GameServer.jar

# Iniciar a tarefa do Game Server
echo "Navegando para /scripts/ e executando GameServerTask.sh"
cd /scripts/
ls -la
./GameServerTask.sh
