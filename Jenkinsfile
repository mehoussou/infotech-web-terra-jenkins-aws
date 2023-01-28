pipeline {
    agent any

    stages {

        stage ("ckeckout"){
            steps {
               checkout scmGit(branches: [[name: '*/jenkins-with-terraform']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/mehoussou/infotech-web-terra-jenkins-aws.git']])

            }  
        }

        stage("provision server") {
            environment {
                 AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
                 AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
                 TF_VAR_env_prefix = 'test'
            }
            steps {
                script{
                    dir('terraform') {
                        sh "terraform init"
                        sh "terraform apply --auto-approve"
                        EC2_PUBLIC_IP = sh (
                            script: "terraform output ec2_public_ip",
                            returnStdout: true
                        ).trim()
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo "Deploying infotech web server"
                    // def "ec2Instance = ${EC2_PUBLIC_IP}"
                    def shellcmd = "bash ./install_apache.sh"
                    // def ec2Instance = "ec2-user@${EC2_PUBLIC_IP}"

                }

            }
        }
       
    }

}
