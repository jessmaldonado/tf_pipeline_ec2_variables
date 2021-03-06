pipeline {
    agent any
    tools {
        "org.jenkinsci.plugins.terraform.TerraformInstallation" "terraform"
    }
    parameters {
        string(name: 'WORKSPACE', defaultValue: 'development', description:'setting up workspace for terraform')
    }
    environment {
        TF_HOME = tool('terraform')
        TP_LOG = "WARN"
        PATH = "$TF_HOME:$PATH"
        ACCESS_KEY = credentials('AWS_ACCESS_KEY_ID')
        SECRET_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    stages {
            stage('Terraform Init'){
            steps {
                dir('tf_pipeline_ec2_variables/'){
                    sh "terraform init -input=false"
                    sh "echo \$PWD"
                    sh "whoami"
                }
            }
        }

        stage('Terraform Format'){
            steps {
                dir('tf_pipeline_ec2_variables/'){
                    sh "terraform fmt -list=true -write=false -diff=true -check=true"
                }
            }
        }

        stage('Terraform Validate'){
            steps {
                dir('tf_pipeline_ec2_variables/'){
                    sh "terraform validate"
                }
            }
        }

       stage('Terraform Plan'){
            steps {
                sh "terraform plan -var 'access_key=$ACCESS_KEY' -var 'secret_key=$SECRET_KEY' -out terraform.tfplan;echo \$? > status"        
                }
       }
        
        stage('Terraform Apply'){
            steps {
                script{
                    def apply = false
                    try {
                        input message: 'Can you please confirm the apply', ok: 'Ready to Apply the Config'
                        apply = true
                    } catch (err) {
                        apply = false
                         currentBuild.result = 'UNSTABLE'
                    }
                    if(apply){
                        dir('tf_pipeline_ec2_variables/'){
                            unstash "terraform-plan"
                            sh 'terraform apply terraform.tfplan' 
                        }
                    }
                }
            }
        }
    }
}
