#!/bin/bash

set -e

VERSION=`grep '<version>.*</version>' connector.as400/pom.xml | cut -d '>' -f 2 | cut -d '<' -f 1 | head -n1`
RELEASE=$BUILD_NUMBER 
echo $VERSION
echo $RELEASE
if [ -z "$VERSION" -o -z "$RELEASE" ] ; then
  echo "You need to specify VERSION / RELEASE variables"
  exit 1
fi

if [ ! -d /root/rpmbuild/SOURCES ] ; then
  mkdir -p /root/rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
fi
rm -rf centreon-plugin-Operatingsystems-AS400-daemon-$VERSION
mkdir centreon-plugin-Operatingsystems-AS400-daemon-$VERSION
cp -r {connector.as400,connector.as400.install,doc,rpm,changelog,LICENSE} centreon-plugin-Operatingsystems-AS400-daemon-$VERSION
tar czf centreon-plugin-Operatingsystems-AS400-daemon-$VERSION.tar.gz centreon-plugin-Operatingsystems-AS400-daemon-$VERSION
cp centreon-plugin-Operatingsystems-AS400-daemon-$VERSION.tar.gz /root/rpmbuild/SOURCES
rpmbuild -ba rpm/centreon-plugin-Operatingsystems-AS400-daemon.spectemplate -D "VERSION $VERSION" -D "RELEASE $RELEASE"
cp -r /root/rpmbuild/RPMS/noarch .
chmod 777 noarch/*.rpm
