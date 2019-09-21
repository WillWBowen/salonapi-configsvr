pipeline{
  agent any
  environment {
    registryCredential = 'dockerhub'
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
        sh "docker build -t willwbowen/salonapi-configsvr:${env.BUILD_ID} ."
        sh "docker tag willwbowen/salonapi-configsvr:${env.BUILD_ID} willwbowen/salonapi-configsvr:latest"
      }
    }
  }
  post {
    always {
      archiveArtifacts 'target/**/*.jar'
    }
    success {
      withRegistry('', registryCredential) {
        sh "docker push willwbowen/salonapi-configsvr:${env.BUILD_ID}"
        sh "docker push willwbowen/salonapi-configsvr:latest"
      }
    }
  }
}
