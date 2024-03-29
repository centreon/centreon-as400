#!/bin/sh
set -ex

pwd
ls -lart
VERSION=`grep '<version>.*</version>' connector.as400/pom.xml | cut -d '>' -f 2 | cut -d '<' -f 1 | head -n1`

if [ -z "$VERSION" -o -z "$RELEASE" -o -z "$DISTRIB" ] ; then
  echo "You need to specify VERSION / RELEASE / DISTRIB variables"
  exit 1
fi

echo "################################################## PACKAGING COLLECT ##################################################"

AUTHOR="Centreon"
AUTHOR_EMAIL="contact@centreon.com"

if [ -d /build ]; then
  rm -rf /build
fi
mkdir -p /build
cd /build

# fix version to debian format accept
VERSION="$(echo $VERSION | sed 's/-/./g')"

mkdir -p /build/centreon-plugin-operatingsystems-as400-daemon
cp -rv /src/* /build/centreon-plugin-operatingsystems-as400-daemon
(cd /build && tar czvpf - centreon-plugin-operatingsystems-as400-daemon) | dd of=centreon-plugin-operatingsystems-as400-daemon-$VERSION.tar.gz
cp -rv /build/centreon-plugin-operatingsystems-as400-daemon/ci/debian /build/centreon-plugin-operatingsystems-as400-daemon/

ls -lart
cd /build/centreon-plugin-operatingsystems-as400-daemon
debmake -f "${AUTHOR}" -e "${AUTHOR_EMAIL}" -u "$VERSION" -y -r "$DISTRIB"
debuild-pbuilder
cd /build

if [ -d "$DISTRIB" ] ; then
  rm -rf "$DISTRIB"
fi
mkdir $DISTRIB
mv /build/*.deb $DISTRIB/
mv /build/$DISTRIB/*.deb /src
