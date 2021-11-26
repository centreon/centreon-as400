#!/bin/bash

set -e

source common.sh

VERSION=`grep '<version>.*</version>' connector.as400/pom.xml | cut -d '>' -f 2 | cut -d '<' -f 1 | head -n1`

AS400RPMSEL7=`echo noarch/*.el7.*.rpm`
AS400RPMSEL8=`echo noarch/*.el8.*.rpm`

# Publish RPMs

put_rpms "standard" "$MAJOR" "el7" "testing" "noarch" "as400" "centreon-as400-$VERSION-$BUILD_NUMBER" $AS400RPMSEL7
put_rpms "standard" "$MAJOR" "el8" "testing" "noarch" "as400" "centreon-as400-$VERSION-$BUILD_NUMBER" $AS400RPMSEL8
