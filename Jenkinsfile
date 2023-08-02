def registry = 'https://tkcicd.jfrog.io/'
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
        stage("Jar Publish") {
            steps {
                script {
                        echo '...Jar publish started...'
                        def server = Artifactory.newServer url:registry+"/artifactory" ,  credentialsId:"jfrog"
                        def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}";
                        def uploadSpec = """{
                            "files": [
                                {
                                "pattern": "jarstaging/(*)",
                                "target": "libs-release-local/{1}",
                                "flat": "false",
                                "props" : "${properties}",
                                "exclusions": [ "*.sha1", "*.md5"]
                                }
                            ]
                        }"""
                        def buildInfo = server.upload(uploadSpec)
                        buildInfo.env.collect()
                        server.publishBuildInfo(buildInfo)
                        echo '...Jar publish ended...'  
                }
            }   
        }   
    }
}
