pipeline {
  agent { label 'aws' } 
  stages {
    stage('Packaging AS400') {
      steps {
        echo "Packaging AS400 CENTOS7"
        sh 'docker run -i --entrypoint /src/ci/as400-packaging.sh -v "$PWD:/src" -e VERSION=$VERSION -e RELEASE=$RELEASE registry.centreon.com/centreon-collect-centos7-dependencies:21.10'
        sh 'rpmsign --addsign *.rpm'
        stash name: 'el7-rpms', includes: '*.rpm'
        archiveArtifacts artifacts: "*.rpm"
        sh 'rm -rf *.rpm'
      }
    }
  }
}
