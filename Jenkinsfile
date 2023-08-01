pipeline {
    agent {
        node {
            label "mvn"
        }
    }
    environment {
        PATH = "/opt/apache-maven-3.9.3/bin:$PATH"
    }
    stages {
        stage('Build using maven') {
            steps {
                sh 'mvn clean deploy'
            }
        }
    }
}
