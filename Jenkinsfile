pipeline {
    agent { dockerfile true }
    
    stages {
        stage('build') {
            steps {
                sh 'mkdir -p build'
                dir("build") {
                    sh 'cmake ../'
                    sh 'make -j4 rhel8'
                }
            }
        }
    }
    post {
        success {
            archiveArtifacts artifacts: 'build/guides/*.html, build/*-ds.xml', allowEmptyArchive: false
        }
    }
}
