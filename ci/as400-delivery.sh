#!/bin/bash

set -e

source common.sh
REPO=$1
VERSION=`grep '<version>.*</version>' connector.as400/pom.xml | cut -d '>' -f 2 | cut -d '<' -f 1 | head -n1`

AS400RPMSEL7=`echo noarch/*.el7.*.rpm`
AS400RPMSEL8=`echo noarch/*.el8.*.rpm`

# Publish RPMs
if [ "$1" = "testing" ] ; then
  put_rpms "standard" "21.10" "el7" "$REPO" "noarch" "centreon-as400" "centreon-as400-$VERSION-$BUILD_NUMBER" $AS400RPMSEL7
  put_rpms "standard" "21.10" "el8" "$REPO" "noarch" "centreon-as400" "centreon-as400-$VERSION-$BUILD_NUMBER" $AS400RPMSEL8
else
  put_rpms "standard" "21.10" "el7" "$REPO" "noarch" "RPMS" "" $AS400RPMSEL8
  put_rpms "standard" "21.10" "el8" "$REPO" "noarch" "RPMS" "" $AS400RPMSEL8
fi