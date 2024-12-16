pipeline {
    agent any
    stages {
        stage('Run Tests') {
            steps {
                script {
                    sh 'chmod +x ./test/run.sh'
                    sh './test/run.sh -p $(pwd)/test'
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution completed.'
        }
        success {
            echo 'Tests executed successfully.'
        }
        failure {
            echo 'Tests failed.'
        }
    }
}
