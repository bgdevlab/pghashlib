FROM postgres:9.5

LABEL authors="theodson"

ARG PG_VER="95"
ARG PG_VERSION="9.5"
ARG PG_SRC_VERSION="9.5.25"

# debian stretch is archived as of 2025... change repositories to use archives
RUN rm /etc/apt/sources.list.d/pgdg.list \
    && echo "deb [trusted=yes] http://archive.debian.org/debian/ stretch main" > /etc/apt/sources.list \
    && echo "deb-src [trusted=yes] http://archive.debian.org/debian/ stretch main" >> /etc/apt/sources.list \
    && echo "deb [trusted=yes] http://archive.debian.org/debian/ stretch-backports main" >> /etc/apt/sources.list \
    && echo "deb [trusted=yes] http://archive.debian.org/debian-security/ stretch/updates main" >> /etc/apt/sources.list \
    && echo "deb-src [trusted=yes] http://archive.debian.org/debian-security/ stretch/updates main" >> /etc/apt/sources.list

RUN apt-get update || true
RUN apt-get --yes -q install unzip make build-essential flex bison \
    libpq-dev libreadline-dev zlib1g-dev \
    postgresql-$PG_VERSION postgresql-contrib-$PG_VERSION postgresql-client-$PG_VERSION

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
