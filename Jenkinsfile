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
        stage('Build') {
            steps {
                echo '...Maven build started...'
                sh 'mvn clean deploy -Dmaven.test.skip=true'
                echo '...Maven build completed...'

            }
        }
        stage('Test'){
            steps{
                echo '...Unit testing started...'
                sh 'mvn surefire-report:report'
                echo '...Unit testing completed...'
            }
        }
        stage('SonarQube analysis') {
            environment {
                scannerHome = tool 'may-sonarqube-scanner';
            }
            steps{
                withSonarQubeEnv('may-sonarqube-server') { 
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
           
        }
         stage("Quality Gate") {
            steps {
                script {
                    timeout(time: 1, unit: 'HOURS') {
                        def qg = waitForQualityGate()
                        if(qg.status != 'OK'){
                            error "Quality gate failure: Pipeline Aborted :: ${qg.status}" 
                            abortPipeline: true
                        }
                    }
                }
            }
        }
    }
}
