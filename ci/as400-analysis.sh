#!/bin/sh

set -e

# This job is run directly after mon-web-unittest on centos7.

# Project.
PROJECT=centreon-as400
PROJECT_NAME="Centreon AS400"

echo "VERSION = $VERSION"

if [ -z "$VERSION" ]; then
  VERSION="0.0"
fi

# environment values required to replace sonarQube project versioning and binding
#   sonar.projectKey="{PROJECT_TITLE}"
#   sonar.projectName="{PROJECT_NAME}"
#   sonar.projectKey="{PROJECT_VERSION}"

sed -i -e "s/{PROJECT_TITLE}/$PROJECT/g" sonar-project.properties
sed -i -e "s/{PROJECT_NAME}/$PROJECT_NAME/g" sonar-project.properties
sed -i -e "s/{PROJECT_VERSION}/$VERSION/g" sonar-project.properties

sonar-scanner
