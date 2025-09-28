#!/bin/bash

echo "Checking for existing PostgreSQL cluster..."
if pg_lsclusters | grep -q main; then
    echo "Cluster already exists. Starting it..."
    pg_ctlcluster $(pg_config --version | awk '{print $2}' | cut -d. -f1) main start
else
    echo "Initializing PostgreSQL cluster..."
    pg_createcluster $(pg_config --version | awk '{print $2}' | cut -d. -f1) main --start
fi

# Change docker subnet if it's different
echo "Configuring PostgreSQL..."
echo -e "host $POSTGRES_DB $POSTGRES_USER 172.19.0.0/16 md5\nhost $POSTGRES_DB $POSTGRES_USER 127.0.0.1/32 md5\nlocal all postgres peer" > /tmp/pg_hba.tmp  && mv /tmp/pg_hba.tmp /etc/postgresql/18/main/pg_hba.conf

echo "Reloading PostgreSQL configuration..."
service postgresql reload

echo "Starting PostgreSQL..."
service postgresql start

echo "Waiting for PostgreSQL to become ready..."
until pg_isready -d "$POSTGRES_DB" -U "$POSTGRES_USER"; do
    sleep 1
done

echo "PostgreSQL is ready. Running Perl script..."
perl -I "/app/cgi-bin" -MCATS::Deploy -e \
    "CATS::Deploy::create_db 'postgres', '$POSTGRES_DB', '$POSTGRES_USER', '$POSTGRES_PASSWORD', pg_auth_type => 'peer', init_config => 1, host => '$POSTGRES_HOST', quiet => 1"

echo "Initialization complete. Keeping container running..."
tail -f /dev/null
