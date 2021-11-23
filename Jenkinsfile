pipeline {
  agent { label 'aws' } 
  stages {
    stage('Packaging AS400') {
      steps {
        parallel(
          build: {
            echo "BUILD AS400"
            sh 'docker run -i --entrypoint /src/ci/as400-build.sh -v "$PWD:/src" registry.centreon.com/as400:centos7'
          },
          packagingcentos7: {
            echo "Packaging AS400 CENTOS7"
            sh "export ${env.BUILD_NUMBER}"
            sh 'docker run -i --entrypoint /src/ci/as400-packaging.sh -v "$PWD:/src" -e RELEASE=${env.BUILD_NUMBER} registry.centreon.com/as400:centos7'        
            sh 'rpmsign --addsign noarch/*.rpm'
            stash name: 'el7-rpms', includes: 'noarch/*.rpm'
            archiveArtifacts artifacts: "noarch/*.rpm"
            sh 'rm -rf *.rpm'
          },
          packagingcentos8: {
            echo "Packaging AS400 CENTOS8"
            sh 'docker run -i --entrypoint /src/ci/as400-packaging.sh -v "$PWD:/src" -e VERSION=2.0.0 -e RELEASE=1 registry.centreon.com/as400:centos8'        
            sh 'rpmsign --addsign noarch/*.rpm'
            stash name: 'el8-rpms', includes: 'noarch/*.rpm'
            archiveArtifacts artifacts: "noarch/*.rpm"
            sh 'rm -rf *.rpm'
          }
        )
      }
    }
  }
  post { 
    always { 
      cleanWs()
    }
  }
}
