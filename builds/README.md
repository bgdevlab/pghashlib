
# Builds

## Ubuntu / Debian
To build hashlib for the host platform's architecture, use the `ubuntu\build_ubuntu.sh` script.
The script and associated Docker image (based on the official PostgreSQL Docker images) pull in the latest
pghashlib source code and build the hashlib extension, then package it into a tar.gz archive and
copy it to the `builds` directory.


```bash
# build for all supported postgresql versions
bash ./build_ubuntu.sh 95
bash ./build_ubuntu.sh 12
bash ./build_ubuntu.sh 15
bash ./build_ubuntu.sh 18
```

The resulting archives are placed in `builds/ubuntu/` and have the following naming convention:

for arm64: `postgresql${PGVERSION}-hashlib.aarch64.tar.gz`
```bash
postgresql95-hashlib.aarch64.tar.gz
postgresql12-hashlib.aarch64.tar.gz
postgresql15-hashlib.aarch64.tar.gz
postgresql18-hashlib.aarch64.tar.gz
```

for x86_64: `postgresql${PGVERSION}-hashlib.x86_64.tar.gz`
```bash
postgresql95-hashlib.x86_64.tar.gz
postgresql12-hashlib.x86_64.tar.gz
postgresql15-hashlib.x86_64.tar.gz
postgresql18-hashlib.x86_64.tar.gz
```

## RHEL / CentOS
Older CentOs based builds

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