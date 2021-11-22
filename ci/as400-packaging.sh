#!/bin/bash

set -e

VERSION=$1
RELEASE=$2

if [ -z "$VERSION" -o -z "$RELEASE" ] ; then
  echo "You need to specify VERSION / RELEASE variables"
  exit 1
fi
sudo apt-get install maven
sudo rm -rf /$HOME/rpmbuild

if [ ! -d /$HOME/rpmbuild/SOURCES ] ; then
  sudo mkdir -p /$HOME/rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
fi

sudo tar czf centreon-plugin-Operatingsystems-AS400-daemon-2.0.0.tar.gz connector.as400 connector.as400.install doc rpm changelog LICENSE
sudo mv centreon-plugin-Operatingsystems-AS400-daemon-2.0.0.tar.gz /$HOME/rpmbuild/SOURCES
rpmbuild -ba rpm/centreon-plugin-Operatingsystems-AS400-daemon.spectemplate -D "VERSION $VERSION" -D "RELEASE $RELEASE"