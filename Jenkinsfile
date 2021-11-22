pipeline {
  agent { label 'aws' } 
  stages {
    stage('Packaging AS400') {
      steps {
        parallel(
          build: {
            echo "BUILD AS400"
            sh 'docker run -i --entrypoint /src/ci/as400-build.sh -v "$PWD:/src" as400:centos7'
          },
          packaging-centos7: {
            echo "Packaging AS400 CENTOS7"
            sh 'docker run -i --entrypoint /src/ci/as400-packaging.sh -v "$PWD:/src" -e VERSION=2.0.0 -e RELEASE=1 as400:centos7'        
            sh 'rpmsign --addsign *.rpm'
            stash name: 'el7-rpms', includes: 'noarch/*.rpm'
            archiveArtifacts artifacts: "*.rpm"
            sh 'rm -rf *.rpm'
          },
          packaging-centos8: {
            echo "Packaging AS400 CENTOS8"
            sh 'docker run -i --entrypoint /src/ci/as400-packaging.sh -v "$PWD:/src" -e VERSION=2.0.0 -e RELEASE=1 as400:centos8'        
            sh 'rpmsign --addsign *.rpm'
            stash name: 'el8-rpms', includes: 'noarch/*.rpm'
            archiveArtifacts artifacts: "*.rpm"
            sh 'rm -rf *.rpm'
          }
        )
      }
    }
  }
}
