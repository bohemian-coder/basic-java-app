def registry = 'https://tkcicd.jfrog.io/'
def imageName = 'tkcicd.jfrog.io/maytkcicd-docker-local/bja'
def version   = '2.1.3'

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

        stage(" Docker Build ") {
            steps {
                script {
                    echo '...Docker build started...'
                    app = docker.build(imageName+":"+version)
                    echo '...Docker build completed...'
                }
            }
        }

        stage (" Docker Publish "){
            steps {
                script {
                    echo '...Docker publish started...'
                        docker.withRegistry(registry, 'jfrog'){
                            app.push()
                        }    
                    echo '...Docker publish ended...'
                }
            }
        }

        stage("Deploy to kubernetes using helm package"){
            steps{
                script {
                    echo '...Docker publish started...'
                        sh 'helm install tkcicd tkcicd-0.1.0.tgz'  
                    echo '...Docker publish ended...'
                }
            }
        }   
    }
}
