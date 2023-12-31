pipeline {
  agent {
    label 'Java-Slave'
  }
  tools {
    maven 'maven'
  }
  stages {
  stage('Gitleaks') {
      steps {
        sh '''
        gitleaks detect --source . --log-opts "-n 1"
        gitleaks detect --source . --log-opts "-n 1" --report-path=gitleaks.json
        mv gitleaks.json gitleaks-$BUILD_NUMBER.json
        aws s3 cp gitleaks-$BUILD_NUMBER.json s3://jenkinsbucketdemo
        '''
      }
    } 
    stage('SonarQube Analysis') {
      steps {
        sh '''
        export PATH="/opt/sonar-scanner/bin:$PATH"
        mvn clean verify sonar:sonar -Dsonar.projectKey=Java_app -Dsonar.projectName='Java_app' -Dsonar.host.url=$SonarQube_URL -Dsonar.token=$SonarQube_Access_Token
        '''
      }
    }
    stage('Qualitygatecheck') {
      steps {
        sh '''
        chmod +x qualitygatecheck.sh
        bash qualitygatecheck.sh
        '''
      }
    }
    stage('Build app') {
      steps {
        sh 'mvn clean install package'
      }
    }
    stage('Push Artifact to S3') {
      steps {
        sh '''
        mv webapp/target/webapp.war webapp/target/webapp-$BUILD_NUMBER.war
        aws s3 cp webapp/target/webapp-$BUILD_NUMBER.war s3://jenkinsbucketdemo
        '''
      }
    }    
   
    // stage('DockerBuild') {
    //   steps {
    //     sh 'docker build -t java .'
    //   }
    // }
    // stage('Deploy to tomcat') {
    //   steps {
    //     sshagent(['tomcat-server-details']) {
    //     sh 'scp -o "StrictHostKeyChecking=no" webapp/target/webapp.war ubuntu@18.117.85.70:/opt/tomcat/webapps'
    //     }
    //   }
    // }
    // stage('Deploy to tomcat') {
    //   steps {
    //        sh 'sudo scp -i demo.pem -o "StrictHostKeyChecking=no" webapp/target/webapp.war ubuntu@65.0.3.198:/opt/tomcat/webapps'
    // }
    // }
}
// post {
//      always {
//        emailext to: 'lakshmiphanindrarudra@gmail.com',
//        attachLog: true, body: "Dear team pipeline is ${currentBuild.result} please check ${BUILD_URL} or PFA build log", compressLog: false,
//        subject: "Jenkins Build Notification: ${JOB_NAME}-Build# ${BUILD_NUMBER} ${currentBuild.result}"
//     }
// }
}
