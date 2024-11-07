# Create base image
FROM alpine:latest AS base

RUN apk update && apk add --no-cache \
    apache-ant \
    openjdk21-jdk \
    bash \
    git

# Build project
FROM base AS build

ARG MARIADB_PASSWORD
ARG MARIADB_USER
ARG MARIADB_DATABASE
ARG MARIADB_HOSTNAME
ARG LOGIN_SERVER_HOSTNAME

WORKDIR /src

COPY . .

# Garantir que todos os diretórios necessários existam
RUN mkdir -p build/bin \
    build/dist/libs \
    dist/game/config \
    dist/login/config \
    java/org/l2jmobius/gameserver/model \
    java/org/l2jmobius/gameserver/network

# Certifique-se de que o diretório de bibliotecas está presente
RUN mkdir -p libs

# Copie as bibliotecas necessárias
COPY libs/*.jar libs/

# Compilar primeiro o core
RUN cd java && javac -sourcepath . org/l2jmobius/*.java

# Depois compilar o resto
RUN ant -f build.xml compile

RUN cp /src/build/dist/libs/*.jar /src/dist/libs/

# Keep only built files and persistent configs
FROM base

WORKDIR /opt/l2

# Copy built jar files
COPY --from=build /src/dist/libs/*.jar .

# Copy configs to custom config directory
RUN mkdir -p /cfg/
COPY --from=build /src/dist/game/config/ipconfig.xml /cfg/
COPY --from=build /src/dist/game/config/Server.ini /cfg/
COPY --from=build /src/dist/login/config/LoginServer.ini /cfg/