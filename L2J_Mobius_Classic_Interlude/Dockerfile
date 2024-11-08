# Base image
FROM ubuntu:latest AS base

RUN apt-get update && apt-get install -y --no-install-recommends \
    ant \
    openjdk-21-jre-headless \
    bash \
    coreutils \
    && rm -rf /var/lib/apt/lists/*

# Build stage
FROM base AS build

ARG MARIADB_PASSWORD
ARG MARIADB_USER
ARG MARIADB_DATABASE
ARG MARIADB_HOSTNAME
ARG LOGIN_SERVER_HOSTNAME

WORKDIR /src

COPY . .

# Alterar caminhos de configuração
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

# Atualizar configurações de banco de dados e hostname
RUN sed -i -E \
    -e "s|//\w+/\w+\?|//${MARIADB_HOSTNAME}/${MARIADB_DATABASE}?|" \
    -e "s/^Login =.*$/Login = ${MARIADB_USER}/" \
    -e "s/^Password =.*$/Password = ${MARIADB_PASSWORD}/" \
    -e "s/^LoginHost =.*$/LoginHost = ${LOGIN_SERVER_HOSTNAME}/" /src/dist/game/config/Server.ini

# Construir o projeto
RUN ant -f build.xml jar

RUN cp /build/dist/libs/*.jar /src/dist/libs/

# Manter apenas os arquivos construídos e configurações persistentes
FROM base

WORKDIR /opt/l2

# Copiar arquivos JAR construídos
COPY --from=build /src/dist/libs/*.jar .

# Copiar configurações para o diretório de configuração personalizado
RUN mkdir -p /cfg/
COPY --from=build /src/dist/game/config/ipconfig.xml /cfg/
COPY --from=build /src/dist/game/config/Server.ini /cfg/
COPY --from=build /src/dist/login/config/LoginServer.ini /cfg/