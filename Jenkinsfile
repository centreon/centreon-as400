pipeline {
  agent { label 'aws' } 
  stages {
    stage('Packaging AS400') {
      steps {
        echo "Packaging AS400 CENTOS7"
        sh './ci/as400-packaging.sh 2.0.0 1'
        //sh 'docker run -i --entrypoint /src/ci/as400-packaging.sh -v "$PWD:/src" -e VERSION=2.0.0 -e RELEASE=1 registry.centreon.com/centreon-collect-centos7-dependencies:21.10'
        sh 'rpmsign --addsign *.rpm'
        stash name: 'el7-rpms', includes: '*.rpm'
        archiveArtifacts artifacts: "*.rpm"
        sh 'rm -rf *.rpm'
      }
    }
  }
}
