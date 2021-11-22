pipeline {
  agent { label 'aws' } 
  stages {
    stage('Packaging AS400') {
      steps {
        echo "Packaging AS400"
        sh 'ci/as400-packaging.sh'
      }
    }
  }
}
