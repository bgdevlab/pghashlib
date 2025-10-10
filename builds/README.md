The tar.gz archives in `builds/rhel/` are pre built hashlib extension.

Possibly better packaged as an `rpm`.


```
# archives are generated from server with already built and installed pghashlib, e.g.
 
PGVERSION=14

pushd /usr && \
tar -cvzf postgresql${PGVERSION}-hashlib.rhel7.minimum.tar.gz $(find pgsql-$PGVERSION -name 'hashlib*') 

pushd /usr/pgsql-$PGVERSION && \
tar -cvzf postgresql${PGVERSION}-hashlib.rhel7.minimum-base.tar.gz $(find . -name 'hashlib*') 
```

### 2025 - Apple Silicon build hashlib for postgresql-9.5

```bash
#
# edited history showing how to build hashlib in OCT 2025 on an official postgresql 9.5 docker image
# note that we have to build postgresql-9.5 from source to get development headers/files t0 make hashlib
# as the postgresql-server-dev-9.5 apt package is no longer available
#
alias ll='ls -la'

unzip pghashlib.zip
apt update
apt install unzip make
apt install --yes -q postgresql-server-dev-all build-essential libreadline-dev zlib1g-dev flex bison
apt install --yes -q postgresql-9.5 postgresql-contrib-9.5 postgresql-client-9.5 libpq-dev

wget --quiet https://github.com/markokr/pghashlib/archive/master.zip -O pghashlib.zip
unzip pghashlib.zip
pushd pghashlib-master/
[[ -f hashlib.html ]] || cp README.rst hashlib.html

cd ..
wget https://ftp.postgresql.org/pub/source/v9.5.25/postgresql-9.5.25.tar.gz
tar -xzf postgresql-9.5.25.tar.gz
cd postgresql-9.5.25
./configure --prefix=/opt/postgresql-9.5
make
make install
ls -l /opt/postgresql-9.5/bin/pg_config
export PATH=/opt/postgresql-9.5/bin:$PATH
which pg_config

cd ../pghashlib-master/
make clean
make
cp hashlib.so /usr/lib/postgresql/9.5/lib/hashlib.so

cd ..
mv pghashlib-master pghashlib_9.5-ubuntu_20
tar -cvzf postgresql95-hashlib.$(uname -m)-ubuntu_20.tar.gz pghashlib_9.5-ubuntu_20

# Thats roughly it...
# For Apple Silicon a file postgresql95-hashlib.aarch64-ubuntu_20.tar.gz will be produced 

```