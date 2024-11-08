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

COPY . .

RUN sed -i \
    -e "s|./config/LoginServer.ini|/cfg/LoginServer.ini|" \
    -e "s|./config/Server.ini|/cfg/Server.ini|" \
    -e "s|./config/ipconfig.xml|/cfg/ipconfig.xml|" /src/java/org/l2jmobius/Config.java

RUN echo -e '\
<?xml version="1.0" encoding="UTF-8"?>\n\
<gameserver address="127.0.0.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="../data/xsd/ipconfig.xsd">\n\
    <define subnet="127.0.0.0/8" address="127.0.0.1" />\n\
    <define subnet="192.168.1.0/24" address="192.168.1.2" />\n\
</gameserver>\n\
' > /src/dist/game/config/ipconfig.xml

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

RUN ant -f build.xml jar
RUN cp /build/dist/libs/*.jar /src/dist/libs/

# Etapa Final
FROM base

WORKDIR /opt/l2

COPY --from=build /src/dist/libs/*.jar .

RUN mkdir -p /cfg/
COPY --from=build /src/dist/game/config/ipconfig.xml /cfg/
COPY --from=build /src/dist/game/config/Server.ini /cfg/
COPY --from=build /src/dist/login/config/LoginServer.ini /cfg/