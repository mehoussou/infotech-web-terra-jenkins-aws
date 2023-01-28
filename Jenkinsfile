pipeline {
    agent any
    parameters {
        string(name: 'environment', defaultValue: 'terraform', description: 'Workspace/environment file to use for deployment')
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        booleanParam(name: 'destroy', defaultValue: false, description: 'Destroy Terraform build?')
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {

        stage ("ckeckout"){
            steps {
                script {
                    dir ("terraform")
                }
            //    checkout scmGit(branches: [[name: '*/jenkins-with-terraform']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/mehoussou/infotech-web-terra-jenkins-aws.git']])
                        
                        git "https://github.com/mehoussou/infotech-web-terra-jenkins-aws.git"  
            }  
        }
    
        stage("provision server") {
            steps {
                script{
                    dir('terraform') {
                        sh "terraform init"
                        sh "terraform plan"
                        sh "terraform apply --auto-approve"
                        // EC2_PUBLIC_IP = sh (
                        //     script: "terraform output ec2_public_ip",
                        //     returnStdout: true
                        // ).trim()
                    }
                }
            }
        }

        stage ("plan") {
            steps {
                sh "terraform init -input=false"
                sh "terraform workspace select ${environment} | terraform workspace new ${environment}"
                sh "terraform plan -input=false -out tfplan"
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo "waiting for web server to initialize..."
                    sleep (time: 120, unit: "SECONDS")

                    echo "Deploying infotech web server..."
                    // def "ec2Instance = ${EC2_PUBLIC_IP}"
                    def shellCmd = "bash ./install_apache.sh"
                    // def ec2Instance = "ec2-user@${EC2_PUBLIC_IP}"

                }

            }
        }
       
    }

}
