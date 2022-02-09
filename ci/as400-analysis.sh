#!/bin/sh

set -e

# This job is run directly after mon-web-unittest on centos7.
VERSION=`grep '<version>.*</version>' connector.as400/pom.xml | cut -d '>' -f 2 | cut -d '<' -f 1 | head -n1`

if [ -z "$VERSION" ] ; then
  echo "You need to specify the VERSION variable"
  exit 1
fi

sonar-scanner -Dsonar.projectVersion="$VERSION"
