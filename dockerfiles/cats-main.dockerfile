FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y gnupg

RUN apt-get update && apt-get install -y \
    sudo \
    wget \
    curl \
    git \
    build-essential \
    libaspell-dev aspell-en aspell-ru \
    libhunspell-dev hunspell-en-us hunspell-ru \
    apache2 libapache2-mod-perl2 libapreq2-3 libapreq2-dev \
    libapache2-mod-perl2-dev libexpat1 libexpat1-dev libapache2-request-perl \
    cpanminus postgresql libpq-dev \
    && apt-get clean

WORKDIR /app

COPY . .

COPY dockerfiles/Config.pm /app/cgi-bin/cats-problem/CATS/Config.pm

RUN chmod +x deploy.bash

RUN ./deploy.bash

EXPOSE 80

RUN chown -R www-data:www-data /app
RUN chmod -R 775 /app

CMD apachectl -D FOREGROUND