pipeline{
    agent any 
    tools {
        terraform 'terraform-v0.13.5'
    }
    stages{
        stage("Git checkout"){
            steps{
                git 'http://gitlab.6ax.su/6ax/terraform-ansible-aws.git'
            }
        }
        stage("Execute Terrafom init"){
            steps{
                sh 'terraform init'
            }
        }
        stage("Execute Terraform apply for terra in AWS"){
            steps{
                sh 'terraform apply -auto-approve'
            }
        }
        stage("Execute ansible-playbook for build EC2 instances"){
            steps{
                sleep 30
                ansiblePlaybook colorized: true, credentialsId: 'dd10d8c4-a359-4369-aaf3-dd38ebb5857e', disableHostKeyChecking: true, installation: 'ansible-2.10.2', inventory: 'hosts', playbook: 'aws_builder_main.yml'
            }
        }
        stage("Execute ansible-playbook for production EC2 instances"){
            steps{
                ansiblePlaybook colorized: true, credentialsId: 'dd10d8c4-a359-4369-aaf3-dd38ebb5857e', disableHostKeyChecking: true, installation: 'ansible-2.10.2', inventory: 'hosts', playbook: 'aws_prod_main.yml'
            }
            
        }
    }
}
