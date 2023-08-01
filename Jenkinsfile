pipeline {
    agent {
        node {
            label "mvn"
        }
    }

    stages {
        stage('Clone code to Jenkins node') {
            steps {
                git branch: 'main', url: 'https://github.com/bohemian-coder/basic-java-app.git'
            }
        }
    }
}
