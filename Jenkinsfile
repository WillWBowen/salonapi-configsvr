pipeline{
  agent any
  tools {
    maven 'Maven 3.6.2'
    jdk 'jdk8'
  }
  environment {
    CONFIGSERVER_PORT = "8888"
    CONFIGSERVER_PASSWORD = "NotTheActualPassword"
    ENCRYPT_KEY = "NotTheActualKey"
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
        sh """
          docker build -t willwbowen/salonapi-configsvr:${env.BUILD_ID} .
          docker tag willwbowen/salonapi-configsvr:${env.BUILD_ID} willwbowen/salonapi-configsvr:latest
        """
      }
    }
    stage('Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
          sh """
            docker login -u ${USERNAME} -p ${PASSWORD}
            docker push willwbowen/salonapi-configsvr:${env.BUILD_ID}
            docker push willwbowen/salonapi-configsvr:latest
          """
        }
      }
    }
    stage('Deploy') {
      steps {
        sh """
          envsubst < ./k8s/deployment.yml | kubectl apply -f -
          envsubst < ./k8s/service.yml | kubectl apply -f -
        """
      }
    }
  }
  post {
    always {
      archiveArtifacts 'target/**/*.jar'
    }

  }
}
