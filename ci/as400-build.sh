#!/bin/bash

set -e
ls -lart
cd centreon.as400
mvn clean package
