pipeline{
  agent any
  environment {
    registry = "willwbowen/salonapi-configsvr"
    registryCredential = 'dockerhub'
    dockerImageVersioned = ''
    dockerImageLatest = ''
  }
  tools {
    maven 'Maven 3.6.2'
    jdk 'jdk8'
  }
  stages {
    stage('Initialize') {
      steps {
        sh '''
          echo "PATH = ${PATH}"
          echo "M2_HOME = ${M2_HOME}"
        '''
      }
    }
    stage('Build') {
      steps {
        sh 'mvn install'
      }
    }
    stage('Make Container') {
      steps {
        script {
          dockerImageVersioned = docker.build registry + ":${BUILD_ID}"
          dockerImageLatest = docker.tag dockerImageVersioned registry+"latest"
        }
      }
    }
  }
  post {
    always {
      archiveArtifacts 'target/**/*.jar'
    }
    success {
      script {
        withRegistry('', registryCredential) {
          dockerImageVersioned.push()
          dockerImageLatest.push()
        }
      }
    }
  }
}
