!#/bin/bash

set -e

VERSION=$1
RELEASE=$2

if [ -z "$VERSION" -o -z "$RELEASE" ] ; then
  echo "You need to specify VERSION / RELEASE variables"
  exit 1
fi

if [ ! -d /root/rpmbuild/SOURCES ] ; then
  sudo mkdir -p /root/rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
fi

tar czf centreon-plugin-Operatingsystems-AS400-daemon-2.0.0.tar.gz .
mv centreon-plugin-Operatingsystems-AS400-daemon-2.0.0.tar.gz /root/rpmbuild/SOURCES/
rpmbuild -ba rpm/centreon-plugin-Operatingsystems-AS400-daemon.spectemplate -D "VERSION $VERSION" -D "RELEASE $RELEASE"