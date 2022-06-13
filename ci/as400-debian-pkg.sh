#!/bin/sh
set -ex

if [ -z "$VERSION" -o -z "$RELEASE" -o -z "$DISTRIB" ] ; then
  echo "You need to specify VERSION / RELEASE / DISTRIB variables"
  exit 1
fi

echo "################################################## PACKAGING COLLECT ##################################################"

AUTHOR="Luiz Costa"
AUTHOR_EMAIL="me@luizgustavo.pro.br"

if [ -d /build ]; then
  rm -rf /build
fi
mkdir -p /build
cd /build

# fix version to debian format accept
VERSION="$(echo $VERSION | sed 's/-/./g')"

cp -rv /src/centreon-as400 /build/
mv -v /build/centreon-as400 /build/centreon-plugin-Operatingsystems-AS400-daemon
(cd /build && tar czvpf - centreon-plugin-Operatingsystems-AS400-daemon) | dd of=centreon-plugin-Operatingsystems-AS400-daemon-$VERSION.tar.gz
cp -rv /src/centreon-as400/ci/debian /build/centreon-plugin-Operatingsystems-AS400-daemon/

ls -lart
cd /build/centreon-plugin-Operatingsystems-AS400-daemon
debmake -f "${AUTHOR}" -e "${AUTHOR_EMAIL}" -u "$VERSION" -y -r "$DISTRIB"
debuild-pbuilder
cd /build

if [ -d "$DISTRIB" ] ; then
  rm -rf "$DISTRIB"
fi
mkdir $DISTRIB
mv /build/*.deb $DISTRIB/
mv /build/$DISTRIB/*.deb /src
