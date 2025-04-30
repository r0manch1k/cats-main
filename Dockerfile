# Используем базовый образ Ubuntu
FROM ubuntu:20.04

# Устанавливаем переменные окружения для работы без интерактива
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get install -y gnupg

# Обновляем пакеты и устанавливаем зависимости
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

# Устанавливаем рабочую директорию
WORKDIR /home/pdf/cats/cats-main

# Копируем все файлы проекта в контейнер
COPY . .

# Делаем скрипт исполняемым
RUN chmod +x deploy.bash

# Устанавливаем Perl-зависимости через cpanminus
RUN cpanm -S \
    Module::Install \
    DBI \
    DBI::Profile \
    DBD::Pg \
    Algorithm::Diff \
    Apache2::Request \
    Archive::Zip \
    Authen::Passphrase \
    File::Copy::Recursive \
    JSON::XS \
    SQL::Abstract \
    Template \
    Test::Exception \
    Text::Aspell \
    Text::CSV \
    Text::Hunspell \
    Text::MultiMarkdown \
    XML::Parser::Expat

# Запускаем скрипт установки
RUN ./deploy.bash

# Открываем порт 80 для Apache
EXPOSE 80

# Запускаем Apache в режиме демона
CMD ["apachectl", "-D", "FOREGROUND"]