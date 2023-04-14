pipeline {
    agent any
    
    stages {
//         stage('Checkout') {
//             steps {
//                 checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/mhassanmanzoorsl/spring-boot-jacoco.git']])
//             }
//         }

        stage('Build') {
            steps {
                sh 'mvn clean package'
               // sh 'mvn clean package -Dmaven.test.failure.ignore=true'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
                //sh 'mvn test -Dmaven.test.failure.ignore=true'
            }
        }
        
        stage('Publishing Junit Tests report ') {
            steps {
                junit 'target/surefire-reports/*.xml'
            }   
        }
        stage('Publishing Code Covergae') {
            steps {
                jacoco()
            }   
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh '''
                        mvn sonar:sonar \
                                -Dsonar.projectKey=sonarqube-demo-f \
                                -Dsonar.projectName='sonarqube-demo-f' \
                                -Dsonar.host.url=http://20.54.72.51:9000 \
                                -Dsonar.token=sqp_115fd2a761d4397b7a8f186a9eae9c4f21378f31
                    '''
                }
            }
        }
        stage('Docker') {
            steps {
                sh 'docker version'
                sh 'docker build -t mhassanmanzoorsl/springbootjacoco:0.0.1 -f Dockerfile .'
                withDockerRegistry(credentialsId: 'Docker-Hub-Registry-mhassanmanzoorsl-creds', url: 'https://index.docker.io/v1/') {
                sh 'docker push mhassanmanzoorsl/springbootjacoco:0.0.1'
                }
            }
        }
        stage('Deploy to K8 Cluster') {
            steps {
                sshagent(['k8s_master_ssh_key']) {
                    sh 'scp -r -o StrictHostKeyChecking=no springbootappk8s.yaml root@192.168.1.60:/'
                    script{
                    try{
                        sh 'ssh root@192.168.1.60 kubectl apply -f /springbootappk8s.yaml --kubeconfig=/root/.kube/config'
                       }
                    catch(error)
                       {}
                    }
    
                }
            }
        }
    }
}
