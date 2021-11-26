pipeline {
  agent { label 'aws' } 
  stages {
    stage('AS400 BUILD AND PACKAGING') {
      parallel {
        stage('Building AS400') {
          agent { label 'aws' }
          steps {
            echo "BUILD AS400"
            sh 'docker run -i --entrypoint /src/ci/as400-build.sh -v "$PWD:/src" registry.centreon.com/as400:centos7'
          }
        }
        stage('Packaging AS400 for centos7') {
          agent { label 'aws' }
          steps {
            echo "Packaging AS400 CENTOS7"
            sh 'docker run -i --entrypoint /src/ci/as400-packaging.sh -v "$PWD:/src" -e RELEASE=\${BUILD_NUMBER} -> ${BUILD_NUMBER} registry.centreon.com/as400:centos7'       
            sh 'rpmsign --addsign noarch/*.rpm'
            stash name: 'el7-rpms', includes: 'noarch/*.rpm'
            archiveArtifacts artifacts: "noarch/*.rpm"
            sh 'rm -rf *.rpm'
          }
        }
        stage('Packaging AS400 for centos8') {
          agent { label 'aws' }
          steps {
            echo "Packaging AS400 CENTOS8"
            sh "docker run -i --entrypoint /src/ci/as400-packaging.sh -v $PWD:/src -e RELEASE=${env.BUILD_NUMBER} registry.centreon.com/as400:centos8"     
            sh 'rpmsign --addsign noarch/*.rpm'
            stash name: 'el8-rpms', includes: 'noarch/*.rpm'
            archiveArtifacts artifacts: "noarch/*.rpm"
            sh 'rm -rf *.rpm'
          }
        }
      }
    }
  }
  post { 
    always { 
      cleanWs()
    }
  }
}
