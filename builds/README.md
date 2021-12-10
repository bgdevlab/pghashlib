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