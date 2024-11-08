# Dockerfile

# Etapa Base
FROM ubuntu:latest AS base

# Instalar dependências essenciais
RUN apt-get update && apt-get install -y --no-install-recommends \
    ant \
    openjdk-21-jre-headless \
    bash \
    coreutils \
    && rm -rf /var/lib/apt/lists/*

# Etapa de Build
FROM base AS build

ARG MARIADB_PASSWORD
ARG MARIADB_USER
ARG MARIADB_DATABASE
ARG MARIADB_HOSTNAME
ARG LOGIN_SERVER_HOSTNAME

WORKDIR /src

# Copiar todos os arquivos para o diretório de trabalho
COPY . .

# Alterar caminhos de configuração nos arquivos Java
RUN sed -i \
    -e "s|./config/LoginServer.ini|/cfg/LoginServer.ini|" \
    -e "s|./config/Server.ini|/cfg/Server.ini|" \
    -e "s|./config/ipconfig.xml|/cfg/ipconfig.xml|" /src/java/org/l2jmobius/Config.java

# Adicionar configuração de rede
RUN echo -e '\
<?xml version="1.0" encoding="UTF-8"?>\n\
<gameserver address="127.0.0.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="../data/xsd/ipconfig.xsd">\n\
    <define subnet="127.0.0.0/8" address="127.0.0.1" />\n\
    <define subnet="192.168.1.0/24" address="192.168.1.2" />\n\
</gameserver>\n\
' > /src/dist/game/config/ipconfig.xml

# Atualizar configurações de banco de dados e hostname nos arquivos de configuração
RUN sed -i -E \
    -e "s|//\w+/\w+\?|//${MARIADB_HOSTNAME}/${MARIADB_DATABASE}?|" \
    -e "s/^Login =.*$/Login = ${MARIADB_USER}/" \
    -e "s/^Password =.*$/Password = ${MARIADB_PASSWORD}/" \
    -e "s/^LoginHost =.*$/LoginHost = ${LOGIN_SERVER_HOSTNAME}/" /src/dist/game/config/Server.ini

RUN sed -i -E \
    -e "s|//\w+/\w+\?|//${MARIADB_HOSTNAME}/${MARIADB_DATABASE}?|" \
    -e "s/^Login =.*$/Login = ${MARIADB_USER}/" \
    -e "s/^Password =.*$/Password = ${MARIADB_PASSWORD}/" \
    -e "s/^LoginHostname =.*$/LoginHostname = ${LOGIN_SERVER_HOSTNAME}/" /src/dist/login/config/LoginServer.ini

# Construir o projeto usando Ant
RUN ant -f build.xml jar

# Adicionar comandos de depuração para listar diretórios após o build
RUN echo "Listando /src/dist/game/" && ls -la /src/dist/game/
RUN echo "Listando /src/dist/libs/" && ls -la /src/dist/libs/

# Copiar os arquivos JAR construídos para o diretório de distribuição
RUN mkdir -p /src/dist/libs/
RUN cp /src/dist/libs/*.jar /src/dist/libs/

# Copiar os scripts de tarefa para o diretório de build
RUN mkdir -p /src/dist/game/
RUN mkdir -p /src/dist/login/
RUN cp /src/dist/game/GameServerTask.sh /src/dist/game/GameServerTask.sh
RUN cp /src/dist/login/LoginServerTask.sh /src/dist/login/LoginServerTask.sh

# Etapa Final
FROM base

WORKDIR /opt/l2

# Copiar os arquivos JAR construídos da etapa de build
COPY --from=build /src/dist/libs/*.jar .

# Criar diretório para configurações personalizadas e copiar os arquivos de configuração
RUN mkdir -p /cfg/
COPY --from=build /src/dist/game/config/ipconfig.xml /cfg/
COPY --from=build /src/dist/game/config/Server.ini /cfg/
COPY --from=build /src/dist/login/config/LoginServer.ini /cfg/

# Criar diretório para scripts de inicialização
RUN mkdir -p /scripts/

# Copiar os scripts de inicialização para o container
COPY start_game_server.sh /scripts/start_game_server.sh
COPY start_login_server.sh /scripts/start_login_server.sh

# Definir permissões de execução para os scripts
RUN chmod +x /scripts/start_game_server.sh /scripts/start_login_server.sh

# Copiar os scripts de tarefa para /scripts/ para evitar conflitos com volumes
COPY --from=build /src/dist/game/GameServerTask.sh /scripts/GameServerTask.sh
COPY --from=build /src/dist/login/LoginServerTask.sh /scripts/LoginServerTask.sh

# Definir permissões de execução para os scripts de tarefa
RUN chmod +x /scripts/GameServerTask.sh /scripts/LoginServerTask.sh
