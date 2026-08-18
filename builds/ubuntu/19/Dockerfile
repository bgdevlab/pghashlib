ARG PG_VER="19beta3"
ARG PG_VERSION="19beta3"
ARG PG_REPO_VERSION="19"
ARG PG_SRC_VERSION="19beta3"

FROM postgres:${PG_VERSION}

ARG PG_VER
ARG PG_VERSION
ARG PG_REPO_VERSION="19"
ARG PG_SRC_VERSION

LABEL authors="theodson"

# Use default repositories provided by the postgres base image (PGDG). Do not override
# them with archived Debian mirrors, as that can create libpq version mismatches.
RUN apt-get update
RUN apt-get --yes -q install unzip make build-essential flex bison \
    libpq-dev libreadline-dev zlib1g-dev pkg-config libicu-dev \
    postgresql-$PG_REPO_VERSION postgresql-contrib-$PG_REPO_VERSION postgresql-client-$PG_REPO_VERSION

RUN apt-get --yes -q install wget
RUN wget --quiet https://github.com/markokr/pghashlib/archive/master.zip -O pghashlib.zip
RUN unzip pghashlib.zip && \
    cd pghashlib-master && \
    [[ -f hashlib.html ]] || cp README.rst hashlib.html && \
    cd ..

RUN wget https://ftp.postgresql.org/pub/source/v$PG_SRC_VERSION/postgresql-$PG_SRC_VERSION.tar.gz
RUN tar -xzf postgresql-$PG_SRC_VERSION.tar.gz && \
    cd postgresql-$PG_SRC_VERSION && \
    ./configure --prefix=/opt/postgresql-$PG_VERSION && \
    make && make install && \
    ls -l /opt/postgresql-$PG_VERSION/bin/pg_config && \
    export PATH=/opt/postgresql-$PG_VERSION/bin:$PATH && \
    cd ../pghashlib-master/ && \
    make clean && \
    make && \
    cd .. && \
    mv pghashlib-master pghashlib_$PG_VERSION && \
    tar -cvzf postgresql${PG_VER}-hashlib.$(uname -m).tar.gz pghashlib_$PG_VERSION
