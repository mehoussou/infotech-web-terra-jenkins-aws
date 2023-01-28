pipeline {
    agent any

    stages {

        stage ("ckeckout"){
            checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: 'Github-creds', url: 'https://github.com/mehoussou/infotech-web-terra-jenkins-aws.git']])
        }

        stage("provision server") {
            environment {
                 AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
                 AWS_SECRET_ACCESS_KEY = credentials('jenkins_aws_secret_access_key')
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
                    def shellcmd = "bash ./install_apache.sh"
                    // def ec2Instance = "ec2-user@${EC2_PUBLIC_IP}"

                }

            }
        }
       
    }

}
