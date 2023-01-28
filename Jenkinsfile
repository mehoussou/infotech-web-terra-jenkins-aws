// pipeline {
//     agent any

//     parameters {
//         string(name: 'environment', defaultValue: 'terraform', description: 'Workspace/environment file to use for deployment')
//         booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
//         booleanParam(name: 'destroy', defaultValue: false, description: 'Destroy Terraform build?')

//     }


//      environment {
//         AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
//         AWS_SECRET_ACCESS_KEY = credentials('jenkins_aws_secret_access_key')
//     }


//     stages {
//         stage('checkout') {
//             steps {
//                  script{
//                         dir("terraform")
//                         {
//                             git "https://github.com/mehoussou/infotech-web-terra-jenkins-aws.git"
//                         }
//                     }
//                 }
//             }

//         stage('Plan') {
//             when {
//                 not {
//                     equals expected: true, actual: params.destroy
//                 }
//             }
            
//             steps {
//                 sh 'terraform init -input=false'
//                 sh 'terraform workspace select ${environment} || terraform workspace new ${environment}'

//                 sh "terraform plan -input=false -out tfplan "
//                 sh 'terraform show -no-color tfplan > tfplan.txt'
//             }
//         }
//         stage('Approval') {
//            when {
//                not {
//                    equals expected: true, actual: params.autoApprove
//                }
//                not {
//                     equals expected: true, actual: params.destroy
//                 }
//            }
           
                
            

//            steps {
//                script {
//                     def plan = readFile 'tfplan.txt'
//                     input message: "Do you want to apply the plan?",
//                     parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
//                }
//            }
//        }

//         stage('Apply') {
//             when {
//                 not {
//                     equals expected: true, actual: params.destroy
//                 }
//             }
            
//             steps {
//                 sh "terraform apply -input=false tfplan"
//             }
//         }
        
//         stage('Destroy') {
//             when {
//                 equals expected: true, actual: params.destroy
//             }
        
//         steps {
//            sh "terraform destroy --auto-approve"
//         }
//     }

//   }
// }


// ###############################################################



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
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo "Deploying infotech web server"
                    def shellcmd = "bash ./install_apache.sh"

                }

            }
        }
       
    }

  }
}
