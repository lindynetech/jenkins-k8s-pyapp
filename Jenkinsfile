pipeline{
    agent{
        label "spot"
    }
    environment {
        imageName = 'lindynetech/py-rest-app'
    }
    stages{
        stage("Docker build") {
            steps {
                sh 'docker build -t $imageName"${BUILD_TIMESTAMP}'
            }
        stage('Docker Login')
            steps {
                withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub',
                    usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
                    sh "docker login --username $USERNAME --password $PASSWORD"
                }
            }
        }
        stage('Docker push') {
            steps {
                sh 'docker push $imageName"${BUILD_TIMESTAMP}'
            }
        }
        stage('Update Version') {
            steps {
                sh "sed -i 's/{{VERSION}}/${BUILD_TIMESTAMP}/g' deployment.yml"
            }
        }
        stage('Deploy to staging') {
            steps {
                sh "kubectl config use-context staging"
                sh 'kubeclt apply -f deployment.yml'
            }
        }
        stage('Perfromance Testing') {
            steps {
                NODE = sh(returnStdout: true, script: "kubectl get nodes -o jsonpath='{ $.items[0].status.addresses[?(@.type=="InternalIP")].address }'")
                PORT = sh(returnStdout: true, script: "kubectl get svc pyrest-service -o=jsonpath='{.spec.ports[0].nodePort}'")
                ENDPOINT=${NODE}:${PORT}
                echo $ENDPOINT
                sh "chmod +x performance-test.sh && ./performance-test.sh ${ENDPOINT}"
            }
        }
        stage('Release') {
            steps {
                sh "kubectl config use-context prod"
                sh 'kubeclt apply -f deployment.yml'
            }
        }
    }
}