ARG PG_VER="95"
ARG PG_VERSION="9.5"
ARG PG_SRC_VERSION="9.5.25"

FROM postgres:${PG_VERSION}

# Available automatically with BuildKit/buildx
ARG TARGETPLATFORM
ARG TARGETARCH
ARG TARGETVARIANT

ARG PG_VER
ARG PG_VERSION
ARG PG_SRC_VERSION

LABEL authors="theodson"

# debian stretch is archived as of 2025... change repositories to use archives
RUN rm /etc/apt/sources.list.d/pgdg.list \
    && echo "deb [trusted=yes] http://archive.debian.org/debian/ stretch main" > /etc/apt/sources.list \
    && echo "deb-src [trusted=yes] http://archive.debian.org/debian/ stretch main" >> /etc/apt/sources.list \
    && echo "deb [trusted=yes] http://archive.debian.org/debian/ stretch-backports main" >> /etc/apt/sources.list \
    && echo "deb [trusted=yes] http://archive.debian.org/debian-security/ stretch/updates main" >> /etc/apt/sources.list \
    && echo "deb-src [trusted=yes] http://archive.debian.org/debian-security/ stretch/updates main" >> /etc/apt/sources.list

RUN apt-get update || true
RUN apt-get --yes -q install unzip make build-essential flex bison \
    postgresql-$PG_VERSION postgresql-contrib-$PG_VERSION postgresql-client-$PG_VERSION

# difference for Intel and Arm
# libpq-dev conflicts on stretch due to pinned libpq5 from PGDG; not needed because we build PG from source
RUN test `uname -m` = 'aarch64' && apt-get --yes -q --no-install-recommends install libreadline-dev zlib1g-dev || echo "skip... not target architecture"

# Mapping note if you compare to `uname -m`:
# - `TARGETARCH=amd64` ↔ `uname -m` typically `x86_64`
# - `TARGETARCH=arm64` ↔ `uname -m` typically `aarch64`
# - `TARGETARCH=arm` with `TARGETVARIANT=v7` ↔ `armv7l`
RUN set -eux; \
    case "${TARGETARCH}" in \
      amd64) \
        echo "Installing deps for x86_64"; \
        apt-get --yes -q --no-install-recommends install libreadline-dev zlib1g-dev \
        ;; \
      arm64) \
        echo "Installing deps for aarch64"; \
        apt-get --yes -q --no-install-recommends install libreadline-dev zlib1g-dev \
        ;; \
      *) \
        echo "Unsupported arch: ${TARGETARCH}" >&2; exit 1; \
        ;; \
    esac


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
