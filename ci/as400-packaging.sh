#!/bin/bash

set -e

if [ -z "$VERSION" -o -z "$RELEASE" ] ; then
  echo "You need to specify VERSION / RELEASE variables"
  exit 1
fi

if [ ! -d /root/rpmbuild/SOURCES ] ; then
  mkdir -p /root/rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
fi
rm -rf centreon-plugin-Operatingsystems-AS400-daemon-2.0.0
mkdir centreon-plugin-Operatingsystems-AS400-daemon-2.0.0
cp -r {connector.as400,connector.as400.install,doc,rpm,changelog,LICENSE} centreon-plugin-Operatingsystems-AS400-daemon-2.0.0
tar czf centreon-plugin-Operatingsystems-AS400-daemon-2.0.0.tar.gz centreon-plugin-Operatingsystems-AS400-daemon-2.0.0
cp centreon-plugin-Operatingsystems-AS400-daemon-2.0.0.tar.gz /root/rpmbuild/SOURCES
rpmbuild -ba rpm/centreon-plugin-Operatingsystems-AS400-daemon.spectemplate -D "VERSION $VERSION" -D "RELEASE $RELEASE"
cp -r /root/rpmbuild/RPMS/noarch .
chmod 777 noarch/*.rpm
chown -R ubuntu: noarch