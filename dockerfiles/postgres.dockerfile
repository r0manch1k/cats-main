FROM postgres:17

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y gnupg

RUN apt-get update && apt-get install -y \
    sudo \
    wget \
    curl \
    git \
    build-essential \
    cpanminus postgresql libpq-dev \
    && apt-get clean

RUN cpanm --notest -S YAML::Tiny Module::Install DBI DBI::Profile DBD::Pg

EXPOSE 5432

WORKDIR /cats-postgres

COPY . .

RUN chmod +x psql.bash

CMD service postgresql start && ./psql.bash

