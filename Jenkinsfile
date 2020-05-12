pipeline {
    agent { dockerfile true }
    
    stages {
        stage('build') {
            steps {
                dir("scap") {
                    sh 'mkdir -p build'
                    dir("build") {
                        sh 'cmake ../'
                        sh 'make -j4 rhel8'
                    }
                }
            }
        }
    }
    post {
        success {
            archiveArtifacts artifacts: 'scap/build/guides/*.html, scap/build/*-ds.xml', allowEmptyArchive: false
        }
    }
}
